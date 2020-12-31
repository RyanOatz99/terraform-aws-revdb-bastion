variable "environment" {}

variable "service_name" {}

variable "region" {}

variable "dns_zones" {
  default = ["revdb.dev", ]
}

variable "public_key_content" {
  description = "Value of public SSH key"
}
