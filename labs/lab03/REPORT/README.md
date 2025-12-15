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


| Метод            | Назначение                             | Как функционирует                                                                                      | Возможные результаты                               |
|------------------|---------------------------------------|------------------------------------------------------------------------------------------------------|--------------------------------------------------|
| **TCP connect**  | Полное сканирование портов           | Устанавливает полноценное соединение с целевым портом с помощью тройного рукопожатия TCP.           | Определяет открытые порты                          |
| **TCP SYN**      | Скрывное сканирование                 | Отправляет SYN-пакеты к открытым портам, не завершает соединение.                                   | Определяет открытые и закрытые порты, незаметно   |
| **UDP**          | Сканирование UDP портов               | Отправляет UDP-пакеты на порты, ожидая ICMP-ответы, чтобы определить открытые порты.               | Определяет открытые порты, может быть более медленным |
| **FIN**          | Сканирование закрытых портов          | Отправляет FIN-пакет к закрытым портам; открытые порты не реагируют, а закрытые — отправляют RST.  | Определяет закрытые порты                           |
| **ACK**          | Проверка наличия фильтров             | Отправляет ACK-пакеты и анализирует ответ; помогает определить, есть ли фильтры между хостами.     | Оценка наличия межсетевых экранов                  |
| **Xmas tree**    | Проверка системы безопасности         | Отправляет пакет с установленными флагами PSH, URG и FIN; обычно используется для обхода фильтров. | Определяет, какие порты открыты и отфильтрованы    |
| **NULL-сканирование** | Скрытое сканирование               | Отправляет пакет без установленных флагов; открытые порты игнорируют его, а закрытые отправляют RST. | Определяет, какие порты открыты, незаметно         |
| **ICMP ping**    | Проверка доступности хоста           | Отправляет ICMP Echo Request и ожидает Echo Reply от целевого хоста.                                | Оценка доступности устройства                       |
| **FTP-proxy**    | Сканирование через прокси FTP        | Использует прокси для проверки доступности FTP-серверов; может выявить дополнительные порты.       | Определение системы передачи файлов                  |
| **Idle scan**    | Невидимое сканирование                | Использует третий, «безмолвный» хост для отправки пакетов на целевой; скрывает отправителя.         | Определение открытых портов без обнаружения         |

<hr>

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

jvs@debian:~$ sudo nmap --script=vuln localhost -vv
[sudo] пароль для jvs: 
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-15 13:49 MSK
NSE: Loaded 105 scripts for scanning.
NSE: Script Pre-scanning.
NSE: Starting runlevel 1 (of 2) scan.
Initiating NSE at 13:49
NSE Timing: About 85.71% done; ETC: 13:50 (0:00:05 remaining)
Completed NSE at 13:50, 34.31s elapsed
NSE: Starting runlevel 2 (of 2) scan.
Initiating NSE at 13:50
Completed NSE at 13:50, 0.00s elapsed
Pre-scan script results:
| broadcast-avahi-dos: 
|   Discovered hosts:
|     224.0.0.251
|   After NULL UDP avahi packet DoS (CVE-2011-1002).
|_  Hosts are all up (not vulnerable).
Warning: Hostname localhost resolves to 2 IPs. Using 127.0.0.1.
Initiating SYN Stealth Scan at 13:50
Scanning localhost (127.0.0.1) [1000 ports]
Discovered open port 22/tcp on 127.0.0.1
Discovered open port 631/tcp on 127.0.0.1
Completed SYN Stealth Scan at 13:50, 1.23s elapsed (1000 total ports)
NSE: Script scanning 127.0.0.1.
NSE: Starting runlevel 1 (of 2) scan.
Initiating NSE at 13:50
Completed NSE at 13:50, 28.60s elapsed
NSE: Starting runlevel 2 (of 2) scan.
Initiating NSE at 13:50
Completed NSE at 13:50, 0.00s elapsed
Nmap scan report for localhost (127.0.0.1)
Host is up, received localhost-response (0.0000050s latency).
Other addresses for localhost (not scanned): ::1
Scanned at 2025-12-15 13:50:06 MSK for 30s
Not shown: 997 closed tcp ports (reset)
PORT     STATE    SERVICE REASON
22/tcp   open     ssh     syn-ack ttl 64
631/tcp  open     ipp     syn-ack ttl 64
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
|_      http://ha.ckers.org/slowloris/
|_http-aspnet-debug: ERROR: Script execution failed (use -d to debug)
|_http-jsonp-detection: Couldn't find any JSONP endpoints.
|_http-wordpress-users: [Error] Wordpress installation was not found. We couldn't find wp-login.php
| http-method-tamper: 
|   VULNERABLE:
|   Authentication bypass by HTTP verb tampering
|     State: VULNERABLE (Exploitable)
|       This web server contains password protected resources vulnerable to authentication bypass
|       vulnerabilities via HTTP verb tampering. This is often found in web servers that only limit access to the
|        common HTTP methods and in misconfigured .htaccess files.
|              
|     Extra information:
|       
|   URIs suspected to be vulnerable to HTTP verb tampering:
|     /admin [GENERIC]
|   
|     References:
|       http://capec.mitre.org/data/definitions/274.html
|       http://www.imperva.com/resources/glossary/http_verb_tampering.html
|       https://www.owasp.org/index.php/Testing_for_HTTP_Methods_and_XST_%28OWASP-CM-008%29
|_      http://www.mkit.com.ar/labs/htexploit/
| http-enum: 
|   /admin.php: Possible admin folder (401 \xD0\x92 \xD0\xB4\xD0\xBE\xD1\x81\xD1\x82\xD1\x83\xD0\xBF\xD0\xB5 \xD0\xBE\xD1\x82\xD0\xBA\xD0\xB0\xD0\xB7\xD0\xB0\xD0\xBD\xD0\xBE)
|   /admin/: Possible admin folder (401 \xD0\x92 \xD0\xB4\xD0\xBE\xD1\x81\xD1\x82\xD1\x83\xD0\xBF\xD0\xB5 \xD0\xBE\xD1\x82\xD0\xBA\xD0\xB0\xD0\xB7\xD0\xB0\xD0\xBD\xD0\xBE)
|   /admin/admin/: Possible admin folder (401 \xD0\x92 \xD0\xB4\xD0\xBE\xD1\x81\xD1\x82\xD1\x83\xD0\xBF\xD0\xB5 \xD0\xBE\xD1\x82\xD0\xBA\xD0\xB0\xD0\xB7\xD0\xB0\xD0\xBD\xD0\xBE)
|   /administrator/: Possible admin folder (401 \xD0\x92 \xD0\xB4\xD0\xBE\xD1\x81\xD1\x82\xD1\x83\xD0\xBF\xD0\xB5 \xD0\xBE\xD1\x82\xD0\xBA\xD0\xB0\xD0\xB7\xD0\xB0\xD0\xBD\xD0\xBE)

............

............

............

|   /admin/environment.xml: Moodle files (401 \xD0\x92 \xD0\xB4\xD0\xBE\xD1\x81\xD1\x82\xD1\x83\xD0\xBF\xD0\xB5 \xD0\xBE\xD1\x82\xD0\xBA\xD0\xB0\xD0\xB7\xD0\xB0\xD0\xBD\xD0\xBE)
|   /classes/: Potentially interesting folder
|   /es/: Potentially interesting folder
|   /help/: Potentially interesting folder
|_  /printers/: Potentially interesting folder
5000/tcp filtered upnp    no-response

NSE: Script Post-scanning.
NSE: Starting runlevel 1 (of 2) scan.
Initiating NSE at 13:50
Completed NSE at 13:50, 0.00s elapsed
NSE: Starting runlevel 2 (of 2) scan.
Initiating NSE at 13:50
Completed NSE at 13:50, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 64.38 seconds
           Raw packets sent: 1001 (44.044KB) | Rcvd: 2000 (84.004KB)


jvs@debian:~$ sudo nmap -sV --script vuln -oN nmapres_new.txt localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-15 13:53 MSK
Pre-scan script results:
| broadcast-avahi-dos: 
|   Discovered hosts:
|     224.0.0.251
|   After NULL UDP avahi packet DoS (CVE-2011-1002).
|_  Hosts are all up (not vulnerable).
Nmap scan report for localhost (127.0.0.1)
Host is up (0.0000040s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 997 closed tcp ports (reset)
PORT     STATE    SERVICE VERSION
22/tcp   open     ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
| vulners: 
|   cpe:/a:openbsd:openssh:10.0p2: 
|     	OSV:BELL-CVE-2025-61985	3.6	https://vulners.com/osv/OSV:BELL-CVE-2025-61985
|     	OSV:BELL-CVE-2025-61984	3.6	https://vulners.com/osv/OSV:BELL-CVE-2025-61984
|     	CVE-2025-61985	3.6	https://vulners.com/cve/CVE-2025-61985
|     	CVE-2025-61984	3.6	https://vulners.com/cve/CVE-2025-61984
|     	B7EACB4F-A5CF-5C5A-809F-E03CCE2AB150	3.6	https://vulners.com/githubexploit/B7EACB4F-A5CF-5C5A-809F-E03CCE2AB150	*EXPLOIT*
|_    	4C6E2182-0E99-5626-83F6-1646DD648C57	3.6	https://vulners.com/githubexploit/4C6E2182-0E99-5626-83F6-1646DD648C57	*EXPLOIT*
631/tcp  open     ipp     CUPS 2.4
|_http-aspnet-debug: ERROR: Script execution failed (use -d to debug)
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       http://ha.ckers.org/slowloris/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
| vulners: 
|   CUPS 2.4: 
|     	MSF:EXPLOIT-MULTI-MISC-CUPS_IPP_REMOTE_CODE_EXECUTION-	9.8	https://vulners.com/metasploit/MSF:EXPLOIT-MULTI-MISC-CUPS_IPP_REMOTE_CODE_EXECUTION-	*EXPLOIT*
|     	1337DAY-ID-39819	9.0	https://vulners.com/zdt/1337DAY-ID-39819*EXPLOIT*
|     	PACKETSTORM:182767	8.6	https://vulners.com/packetstorm/PACKETSTORM:182767	*EXPLOIT*
|     	6D7EB122-6604-5374-B851-DA56ABDA1F34	8.6	https://vulners.com/githubexploit/6D7EB122-6604-5374-B851-DA56ABDA1F34	*EXPLOIT*
|     	34D7D370-3683-5358-9692-BB0B5AF7F412	8.6	https://vulners.com/githubexploit/34D7D370-3683-5358-9692-BB0B5AF7F412	*EXPLOIT*
|     	CVE-2024-47850	7.5	https://vulners.com/cve/CVE-2024-47850
|     	MSF:AUXILIARY-SCANNER-MISC-CUPS_BROWSED_INFO_DISCLOSURE-	5.3	https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-MISC-CUPS_BROWSED_INFO_DISCLOSURE-	*EXPLOIT*
|     	F5502B30-710E-5D69-B67C-937F75899289	5.3	https://vulners.com/githubexploit/F5502B30-710E-5D69-B67C-937F75899289	*EXPLOIT*
|     	D0B85558-0ED9-5259-A56D-4C807CC07FCF	5.3	https://vulners.com/githubexploit/D0B85558-0ED9-5259-A56D-4C807CC07FCF	*EXPLOIT*
|     	ADDB422D-CF88-55B8-BA36-EC2BAC7507A0	5.3	https://vulners.com/githubexploit/ADDB422D-CF88-55B8-BA36-EC2BAC7507A0	*EXPLOIT*
|     	9DB4B6B1-3FB0-5827-B554-3F3779D23B09	5.3	https://vulners.com/githubexploit/9DB4B6B1-3FB0-5827-B554-3F3779D23B09	*EXPLOIT*
|_    	48FAED93-C711-59A0-B81E-A65D4463C7F0	5.3	https://vulners.com/githubexploit/48FAED93-C711-59A0-B81E-A65D4463C7F0	*EXPLOIT*
|_http-server-header: CUPS/2.4 IPP/2.1
| http-enum: 
|   /admin.php: Possible admin folder (401 \xD0\x92 \xD0\xB4\xD0\xBE\xD1\x81\xD1\x82\xD1\x83\xD0\xBF\xD0\xB5 \xD0\xBE\xD1\x82\xD0\xBA\xD0\xB0\xD0\xB7\xD0\xB0\xD0\xBD\xD0\xBE)
|   /admin/: Possible admin folder (401 \xD0\x92 \xD0\xB4\xD0\xBE\xD1\x81\xD1\x82\xD1\x83\xD0\xBF\xD0\xB5 \xD0\xBE\xD1\x82\xD0\xBA\xD0\xB0\xD0\xB7\xD0\xB0\xD0\xBD\xD0\xBE)


$ cat > ./nmapres_new.txt # сделать подобный пример файлу exmp_targets.txt

jvs@debian:~/course_labs/labs/lab03/REPORT$ grep "VULNERABLE" nmapres_new.txt
|   VULNERABLE:
|     State: LIKELY VULNERABLE



jvs@debian:~/course_labs/labs/lab03/REPORT$ mkdir -p ~/project/reports
jvs@debian:~/course_labs/labs/lab03/REPORT$ nmap -sV -p 8080 --script vuln -oN ~/project/reports/nmapres_new.txt -oX ~/project/reports/nmapres_new.xml localhost
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-15 13:58 MSK
Pre-scan script results:
| broadcast-avahi-dos: 
|   Discovered hosts:
|     224.0.0.251
|   After NULL UDP avahi packet DoS (CVE-2011-1002).
|_  Hosts are all up (not vulnerable).
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00059s latency).
Other addresses for localhost (not scanned): ::1

PORT     STATE  SERVICE    VERSION
8080/tcp closed http-proxy

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 34.49 seconds



jvs@debian:~/course_labs/labs/lab03/REPORT$ xsltproc ~/project/reports/nmapres_new.xml -o ~/project/reports/nmapres_new.html

```

HTML отчет:

<img width="1440" height="822" alt="Снимок экрана 2025-12-15 в 14 01 34" src="https://github.com/user-attachments/assets/9fbe3c7d-6bb1-41d9-b5ae-e30458d430d6" />


- [X] 3. Используйте команду `tree` и выведите все вложенные файлы по директориям.

```bash

jvs@debian:~/course_labs$ tree .
.
├── assets
│   └── logotype
│       ├── logo2.jpg
│       └── logo.jpg
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── docs
│   ├── about.md
│   ├── APPENDIX.md
│   ├── appsec_tt.md
│   ├── artifacts
│   │   ├── assets
│   │   │   ├── favicon.ico
│   │   │   ├── logo.png
│   │   │   └── logotypemd.jpg
│   │   ├── cheatsheet
│   │   │   ├── CHEATSHEET_DOCKERIGNORE.md
│   │   │   ├── CHEATSHEET_DOCKER.md
│   │   │   ├── CHEATSHEET_GH_CLI.md
│   │   │   ├── CHEATSHEET_GITIGNORE.md
│   │   │   └── CHEATSHEET_GIT.md
│   │   ├── exmpls
│   │   │   ├── exmpl.pdf
│   │   │   ├── Multisignature.pdf
│   │   │   ├── PrintNightmare.pdf
│   │   │   └── RA.pdf
│   │   ├── owasp
│   │   │   ├── Authentication.pdf
│   │   │   ├── Authorization.pdf
│   │   │   ├── Client-side_Attacks.pdf
│   │   │   ├── Command_Execution.pdf
│   │   │   ├── Information_Disclosure.pdf
│   │   │   ├── Logical_Attacks.pdf
│   │   │   └── OWASP_Top_10_CICD_Risks.pdf
│   │   └── ppt
│   │       └── Лекция_Управление Рисками ИБ_intro.pdf
│   ├── Authentication.md
│   ├── Authorization.md
│   ├── Client-side Attacks.md
│   ├── Command Execution.md
│   ├── Contributor Covenant.md
│   ├── course.md
│   ├── exmpl.md
│   ├── index.md
│   ├── Information Disclosure.md
│   ├── javascripts
│   │   └── custom-title.js
│   ├── labs
│   │   ├── lab01.md
│   │   ├── lab02.md
│   │   ├── lab03.md
│   │   ├── lab04.md
│   │   └── lab05.md
│   ├── licenses.md
│   ├── Logical Attacks.md
│   ├── Multisignature.md
│   ├── OWASP_Top_10_CICD_Risks.md
│   ├── PrintNightmare.md
│   ├── RA.md
│   ├── Security.md
│   └── stylesheets
│       ├── burger.css
│       ├── footer.css
│       ├── header.css
│       ├── mobile-logo.css
│       ├── search.css
│       ├── sidebar.css
│       ├── tools-overlay.css
│       └── typeset.css
├── labs
│   ├── lab01
│   │   ├── README.md
│   │   └── typersteel.py
│   ├── lab02
│   │   ├── exmpl_hello.py
│   │   ├── pygamesteel.py
│   │   └── README.md
│   ├── lab03
│   │   ├── exmp_targets.txt
│   │   ├── README.md
│   │   └── REPORT
│   │       ├── nmapres_new.txt
│   │       └── README.md
│   ├── lab04
│   │   └── README.md
│   ├── lab05
│   │   ├── client
│   │   │   ├── client.py
│   │   │   ├── Dockerfile
│   │   │   └── requirements.txt
│   │   ├── docker-compose.yml
│   │   ├── README.md
│   │   ├── server
│   │   │   ├── app.py
│   │   │   ├── Dockerfile
│   │   │   └── requirements.txt
│   │   └── source
│   │       ├── Dockerfile
│   │       ├── hello.py
│   │       └── requirements.txt
│   └── lab06
│       └── README.md
├── LICENSE.md
├── mkdocs.yml
├── mypy.ini
├── NOTICE.md
├── README.md
├── RELEASE_NOTES.md
├── requirements.txt
└── SECURITY.md

24 directories, 87 files

```

- [X] 4.Найдите IP сетевой карты `Ethernet`, которая соответствует вашей виртуальной машине используя `ifconfig` и выполните команду

```bash

jvs@debian:~/course_labs$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:3a:71:ac brd ff:ff:ff:ff:ff:ff
    altname enp2s0
    altname enx000c293a71ac
    inet 172.16.238.189/24 brd 172.16.238.255 scope global dynamic noprefixroute ens160
       valid_lft 1563sec preferred_lft 1563sec
    inet6 fe80::20c:29ff:fe3a:71ac/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: docker_gwbridge: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:7e:e5:df:68 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/16 brd 172.18.255.255 scope global docker_gwbridge
       valid_lft forever preferred_lft forever
    inet6 fe80::42:7eff:fee5:df68/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
4: br-722957a69741: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:e3:7a:f6:3f brd ff:ff:ff:ff:ff:ff
    inet 172.19.0.1/16 brd 172.19.255.255 scope global br-722957a69741
       valid_lft forever preferred_lft forever
5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:ef:bb:f8:89 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
10: veth0457570@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker_gwbridge state UP group default 
    link/ether 5a:8c:98:8e:4b:14 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::588c:98ff:fe8e:4b14/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
14: veth11ea278@if13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker_gwbridge state UP group default 
    link/ether 82:68:2e:de:fa:fa brd ff:ff:ff:ff:ff:ff link-netnsid 2
    inet6 fe80::8068:2eff:fede:fafa/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever 


jvs@debian:~/course_labs$ nmap -sP 172.16.238.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-15 14:11 MSK
Nmap scan report for 172.16.238.1
Host is up (0.0033s latency).
Nmap scan report for 172.16.238.2
Host is up (0.0023s latency).
Nmap scan report for 172.16.238.189
Host is up (0.00044s latency).
Nmap done: 256 IP addresses (3 hosts up) scanned in 2.89 seconds

```

- [X] 5. Определите ОС, данные ssh, telnet  с помощью `nmap` и выведитео них информацию.

```bash

jvs@debian:~/course_labs$ sudo nmap -A -p 22,23 172.16.238.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2025-12-15 14:08 MSK
Nmap scan report for 172.16.238.1
Host is up (0.00077s latency).

PORT   STATE  SERVICE VERSION
22/tcp closed ssh
23/tcp closed telnet
MAC Address: 1A:3E:EF:2D:CB:65 (Unknown)
Too many fingerprints match this host to give specific OS details
Network Distance: 1 hop

TRACEROUTE
HOP RTT     ADDRESS
1   0.77 ms 172.16.238.1

Nmap scan report for 172.16.238.2
Host is up (0.00061s latency).

PORT   STATE  SERVICE VERSION
22/tcp closed ssh
23/tcp closed telnet
MAC Address: 00:50:56:E9:6C:2D (VMware)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: specialized
Running: VMware Player
OS CPE: cpe:/a:vmware:player
OS details: VMware Player virtual NAT device
Network Distance: 1 hop

TRACEROUTE
HOP RTT     ADDRESS
1   0.61 ms 172.16.238.2

Nmap scan report for 172.16.238.254
Host is up (0.00067s latency).

PORT   STATE    SERVICE VERSION
22/tcp filtered ssh
23/tcp filtered telnet
MAC Address: 00:50:56:E9:C5:72 (VMware)
Too many fingerprints match this host to give specific OS details
Network Distance: 1 hop

TRACEROUTE
HOP RTT     ADDRESS
1   0.67 ms 172.16.238.254

Nmap scan report for 172.16.238.189
Host is up (0.00015s latency).

PORT   STATE  SERVICE VERSION
22/tcp open   ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
23/tcp closed telnet
Device type: general purpose
Running: Linux 2.6.X|5.X
OS CPE: cpe:/o:linux:linux_kernel:2.6.32 cpe:/o:linux:linux_kernel:5 cpe:/o:linux:linux_kernel:6
OS details: Linux 2.6.32, Linux 5.0 - 6.2
Network Distance: 0 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 256 IP addresses (4 hosts up) scanned in 13.17 seconds


```

- [X] 6. Результаты из `nmapres_new.txt` надо перенести в `nmapres.txt` и оставить оба файла рядом в локальном репозитории. Желательно использовать `cp` в консоли через редактор.

```bash

jvs@debian:~/course_labs/labs/lab03/REPORT$ cp nmapres_new.txt nmapres.txt

jvs@debian:~/course_labs/labs/lab03/REPORT$ git add nmapres.txt nmapres_new.txt

jvs@debian:~/course_labs/labs/lab03/REPORT$ git commit -m "add nmapres files"

```

- [X] 7. Оформить `README.md` по аналогии и использовать `shield`, etc.
- [X] 8. Составить `gist` отчет и отправить ссылку личным сообщением

***
