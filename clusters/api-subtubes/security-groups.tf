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
  to_port           = 0    # 65535
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


resource "aws_security_group_rule" "lb_ingress_https" {
  type = "ingress"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description       = ""
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
  security_group_id = aws_security_group.prod_api_subtubes_lb.id
}






resource "aws_security_group" "prod_api_subtubes_service" {
  name        = "api-subtubes-prod"
  description = "2022-10-06T06:35:44.526Z"
  vpc_id      = data.terraform_remote_state.vpc.outputs.prod_main_vpc_id
  tags        = {}
  tags_all    = {}
}

# terraform import aws_security_group_rule.service_egress_all sg-03534b2bd1efbb691_egress_all_0_0_0.0.0.0/0
resource "aws_security_group_rule" "service_egress_all" {
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
  type              = "egress"
  security_group_id = aws_security_group.prod_api_subtubes_service.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]

  timeouts {}
}

# terraform import aws_security_group_rule.service_ingress sg-03534b2bd1efbb691_ingress_tcp_6060_6060_0.0.0.0/0
resource "aws_security_group_rule" "service_ingress" {
  from_port         = 6060
  protocol          = "tcp"
  to_port           = 6060
  type              = "ingress"
  security_group_id = aws_security_group.prod_api_subtubes_service.id
  source_security_group_id = aws_security_group.prod_api_subtubes_lb.id

  timeouts {}
}
