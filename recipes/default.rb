#
# Cookbook:: mongodb-afd
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
apt_repository 'mongodb' do
  uri        'http://repo.mongodb.org/apt/ubuntu'
  distribution 'trusty/mongodb-org/3.4'
  components ['multiverse']
  key '0C49F3730359A14518585931BC711F9BA15703C6'
  keyserver 'keyserver.ubuntu.com'
  action :add
end
