provider "aws" {
  version = "~> 2.43"
  region  = var.region
}

provider "aws" {
  version = "~> 2.41"
  region  = var.region
  alias   = "route_53_provider"
}

provider "template" {
  version = "~> 2.1"
}
