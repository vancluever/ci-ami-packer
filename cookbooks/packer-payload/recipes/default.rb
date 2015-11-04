case node[platform_family]
when 'debian'
  include_recipe 'apt::default'
  execute 'apt-get -y upgrade' do
    action :run
  end
when 'redhat'
  execute 'yum -y update' do
    action :run
  end
end

include_recipe 'build-essential::default'
include_recipe 'java::default'

ruby_runtime '2' do
  action :install
end

python_runtime '2' do
  action :install
end

node['packer-payload']['ruby_gems'].each do |gem|
  ruby_gem gem do
    action :install
  end
  chef_gem gem do
    action :install
  end
end

node['packer-payload']['python_pips'].each do |pip_pkg|
  python_package pip_pkg do
    action :install
  end
end
