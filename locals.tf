locals {
    ami_id = var.ami != "" ? var.ami : data.aws_ami.ubuntu_bionic.image_id
    common_tags = {
        environment = var.environment
        managed-by  = "terraform"
        account     = data.aws_caller_identity.current.account_id
        service     = var.service_name
        region      = data.aws_region.current.name
    }
    secrets_arn_list = [
    for secret in data.aws_secretsmanager_secret_version.bastion : secret.arn
    ]

    bastion_encryption_keys = var.bastion_encryption_keys


    keys_arn_list = [
    for key in data.aws_kms_alias.bastion : key.arn
    ]


    userdata_bastion = format(
    "#cloud-config\n%s",
    yamlencode(
    {
        "write_files" : [
            {
                content : "export CHEF_LICENSE=accept",
                path : "/etc/profile.d/chef-license.sh"
            },
            {
                content : "",
                path : "/etc/chef/accepted_licenses/chef_dk"
            },
            {
                content : "",
                path : "/etc/chef/accepted_licenses/chef_infra_client"
            },
            {
                content : "",
                path : "/etc/chef/accepted_licenses/inspec"
            },
            {
                content : "[default]\nregion=${data.aws_region.current.name}\n",
                path : "/root/.aws/config",
                permissions : "0600"
            }

        ]
        apt : {
            sources : {
                chef : {
                    source : "deb http://packages.chef.io/repos/apt/stable $RELEASE main"
                    key : file("${path.module}/DEB-GPG-KEY-CHEF")
                }
            }
        }
        packages : [
            "chef", "vim", "awscli"
        ]
    })
    )
}
