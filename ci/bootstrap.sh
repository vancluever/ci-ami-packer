#!/usr/bin/env bash

PACKER_URL="https://releases.hashicorp.com/packer"
PACKER_VER="0.8.6"
PACKER_SUM="2f1ca794e51de831ace30792ab0886aca516bf6b407f6027e816ba7ca79703b5"
PACKER_ZIP="packer_${PACKER_VER}_linux_amd64.zip"

cd "$(dirname $0)/../"

if [ ! -d vendor ] ; then mkdir vendor; fi
if [ ! -d vendor ] ; then mkdir vendor/bin; fi
if [ ! -d vendor ] ; then mkdir vendor/cache; fi

# we need unzip
if ! which unzip; then
  # redhat
  if which yum ; then
    sudo yum install unzip
  elif which apt-get ; then
    sudo apt-get install unzip
  else
    echo "ERROR: unzip not found and cannot install"
  fi
fi

wget -O vendor/cache/$PACKER_ZIP $PACKER_URL/$PACKER_VER/PACKER_ZIP
pushd vendor/cache
echo "$PACKER_SUM  $PACKER_ZIP" | shasum -c
popd

unzip vendor/cache/$PACKER_ZIP -d vendor/bin/
