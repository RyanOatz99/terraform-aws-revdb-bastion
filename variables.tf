variable "ami" {
  description = "AMI identifier that will be used for bastion. By default will use latest Ubuntu LTS."
  default     = ""
}

variable "region" {
  description = "AWS region"
  default     = "us-east-2"
}

variable "instance_type" {
  description = "Type of instance"
  default     = "t3.nano"
}

variable "subnet_id" {
  description = "Subnet id where to create EC2 instance for bastion host"
}

variable "key_pair_name" {
  description = "SSH key pair"
}

variable "environment" {
  default = "prod"
}

variable "service_name" {
  default = "revdb_bastion"
}

variable "tags" {
  description = "Tags to apply to each resource"
  default     = {}
}

variable "module_depends_on" {
  description = "Module dependencies"
  type        = any
  default     = null
}


variable "userdata" {
  description = "Provisioning userdata. If empty, default chef provisioner will be used."
  default     = ""
}

variable "bastion_secrets" {
  description = "List of secrets (SSM) the instances need RO access to"
  type        = list
  default     = []
}

variable "bastion_encryption_keys" {
  description = "List of encryption keys (KMS) the instances need RO access to"
  type        = list
  default = [
    "aws/ssm",
    "aws/secretsmanager"
  ]
}

variable "s3_bucket_rw_list" {
  description = "List of arm of s3 buckets the instances need RW access to"
  type        = list
  default     = []
}

variable "s3_bucket_ro_list" {
  description = "List of arm of s3 buckets the instances need RO access to"
  type        = list
  default     = []
}
variable "root_volume_size" {
  description = "Root volume size in GB"
  default     = 32
}

variable "dns_zones" {
  description = "DNS zones where create domain name for the bastion server"
  type        = list
  default     = []
}

variable "hostname_prefix" {
  default = "bastion"
}
