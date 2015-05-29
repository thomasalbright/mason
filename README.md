Mason
=====

Generate iptables rules from common configurations

Currently, mason only implements 1 configuration.  However, the plan is
to add others as needed.

The currently-supported configuration is for a server with HTTP, HTTPS,
SSH, and ping.  Most other incoming packets are rejected.  It also
attempts to slow down SSH attackers by restricting login attempts to
once every 2 seconds, and temporarily blacklisting an IP after 5 failed
attempts.


Usage
-----

1. Create a ruby script with your desired firewall rules, defined using mason:

    require_relative('mason')

    puts generate


2. Run your script, saving the output to a new bash script

    ruby generate.rb > iptables-set   # (Where 'iptables-set' is any filename you choose)


3. Run the generated bash script

    ./iptables-set


4. After executing the generated ruleset, to persist the rules through reboots
   on RHEL or CentOS, run

    service iptables save


Requirements
------------


For generating iptables rules
-----------------------------

* ruby


For executing generated rules
-----------------------------

* Bourne shell (sh)
* iptables
