resource "aws_iam_role" "revdb_bastion_role" {
  name = "${var.service_name}_role"

  assume_role_policy = data.aws_iam_policy_document.bastion.json

  tags = merge(
    var.tags,
    local.common_tags,
    {
      "Name"        = "bastion"
      "environment" = var.environment
      "service"     = var.service_name
    }
  )
}

resource "aws_iam_role_policy_attachment" "revdb_bastion_policy_attachment" {
  role       = aws_iam_role.revdb_bastion_role.name
  policy_arn = aws_iam_policy.revdb_bastion_policy.arn
}

resource "aws_iam_instance_profile" "revdb_bastion_profile" {
  name = "${var.service_name}_profile"
  role = aws_iam_role.revdb_bastion_role.name
}

resource "aws_iam_policy" "revdb_bastion_policy" {
  name        = "${var.service_name}_policy"
  path        = "/"
  description = "${var.service_name} IAM Policy"
  policy      = data.aws_iam_policy_document.bastion_permissions.json
  depends_on  = [var.module_depends_on]
}
