#!/usr/bin/env ruby

require 'ubuntu_ami'
distro = ENV['DISTRO']
region = ENV['SRC_REGION']
ami_id = Ubuntu.release(distro).amis.find do |ami|
  ami.arch == 'amd64' &&
  ami.root_store == 'ebs' &&
  ami.region == region
end
puts ami_id.name
