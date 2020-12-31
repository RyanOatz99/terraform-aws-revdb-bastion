import logging
import os
import stat
from pprint import pformat

import boto3
import pytest
from os import path as osp

from terraform_ci import setup_environment, setup_logging

# "114198773012" is our test account
TEST_ACCOUNT = "114198773012"
LOG = logging.getLogger(__name__)

# setup terraform environment
setup_environment()
setup_logging(LOG, debug=True)


# make sure tests run under our test account
assert boto3.client("sts").get_caller_identity().get("Account") == TEST_ACCOUNT


@pytest.fixture(scope="session")
def ec2_client():
    ec2 = boto3.client("ec2", region_name="us-east-2")
    response = ec2.describe_vpcs()
    assert len(response["Vpcs"]) == 1, (
        "More than one VPC exists: %s"
        "Check if Travis-CI is running another test https://travis-ci.com/revenants-cie/"
        % pformat(response, indent=4)
    )
    return ec2


@pytest.fixture(scope="session")
def ec2_client_map():
    regions = [
        reg["RegionName"]
        for reg in boto3.client("ec2", region_name="us-east-1").describe_regions()[
            "Regions"
        ]
    ]
    ec2_map = {reg: boto3.client("ec2", region_name=reg) for reg in regions}

    for reg in regions:
        response = ec2_map[reg].describe_vpcs()
        assert len(response["Vpcs"]) == 1, (
            "More than one VPC exists in region %s: %s"
            "Check if Travis-CI is running another test https://travis-ci.com/revenants-cie/"
            % (reg, pformat(response, indent=4))
        )
    return ec2_map


def update_source(path, module_path):
    lines = open(path).readlines()
    with open(path, "w") as fp:
        for line in lines:
            line = line.replace("%SOURCE%", module_path)
            fp.write(line)


def create_tf_conf(tf_dir, **kwargs):
    with open(osp.join(tf_dir, "configuration.tfvars"), "w") as fd:
        for key, value in kwargs.items():
            fd.write(
                '{key} = "{value}"\n'.format(
                    key=key,
                    value=value
                )
            )
    LOG.info(
        "Terraform configuration: %s",
        open(osp.join(tf_dir, "configuration.tfvars")).read(),
    )


@pytest.fixture()
def ssh_key_pair():
    """
    :return: Public key
    :rtype: tuple
    """
    return open("tests/id_rsa.pub").read().strip()
