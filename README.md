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

    ./mason > iptables-set   # (Where 'iptables-set' is any filename you choose)
    ./iptables-set

After executing the generated ruleset, to persist the rules through reboots on
RHEL or CentOS, run

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
