

resource "aws_security_group" "bastion_sg" {
  name        = "${var.service_name}_sg"
  description = "Security group for a jumphost. Allows SSH and ICMP."
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(
    var.tags,
    local.common_tags,
    {
      "Name" = var.service_name
    }
  )
}
