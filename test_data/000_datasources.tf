data "aws_vpcs" "available" {
  filter {
    name = "isDefault"
    values = [
      true
    ]
  }
}

data "aws_subnet_ids" "available" {
  vpc_id = tolist(data.aws_vpcs.available.ids)[0]
}

data "aws_subnet" "selected" {
  id = tolist(data.aws_subnet_ids.available.ids)[0]
}
