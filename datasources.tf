data "aws_ami" "ubuntu_bionic" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_subnet" "selected" {
    id = var.subnet_id
}

data "aws_kms_alias" "bastion" {
    for_each = toset(local.bastion_encryption_keys)
    name     = "alias/${each.key}"
}

data "template_cloudinit_config" "bastion" {
    gzip          = true
    base64_encode = true

    part {
        content_type = "text/cloud-config"
        content      = local.userdata_bastion
    }
}

data "aws_secretsmanager_secret_version" "bastion" {
    for_each  = toset(var.bastion_secrets)
    secret_id = each.key
}


data "aws_route53_zone" "zone" {
    count    = length(var.dns_zones)
    name     = var.dns_zones[count.index]
    provider = aws.route_53_provider
}

data "aws_iam_policy_document" "bastion" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "bastion_permissions" {
    statement {
        actions = [
            "secretsmanager:GetRandomPassword",
            "ec2:Describe*",
            "s3:HeadBucket",
            "s3:ListAllMyBuckets",
        ]
        resources = ["*"]
    }
    statement {
        actions = [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds"
        ]
        resources = local.secrets_arn_list
    }
    statement {
        actions   = ["kms:*"]
        resources = local.keys_arn_list
    }
    statement {
        actions = ["kms:*"]
        resources = [
            "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
        ]
    }
    dynamic "statement" {
        for_each = toset(var.s3_bucket_rw_list)
        content {
            actions = [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ]
            resources = [
                "${data.aws_s3_bucket.rw[statement.key].arn}/*",
                data.aws_s3_bucket.rw[statement.key].arn
            ]
        }
    }
    dynamic "statement" {
        for_each = toset(var.s3_bucket_ro_list)
        content {
            actions = [
                "s3:GetObject",
                "s3:ListBucket"
            ]
            resources = [
                "${data.aws_s3_bucket.ro[statement.key].arn}/*",
                data.aws_s3_bucket.ro[statement.key].arn
            ]
        }
    }
}
