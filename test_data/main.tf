    module "test_bastion" {
  source        = "../"
  dns_zones     = var.dns_zones
        region = var.region
  subnet_id     = data.aws_subnet.selected.id
  environment   = var.environment
  service_name  = var.service_name
  key_pair_name = aws_key_pair.deployer.key_name
  s3_bucket_ro_list = [
    "test-revdb-mysql57"
  ]
  s3_bucket_rw_list = [
    "test-revenants-chef-server-backups-us-east-1"
  ]
  providers = {
    aws                   = aws
    aws.route_53_provider = aws
  }
  module_depends_on = [
    aws_key_pair.deployer
  ]
}
