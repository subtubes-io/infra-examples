resource "aws_security_group" "openvpn" {
  name   = "openvpn"
  vpc_id = data.terraform_remote_state.vpc.outputs.prod_main_vpc_id
}

resource "aws_security_group_rule" "ssh" {
  count             = var.enable_public_acess
  type              = "ingress"
  to_port           = 22
  protocol          = "TCP"
  from_port         = 22
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn.id
}

// openvpn daemon
resource "aws_security_group_rule" "https" {
  count             = var.enable_public_acess
  type              = "ingress"
  to_port           = 443
  protocol          = "TCP"
  from_port         = 443
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn.id
}

resource "aws_security_group_rule" "openvpn_admin" {
  count             = var.enable_public_acess
  type              = "ingress"
  to_port           = 943
  protocol          = "TCP"
  from_port         = 943
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn.id
}

resource "aws_security_group_rule" "openvpn_public" {
  count             = var.enable_public_acess
  type              = "ingress"
  to_port           = 945
  protocol          = "TCP"
  from_port         = 945
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn.id
}

resource "aws_security_group_rule" "openvpn_udp" {
  type              = "ingress"
  to_port           = 1194
  protocol          = "UDP"
  from_port         = 1194
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn.id
}

resource "aws_instance" "openvpn" {
  ami                    = "ami-0d10bccf2f1a6d60b"
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.openvpn.id]

  key_name                    = "aws-ec2-subtubes-prod"
  subnet_id                   = data.terraform_remote_state.vpc.outputs.prod_main_public_subnets_ids[0]
  associate_public_ip_address = true
  tags = {
    managedby = "manual"
  }
}

resource "aws_security_group_rule" "base_egress" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 0
  protocol          = "-1"
   security_group_id = aws_security_group.openvpn.id
  to_port           = 0
  type              = "egress"

  timeouts {}

}
