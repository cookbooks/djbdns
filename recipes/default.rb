include_recipe "build-essential"
include_recipe "runit"

package "djbdns"

user "dnscache" do
  uid 9997
  case node[:platform]
  when "ubuntu","debian"
    gid "nogroup"
  when "redhat", "centos"
    gid "nobody"
  else
    gid "nobody"
  end
  shell "/bin/false"
  home "/home/dnscache"
end

user "dnslog" do
  uid 9998
  case node[:platform]
  when "ubuntu","debian"
    gid "nogroup"
  when "redhat", "centos"
    gid "nobody"
  else
    gid "nobody"
  end
  shell "/bin/false"
  home "/home/dnslog"
end

user "tinydns" do
  uid 9999
  case node[:platform]
  when "ubuntu","debian"
    gid "nogroup"
  when "redhat", "centos"
    gid "nobody"
  else
    gid "nobody"
  end
  shell "/bin/false"
  home "/home/tinydns"
end