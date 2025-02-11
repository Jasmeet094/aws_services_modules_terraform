#!/bin/bash

# User data script to prepare an OpenVPN server. Requires some parameters to be
# passed in via Terraform template variables.

# userdata template variables passed in via Terraform
# $${environment$}
# $${use_rds}
# $${rds_master_name}
# $${rds_master_password}
# $${rds_host$}
# $${openvpn_password}
# $${openvpn_dns}
# $${openvpn_networks}

export USE_RDS=${use_rds}
export OPENVPN_PASSWORD=${openvpn_password}
export RDS_MASTER_NAME=${rds_master_name}
export RDS_MASTER_PASSWORD=${rds_master_password}
export RDS_HOST=${rds_host}
export INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
export REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')
export DEBIAN_FRONTEND=noninteractive

function install_required_tools  {
  while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
    echo Waiting for other instances of apt to complete...
    sleep 5
  done
  apt-get update -qq
  apt-get install -qq awscli jq curl mysql-client libmysqlclient-dev unzip
}

function disable_source_dest_check {
  # Set no source/dest check - needed here because of asg limitation
  aws --region $REGION ec2 modify-instance-attribute --no-source-dest-check --instance-id $INSTANCE_ID
}

function associate_eip {
  # Allow the instance to associate a static IP.
  aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id ${eip} --allow-reassociation --region $REGION
}

function init_openvpn {
  # Initialize the OpenVPN installation
  sudo ovpn-init --ec2 --batch --force

  echo "#Set password for openvpn user"
  echo "openvpn:$OPENVPN_PASSWORD" | sudo chpasswd
}

function migrate_to_rds {

DB_PREFIX="${environment}_"
MYSQL_PREF=/etc/.my.cnf

cat <<EOF > $${MYSQL_PREF}
[client]
user=$RDS_MASTER_NAME
password=$RDS_MASTER_PASSWORD
port=3306
host=$RDS_HOST
EOF

ln -s $${MYSQL_PREF} /root/.my.cnf

systemctl stop openvpnas.service

pushd /usr/local/openvpn_as/scripts
for ITEM in certs user_prop config log cluster notification; do
  echo  "...  preparing $${ITEM} database and config"

  MYSQL_DB_NAME="$${DB_PREFIX}as_$${ITEM}"
  LOCAL_DB_NAME=`echo $${ITEM} | tr -d '_'`
  LOCAL_DB_FILE="/usr/local/openvpn_as/etc/db/$${LOCAL_DB_NAME}.db"
  DB_KEY="$${ITEM}_db"

  #- set db configuration value
  sed -i "s|$${DB_KEY}=.*|$${DB_KEY}=mysql://$${RDS_HOST}/$${MYSQL_DB_NAME}|" /usr/local/openvpn_as/etc/as.conf

  #- create MySql DB
  mysql --defaults-file=$${MYSQL_PREF} -e "CREATE DATABASE IF NOT EXISTS $${MYSQL_DB_NAME};"

  #- import local DB schema into MySql if no tables exist
  mysql --defaults-file=$${MYSQL_PREF} --silent --skip-column-names \
  -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$${MYSQL_DB_NAME}';" \
  | grep -e ^0 -q \
  && ./dbcvt -t $${ITEM} -s sqlite:///$${LOCAL_DB_FILE} -d mysql://$${RDS_HOST}/$${MYSQL_DB_NAME} -p $${MYSQL_PREF}
done
popd

###
echo  '!!!!  RESTART OPENVPN'
systemctl restart openvpnas.service

}

function configure_openvpn {

###
echo  '!!!!  CONFIGURE OPENVPN DEFAULTS'
sleep 10
pushd /usr/local/openvpn_as/scripts
# Set the proper DNS name of the server
./sacli --key "host.name" --value "${domain_name}"  ConfigPut
./sacli --key "cs.web_server_name" --value "${domain_name}"  ConfigPut

./sacli --key "cs.tls_version_min" --value "1.2"  ConfigPut
./sacli --key "vpn.server.daemon.tcp.n_daemons" --value "8"  ConfigPut
./sacli --key "vpn.server.daemon.udp.n_daemons" --value "8"  ConfigPut
# Set custom DNS servers
./sacli --key "vpn.client.routing.reroute_dns" --value "custom"  ConfigPut
./sacli --key "vpn.server.routing.gateway_access" --value "true"  ConfigPut
%{ for index, dns in openvpn_dns ~}
./sacli --key "vpn.server.dhcp_option.dns.${index}" --value "${dns}" ConfigPut
%{ endfor ~}
# Updating access to private networks
%{ for index, network in openvpn_networks ~}
./sacli --key "vpn.server.routing.private_network.${index}" --value "${network}" ConfigPut
%{ endfor ~}
./sacli start
popd

}

function main {
  install_required_tools
  disable_source_dest_check
  associate_eip
  init_openvpn

  if [[ "$USE_RDS" = "true" ]]; then
    migrate_to_rds
  fi
  configure_openvpn
}

#Entry point
main
