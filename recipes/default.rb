#
# Cookbook:: mongodb-afd
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Setup is described here
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/

# Update periodically - doesn't really make sense for running through Kitchen, but perfect for when run as chef-client 
apt_update 'all platforms' do
  frequency 86400
  action :periodic
end

# Add the mongo dist repo to the /etc/apt/source.list.d
apt_repository 'mongodb' do
  uri        'http://repo.mongodb.org/apt/ubuntu'
  distribution 'trusty/mongodb-org/3.4'
  components ['multiverse']
  key '0C49F3730359A14518585931BC711F9BA15703C6'
  keyserver 'keyserver.ubuntu.com'
  cache_rebuild true
  action :add
end

# Install the mongodb-org package
apt_package 'mongodb-org'

# enable the service to start and start from boot
service 'mongod' do
  action [:enable, :start]
end

# Write the seed file out to the node to initialise the Database
cookbook_file node['mongo_db']['database']['seed_file'] do
  source 'data.json'
  mode '0644'
  owner 'mongodb'
  group 'mongodb'
end

# Seed a new collection
execute 'Seed test Databatse' do
  command "mongoimport --db #{node['mongo_db']['database']['name']} --collection #{node['mongo_db']['database']['collection']}  --file #{node['mongo_db']['database']['seed_file']}"
  not_if "mongo test --eval \"printjson(db.getCollectionNames())\" | grep #{node['mongo_db']['database']['collection']}"
end
