# Create Bastion Instance
resource "aws_instance" "bastion_instance" {
  ami                         = var.bastion_instance_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = module.network.lb_public_subnet_ids[0]
  vpc_security_group_ids      = [module.secgrp.lb_security_group_id]
  source_dest_check           = false
  key_name                    = var.aws_ssh_key_pair
  associate_public_ip_address = true

  lifecycle {
    ignore_changes = [ami]
  }

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Bastion" },
    var.tags,
  )
}

# Create Elastic IP for the Bastion instance
resource "aws_eip" "instance-eip" {
  vpc = true
  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Bastion" },
  )
}
# Associate Elastic IP association
resource "aws_eip_association" "bastion_eip_association" {
  instance_id   = aws_instance.bastion_instance.id
  allocation_id = aws_eip.instance-eip.id
}
