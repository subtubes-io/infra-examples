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
    "sg-06e160a2311509528",
  ]
  subnets = [
    "subnet-035d7bc44500bc0e9",
    "subnet-0a30d5f28757aa769",
  ]
  tags     = {}
  tags_all = {}

  subnet_mapping {
    subnet_id = "subnet-035d7bc44500bc0e9"
  }
  subnet_mapping {
    subnet_id = "subnet-0a30d5f28757aa769"
  }

  timeouts {}

}
