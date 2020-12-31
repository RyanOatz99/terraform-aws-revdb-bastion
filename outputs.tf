output "public_bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "hostname" {
  value = aws_route53_record.bastion[*].fqdn
}
