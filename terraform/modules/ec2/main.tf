resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  user_data              = data.template_cloudinit_config.user-data.rendered
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ips

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = var.instance_name
  }
}