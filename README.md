RevDB Bastion Module
================

Description
-----------

This module creates a bastion ec2 instance. Configuration extends to:

* Custom or auto AMI
* IAM policies and roles
* S3 Buckets
* Secrets and encryption keys
* Hostname

For a more information, check out our blog

[https://revdb.io/blog](https://revdb.io/blog)

S3 buckets and secrets
----------------------
We provide a way in the module, to pass in a list of s3 buckets for both rw/ro and a list of
secrets and kms aliases to control secret distribution.

For each of these, the policy will be automatically extended and created.


Examples
--------

The basic, this assumes you have no S3 bucket, secret or other dependencies. Deployer key must exists.

```hcl
module "bastion" {
  source = "revenants-cie/revdb-bastion/aws"
  dns_zones = ["infrastructureascode.blog"]
  key_pair_name = "deployer"
  subnet_id = "subnet-0a957113a9566cf64"
}

output "hostname" {
  value = module.bastion.hostname
}
```

Complex configuration might include a lot more, here is a hint:

```hcl
module "bastion" {
  source = "../../revdb/terraform-aws-revdb-bastion"
  dns_zones = ["infrastructureascode.blog"]
  key_pair_name = "deployer"
  subnet_id = "subnet-0a957113a9566cf64"
  environment = "test"
  service_name = "my_bastion"
  bastion_secrets = [
    "/chef-server/users/deployer/key",
    "/chef-server/users/admin1/key",
  ]
  bastion_encryption_keys = [
    "aws/ssm",
    "aws/secretsmanager"
  ]
  s3_bucket_ro_list = [
    "generic_config_files"
  ]
  s3_bucket_rw_list = [
    "baction_backup_bucket",
    "bastion_operational_logs"
  ]
}

output "hostname" {
  value = module.bastion.hostname
}
```

Output
------

Hostname of the new bastion instance

```bash
Outputs:

hostname = [
  "bastion.infrastructureascode.blog",
]
```
