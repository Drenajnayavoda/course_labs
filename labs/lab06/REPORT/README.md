<div align="center">
<h1><a id="intro">Лабораторная работа №6</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Ласточкин_И._А.-8b9aff" alt="Contributor Badge"></a></div>

***

Салют :wave:,<br>
Данная лабораторная работа посвещена изучению аудита безопасности `Docker` при использовании `Docker Bench Security`. Мы рассмотрим как с ним работать. Мы разберем как проверить конфигурации безопасности и выявить их не корректность, как произвести чекап с `CIS Docker Benchmark v1.6.0`.

Для сдачи данной работы также будет требоваться ответить на дополнительыне вопросы по описанным темам.

***

## Структура репозитория лабораторной работы

```bash
lab06
├── audit.sh
├── config
│   └── nginx.conf
├── docker-compose.yml
├── README.md
└── vulnerable-app.yml
```

***

## Материал

- **Docker Bench Security** - официальным инструментом аудита безопасности от Docker, который проверяет наличие практик при развертывания на `CIS Docker Benchmark`

- Реальный аудит контейнерной безопасности выполняется на Linux‑хосте / WSL2 с нативным Docker Engine», что соответствует методике CIS и практике промышленного Dockerhardening

- **Рассматриваемые вопросы безопасности**
    - Привилегионные контейнера
    - Захардкоженные данные учеток
    - Отключенные профили безопасности (AppArmor, Seccomp)
    - Прямое монтирования файловой системы
    - Устаревшие образы и явный запуск сервисов от привелегированного пользователя
    - Дополнительные сервисы, лишние утилиты
    - Ррасширенные volume‑маунты
    - env и SQL‑инициализации
    - Примеры анти‑паттернов privileged, host‑network, docker.sock, secrets-in-env, outdated images

-  **Контекст безопасности**

    - Не задавать пользователей с правами «root» для работы сервисов внутри контейнеров. 
    - Не запускать контейнеры в привилегированном режиме. 
    - Не отключать профили безопасности Docker. 
    - Не допускать запуск контейнеров, использующих тип сети «host»
    - Не разрешать доступ к docker.socket изнутри контейнера. Не подключать docker socket в контейнер без необходимости, либо с использованием плагинов авторизации. 
    - Не использовать секреты в открытом виде в Docker-файлах образов. По возможности не использовать переменные окружения и не хранить секреты внутри контейнера. Хранение и управление секретами возложить на сторонний сервис.
    - Ограничивать и контролировать использование ресурсов контейнерами. Указывать ограничения на уровне самого ПО или на уровне контейнеров для использования ресурсов хоста.
    - Контролировать качество базовых образов контейнеров. Использовать официальные образы и использовать образы с минимально необходимым набором инструментов.
    - Сканировать образы на наличие уязвимостей и проверки требований ИБ (Compliance Checks)
    - Сбрасывание capabilities уменьшает поверхность атаки
    - Файловые системы только для чтения предотвращают фальсификалирование
    - Пространства имен пользователя улучшает изоляцию

***

## Задание

- [x] 1. Необходимо установить `Docker Engine` для Linux
- [x] 2. Проверьте работу докера и сделать скрипт `audit.sh` исполняемым

jvs@debian:~/course_labs/labs/lab06$ chmod +x audit.sh

- [x] 3. Развернуть уязвимое приложение как отдельные стенды

```bash
jvs@debian:~/course_labs/labs/lab06$ docker compose up -d
WARN[0000] /home/jvs/course_labs/labs/lab06/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 24/24
 ✔ app Pulled                                                                                                                                           12.1s 
   ✔ 72b1a4cffaa5 Pull complete                                                                                                                          6.5s 
   ✔ 3acc1c0e9d9b Pull complete                                                                                                                          8.0s 
   ✔ fa3dd49b5d3b Pull complete                                                                                                                          7.4s 
 ✔ vulnerable-web Pulled                                                                                                                                 6.7s 
   ✔ f6b4fb944634 Pull complete                                                                                                                          1.0s 
   ✔ a0ef6d8231d0 Pull complete                                                                                                                          0.9s 
   ✔ 9076aaa4fd77 Pull complete                                                                                                                          1.0s 
   ✔ c0de4eea5b76 Pull complete                                                                                                                          1.7s 
   ✔ 6628835d87d2 Pull complete                                                                                                                          1.8s 
   ✔ ceb87b8ac279 Pull complete                                                                                                                          1.9s 
   ✔ f4f04eae8d5e Pull complete                                                                                                                          2.7s 
   ✔ 8a735f2296d4 Pull complete                                                                                                                          3.2s 
 ✔ insecure-db Pulled                                                                                                                                   15.5s 
   ✔ 409f53b105a8 Pull complete                                                                                                                          2.7s 
   ✔ d2f73330ca75 Pull complete                                                                                                                          3.5s 
   ✔ 9cf4b6218dc3 Pull complete                                                                                                                          3.6s 
   ✔ 9d26d6c343c2 Pull complete                                                                                                                          4.0s 
   ✔ fcf4b0abe453 Pull complete                                                                                                                          7.5s 
   ✔ c795092f8ce9 Pull complete                                                                                                                          4.4s 
   ✔ d7215aa7d72d Pull complete                                                                                                                          4.8s 
   ✔ 302472f811f6 Pull complete                                                                                                                          5.4s 
   ✔ ac7318a68b4c Pull complete                                                                                                                          5.7s 
   ✔ fe5ac8f25241 Pull complete                                                                                                                          6.3s 
[+] Running 4/4
 ✔ Network lab06_default       Created                                                                                                                   0.1s 
 ✔ Container insecure-db       Started                                                                                                                   0.1s 
 ✔ Container vulnerable-app    Started                                                                                                                   0.1s 
 ✔ Container vulnerable-nginx  Started                                                                                                                   0.0s 

jvs@debian:~/course_labs/labs/lab06$ docker compose -f vulnerable-app.yml up -d
WARN[0000] /home/jvs/course_labs/labs/lab06/vulnerable-app.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 10/10
 ✔ debug-shell Pulled                                                                                                                                    3.6s 
   ✔ f6b4fb944634 Already exists                                                                                                                         0.0s 
 ✔ vulnerable-web Pulled                                                                                                                                 7.4s 
   ✔ d637807aba98 Pull complete                                                                                                                          1.6s 
   ✔ 15a5b76537aa Pull complete                                                                                                                          1.9s 
   ✔ f43c327f6738 Pull complete                                                                                                                          0.8s 
   ✔ 1d5a66120144 Pull complete                                                                                                                          2.1s 
   ✔ 96b249cf17a2 Pull complete                                                                                                                          2.5s 
   ✔ a178f616fffa Pull complete                                                                                                                          2.8s 
   ✔ f54f17cce8f7 Pull complete                                                                                                                          3.1s 
WARN[0007] Found orphan containers ([vulnerable-app insecure-db]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up. 
[+] Running 4/4
 ✔ Container debug-shell                                                  Started                                                                        0.1s 
 ✔ Container vulnerable-nginx                                             Recreated                                                                      0.1s 
 ! debug-shell Published ports are discarded when using host network mode                                                                                0.0s 
 ✔ Container vulnerable-web                                               Started                                                                        0.2s 

jvs@debian:~/course_labs/labs/lab06$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS      NAMES
f0e3224f6d09   nginx:latest   "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds              vulnerable-web
3c688e4d7d74   registry:2     "/entrypoint.sh /etc…"   3 days ago      Up 3 days      5000/tcp   registry.1.wz50t2s123b1uy3zkytom4n56

```

- [x] 4. Запустите скрипт из `venv` и проанализируйте то, что вывело на терминале и что вывело при конвертировании

```bash
(venv) jvs@debian:~/course_labs/labs/lab06$ ./audit.sh
Starting Docker CIS & Image Security Audit
==========================================
Detected platform: Linux
Using docker-bench-security image: docker/docker-bench-security:latest
Reports will be saved to: ./audit_reports/

Running Trivy scan for docker/docker-bench-security:latest...
2026-01-14T14:44:55+03:00	INFO	[vulndb] Need to update DB
2026-01-14T14:44:55+03:00	INFO	[vulndb] Downloading vulnerability DB...
2026-01-14T14:44:55+03:00	INFO	[vulndb] Downloading artifact...	repo="mirror.gcr.io/aquasec/trivy-db:2"
80.10 MiB / 80.10 MiB [------------------------------------------------------------------------------------------------------------] 100.00% 1.20 MiB p/s 1m7s
2026-01-14T14:46:14+03:00	INFO	[vulndb] Artifact successfully downloaded	repo="mirror.gcr.io/aquasec/trivy-db:2"
2026-01-14T14:46:14+03:00	INFO	[vuln] Vulnerability scanning is enabled
2026-01-14T14:46:14+03:00	INFO	[secret] Secret scanning is enabled
2026-01-14T14:46:14+03:00	INFO	[secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2026-01-14T14:46:14+03:00	INFO	[secret] Please see https://trivy.dev/docs/v0.68/guide/scanner/secret#recommendation for faster secret detection
2026-01-14T14:46:15+03:00	INFO	Detected OS	family="alpine" version="3.8.2"
2026-01-14T14:46:15+03:00	INFO	[alpine] Detecting vulnerabilities...	os_version="3.8" repository="3.8" pkg_num=25
2026-01-14T14:46:15+03:00	INFO	Number of language-specific files	num=0
2026-01-14T14:46:15+03:00	WARN	This OS version is no longer supported by the distribution	family="alpine" version="3.8.2"
2026-01-14T14:46:15+03:00	WARN	The vulnerability detection may be insufficient because security updates are not provided
Saved to: ./audit_reports/json/docker-bench-security-trivy.json

Scanning lab images for vulnerabilities...

=== Trivy scan for nginx:alpine ===
2026-01-14T14:46:15+03:00	INFO	[vuln] Vulnerability scanning is enabled
2026-01-14T14:46:15+03:00	INFO	[secret] Secret scanning is enabled
2026-01-14T14:46:15+03:00	INFO	[secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2026-01-14T14:46:15+03:00	INFO	[secret] Please see https://trivy.dev/docs/v0.68/guide/scanner/secret#recommendation for faster secret detection
2026-01-14T14:46:16+03:00	INFO	Detected OS	family="alpine" version="3.23.2"
2026-01-14T14:46:16+03:00	WARN	This OS version is not on the EOL list	family="alpine" version="3.23"
2026-01-14T14:46:16+03:00	INFO	[alpine] Detecting vulnerabilities...	os_version="3.23" repository="3.23" pkg_num=72
2026-01-14T14:46:16+03:00	INFO	Number of language-specific files	num=0
Saved to: ./audit_reports/json/nginx-alpine-trivy.json

=== Trivy scan for python:3.11-alpine ===
2026-01-14T14:46:16+03:00	INFO	[vuln] Vulnerability scanning is enabled
2026-01-14T14:46:16+03:00	INFO	[secret] Secret scanning is enabled
2026-01-14T14:46:16+03:00	INFO	[secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2026-01-14T14:46:16+03:00	INFO	[secret] Please see https://trivy.dev/docs/v0.68/guide/scanner/secret#recommendation for faster secret detection
2026-01-14T14:46:16+03:00	INFO	[python] Licenses acquired from one or more METADATA files may be subject to additional terms. Use `--debug` flag to see all affected packages.
2026-01-14T14:46:16+03:00	INFO	Detected OS	family="alpine" version="3.23.2"
2026-01-14T14:46:16+03:00	WARN	This OS version is not on the EOL list	family="alpine" version="3.23"
2026-01-14T14:46:16+03:00	INFO	[alpine] Detecting vulnerabilities...	os_version="3.23" repository="3.23" pkg_num=38
2026-01-14T14:46:16+03:00	INFO	Number of language-specific files	num=1
2026-01-14T14:46:16+03:00	INFO	[python-pkg] Detecting vulnerabilities...
Saved to: ./audit_reports/json/python-3.11-alpine-trivy.json

=== Trivy scan for postgres:16-alpine ===
2026-01-14T14:46:17+03:00	INFO	[vuln] Vulnerability scanning is enabled
2026-01-14T14:46:17+03:00	INFO	[secret] Secret scanning is enabled
2026-01-14T14:46:17+03:00	INFO	[secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2026-01-14T14:46:17+03:00	INFO	[secret] Please see https://trivy.dev/docs/v0.68/guide/scanner/secret#recommendation for faster secret detection
2026-01-14T14:46:21+03:00	INFO	Detected OS	family="alpine" version="3.23.2"
2026-01-14T14:46:21+03:00	WARN	This OS version is not on the EOL list	family="alpine" version="3.23"
2026-01-14T14:46:21+03:00	INFO	[alpine] Detecting vulnerabilities...	os_version="3.23" repository="3.23" pkg_num=45
2026-01-14T14:46:21+03:00	INFO	Number of language-specific files	num=1
2026-01-14T14:46:21+03:00	INFO	[gobinary] Detecting vulnerabilities...
2026-01-14T14:46:21+03:00	WARN	Using severities from other vendors for some vulnerabilities. Read https://trivy.dev/docs/v0.68/guide/scanner/vulnerability#severity-selection for details.
Saved to: ./audit_reports/json/postgres-16-alpine-trivy.json

Linux host detected – configuring mounts for CIS Docker Benchmark coverage

Mounting /usr/bin/containerd
Mounting /usr/bin/runc
Mounting /usr/lib/systemd
Mounting /etc/docker
Mounting /var/log
Running Docker Bench Security container (CIS host audit)

WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: exec: "/usr/bin/dumb-init": stat /usr/bin/dumb-init: no such file or directory: unknown.
```

Так как у меня Mac с ARM, DBS не запускается, поэтому проведу ручной разбор конфигурации docker-compose:

<details>
<summary>Анализ docker-compose.yml</summary>

```bash

version: '3.8'  # [PASS] Актуальная версия Compose. Это позволяет использовать современные опции безопасности, такие как security_opt.

services:
  vulnerable-web:
    image: nginx:alpine  # [PASS] Минимальный официальный образ на базе Alpine. Причина: Меньше пакетов, меньше рисков атаки.
    container_name: vulnerable-nginx  # [INFO] Не влияет на безопасность.
    depends_on:
      - insecure-db
      - app  # [INFO] Зависимости не создают проблем с безопасностью.
    ports:
      - "8080:80"  # [WARN] Открытый порт на хосте. Причина: Увеличивает риск; атаки на порт 8080 могут использовать уязвимости в nginx.
    volumes:
      - ./config/nginx.conf:/etc/nginx/nginx.conf:ro  # [PASS] Монтирование только для чтения. Причина: Не дает контейнеру менять файлы.
    security_opt:
      - no-new-privileges:true  # [PASS] Запрет новых привилегий. Причина: Ограничивает рост прав внутри контейнера.
    user: "nginx"  # [PASS] Запуск не от root. Причина: Следует принципу минимальных прав.

  insecure-db:
    image: postgres:16-alpine  # [PASS] Минимальный образ. Причина: Официальный, с малым набором инструментов.
    container_name: insecure-db
    environment:
      - POSTGRES_PASSWORD=root  # [FAIL] Жестко заданный секрет в environment. Причина: Пароль видно в docker inspect; риск утечки.
      - POSTGRES_DB=vulnapp
      - POSTGRES_USER=vulnuser  # [WARN] Слабые учетные данные. Причина: Легко взломать brute-force.
    ports:
      - "5432:5432"  # [WARN] Открытый порт базы данных. Причина: Прямой доступ с хоста; лучше использовать внутреннюю сеть.
    volumes:
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql:ro  # [PASS] Только для чтения. Причина: Защищает от изменений.

  app:
    image: python:3.11-alpine  # [PASS] Минимальный образ.
    container_name: vulnerable-app
    depends_on:
      - insecure-db
    working_dir: /app  # [INFO] Не влияет на безопасность.
    volumes:
      - ./app:/app:rw  # [WARN] Монтирование с правом записи. Причина: Контейнер может изменить файлы на хосте; лучше сделать только для чтения.
    command: ["python", "app.py"]  # [INFO] Команда без рисков, но код app.py стоит проверить на проблемы.
    environment:
      - APP_SECRET_KEY=hardcoded-in-env  # [FAIL] Секрет в environment. Причина: Риск утечки через inspect или взломанный контейнер.
      - DB_URL=postgresql://vulnuser:root@insecure-db:5432/vulnapp  # [FAIL] Полные учетные данные в URL. Причина: Жестко заданный пароль; легко украсть.
      - DEBUG=true  # [WARN] Режим отладки включен. Причина: Может показать лишнюю информацию в ошибках.
    ports:
      - "5001:5000"  # [WARN] Открытый порт приложения.

```

</details>

 <details>
<summary>Анализ vulnerable-app.yml</summary>

```bash

version: "3.8"  # [PASS] Актуальная версия.

services:
  vulnerable-web:
    image: nginx:latest  # [WARN] Тег 'latest'. Причина: Версия не фиксирована; могут прийти обновления с уязвимостями.
    container_name: vulnerable-web
    privileged: true  # [FAIL] Privileged режим. Причина: Контейнер получает полный доступ к хосту; риск выхода за пределы контейнера.
    network_mode: host  # [FAIL] Host network mode. Причина: Контейнер делит сеть с хостом; можно перехватывать трафик.
    pid: host  # [FAIL] Host PID namespace. Причина: Доступ к процессам хоста; риск вмешательства.
    user: "0:0"  # [FAIL] Запуск от root. Причина: Нарушает минимальные права; упрощает рост привилегий.
    restart: always  # [INFO] Полезно для работы, но не для безопасности.
    environment:
      - ADMIN_USERNAME=admin  # [FAIL] Жестко заданные учетные данные.
      - ADMIN_PASSWORD=admin123  # [FAIL] Слабый пароль. Причина: Легко угадать или взломать.
      - DB_HOST=127.0.0.1
      - DB_USER=root
      - DB_PASSWORD=root  # [FAIL] Пароль в environment.
      - FLAG=FLAG{HARDCODED_SECRET_IN_ENV}  # [FAIL] Секрет в environment; показывает риск утечки.
    volumes:
      - /:/hostroot:rw  # [FAIL] Монтирование корневой системы хоста с правом записи. Причина: Полный доступ; риск изменений на хосте.
      - /var/run/docker.sock:/var/run/docker.sock  # [FAIL] Монтирование docker.sock. Причина: Управление Docker; можно создавать новые контейнеры.
      - ./backup:/var/backups:rw  # [WARN] С правом записи; можно менять.
      - ./config/nginx.conf:/etc/nginx/nginx.conf:rw  # [WARN] С правом записи.
    cap_add:
      - ALL  # [FAIL] Добавление всех capabilities. Причина: Увеличивает риски атаки; лучше убрать все и добавить только нужные.
    security_opt:
      - apparmor:unconfined  # [FAIL] AppArmor отключен. Причина: Нет изоляции.
      - seccomp:unconfined  # [FAIL] Seccomp отключен. Причина: Нет фильтров системных вызовов.
    logging:
      driver: "json-file"  # [PASS] JSON-логи. Причина: Легко анализировать.
      options:
        max-size: "50m"  # [PASS] Ограничение размера логов. Причина: Не дает переполнения.
    command: ["/bin/sh", "-c", "apt-get update && apt-get install -y vim net-tools iputils-ping && nginx -g 'daemon off;'"]  # [FAIL] Установка лишних инструментов. Причина: Увеличивает риски; в минимальном образе не нужно.

  debug-shell:
    image: alpine:latest  # [WARN] Тег 'latest'.
    container_name: debug-shell
    privileged: true  # [FAIL] Privileged.
    network_mode: host  # [FAIL] Host network.
    pid: host  # [FAIL] Host PID.
    user: "0:0"  # [FAIL] Root user.
    environment:
      - SSH_PASSWORD=password  # [FAIL] Слабый пароль для SSH.
    ports:
      - "22:22"  # [FAIL] Открытый SSH-порт. Причина: Риск удаленного доступа.
    volumes:
      - /:/hostroot:rw  # [FAIL] Корневая система хоста с правом записи.
    command: ["/bin/sh", "-c", "apk add --no-cache openssh-server && echo 'root:password' | chpasswd && /usr/sbin/sshd -D -o PermitRootLogin=yes -o PasswordAuthentication=yes"]  # [FAIL] Установка SSH с доступом root. Причина: Создает заднюю дверь.
```

</details>

- [x] 5. Проведите анализ уязвимостей, опишите их причину возникновения

Из compose (ручной Анализ): Основные — privileged (breakout), secrets-in-env (утечка), host mounts (доступ к хосту), отключенные профили (изоляция off), root user (эскалация), лишние utils (поверхность атаки), открытые порты (exposure). Причины: Анти-паттерны нарушающие least privilege

- [x] 6. Опишите влияния уязвимостей, их сценарий атаки



- [x] 7. Оцените риски ИБ и предложите меры для их снижения: 

> - Следует разобрать `.yaml` описав, что в них считается не безопасным и почему

> - Опишите сценарии реализации рисков CR, DL

Пример исправленного vulnerable-app.yml:

```bash
textversion: "3.8"
services:
  vulnerable-web:
    image: nginx:1.25-alpine  # Фиксированный тег
    container_name: vulnerable-web
    privileged: false  # Убрать
    network_mode: default  # Не host
    pid: container  # Не host
    user: "1000:1000"  # Non-root
    restart: always
    environment: []  # Нет secrets
    volumes:
      - ./config/nginx.conf:/etc/nginx/nginx.conf:ro  # Только ro, убрать docker.sock и /
    cap_drop: [ALL]  # Drop all.
    cap_add: [NET_BIND_SERVICE]  # Только needed
    security_opt:
      - apparmor:docker-default
      - seccomp:default
    command: ["nginx", "-g", "daemon off;"]  # Без install utils
  debug-shell:  # Удалить entirely, или сделать minimal без privileged/SSH
    # ... (аналогичные фиксы)
secrets:
  db_password: { file: ./secrets/db_pass }  # Для creds
```

- [x] 8. Сделайте анализ уязвимостей из сгенерированных файлов .odt, .xslx и опишите их в отчете. Файлы конвертируются в эти директории

```bash
"├── json/          (Trivy JSON outputs)"
"├── text/          (CIS audit text outputs)"
"├── xlsx/          (Excel spreadsheets)"
"└── odt/           (OpenDocument Text files)"
```

- [x] 9. Подготовьте отчет `gist`.
- [x] 10. Почистите кеш от `venv` и остановите уязвимостей приложение, почистите контейнера

```bash
$ rm -rf venv
$ docker-compose -f demo-vulnerable-app.yml down
$ docker system prune -f
```
 
***

## Troobleshooting

- Права для исполнения скрипта

```bash
$ chmod +x xxx.sh # разрешение прав при permission denied
```

- На macOS/AArch64 docker-bench-security может не запускаться из‑за ограничений Docker Desktop и это работает для Linux‑VM. На Mac используем Trivy‑скан и разбор конфигурации compose‑файлов.

***

## Links

- [Docker](https://docs.docker.com/)
- [Docker Engine security](https://docs.docker.com/engine/security/)
- [Docker Bench for Security](https://github.com/docker/docker-bench-security)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [Trivy: Container Security Scanner](https://aquasecurity.github.io/trivy/)
- [Markdown](https://stackedit.io)
- [Gist](https://gist.github.com)
- [GitHub Docs](https://docs.github.com/en)
- [GitHub CLI](https://cli.github.com)

Copyright (c) 2025 Ivan Lastochkin
