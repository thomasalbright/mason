Manual Regression Tests
=======================

Under the default configuration, verify that the output of:

    iptables -L -n -v

is identical to:

```
17369 1980K ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/0           
  293 12408 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0           state INVALID LOG flags 6 level 4 prefix `DROP INVALID ' 
  293 12408 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0           state INVALID 
 101K   16M ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
    0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp flags:0x3F/0x00 
    0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp flags:0x03/0x03 
    0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp flags:0x06/0x06 
    0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp flags:0x05/0x05 
    0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp flags:0x11/0x01 
    0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp flags:0x30/0x20 
  200  9680 SSH        tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           state NEW tcp dpt:2222 
  383 21832 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           state NEW tcp dpt:80 
 3653  211K ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           state NEW tcp dpt:443 
    7   224 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0           icmp type 8 
  550 28200 LOG        all  --  !lo    *       0.0.0.0/0            0.0.0.0/0           LOG flags 6 level 4 prefix `DROP ' 

Chain FORWARD (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy DROP 4 packets, 508 bytes)
 pkts bytes target     prot opt in     out     source               destination         
17369 1980K ACCEPT     all  --  *      lo      0.0.0.0/0            0.0.0.0/0           
76582  373M ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           state NEW,RELATED,ESTABLISHED 

Chain SSH (1 references)
 pkts bytes target     prot opt in     out     source               destination         
  189  9072 REJECT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           recent: UPDATE seconds: 3600 name: SSH_ABL side: source reject-with icmp-port-unreachable 
    1    48 SSH_ABL    all  --  *      *       0.0.0.0/0            0.0.0.0/0           recent: CHECK seconds: 60 hit_count: 5 name: SSH side: source 
    0     0 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0           recent: CHECK seconds: 2 name: SSH side: source LOG flags 0 level 4 prefix `RATE: ' 
    0     0 REJECT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           recent: UPDATE seconds: 2 name: SSH side: source reject-with icmp-port-unreachable 
    0     0 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0           recent: REMOVE name: SSH_ABL side: source LOG flags 0 level 4 prefix `ABL: -SSH: ' 
   10   560 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           recent: SET name: SSH side: source 

Chain SSH_ABL (1 references)
 pkts bytes target     prot opt in     out     source               destination         
    1    48 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0           recent: SET name: SSH_ABL side: source LOG flags 0 level 4 prefix `ABL: +SSH: ' 
    1    48 REJECT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           reject-with icmp-port-unreachable 
```
