<div align="center">
<h1><a id="intro">Лабораторная работа №3</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Ласточки_И._А.-8b9aff" alt="Contributor Badge"></a></div>

***

<br>Салют :wave:, </br>
Данная лабораторная работа посвещена изучению `nmap` и как с ним работать. Эта лабораторная работа послужит подпоркой для старта в выявлении и определении уязвимостей на уровне сканера портов, что бы освоить базовые методы сканирования. 

***

## Задание

- [X] 1. Опишите используемые методы по их назначению, как они функционируют и какие результаты могут дать для оценки. Используйте сноску из материалов выше по флагам команд.
- [X] 2. Выведите на терминале и проанализируйте следующие команды консоли

```bash
$ nmap localhost

jvs@debian:~/course_labs/labs/lab03$ nmap localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:13 MSK
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000049s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 998 closed tcp ports (conn-refused)
PORT    STATE SERVICE
22/tcp  open  ssh
631/tcp open  ipp

Nmap done: 1 IP address (1 host up) scanned in 0.05 seconds

$ nmap -sC localhost

jvs@debian:~/course_labs/labs/lab03$ nmap -sC localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:14 MSK
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000033s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 998 closed tcp ports (conn-refused)
PORT    STATE SERVICE
22/tcp  open  ssh
631/tcp open  ipp
|_ssl-date: TLS randomness does not represent time
|_http-title: Home - CUPS 2.4.10
| http-robots.txt: 1 disallowed entry 
|_/
| ssl-cert: Subject: commonName=debian/organizationName=debian/stateOrProvinceName=Unknown/countryName=RU
| Subject Alternative Name: DNS:debian, DNS:debian.local, DNS:localhost
| Not valid before: 2025-11-30T19:00:02
|_Not valid after:  2035-11-28T19:00:02

Nmap done: 1 IP address (1 host up) scanned in 1.68 seconds

$ nmap -p localhost

jvs@debian:~/course_labs/labs/lab03$ nmap -p localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:15 MSK
Found no matches for the service mask 'localhost' and your specified protocols
QUITTING!

$ nmap -O localhost

jvs@debian:~/course_labs/labs/lab03$ sudo nmap -O localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:55 MSK
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000049s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 998 closed tcp ports (reset)
PORT    STATE SERVICE
22/tcp  open  ssh
631/tcp open  ipp
Device type: general purpose
Running: Linux 2.6.X|5.X
OS CPE: cpe:/o:linux:linux_kernel:2.6.32 cpe:/o:linux:linux_kernel:5 cpe:/o:linux:linux_kernel:6
OS details: Linux 2.6.32, Linux 5.0 - 6.2
Network Distance: 0 hops

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1.45 seconds

$ nmap -p 80 localhost

jvs@debian:~/course_labs/labs/lab03$ nmap -p 80 localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:15 MSK
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00017s latency).
Other addresses for localhost (not scanned): ::1

PORT   STATE  SERVICE
80/tcp closed http

Nmap done: 1 IP address (1 host up) scanned in 0.03 seconds

$ nmap -p 443 localhost

jvs@debian:~/course_labs/labs/lab03$ nmap -p 443 localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:16 MSK
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00017s latency).
Other addresses for localhost (not scanned): ::1

PORT    STATE  SERVICE
443/tcp closed https

Nmap done: 1 IP address (1 host up) scanned in 0.04 seconds

$ nmap -p 8443 localhost

jvs@debian:~/course_labs/labs/lab03$ nmap -p 8443 localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:16 MSK
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00017s latency).
Other addresses for localhost (not scanned): ::1

PORT     STATE  SERVICE
8443/tcp closed https-alt

Nmap done: 1 IP address (1 host up) scanned in 0.04 seconds

$ nmap -p "*" localhost

jvs@debian:~/course_labs/labs/lab03$ nmap -p "*" localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:17 MSK
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000070s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 8375 closed tcp ports (conn-refused)
PORT    STATE SERVICE
22/tcp  open  ssh
631/tcp open  ipp

Nmap done: 1 IP address (1 host up) scanned in 1.11 seconds

$ nmap -sV -p 22,8080 localhost

jvs@debian:~/course_labs/labs/lab03$ nmap -sV -p 22,8080 localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:17 MSK
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00028s latency).
Other addresses for localhost (not scanned): ::1

PORT     STATE  SERVICE    VERSION
22/tcp   open   ssh        OpenSSH 10.0p2 Debian 7 (protocol 2.0)
8080/tcp closed http-proxy
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 0.17 seconds

$ nmap -sP 192.168.1.0/24

jvs@debian:~/course_labs/labs/lab03$ nmap -sP 192.168.1.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:18 MSK
Nmap done: 256 IP addresses (0 hosts up) scanned in 104.29 seconds
jvs@debian:~/course_labs/labs/lab03$ nmap -sP 192.168.31.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:20 MSK
Nmap scan report for 192.168.31.1
Host is up (0.013s latency).
Nmap scan report for 192.168.31.156
Host is up (0.018s latency).
Nmap done: 256 IP addresses (2 hosts up) scanned in 3.09 seconds
jvs@debian:~/course_labs/labs/lab03$ 

$ nmap --open 192.168.1.1

jvs@debian:~/course_labs/labs/lab03$ nmap --open 192.168.1.1
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:21 MSK
Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn
Nmap done: 1 IP address (0 hosts up) scanned in 3.08 seconds
jvs@debian:~/course_labs/labs/lab03$ nmap --open 192.168.31.1
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:21 MSK
Nmap scan report for 192.168.31.1
Host is up (1.0s latency).
Not shown: 985 closed tcp ports (conn-refused), 10 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
53/tcp   open  domain
80/tcp   open  http
443/tcp  open  https
8080/tcp open  http-proxy
8099/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 15.57 seconds

$ nmap --packet-trace 192.168.1.1

jvs@debian:~/course_labs/labs/lab03$ nmap --packet-trace 192.168.1.1
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:23 MSK
CONN (0.0329s) TCP localhost > 192.168.1.1:80 => Operation now in progress
CONN (0.0330s) TCP localhost > 192.168.1.1:443 => Operation now in progress
CONN (2.0358s) TCP localhost > 192.168.1.1:443 => Operation now in progress
CONN (2.0362s) TCP localhost > 192.168.1.1:80 => Operation now in progress
Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn
Nmap done: 1 IP address (0 hosts up) scanned in 3.04 seconds
jvs@debian:~/course_labs/labs/lab03$ nmap --packet-trace 192.168.31.1
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:23 MSK
CONN (0.0401s) TCP localhost > 192.168.31.1:80 => Operation now in progress
CONN (0.0402s) TCP localhost > 192.168.31.1:443 => Operation now in progress
CONN (0.0476s) TCP localhost > 192.168.31.1:80 => Connected
NSOCK INFO [0.0470s] nsock_iod_new2(): nsock_iod_new (IOD #1)
NSOCK INFO [0.0470s] nsock_connect_udp(): UDP connection requested to 172.16.238.2:53 (IOD #1) EID 8
NSOCK INFO [0.0470s] nsock_read(): Read request from IOD #1 [172.16.238.2:53] (timeout: -1ms) EID 18
NSOCK INFO [0.0480s] nsock_write(): Write request for 43 bytes to IOD #1 EID 27 [172.16.238.2:53]
NSOCK INFO [0.0480s] nsock_trace_handler_callback(): Callback: CONNECT SUCCESS for EID 8 [172.16.238.2:53]
NSOCK INFO [0.0480s] nsock_trace_handler_callback(): Callback: WRITE SUCCESS for EID 27 [172.16.238.2:53]
NSOCK INFO [0.1000s] nsock_trace_handler_callback(): Callback: READ SUCCESS for EID 18 [172.16.238.2:53] (43 bytes): .'...........1.31.168.192.in-addr.arpa.....
NSOCK INFO [0.1000s] nsock_read(): Read request from IOD #1 [172.16.238.2:53] (timeout: -1ms) EID 34
NSOCK INFO [0.1000s] nsock_iod_delete(): nsock_iod_delete (IOD #1)
NSOCK INFO [0.1000s] nevent_delete(): nevent_delete on event #34 (type READ)
CONN (0.1008s) TCP localhost > 192.168.31.1:22 => Operation now in progress
CONN (0.1008s) TCP localhost > 192.168.31.1:113 => Operation now in progress
CONN (0.1009s) TCP localhost > 192.168.31.1:135 => Operation now in progress
CONN (0.1010s) TCP localhost > 192.168.31.1:3306 => Operation now in progress
CONN (0.1010s) TCP localhost > 192.168.31.1:554 => Operation now in progress
CONN (0.1011s) TCP localhost > 192.168.31.1:53 => Operation now in progress
CONN (0.1011s) TCP localhost > 192.168.31.1:5900 => Operation now in progress
CONN (0.1011s) TCP localhost > 192.168.31.1:199 => Operation now in progress
CONN (0.1012s) TCP localhost > 192.168.31.1:8080 => Operation now in progress
CONN (0.1012s) TCP localhost > 192.168.31.1:1025 => Operation now in progress
CONN (0.1077s) TCP localhost > 192.168.31.1:53 => Connected
CONN (0.1077s) TCP localhost > 192.168.31.1:8080 => Connected
CONN (0.1091s) TCP localhost > 192.168.31.1:445 => Operation now in progress
CONN (0.1092s) TCP localhost > 192.168.31.1:143 => Operation now in progress
CONN (0.1092s) TCP localhost > 192.168.31.1:1723 => Operation now in progress
CONN (0.1093s) TCP localhost > 192.168.31.1:21 => Operation now in progress
CONN (1.1104s) TCP localhost > 192.168.31.1:1025 => Connection refused
CONN (1.1154s) TCP localhost > 192.168.31.1:445 => Connection refused
CONN (1.1154s) TCP localhost > 192.168.31.1:143 => Connection refused
CONN (1.1154s) TCP localhost > 192.168.31.1:1723 => Connection refused
CONN (1.1154s) TCP localhost > 192.168.31.1:21 => Connection refused
.......................
.......................
.......................
CONN (73.1906s) TCP localhost > 192.168.31.1:2383 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:10629 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:31038 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:19283 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:5440 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:9418 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:42 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:4125 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:125 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:5877 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:20828 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:1105 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:1000 => Connection refused
CONN (73.1906s) TCP localhost > 192.168.31.1:15660 => Connection refused
Nmap scan report for 192.168.31.1
Host is up (1.0s latency).
Not shown: 995 closed tcp ports (conn-refused)
PORT     STATE SERVICE
53/tcp   open  domain
80/tcp   open  http
443/tcp  open  https
8080/tcp open  http-proxy
8099/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 73.19 seconds

$ nmap --packet-trace scanme.nmap.org

jvs@debian:~/course_labs/labs/lab03$ nmap --packet-trace scanme.nmap.org
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:27 MSK
CONN (0.1013s) TCP localhost > 45.33.32.156:80 => Operation now in progress
CONN (0.1015s) TCP localhost > 45.33.32.156:443 => Operation now in progress
CONN (0.2760s) TCP localhost > 45.33.32.156:80 => Connected
NSOCK INFO [0.2760s] nsock_iod_new2(): nsock_iod_new (IOD #1)
NSOCK INFO [0.2780s] nsock_connect_udp(): UDP connection requested to 172.16.238.2:53 (IOD #1) EID 8
NSOCK INFO [0.2780s] nsock_read(): Read request from IOD #1 [172.16.238.2:53] (timeout: -1ms) EID 18
NSOCK INFO [0.2780s] nsock_write(): Write request for 43 bytes to IOD #1 EID 27 [172.16.238.2:53]
NSOCK INFO [0.2780s] nsock_trace_handler_callback(): Callback: CONNECT SUCCESS for EID 8 [172.16.238.2:53]
NSOCK INFO [0.2780s] nsock_trace_handler_callback(): Callback: WRITE SUCCESS for EID 27 [172.16.238.2:53]
NSOCK INFO [0.3440s] nsock_trace_handler_callback(): Callback: READ SUCCESS for EID 18 [172.16.238.2:53] (72 bytes): .............156.32.33.45.in-addr.arpa..................scanme.nmap.org.
NSOCK INFO [0.3440s] nsock_read(): Read request from IOD #1 [172.16.238.2:53] (timeout: -1ms) EID 34
NSOCK INFO [0.3440s] nsock_iod_delete(): nsock_iod_delete (IOD #1)
NSOCK INFO [0.3440s] nevent_delete(): nevent_delete on event #34 (type READ)
CONN (0.3466s) TCP localhost > 45.33.32.156:139 => Operation now in progress
CONN (0.3467s) TCP localhost > 45.33.32.156:143 => Operation now in progress
CONN (0.3468s) TCP localhost > 45.33.32.156:22 => Operation now in progress
CONN (0.3468s) TCP localhost > 45.33.32.156:80 => Operation now in progress
CONN (0.3469s) TCP localhost > 45.33.32.156:443 => Operation now in progress
CONN (0.3470s) TCP localhost > 45.33.32.156:25 => Operation now in progress
CONN (0.3470s) TCP localhost > 45.33.32.156:111 => Operation now in progress
CONN (0.3471s) TCP localhost > 45.33.32.156:8888 => Operation now in progress
CONN (0.3472s) TCP localhost > 45.33.32.156:21 => Operation now in progress
CONN (0.3473s) TCP localhost > 45.33.32.156:993 => Operation now in progress
CONN (0.5195s) TCP localhost > 45.33.32.156:139 => Connection refused
CONN (0.5195s) TCP localhost > 45.33.32.156:143 => Connection refused
CONN (0.5195s) TCP localhost > 45.33.32.156:80 => Connected
CONN (0.5195s) TCP localhost > 45.33.32.156:8888 => Connection refused
CONN (0.5227s) TCP localhost > 45.33.32.156:22 => Connected
CONN (0.5227s) TCP localhost > 45.33.32.156:443 => Connection refused
CONN (0.5227s) TCP localhost > 45.33.32.156:25 => Connection refused
CONN (0.5227s) TCP localhost > 45.33.32.156:111 => Connection refused
CONN (0.5227s) TCP localhost > 45.33.32.156:21 => Connection refused
CONN (0.5227s) TCP localhost > 45.33.32.156:993 => Connection refused
CONN (0.5230s) TCP localhost > 45.33.32.156:995 => Operation now in progress
CONN (0.5232s) TCP localhost > 45.33.32.156:587 => Operation now in progress
CONN (0.5232s) TCP localhost > 45.33.32.156:1025 => Operation now in progress
CONN (0.5233s) TCP localhost > 45.33.32.156:1723 => Operation now in progress
.......................
.......................
.......................
CONN (10.3718s) TCP localhost > 45.33.32.156:7435 => Operation now in progress
CONN (10.3718s) TCP localhost > 45.33.32.156:11110 => Connection refused
CONN (10.3718s) TCP localhost > 45.33.32.156:4126 => Connection refused
CONN (10.3718s) TCP localhost > 45.33.32.156:1301 => Connection refused
CONN (10.3718s) TCP localhost > 45.33.32.156:7911 => Connection refused
CONN (10.5429s) TCP localhost > 45.33.32.156:3300 => Connection refused
CONN (10.5429s) TCP localhost > 45.33.32.156:9503 => Connection refused
CONN (10.5429s) TCP localhost > 45.33.32.156:616 => Connection refused
CONN (10.5429s) TCP localhost > 45.33.32.156:1503 => Connection refused
CONN (10.5429s) TCP localhost > 45.33.32.156:7435 => Connection refused
CONN (10.5445s) TCP localhost > 45.33.32.156:18040 => Connection refused
CONN (10.5445s) TCP localhost > 45.33.32.156:5950 => Connection refused
CONN (10.5445s) TCP localhost > 45.33.32.156:4444 => Connection refused
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.17s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 996 closed tcp ports (conn-refused)
PORT      STATE SERVICE
22/tcp    open  ssh
80/tcp    open  http
9929/tcp  open  nping-echo
31337/tcp open  Elite

Nmap done: 1 IP address (1 host up) scanned in 10.55 seconds

$ nmap --iflist

jvs@debian:~/course_labs/labs/lab03$ nmap --iflist
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:28 MSK
************************INTERFACES************************
DEV    (SHORT)  IP/MASK                     TYPE     UP MTU   MAC
lo     (lo)     127.0.0.1/8                 loopback up 65536
lo     (lo)     ::1/128                     loopback up 65536
ens160 (ens160) 172.16.238.189/24           ethernet up 1500  00:0C:29:BA:87:65
ens160 (ens160) fe80::20c:29ff:feba:8765/64 ethernet up 1500  00:0C:29:BA:87:65

**************************ROUTES**************************
DST/MASK                     DEV    METRIC GATEWAY
172.16.238.0/24              ens160 100
0.0.0.0/0                    ens160 100    172.16.238.2
::1/128                      lo     0
fe80::20c:29ff:feba:8765/128 ens160 0
fe80::/64                    ens160 1024
ff00::/8                     ens160 256

$ nmap -iL scanme.nmap.org

jvs@debian:~/course_labs/labs/lab03$ nmap -iL scanme.nmap.org
Failed to open input file scanme.nmap.org for reading: No such file or directory (2)
jvs@debian:~/course_labs/labs/lab03$ echo "scanme.nmap.org" > scanme.nmap.org
jvs@debian:~/course_labs/labs/lab03$ nmap -iL scanme.nmap.org
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:49 MSK
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.17s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 996 closed tcp ports (conn-refused)
PORT      STATE SERVICE
22/tcp    open  ssh
80/tcp    open  http
9929/tcp  open  nping-echo
31337/tcp open  Elite

Nmap done: 1 IP address (1 host up) scanned in 18.86 seconds

$ nmap -A -iL scanme.nmap.org

jvs@debian:~/course_labs/labs/lab03$ nmap -A -iL scanme.nmap.org
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:50 MSK
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.18s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 996 closed tcp ports (conn-refused)
PORT      STATE SERVICE    VERSION
22/tcp    open  ssh        OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 ac:00:a0:1a:82:ff:cc:55:99:dc:67:2b:34:97:6b:75 (DSA)
|   2048 20:3d:2d:44:62:2a:b0:5a:9d:b5:b3:05:14:c2:a6:b2 (RSA)
|   256 96:02:bb:5e:57:54:1c:4e:45:2f:56:4c:4a:24:b2:57 (ECDSA)
|_  256 33:fa:91:0f:e0:e1:7b:1f:6d:05:a2:b0:f1:54:41:56 (ED25519)
80/tcp    open  http       Apache httpd 2.4.7 ((Ubuntu))
|_http-favicon: Nmap Project
|_http-title: Go ahead and ScanMe!
|_http-server-header: Apache/2.4.7 (Ubuntu)
9929/tcp  open  nping-echo Nping echo
31337/tcp open  tcpwrapped
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 53.04 seconds

$ nmap -sA scanme.nmap.org

jvs@debian:~/course_labs/labs/lab03$ sudo nmap -sA scanme.nmap.org
[sudo] пароль для jvs: 
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:52 MSK
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.00022s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
All 1000 scanned ports on scanme.nmap.org (45.33.32.156) are in ignored states.
Not shown: 1000 unfiltered tcp ports (reset)

Nmap done: 1 IP address (1 host up) scanned in 1.37 seconds

$ nmap -PN scanme.nmap.org

jvs@debian:~/course_labs/labs/lab03$ nmap -PN scanme.nmap.org 
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 19:56 MSK
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.18s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 996 closed tcp ports (conn-refused)
PORT      STATE SERVICE
22/tcp    open  ssh
80/tcp    open  http
9929/tcp  open  nping-echo
31337/tcp open  Elite

Nmap done: 1 IP address (1 host up) scanned in 455.44 seconds

$ nmap --script=vuln IP_addr -vv

jvs@debian:~/course_labs/labs/lab03$ nmap --script=vuln 45.33.32.156 -vv
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-07 20:12 MSK
NSE: Loaded 105 scripts for scanning.
NSE: Script Pre-scanning.
NSE: Starting runlevel 1 (of 2) scan.
Initiating NSE at 20:12
NSE Timing: About 85.71% done; ETC: 20:12 (0:00:05 remaining)
Completed NSE at 20:12, 34.36s elapsed
NSE: Starting runlevel 2 (of 2) scan.
Initiating NSE at 20:12
Completed NSE at 20:12, 0.00s elapsed
Pre-scan script results:
| broadcast-avahi-dos: 
|   Discovered hosts:
|     224.0.0.251
|   After NULL UDP avahi packet DoS (CVE-2011-1002).
|_  Hosts are all up (not vulnerable).
Initiating Ping Scan at 20:12
Scanning 45.33.32.156 [2 ports]
Completed Ping Scan at 20:12, 0.18s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 20:12
Completed Parallel DNS resolution of 1 host. at 20:12, 0.07s elapsed
Initiating Connect Scan at 20:12
Scanning scanme.nmap.org (45.33.32.156) [1000 ports]
Discovered open port 80/tcp on 45.33.32.156
Discovered open port 22/tcp on 45.33.32.156
Discovered open port 9929/tcp on 45.33.32.156
Discovered open port 31337/tcp on 45.33.32.156
Completed Connect Scan at 20:13, 13.07s elapsed (1000 total ports)
NSE: Script scanning 45.33.32.156.
NSE: Starting runlevel 1 (of 2) scan.
Initiating NSE at 20:13
NSE: [tls-ticketbleed 45.33.32.156:31337] Not running due to lack of privileges.
NSE: [firewall-bypass 45.33.32.156] lacks privileges.
NSE Timing: About 76.53% done; ETC: 20:13 (0:00:10 remaining)
NSE Timing: About 99.21% done; ETC: 20:14 (0:00:00 remaining)
NSE Timing: About 99.21% done; ETC: 20:14 (0:00:01 remaining)
NSE Timing: About 99.21% done; ETC: 20:15 (0:00:01 remaining)
NSE Timing: About 99.21% done; ETC: 20:15 (0:00:01 remaining)
NSE Timing: About 99.21% done; ETC: 20:16 (0:00:01 remaining)
NSE Timing: About 99.21% done; ETC: 20:16 (0:00:02 remaining)
NSE Timing: About 99.21% done; ETC: 20:17 (0:00:02 remaining)
NSE Timing: About 99.21% done; ETC: 20:17 (0:00:02 remaining)
NSE Timing: About 99.21% done; ETC: 20:18 (0:00:02 remaining)
NSE Timing: About 99.21% done; ETC: 20:18 (0:00:03 remaining)
NSE Timing: About 99.21% done; ETC: 20:19 (0:00:03 remaining)
NSE Timing: About 99.21% done; ETC: 20:19 (0:00:03 remaining)
NSE Timing: About 99.21% done; ETC: 20:20 (0:00:03 remaining)
NSE Timing: About 99.21% done; ETC: 20:20 (0:00:04 remaining)
Completed NSE at 20:21, 476.87s elapsed
NSE: Starting runlevel 2 (of 2) scan.
Initiating NSE at 20:21
Completed NSE at 20:21, 0.00s elapsed
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up, received syn-ack (0.17s latency).
Scanned at 2025-12-07 20:12:54 MSK for 490s
Not shown: 996 closed tcp ports (conn-refused)
PORT      STATE SERVICE    REASON
22/tcp    open  ssh        syn-ack
80/tcp    open  http       syn-ack
|_http-litespeed-sourcecode-download: Request with null byte did not work. This web server might not be vulnerable
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-jsonp-detection: Couldn't find any JSONP endpoints.
| http-csrf: 
| Spidering limited to: maxdepth=3; maxpagecount=20; withinhost=scanme.nmap.org
|   Found the following possible CSRF vulnerabilities: 
|     
|     Path: http://scanme.nmap.org:80/
|     Form id: nst-head-search
|     Form action: /search/
|     
|     Path: http://scanme.nmap.org:80/
|     Form id: nst-foot-search
|_    Form action: /search/
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
| http-enum: 
|_  /images/: Potentially interesting directory w/ listing on 'apache/2.4.7 (ubuntu)'
|_http-wordpress-users: [Error] Wordpress installation was not found. We couldn't find wp-login.php
9929/tcp  open  nping-echo syn-ack
31337/tcp open  Elite      syn-ack

NSE: Script Post-scanning.
NSE: Starting runlevel 1 (of 2) scan.
Initiating NSE at 20:21
Completed NSE at 20:21, 0.00s elapsed
NSE: Starting runlevel 2 (of 2) scan.
Initiating NSE at 20:21
Completed NSE at 20:21, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 524.71 seconds

$ nmap -sV --script vuln -oN nmapres_new.txt localhost
$ cat > ./nmapres_new.txt # сделать подобный пример файлу exmp_targets.txt
$ grep "VULNERABLE" nmapres_new.txt

$ mkdir -p ~/project/reports
$ nmap -sV -p 8080 --script vuln -oN ~/project/reports/nmapres_new.txt -oX ~/project/reports/nmapres_new.xml localhost
$ xsltproc ~/project/reports/nmapres_new.xml -o ~/project/reports/nmapres_new.html
```

- [X] 3. Используйте команду `tree` и выведите все вложенные файлы по директориям.
- [X] 4.Найдите IP сетевой карты `Ethernet`, которая соответствует вашей виртуальной машине используя `ifconfig` и выполните команду

```bash
nmap -sP inet_addr
```

- [X] 5. Определите ОС, данные ssh, telnet  с помощью `nmap` и выведитео них информацию.
- [X] 6. Результаты из `nmapres_new.txt` надо перенести в `nmapres.txt` и оставить оба файла рядом в локальном репозитории. Желательно использовать `cp` в консоли через редактор.
- [X] 7. Оформить `README.md` по аналогии и использовать `shield`, etc.
- [X] 8. Составить `gist` отчет и отправить ссылку личным сообщением

***
