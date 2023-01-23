resource "aws_security_group" "ec2_demo" {
  name   = "ec2_demo"
  vpc_id = data.terraform_remote_state.vpc.outputs.prod_main_vpc_id
}

resource "aws_security_group_rule" "ssh" {
#  count             = var.enable_public_acess
  type              = "ingress"
  to_port           = 22
  protocol          = "TCP"
  from_port         = 22
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_demo.id
}


resource "aws_instance" "ec2_demo" {
  ami                    = "ami-0ecc74eca1d66d8a6" #"ami-0d10bccf2f1a6d60b"
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.ec2_demo.id]

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
   security_group_id = aws_security_group.ec2_demo.id
  to_port           = 0
  type              = "egress"
  timeouts {}
}
