locals {
  instance_userdata = <<USERDATA
#!/bin/sh
yum update -y
USERDATA
}