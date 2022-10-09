resource "aws_security_group" "prod_api_subtubes_lb" {
  name        = "api-subtubes-loadbalancer"
  description = "api-subtubes-loadbalancer"
  vpc_id      = data.terraform_remote_state.vpc.outputs.prod_main_vpc_id
  tags        = {}
  tags_all    = {}
}

# terraform import aws_security_group_rule.egress_all sg-06e160a2311509528_egress_all_0_0_0.0.0.0/0
resource "aws_security_group_rule" "lb_egress_all" {
  type              = "egress"
  description       = ""
  from_port         = 0
  protocol          = "-1" #change to tcp
  to_port           = 0 # 65535
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.prod_api_subtubes_lb.id
}

# terraform import aws_security_group_rule.ingress_http sg-06e160a2311509528_ingress_tcp_80_80_0.0.0.0/0
resource "aws_security_group_rule" "lb_ingress_http" {
  type = "ingress"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description       = ""
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
  security_group_id = aws_security_group.prod_api_subtubes_lb.id
}
