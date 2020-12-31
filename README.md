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

For a more information, check out our blog with an example on how to use the module.

[https://revdb.io/2020/12/31/how-to-create-a-bastion-host-on-aws-using-terraform/](https://revdb.io/2020/12/31/how-to-create-a-bastion-host-on-aws-using-terraform/)

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
  key_pair_name = "deployer"
  subnet_id = "subnet-0a957113a9566cf64"
}

output "hostname" {
  value = module.bastion.public_bastion_ip
}
```

Will result in the output like this

```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

hostname = []
ipaddress = 18.224.24.223
```

Complex configuration might include a lot more, here is a hint:

```hcl
module "bastion" {
  source = "revenants-cie/revdb-bastion/aws"
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
ipaddress = 18.224.24.223
```
