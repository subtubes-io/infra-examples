resource "aws_lb" "subtubes_prod" {
  drop_invalid_header_fields = false
  enable_deletion_protection = false
  enable_http2               = true
  enable_waf_fail_open       = false
  idle_timeout               = 60
  internal                   = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = "api-subtubes-loadbalancer"
  preserve_host_header       = false
  security_groups = [
    aws_security_group.prod_api_subtubes_lb.id
    #aws_security_group.api_subtubes_lb.id
  ]

  subnets  = data.terraform_remote_state.vpc.outputs.prod_main_public_subnets_ids
  tags     = {}
  tags_all = {}

  dynamic "subnet_mapping" {
    for_each = data.terraform_remote_state.vpc.outputs.prod_main_public_subnets_ids
    content {
      subnet_id = subnet_mapping.value
    }
  }


  timeouts {}

}



resource "aws_lb_listener" "subtubes_prod" {
  load_balancer_arn = aws_lb.subtubes_prod.arn
  port              = 80
  protocol          = "HTTP"
  tags              = {}
  tags_all          = {}

  default_action {

    target_group_arn = aws_lb_target_group.api_subtubes.arn
    type             = "forward"
  }

  timeouts {}
}



# resource "aws_lb_listener" "subtubes_prod" {
#   load_balancer_arn = aws_lb.subtubes_prod.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.front_end.arn
#   }
# }
