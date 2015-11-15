#!/bin/bash -xe

DISTROS="trusty"

if [ ! -z "$AWS_REGION" ] ; then
  SRC_REGION=$AWS_REGION
else
  SRC_REGION=$(curl -s \
    http://169.254.169.254/latest/meta-data/placement/availability-zone \
    | sed -e 's/.$//g')
    if [ -z "$SRC_REGION" ] ; then
      SRC_REGION="us-east-1"
    fi
fi
export SRC_REGION

cd "$(dirname $0)/../"

rm -rf berks-cookbooks
bundle exec berks vendor -b cookbooks/packer-payload/Berksfile

for DISTRO in $DISTROS ; do
  export DISTRO
  SRC_AMI=$(bundle exec ruby ci/get_ubuntu_ami.rb)
  export SRC_AMI
  packer build templates/ubuntu.json
done
