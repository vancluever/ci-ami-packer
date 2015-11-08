#!/usr/bin/env bash

DISTROS="trusty"

SRC_REGION=`curl -s \
  http://169.254.169.254/latest/meta-data/placement/availability-zone \
  | sed -e 's/.$//g'`
export SRC_REGION

cd "$(dirname $0)/../"

for DISTRO in $DISTROS ; do
  export DISTRO
  SRC_AMI=$(ruby -e "require 'ubuntu_ami'" \
    -e "puts Ubuntu.release('$DISTRO').amis.find do |ami|"
    -e "  ami.arch == 'amd64' and ami.root_store == 'ebs'"
    -e "  and ami.region == '$SRC_REGION' }"
    -e "end.name")
  export SRC_AMI
  packer build ubuntu.json
done
