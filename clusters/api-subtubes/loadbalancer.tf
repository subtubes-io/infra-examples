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
   aws_security_group.api_subtubes_lb.id
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
