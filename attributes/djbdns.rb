djbdns Mash.new unless attribute?("djbdns")

djbdns[:tinydns_ipaddress] = "127.0.0.1" unless djbdns.has_key?(:tinydns_ipaddress)
djbdns[:tinydns_internal_ipaddress] = "127.0.0.1" unless djbdns.has_key?(:tinydns_internal_ipaddress)
djbdns[:axfrdns_ipaddress] = "127.0.0.1" unless djbdns.has_key?(:axfrdns_ipaddress)
djbdns[:public_dnscache_ipaddress] = ipaddress unless djbdns.has_key?(:public_dnscache_ipaddress)
# Default allowed networks is the current network class B
djbdns[:public_dnscache_allowed_networks] = [ipaddress.split(".")[0,2].join(".")] unless djbdns.has_key?(:public_dnscache_allowed_networks)
# Reverse DNS (PTR) networks
djbdns[:ptr_networks] = ['168.192', '28.172'] unless djbdns.has_key?(:ptr_networks)

# this may not exist on a first run of chef-solo on ec2
if attribute?("domain")
  djbdns[:tinydns_internal_resolved_domain] = domain unless djbdns.has_key?(:tinydns_internal_resolved_domain)
end
