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

Trivy:
Устаревшие образы (alpine 3.8.2) — не поддерживаются, не получают обновлений безопасности.
Уязвимые пакеты (nginx, Python, Postgres) — установлены старые версии библиотек и зависимостей.
Секреты в образах — ключи и пароли могут быть встроены в слои.
Нефиксированные образы (latest) и отсутствие контроля цепочки поставок — образы могут изменяться без проверки.

- [x] 6. Опишите влияния уязвимостей, их сценарий атаки

privileged: true
Влияние: контейнер получает почти полный доступ к хосту → возможен выход из изоляции и полный компромисс хоста.
Сценарий: злоумышленник получает доступ в контейнер (через RCE/эксплойт) → использует привилегии для изменения системных файлов или запуска root-процессов на хосте.
Рекомендация: убрать privileged; дать только необходимые capabilities.

network_mode: host
Влияние: контейнер видит и использует сетевой стек хоста → перехват трафика, сканирование сервисов хоста.
Сценарий: эксплойт в приложении позволяет прослушать/подменить трафик локальных сервисов или использовать открытые порты хоста.
Рекомендация: использовать bridge/overlay, ограничить порты.

pid: host
Влияние: доступ к PID-пространству хоста → можно убивать/инспектировать процессы хоста.
Сценарий: через контейнер атакующий обнаруживает привилегированные процессы и завершает/инъектирует в них код.
Рекомендация: убрать pid: host.

user: "0:0" / PermitRootLogin
Влияние: процессы выполняются от root → эксплойт в приложении приводит к root на контейнере (и при плохих монтированиях — на хосте).
Сценарий: RCE → получение root; в связке с docker.sock или / монтированием — эскалация до хоста.
Рекомендация: запускать от непривилегированного пользователя.

Монтирование /:/hostroot:rw (rootfs rw)
Влияние: полный доступ к файловой системе хоста → немедленный компромисс.
Сценарий: злоумышленник модифицирует /etc/shadow, systemd-юниты, ставит бекдор на хост.
Рекомендация: не монтировать корень; если нужно — ограниченные, readonly пути.

Монтирование /var/run/docker.sock
Влияние: управление Docker на хосте → возможность создавать контейнеры с привилегиями, читать образы/секреты.
Сценарий: доступ в контейнер → запуск контейнера с привилегиями и доступ к хосту.
Рекомендация: избегать монтирования docker.sock; использовать API прокси/ролепривязку.

cap_add: ALL / security_opt: apparmor/seccomp unconfined
Влияние: отключение механик изоляции → увеличивает поверхность для атак системных вызовов и привилегий.
Сценарий: эксплойт использует опасные syscalls, которых нельзя было бы выполнить при включённом seccomp/AppArmor.
Рекомендация: не давать ALL; применять минимальный набор capabilities; включить профили seccomp/AppArmor.

Тег latest / нефиксированные образы
Влияние: непредсказуемые обновления, возможна подмена/неожиданное поведение; труднее отслеживать уязвимости.
Сценарий: автоматическая тянка образа с изменённым/уязвимым ПО → внезапное появление уязвимости в проде.
Рекомендация: фиксировать по тегу/digest, контролировать registry.

Устаревший OS / образы с EOL (alpine 3.8 и т.д.), старые пакеты
Влияние: отсутствуют security-обновления → известные CVE остаются эксплуатируемыми.
Сценарий: атаки по известным CVE квери/библиотекам (RCE, privilege escalation, утечка данных).
Рекомендация: обновить образы, пересобрать, включить SCA в CI.

Секреты в environment (ADMIN_PASSWORD, DB_PASSWORD, FLAG, APP_SECRET_KEY, DB_URL)
Влияние: секреты видны через docker inspect, логи или могут быть слиты при компромете контейнера.
Сценарий: воруют пароль → подключаются к БД/админке; секрет в env используется для обхода аутентификации.
Рекомендация: использовать secrets (Docker secrets/KV), vault, не хранить в env.

Установка инструментов в runtime (apt-get / apk add) / команда с установкой
Влияние: расширяет набор инструментов внутри образа (net-tools, sshd, vim) — даёт атакующему готовые инструменты.
Сценарий: после RCE атакующему доступны средства разведки и устойчивости (ssh, сетевые сканеры).
Рекомендация: собирать минимальные образы в CI, запрещать установки в runtime.

Открытые порты (22, 8080, 5432, 5001)
Влияние: увеличивают поверхность атаки; сервисы могут быть доступны извне.
Сценарий: брутфорс SSH, поиск уязвимостей nginx/приложения/БД и эксплойт.
Рекомендация: открывать только нужные порты, ограничивать доступ firewall/ingress.

Режим отладки (DEBUG=true)
Влияние: утечка подробной отладочной информации, стэктрейсы, секреты.
Сценарий: ошибка вызывает вывод секретов или внутренних путей/ключей → облегчает дальнейшие атаки.
Рекомендация: DEBUG=false в production.

Монтирование кода с правом записи (./app:/app:rw)
Влияние: контейнер может менять код на хосте → персистентная компрометация.
Сценарий: злоумышленник модифицирует app.py чтобы получить постоянный доступ.
Рекомендация: readonly монтирование или CI-деплой артефактов.

- [x] 7. Оцените риски ИБ и предложите меры для их снижения: 

image: ...:latest — плохая фиксация версии → непредсказуемые изменения/внезапные уязвимости. (CR/DL)
Митиг.: фиксировать тег или digest.

privileged: true / cap_add: - ALL — даёт контейнеру права, близкие к root хоста → быстрый путь к компрометации. (CR)
Митиг.: убрать privileged, минимизировать capabilities.

network_mode: host — общий сетевой стек с хостом → перехват/сканирование/атаки на локальные сервисы. (CR/DL)
Митиг.: использовать bridge/overlay, ограничить порты.

pid: host — доступ к процессам хоста → вмешательство в процессы хоста. (CR)
Митиг.: убрать.

user: "0:0" / PermitRootLogin=yes — запуск от root → упрощённая эскалация. (CR)
Митиг.: запускать от непривилегированного пользователя.

/:/hostroot:rw — монтирование корня хоста с записью → полный контроль над хостом. (CR/DL)
Митиг.: не монтировать корень; readonly, ограниченные пути.

/var/run/docker.sock:/var/run/docker.sock — управление Docker демоном → создание привилегированных контейнеров/доступ к образам. (CR)
Митиг.: не монтировать; использовать прокси/ролепривязку.

security_opt: apparmor:unconfined / seccomp:unconfined — отключение профилей → больше surface для syscall-атак. (CR)
Митиг.: включить строгие профили seccomp/AppArmor.

Жёсткие пароли/секреты в environment (ADMIN_PASSWORD, DB_PASSWORD, FLAG, APP_SECRET_KEY, DB_URL) — видны через inspect/логи → лёгкая кража. (DL)
Митиг.: Docker secrets / Vault / env на runtime через secure store; ротация секретов.

Открытые порты на хосте (22, 5432, 8080, 5001) — доступ извне → перебор/сканирование уязвимостей. (CR/DL)
Митиг.: уменьшить, использовать firewall, bastion, network policies.

Установка пакетов в runtime (apt-get/apk add) — увеличивает набор инструментов и CVE; даёт атакующему готовые утилиты. (CR)
Митиг.: собирать образ в CI; запретить runtime-установки.

volumes с :rw на конфиги/backup — позволяет изменять конфиг и персистентно сохранять бэкдоры. (CR/DL)
Митиг.: readonly для конфигов; контролировать backup, использовать ACL.

Сценарий реализации риска CR
Атакующий находит RCE уязвимость в приложении (например, через уязвимый nginx или web-app).
Через RCE получает shell в контейнере, запускает команды с root (контейнер запущен от root / privileged).
Использует /var/run/docker.sock или /:/hostroot:rw для создания привилегированного контейнера или изменения файлов хоста → получает root на хосте.
Устанавливает персистентный бекдор, читает локальные креды, разворачивает lateral movement.
Последствие: полный контроль над хостом и соседними контейнерами.

Сценарий реализации риска DL
Атакующий получает доступ в контейнер (RCE / подброс SSH по слабому паролю / доступ к облаку).
Читает переменные окружения (DB_PASSWORD, APP_SECRET_KEY, FLAG) через docker exec/inspect или напрямую в процессе.
Подключается к БД по полученным учетным данным (порт 5432 открыт на хосте) и выгружает данные; или копирует файлы через смонтированные ./backup или /:/hostroot.
Экспортирует/публикует данные — утечка конфиденциальной информации; при повреждении — потеря данных.
Последствие: утечка пользовательских/бизнес-данных, репутационные и юридические риски.


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

docker-bench-security-trivy.json (Alpine 3.8.2)
Найдены критичные уязвимости — CVE-2019-9893 (libseccomp), CVE-2019-14697 (musl, musl-utils).
Корень проблемы: образ базируется на устаревшей версии Alpine (3.8.2), которая больше не получает обновлений безопасности.
Последствия: отсутствующие патчи для низкоуровневых библиотек позволяют использовать известные эксплойты — возможны эскалация привилегий и обход изоляции контейнера.
Что сделать: заменить образ на поддерживаемый, пересобрать с актуальными пакетами, зафиксировать тег/digest и ввести регулярные пересборки.

nginx-alpine-trivy.json (Alpine 3.23.2)
Критичных уязвимостей не обнаружено.
Вывод: образ актуален — оставлять, но периодически пересканивать.

python-3.11-alpine-trivy.json (Alpine 3.23.2)
Найдено CVE-2025-8869 (pip, severity MEDIUM).
Причина: в образе присутствует версия pip с известной уязвимостью.
Риск: атака через менеджер пакетов или поставляемые зависимости; потенциально — выполнение нежелательных действий при установке пакетов.
Рекомендация: обновить pip внутри образа, пересобрать, включить проверку зависимостей (pip-audit/SCA).

postgres-16-alpine-trivy.json (Alpine 3.23.2)
Найдено несколько уязвимостей в стандартной библиотеке (ряд HIGH и MEDIUM), плюс сообщение о том, что некоторые оценки берутся от других вендоров (в т.ч. Go-бинарники).
Причина: образ содержит компоненты (Go-бинарники / stdlib) с уязвимостями; данные о severity агрегированы из разных баз.
Риск: эксплуатация ошибок в библиотеке может привести к RCE, утечке или повреждению данных.
Рекомендация: обновить/пересобрать образ, проверить и обновить все встроенные бинарники и зависимости (особенно Go-модули), приоритизировать CVE с HIGH.

Рекомендации по CIS-пунктам

1.1.3–1.1.18 — auditd для Docker
Настройте системный аудит для критичных Docker-файлов и директорий (например, /var/lib/docker, /etc/docker). Это позволит отслеживать изменения конфигурации и файлов образов.

2.2 — ограничение трафика на default bridge
Не полагайтесь на стандартный мост Docker — применяйте сетевые политики, пользовательские bridge/overlay-сети и фильтрацию трафика, чтобы изолировать контейнеры и снизить возможность латерального движения.

2.9 — включение user namespaces
Включите разбиение соответствий пользователей (user namespace remapping), чтобы root внутри контейнера отображался на непривилегированного пользователя хоста — это существенно снижает риск компрометации хоста при взятии root в контейнере.

2.14 — применять no-new-privileges по умолчанию
Принудительно запрещайте повышение привилегий внутри контейнера (--security-opt=no-new-privileges), чтобы процессы не могли получить дополнительные capabilities.

4.5 — включить Docker Content Trust
Активируйте проверку подписи образов (DOCKER_CONTENT_TRUST=1) и внедрите процесс подписи релизных образов — это защитит от подмены или поставки поддельных образов.

4.6 — добавить HEALTHCHECK
В Dockerfile/образах задавайте HEALTHCHECK — оркестратор сможет корректно определять состояние контейнера и убирать неисправные экземпляры автоматически.

- [x] 9. Подготовьте отчет `gist`.

https://gist.github.com/Drenajnayavoda/518e00c0a3e15de49cd8a05f9c59affd

- [x] 10. Почистите кеш от `venv` и остановите уязвимостей приложение, почистите контейнера

```bash
$ rm -rf venv
$ docker-compose -f demo-vulnerable-app.yml down
$ docker system prune -f
```
Сделано
 
***

## Troobleshooting

- Права для исполнения скрипта

```bash
$ chmod +x xxx.sh # разрешение прав при permission denied
```

- На macOS/AArch64 docker-bench-security может не запускаться из‑за ограничений Docker Desktop и это работает для Linux‑VM. На Mac используем Trivy‑скан и разбор конфигурации compose‑файлов.

***

Copyright (c) 2025 Ivan Lastochkin
