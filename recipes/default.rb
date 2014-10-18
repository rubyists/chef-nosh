#
# Cookbook Name:: nosh
# Recipe:: default
#
# Copyright 2014, Kevin Berry <kevin@opensourcealchemist.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential" # We expect build-essential to know what platforms it supports

unless File.exists?(File.join(node['nosh']['prefix'],"bin","nosh"))
  #TODO: Abstract this out into a common slashpackage paradigm
  directory "/usr/local/package" do
    mode 1755
  end

  link "/package" do
    to "/usr/local/package"
  end

  tarball = "nosh-#{node['nosh']['version']}.tar.bz2"

  remote_file "/package/#{tarball}" do
    source node['nosh']['source_url']
  end

  bash "extract_nosh" do
    cwd "/package"
    code "tar xjf #{tarball}"
    not_if { File.directory?("/package/nosh") }
  end

  bash "compile_nosh" do
    cwd "/package/nosh"
    code "package/compile"
  end

  bash "export_nosh" do
    cwd "/package/nosh"
    code "package/export #{node['nosh']['prefix']}"
  end

  directory "/package/nosh/build" do
    action :delete
    recursive true
  end
end
