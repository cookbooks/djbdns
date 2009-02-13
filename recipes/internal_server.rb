include_recipe "djbdns"

execute "/usr/bin/tinydns-conf tinydns dnslog /etc/tinydns-internal #{node[:djbdns][:tinydns_ipaddress]}" do
  only_if "/usr/bin/test ! -d /etc/tinydns-internal"
end

execute "build-tinydns-internal-data" do
  cwd "/etc/tinydns-internal/root"
  command "make"
  action :nothing
end

# create dns entries for all nodes; requires chef-client (as opposed to chef-solo)
hosts = []
search(:node, "*") {|n| hosts << n }

template "/etc/tinydns-internal/root/data" do
  source "tinydns-internal-data.erb"
  mode 644
  variables(:hosts => hosts)
  notifies :run, resources("execute[build-tinydns-internal-data]")
end

template "/etc/tinydns-internal/run" do
  source "sv-server-run.erb"
  mode 0755
end

template "/etc/tinydns-internal/log/run" do
  source "sv-server-log-run.erb"
  mode 0755
end

link "#{node[:runit_service_dir]}/tinydns-internal" do
  to "/etc/tinydns-internal"
end

link "/etc/init.d/tinydns-internal" do
  to node[:runit_sv_bin]
end