output "output" {
  value = {
    capacity_reservation = element(concat(aws_instance.this.*.capacity_reservation_specification, aws_spot_instance_request.this.*.capacity_reservation_specification, [""]), 0)
    spot_request_state   = element(concat(aws_spot_instance_request.this.*.spot_request_state, [""]), 0)
    primary_interface    = element(concat(aws_instance.this.*.primary_network_interface_id, aws_spot_instance_request.this.*.primary_network_interface_id, [""]), 0)
    spot_instance_id     = element(concat(aws_spot_instance_request.this.*.spot_instance_id, [""]), 0)
    spot_bid_status      = element(concat(aws_spot_instance_request.this.*.spot_bid_status, [""]), 0)
    instance_state       = element(concat(aws_instance.this.*.instance_state, aws_spot_instance_request.this.*.instance_state, [""]), 0)
    password_data        = element(concat(aws_instance.this.*.password_data, aws_spot_instance_request.this.*.password_data, [""]), 0)
    outpost_arn          = element(concat(aws_instance.this.*.outpost_arn, aws_spot_instance_request.this.*.outpost_arn, [""]), 0)
    private_dns          = element(concat(aws_instance.this.*.private_dns, aws_spot_instance_request.this.*.private_dns, [""]), 0)
    public_dns           = element(concat(aws_instance.this.*.public_dns, aws_spot_instance_request.this.*.public_dns, [""]), 0)
    private_ip           = element(concat(aws_instance.this.*.private_ip, aws_spot_instance_request.this.*.private_ip, [""]), 0)
    public_ip            = element(concat(aws_instance.this.*.public_ip, aws_spot_instance_request.this.*.public_ip, [""]), 0)
    tags_all             = element(concat(aws_instance.this.*.tags_all, aws_spot_instance_request.this.*.tags_all, [""]), 0)
    arn                  = element(concat(aws_instance.this.*.arn, aws_spot_instance_request.this.*.arn, [""]), 0)
    id                   = element(concat(aws_instance.this.*.id, aws_spot_instance_request.this.*.id, [""]), 0)
  }
}
