#
# Cookbook Name:: daemontools
# Recipe:: source
#
# Copyright 2010-2012, Opscode, Inc.
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

include_recipe "build-essential"

remote_file "/tmp/daemontools.tar.gz" do
  source node['daemontools']['source_url']
  checksum node['daemontools']['source_checksum']
  owner "root"
  not_if {::File.exists?("#{node['daemontools']['bin_dir']}/svscan")}
end

bash "install_daemontools" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    (cd /tmp; mkdir daemontools)
    (cd /tmp; tar zxvf daemontools.tar.gz -C daemontools --strip-components 2)
    (cd /tmp/daemontools; perl -pi -e 's/extern int errno;/\#include <errno.h>/' src/error.h)
    (cd /tmp/daemontools; package/compile)
    (cd /tmp/daemontools; mv command/* #{node['daemontools']['bin_dir']})
    EOH
  not_if {::File.exists?("#{node['daemontools']['bin_dir']}/svscan")}
end
