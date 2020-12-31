from terraform_ci import terraform_apply

from tests.conftest import create_tf_conf


def test_bastion(ssh_key_pair):
    tf_dir = "test_data"
    destroy_after = True
    create_tf_conf(
        tf_dir,
        region="us-east-1",
        environment="_default",
        service_name="bastion",
        public_key_content=ssh_key_pair
    )
    with terraform_apply(tf_dir, json_output=True, destroy_after=destroy_after) as tf_out:
        assert(tf_out['bastion_ip']['value'])
