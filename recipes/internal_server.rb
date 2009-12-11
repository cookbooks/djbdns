include_recipe "djbdns"

execute "/usr/bin/tinydns-conf tinydns dnslog /etc/tinydns-internal #{node[:djbdns][:tinydns_ipaddress]}" do
  only_if "/usr/bin/test ! -d /etc/tinydns-internal"
end

directory "/etc/tinydns-internal/root/zones" do
  mode 0755
end

directory "/etc/tinydns-internal/root/backup_data" do
  mode 0755
end

execute "build-tinydns-internal-data" do
  cwd "/etc/tinydns-internal/root"
  command "./update_from_zones && make"
  action :nothing
  notifies :restart, resources(:service => "public-dnscache")
end

template "/etc/tinydns-internal/run" do
  source "sv-server-run.erb"
  mode 0755
end

template "/etc/tinydns-internal/root/update_from_zones" do
  source "update_from_zones.sh.erb"
  mode 0755
end

remote_file "/etc/tinydns-internal/root/zones/old.zone" do
  source "old.zone"
  notifies :run, resources("execute[build-tinydns-internal-data]")
  backup false
end

remote_file "/etc/tinydns-internal/root/valtz" do
  source "valtz"
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