resource "aws_route53_record" "bastion" {
  count    = length(var.dns_zones)
  provider = aws.route_53_provider
  name     = var.hostname_prefix
  type     = "A"
  zone_id  = data.aws_route53_zone.zone[count.index].id
  ttl      = "300"
  records = [
    aws_instance.bastion.public_ip
  ]
}
