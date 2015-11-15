#!/bin/bash -xe

PACKER_URL="https://releases.hashicorp.com/packer"
PACKER_VER="0.8.6"
PACKER_SUM="2f1ca794e51de831ace30792ab0886aca516bf6b407f6027e816ba7ca79703b5"
PACKER_ZIP="packer_${PACKER_VER}_linux_amd64.zip"

cd "$(dirname $0)/../"

if [ ! -d vendor ] ; then mkdir vendor; fi
if [ ! -d vendor/bin ] ; then mkdir vendor/bin; fi
if [ ! -d vendor/cache ] ; then mkdir vendor/cache; fi

# we need unzip
if ! which unzip; then
  echo "ERROR: unzip not found"
  exit 0
fi

# bundler needs to be installed if it's not already on the box
if ! which bundle; then gem install bundler ; fi
# Install any gems we need gracefully into vendor with bundler
bundle install --binstubs --path vendor --retry 3

if [ "$(echo "$PACKER_SUM  vendor/cache/$PACKER_ZIP" | shasum -c > /dev/null ; echo $?)" -ne "0" ] ; then
  wget -O "vendor/cache/$PACKER_ZIP" "$PACKER_URL/$PACKER_VER/$PACKER_ZIP"
  echo "$PACKER_SUM  vendor/cache/$PACKER_ZIP" | shasum -c
  unzip -o "vendor/cache/$PACKER_ZIP" -d vendor/bin/
fi
