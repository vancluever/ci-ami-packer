#!/usr/bin/env bash

PACKER_URL="https://releases.hashicorp.com/packer"
PACKER_VER="0.8.6"
PACKER_SUM="2f1ca794e51de831ace30792ab0886aca516bf6b407f6027e816ba7ca79703b5"
PACKER_ZIP="packer_${PACKER_VER}_linux_amd64.zip"

cd "$(dirname $0)/../"

if [ ! -d vendor ] ; then mkdir vendor; fi
if [ ! -d vendor ] ; then mkdir vendor/bin; fi
if [ ! -d vendor ] ; then mkdir vendor/cache; fi

# Sudo is necessary for this setup.

if $(sudo sh -c true; echo $0) -ne "0"; then
  echo "ERROR: User needs to be able to sudo"
  exit 1
fi

# we need unzip
if ! which unzip; then
  # redhat
  if which yum ; then
    sudo yum install unzip
  elif which apt-get ; then
    sudo apt-get install unzip
  else
    echo "ERROR: unzip not found and cannot install"
    exit 0
  fi
fi

# We also need ChefDK
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -c current -P chefdk
# Chef gems
sudo chef gem install --no-user-install ubuntu_ami

wget -O vendor/cache/$PACKER_ZIP $PACKER_URL/$PACKER_VER/PACKER_ZIP
pushd vendor/cache
echo "$PACKER_SUM  $PACKER_ZIP" | shasum -c
popd

unzip vendor/cache/$PACKER_ZIP -d vendor/bin/
