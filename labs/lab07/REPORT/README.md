<div align="center">
<h1><a id="intro">Лабораторная работа №7</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Шмаков_И._С.-8b9aff" alt="Contributor Badge"></a></div>

***

Салют :wave:,<br>
Данная лабораторная работа посвещена изучению аудита безопасности исходного кода приложения на статический анализ, включая првоерки зависимости. Мы рассмотрим как работать с `Semgrep`, `Checkov`, `Dependency Check` и правилами для них. Аналогично познакомися с `maven`. Мы разберем как проверить конфигурации безопасности и выявить их не корректность, как произвести чекап.

Для сдачи данной работы также будет требоваться ответить на дополнительыне вопросы по описанным темам.

***

## Структура репозитория лабораторной работы

```bash
lab07
├── cheat_check_yuorself.sh
├── docker-compose.yml
├── sast
│   ├── checkov-config.yaml
│   └── semgrep-rules.yml
├── sca
│   ├── dependency-check.sh
│   ├── generate_unified_report.sh
│   └── pom.xml
└── vulnerable-app
    ├── app.py
    ├── config.yaml
    ├── Dockerfile
    └── requirements.txt
```

***

## Материал

- SAST Static Application Security Testing — это статический анализ исходного кода, шаблонов и конфигураций на наличие уязвимостей без выполнения приложения, где:

> - Проверяются исходники, конфиги, Dockerfile, IaC‑файлы, шаблоны, но код не запускается
> - Инструменты SAST ищут небезопасные конструкции SQL‑инъекции, XSS, небезопасное использование криптографии, жёстко заданные секреты и т.п., сравнивая код с набором правил и паттернов
> - Подходит на ранних стадиях разработки: ошибки находят до деплоя, прямо на этапе коммита или CI

- SCA Software Composition Analysis — анализ сторонних библиотек, зависимостей и компонентов, которые приложение использует, где:

> - Целью является поиск уязвимостей и проблем в сторонних пакетах
> - Инструменты строят «список компонентов» SBOM, сопоставляют версии библиотек с базами уязвимостей NVD, GitHub Advisories и др., а также показывают, какие зависимости нужно обновить

- Semgrep используется для анализа исходного кода и конфигураций по набору правил, где:

> - Работает по принципу «структурного grep»: ищет не просто строки, а языковые конструкции if, функции, вызовы библиотек, поэтому хорошо подходит для поиска уязвимых паттернов в Python, Java, JavaScript и т.д.
> - Поддерживает готовые правила, в том числе по OWASP Top 10, и кастомные, которые можно описать в YAML

- Checkov ориентирован на инфраструктуру как код (IaC) и Docker, где:

> - Анализирует Terraform, CloudFormation, Kubernetes‑манифесты, Dockerfile и другие инфраструктурные файлы на ошибки конфигурации, которые могут привести к уязвимостям, как открытые порты, небезопасные политики, отключённая проверка сертификатов и т.п.
> - Подходит для автоматической проверки Docker/IaC в пайплайнах, чтобы не пропускать небезопасные настройки в образах и инфраструктуре

- OWASP Dependency‑Check для поиска уязвимостей в зависимостях проекта, где

> - Анализирует используемые библиотеки Maven‑зависимости, JAR‑файлы, Python‑пакеты и др., сопоставляет их с базами уязвимостей и выдаёт список известных проблем для конкретных версий по CVE

***

## Задание

- [x] 1. Разверните и подготовьте окружение для уязвимого приложения

```bash
$ python3 -m venv venv
$ source venv/bin/activate
$ pip install -r vulnerable-app/requirements.txt
```
Сделано

- [x] 2. Запустите уязвимое приложение

```bash
(venv) jvs@debian:~/course_labs/labs/lab07$ docker-compose -f docker-compose.yml up -d --build
WARN[0000] /home/jvs/course_labs/labs/lab07/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Building 43.0s (12/12) FINISHED                                                                                                            docker:default
 => [vulnerable-app internal] load build definition from Dockerfile                                                                                      0.0s
 => => transferring dockerfile: 463B                                                                                                                     0.0s
 => [vulnerable-app internal] load metadata for docker.io/library/python:3.11-slim                                                                       2.6s
 => [vulnerable-app auth] library/python:pull token for registry-1.docker.io                                                                             0.0s
 => [vulnerable-app internal] load .dockerignore                                                                                                         0.0s
 => => transferring context: 2B                                                                                                                          0.0s
 => [vulnerable-app 1/6] FROM docker.io/library/python:3.11-slim@sha256:c24e9effa2821a6885165d930d939fec2af0dcf819276138f11dd45e200bd032                 2.3s
 => => resolve docker.io/library/python:3.11-slim@sha256:c24e9effa2821a6885165d930d939fec2af0dcf819276138f11dd45e200bd032                                0.0s
 => => sha256:43f104c059a6e95da1dc5f65852a490b508ab85793f6f4369860995278e458c3 1.75kB / 1.75kB                                                           0.0s
 => => sha256:cfb0438cf5f86f4446f89139a4d8a71ab93e9c4367fc4600866cf43b2a210834 5.49kB / 5.49kB                                                           0.0s
 => => sha256:d67bedf18e0abdffd887db745e6a45c9173ae1b93fd7fac8d7a8c6b2e5346455 1.27MB / 1.27MB                                                           0.5s
 => => sha256:068949646e5ac13b4b3f99bca3f1249ca853fc5bd30512ea7d447af7a649b011 14.31MB / 14.31MB                                                         1.4s
 => => sha256:518abaec573aacfc293edf9e19b26274fc7ee5d3448e80f90eecdae829acd7e7 249B / 249B                                                               0.8s
 => => sha256:c24e9effa2821a6885165d930d939fec2af0dcf819276138f11dd45e200bd032 10.37kB / 10.37kB                                                         0.0s
 => => extracting sha256:d67bedf18e0abdffd887db745e6a45c9173ae1b93fd7fac8d7a8c6b2e5346455                                                                0.1s
 => => extracting sha256:068949646e5ac13b4b3f99bca3f1249ca853fc5bd30512ea7d447af7a649b011                                                                0.8s
 => => extracting sha256:518abaec573aacfc293edf9e19b26274fc7ee5d3448e80f90eecdae829acd7e7                                                                0.0s
 => [vulnerable-app internal] load build context                                                                                                         0.0s
 => => transferring context: 4.29kB                                                                                                                      0.0s
 => [vulnerable-app 2/6] WORKDIR /app                                                                                                                    0.1s
 => [vulnerable-app 3/6] RUN apt-get update &&     apt-get install -y --no-install-recommends         build-essential         libjpeg-dev zlib1g-dev    18.1s
 => [vulnerable-app 4/6] COPY requirements.txt /app/requirements.txt                                                                                     0.0s 
 => [vulnerable-app 5/6] RUN pip install --no-cache-dir -r requirements.txt                                                                             18.5s 
 => [vulnerable-app 6/6] COPY . /app                                                                                                                     0.0s 
 => [vulnerable-app] exporting to image                                                                                                                  1.2s 
 => => exporting layers                                                                                                                                  1.2s 
 => => writing image sha256:1318e9152439da16cf49a221bb7d6afe350bcf5d9812f105b6631c563ffd9c0d                                                             0.0s 
 => => naming to docker.io/library/lab07-vulnerable-app                                                                                                  0.0s 
[+] Running 2/2                                                                                                                                               
 ✔ Network lab07_default             Created                                                                                                             0.1s 
 ✔ Container lab07-vulnerable-app-1  Started        
```

- [x] 3. Запустите SAST Semgrep и проанализируйте выведенный лог в консоли и опишите логику правил для `semgrep-rules.yml` исходя из паттернов, которые используются. Отчет будет в директории SAST

```bash
(venv) jvs@debian:~/course_labs/labs/lab07$ semgrep --config sast/semgrep-rules.yml   --json   --output sast/semgrep-report.json   vulnerable-app/

┌──── ○○○ ────┐
│ Semgrep CLI │
└─────────────┘
...

...
┌──────────────┐
│ Scan Summary │
└──────────────┘
✅ Scan completed successfully.
 • Findings: 5 (5 blocking)
 • Rules run: 16
 • Targets scanned: 2
 • Parsed lines: ~100.0%
 • Scan was limited to files tracked by git
 • For a detailed list of skipped files and lines, run semgrep with the --verbose flag
Ran 16 rules on 2 files: 5 findings.
 
(venv) jvs@debian:~/course_labs/labs/lab07$ ls sast/semgrep-report.json 
sast/semgrep-report.json

```

Semgrep запустил 16 кастомных правил (12 для Python, 4 для YAML), ориентированных на поиск типовых уязвимостей: SQL-инъекции, RCE, `eval`, XSS, небезопасную десериализацию, debug-режим и жёстко заданные секреты.
По результатам анализа обнаружено 5 blocking-срабатываний, что указывает на наличие реальных небезопасных конструкций в `app.py` и/или `config.yaml`.
Не все правила сработали, что означает либо отсутствие соответствующих паттернов в коде, либо их неприменимость к данному приложению.

Описание логики правил `semgrep-rules.yml` по используемым паттернам:

### CRITICAL

* **py-sql-injection-critical** — выявляет SQL-инъекции по конкатенации строк и f-строк при формировании SQL-запросов без параметризации.
* **py-os-system-rce** — фиксирует возможность RCE при передаче пользовательских данных в `os.system`.
* **py-subprocess-rce** — обнаруживает командные инъекции при вызове shell через `subprocess` (`sh -c`).
* **py-arbitrary-file-read** — ловит чтение файлов по неконтролируемому пути (`open`), что указывает на LFI/Path Traversal.
* **py-unsafe-pickle-deserialization** — выявляет небезопасную десериализацию через `pickle.loads`, потенциально ведущую к RCE.

### HIGH

* **py-reflected-xss** — обнаруживает reflected XSS при прямой подстановке пользовательского ввода в HTML-ответ.
* **py-hardcoded-db-credentials** — ищет жёстко заданные логины и пароли БД в коде.
* **py-eval-user-input** — фиксирует использование `eval` над пользовательским вводом.
* **yaml-hardcoded-secrets-config / yaml-hardcoded-secrets-2** — выявляют хранение секретов и паролей в YAML-конфигурации.

### MEDIUM / LOW

* **py-debug-mode-enabled** — определяет включённый DEBUG-режим в продакшн-коде.
* **py-verbose-logging-sensitive** — указывает на избыточное логирование, потенциально раскрывающее чувствительные данные.
* **py-debug-endpoint-exposes-env** — выявляет debug-эндпоинты, возвращающие заголовки и переменные окружения.
* **yaml-insecure-security-flags** — обнаруживает отключённые механизмы защиты (CSRF, cookies, rate limiting).
* **py-info-version-disclosure** — фиксирует раскрытие версии приложения.
* **yaml-debug-and-unsafe-features** — указывает на включённые debug- и небезопасные экспериментальные функции.


- [x] 4. Запустите SAST Checkov по Dockerfile, compose и проанализируйте выведенный лог в консоли и опишите логику правил для `checkov-config.yaml` по `Docker`. Отчет будет в директории SAST

```bash
jvs@debian:~/course_labs/labs/lab07$ checkov --framework dockerfile   --file vulnerable-app/Dockerfile docker-compose.yml   --output json   --output-file-path sast/checkov-report.json   --soft-fail
[ dockerfile framework ]: 100%|████████████████████|[1/1], Current File Scanned=vulnerable-app/Dockerfile
{
    "check_type": "dockerfile",
    "results": {
        "passed_checks": [
            {
                "check_id": "CKV_DOCKER_1",
                "bc_check_id": "BC_DKR_1",
                "check_name": "Ensure port 22 is not exposed",
                "check_result": {
                    "result": "PASSED",
                    "results_configuration": null
                },
                "code_block": [
                    [
                        1,
                        "FROM python:3.11-slim\n"
                    ],
                    [
                        2,
                        "WORKDIR /app\n"
                    ],

...

```

Общий итог сканирования
Проверок выполнено: 52
Пройдено: 50
Провалено: 2
Ошибок парсинга: 0
Checkov: 3.2.497

Логика Docker-правил (checkov-config.yaml)
CKV_DOCKER_2 / CKV_DOCKER_10 — контейнер должен быть управляемым
Обязательное наличие HEALTHCHECK для мониторинга состояния сервиса.
CKV_DOCKER_3 / CKV_DOCKER_8 — запрет запуска под root
Требуется явное создание и использование non-root пользователя.
CKV_DOCKER_5 — воспроизводимость сборки
Запрещено использование latest без явного указания версии образа.
CKV_DOCKER_7 — предсказуемость сборки
Использование COPY вместо ADD для исключения побочных эффектов.
CKV_DOCKER_9 — минимизация attack surface
Сокращение числа пакетов, слоёв и общего размера образа.
CKV_DOCKER_12 — защита секретов
Запрет хранения чувствительных данных в ENV.
CKV_DOCKER_13 — изоляция контейнера
Запрет привилегированного режима выполнения.
CKV_DOCKER_14 — принцип минимальных привилегий
Ограничение Linux capabilities контейнера.
CKV_DOCKER_16 — защита файловой системы
Предпочтение read-only root filesystem.


- [x] 5. Подготовка зависимостей Java и Maven‑скан для проведения SCA. Отчеты будут в директории SCA. Будет ошибка, которую надо поправить, что бы уязвимости определялись или добавить дополнительные уязвимости для их вывода в отчете

```bash
$ cd sca
$ ./dependency-check.sh --update # обновление и поставка базы NVD API
$ mvn dependency:resolve
$ mvn dependency:copy-dependencies -DoutputDirectory=./lib # зависимости из $ pom.xml как jar в ./lib
$ mvn org.owasp:dependency-check-maven:check || true # Maven-плагин OWASP
```

- [x] 6. Запустите SCA CLI OWASP Dependency-Check для уязвимого приложения. Отчеты будут в директории SCA. Опишите как работает сканирование SCA для `pom.xml` и `app.py`
- [x] 7. Соберите единый отчет из всех сканирований в виде `html`, `csv`, `json`

```bash
$ bash sca/generate_unified_report.sh
```

- [x] 8. Проанализируйте все уязвимости и обьясните для SAST Checkov сработки статуса `Unknown`. Классифицируйте их и укажите какие не должны быть в отчетах. Внесите исправления и запустите повторное сканирование и убедитесь, что они устранены. Приложите исправленный файл и отчет без уязвимостей. 
- [x] 9. Опишите выведенные уязвимости для SAST Semgrep и принцип их работы. Поправьте скрипт `app.py`. Запустите повторное сканирование и убедитесь, что они устранены. Приложите исправленный файл `app.py` и отчет без уязвимостей. 
- [x] 10. Доработайте SCA уязвимости, что бы они только остались в фиинальной версии отчетов.
- [x] 11. Проверьте себя по найденным сработкам анализаторов и так вы сможете помочь себе разобраться в ситуации, если возникнут сложности

```bash
$ bash cheat_check_yuorself.sh
```

- [x] 12. Делайте все коммиты на соответствующих шагах, далее заливайте изменения в удаленный репозиторий.
- [x] 13. Подготовьте отчет `gist`.
- [x] 14. Почистите кеш от `venv` и остановите уязвимое приложение

```bash
$ deactivate
$ rm -rf venv
$ docker-compose -f ххх down
$ docker-compose -f docker-compose.yml down
$ docker system prune -f
```
Сделано

Copyright (c) 2025 Ivan Lastochkin
