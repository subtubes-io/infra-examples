resource "aws_lb_target_group" "api_subtubes" {
  name                          = "api-subtubes"
  vpc_id                        = data.terraform_remote_state.vpc.outputs.prod_main_vpc_id
  deregistration_delay          = "300"
  load_balancing_algorithm_type = "round_robin"
  port                          = 443
  protocol                      = "HTTPS"
  protocol_version              = "HTTP1"
  slow_start                    = 0
  tags                          = {}
  tags_all                      = {}
  target_type                   = "ip"


  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/api/messages/public"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
}
