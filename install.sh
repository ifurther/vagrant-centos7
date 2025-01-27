#!/bin/bash
set -x

export PATH=$PATH:/usr/local/bin

TERRAFORM_VERSION="0.10.1"
PACKER_VERSION="1.4.3"
VAGRANT_VERSION="2.2.5"


# install pip
pip install -U pip && pip3 install -U pip
if [[ $? == 127 ]]; then
    wget -q https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    python3 get-pip.py
    rm -rf get-pip.py
fi
# install awscli and ebcli
pip install -U awscli
pip install -U awsebcli

#vagrant
V_VERSION=$(vagrant -v | head -1 | cut -d ' ' -f 2)
V_RETVAL=${PIPESTATUS[0]}

[[ $V_VERSION != $VAGRANT_VERSION ]] || [[ $V_RETVAL != 0 ]] \
&& yum install -y https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.rpm


#terraform
T_VERSION=$(terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}

[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# packer
P_VERSION=$(packer.io -v)
P_RETVAL=$?

[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/ \
&& sudo ln -s /usr/local/packer /usr/local/bin/packer.io \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip

# clean up
yum clean all
