provider "aws" {
  region = var.region
}
provider "aws" {
  region = var.region
  alias  = "route_53_provider"
}
