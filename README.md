Mason
=====

Build iptables rules from common configurations

Currently, mason only implements 1 configuration.  However, the plan is
to add others as needed.

The currently-supported configuration is for a server with HTTP, HTTPS,
SSH, and ping.  Most other incoming packets are rejected.  It also
attempts to slow down SSH attackers by restricting login attempts to
once every 2 seconds, and temporarily blacklisting an IP after 5 failed
attempts.


Requirements
------------

* Bourne shell (sh)
* iptables
