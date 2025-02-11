MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==NCODELIBRARY=="

--==NCODELIBRARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash -xe
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent

--==NCODELIBRARY==--