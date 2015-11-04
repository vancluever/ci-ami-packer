#!/usr/bin/env bash

TEMPLATES="ubuntu-14.04"

cd "$(dirname $0)/../"

for TEMPLATE in $TEMPLATES ; do
  packer build $TEMPLATE.json
done
