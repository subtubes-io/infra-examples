resource "aws_route53_record" "public" {
  name    = "api.subtubes.io"
  type    = "A"
  zone_id = "Z3VGYF890VO9CP"

  alias {
    evaluate_target_health = false
    name                   = aws_lb.subtubes_prod.dns_name // dualstack.api-subtubes-loadbalancer-434722632.us-west-2.elb.amazonaws.com
    zone_id                = aws_lb.subtubes_prod.zone_id
  }
}


# terraform import aws_route53_record.public Z3VGYF890VO9CP_api.subtubes.io_A
