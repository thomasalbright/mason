#!/usr/bin/env ruby

def allow_ssh(port: 22)
  return <<-eos

# Allow SSH connections
# - Force a two-second pause between connections from the same host
# - If same host attempts & fails to connect 5 times in 60 seconds,
#   blacklist for 1 hour, before whitelisting again
iptables -N SSH
iptables -N SSH_ABL
iptables --append SSH --match recent --name SSH_ABL --update --seconds 3600 --jump REJECT
iptables --append SSH --match recent --name SSH --rcheck --seconds 60 --hitcount 5 --jump SSH_ABL
iptables --append SSH_ABL --match recent --name SSH_ABL --set --jump LOG --log-level 4 --log-prefix "ABL: +SSH: "
iptables --append SSH_ABL --jump REJECT
iptables --append SSH --match recent --name SSH --rcheck --seconds 2 --jump LOG --log-level 4 --log-prefix "RATE: "
iptables --append SSH --match recent --name SSH --update --seconds 2 --jump REJECT
iptables --append SSH --match recent --name SSH_ABL --remove --jump LOG --log-level 4 --log-prefix "ABL: -SSH: "
iptables --append SSH --match recent --name SSH --set --jump ACCEPT
iptables --append INPUT --match state --state NEW -p tcp --match tcp --dport #{port} --jump SSH

eos
end

def generate(*args)
  to_write = <<-eos
#!/bin/sh
IPTABLES=/sbin/iptables

# Flush existing iptables rules & set default policy to DROP
iptables --flush
iptables --delete-chain
iptables --policy INPUT DROP
iptables --policy OUTPUT DROP
iptables --policy FORWARD DROP

# Allow all traffic on the loopback interface
iptables --append INPUT --in-interface lo --jump ACCEPT
iptables --append OUTPUT --out-interface lo --jump ACCEPT


#### INPUT chain

# state tracking rules
iptables --append INPUT --match state --state INVALID --jump LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
iptables --append INPUT --match state --state INVALID --jump DROP
iptables --append INPUT --match state --state ESTABLISHED,RELATED --jump ACCEPT

# Drop "unclean" malformed packets.
# - A future --match argument which will do all these things will be:
#   `iptables -A INPUT -m unclean -j DROP`.  But this is still listed as
#   experimental.
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags ACK,URG URG -j DROP
eos

  args.each do |rule|
    to_write << rule
  end

  to_write << <<-eos
# Allow HTTP and HTTPS
iptables -A INPUT -m state --state NEW -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -p tcp -m tcp --dport 443 -j ACCEPT

# Allow ping
iptables --append INPUT --protocol icmp --icmp-type echo-request --jump ACCEPT

# default INPUT LOG rule
iptables --append INPUT ! --in-interface lo --jump LOG --log-prefix "DROP " --log-ip-options --log-tcp-options


#### OUTPUT chain

# Allow all outgoing traffic
iptables --append OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
eos

  return to_write
end
