resource "aws_instance" "bastion" {
  ami                  = local.ami_id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  key_name             = var.key_pair_name
  iam_instance_profile = aws_iam_instance_profile.revdb_bastion_profile.name
  availability_zone    = data.aws_subnet.selected.availability_zone
  root_block_device {
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }
  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = merge(
    var.tags,
    local.common_tags,
    {
      "Name"              = "bastion",
      "image"             = local.ami_id,
      "availability-zone" = data.aws_subnet.selected.availability_zone,
      "instance-type"     = var.instance_type,
      "environment"       = var.environment
      "service"           = var.service_name
    }
  )
  user_data = var.userdata != "" ? var.userdata : data.template_cloudinit_config.bastion.rendered
  depends_on = [
    var.module_depends_on
  ]
}

