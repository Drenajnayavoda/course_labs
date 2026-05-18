<div align="center">
<h1><a id="intro">Лабораторная работа №9</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a>
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a>
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt="RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt="AppSec"></a> <img src="https://img.shields.io/badge/DevSecOps-2448a2" alt="DevSecOps"></a> <img src="https://img.shields.io/badge/Contributor-Шмаков_И._С.-8b9aff" alt="Contributor Badge"></a></div>

***

Салют :wave:,<br>
Эта лабораторная работа посвящена построению **сквозного DevSecOps‑пайплайна** в GitHub Actions, который автоматически прогоняет SAST (`Semgrep` + `Checkov`), SCA (`OWASP Dependency-Check`), сканирование контейнерного образа (`Trivy`) и DAST (`OWASP ZAP Baseline`) и сводит все находки в единый HTML‑отчёт.

> В данной работе `app/` содержит **намеренно уязвимое Flask‑приложение из лаб 7–8**. Задача пайплайна — автоматически найти те же уязвимости, что мы ранее находили вручную в лабах 7 и 8, и **заблокировать или зафиксировать** их до попадания в production.

Источник уязвимого приложения — `labs/basic/lab07/vulnerable-app/*` из upstream‑репозитория [geminishkv/course_labs@develop](https://github.com/geminishkv/course_labs/tree/develop/labs/basic/lab07/vulnerable-app). Скопирован «как есть», только адаптирован путь сборки в `docker-compose.yml` (`./vulnerable-app` → `./app`).

***

## Структура репозитория лабораторной работы

```bash
lab09
├── app                              # уязвимое приложение из lab07 (upstream)
│   ├── app.py
│   ├── config.yaml
│   ├── Dockerfile
│   └── requirements.txt
├── docker-compose.yml               # запуск приложения для DAST
├── pipeline
│   ├── sast
│   │   ├── checkov-config.yaml      # конфиг Checkov для Dockerfile
│   │   └── semgrep-rules.yml        # 7 кастомных правил под Python/Flask
│   ├── sca
│   │   └── dependency-check.sh      # обёртка над dependency-check CLI
│   ├── dast
│   │   ├── zap-baseline.conf        # rules-файл для ZAP
│   │   └── zap_scan.sh              # локальный запуск ZAP в Docker
│   └── merge_reports.py             # сшивает 5 JSON-отчётов в один HTML
├── .github
│   └── workflows
│       └── devsecops.yml            # копия рабочего workflow (для документации)
└── REPORT
    └── README.md                    # этот файл
```

Сам рабочий workflow живёт в корне репозитория: `.github/workflows/devsecops-lab09.yml` (GitHub Actions запускает только то, что лежит в `.github/workflows/` от корня).

***

## Материал

- **SAST** — статический анализ исходного кода без его выполнения. Ищет в `*.py`, `Dockerfile`, `docker-compose.yml`, `*.yaml` известные опасные конструкции: SQL‑инъекции, XSS, hardcoded‑секреты, `eval()`, `subprocess(shell=True)`, неправильные настройки контейнера и т.п. В этой работе используются:
  > - **Semgrep** — universal pattern‑matching, можно писать свои YAML‑правила (`pipeline/sast/semgrep-rules.yml`).
  > - **Checkov** — проверяет IaC: Dockerfile, docker‑compose, Terraform, Kubernetes.

- **SCA** — анализ сторонних зависимостей. Берёт список пакетов из `requirements.txt` (и аналогов) и сверяет с базой CVE.
  > - **OWASP Dependency-Check** — официальный движок NIST NVD, понимает Python, Java, .NET, Node и др. Запускается через [`dependency-check/Dependency-Check_Action@main`](https://github.com/dependency-check/Dependency-Check_Action).

- **Container Image Scanning** — сканирование уже собранного Docker‑образа. В отличие от SCA‑по‑манифесту ловит уязвимости в **OS‑пакетах базового образа** (`libgnutls`, `libssh2`, и т.п.) и в установленных в образе Python‑зависимостях.
  > - **Trivy** — быстрый, поддерживает Debian/Alpine/UBI, Python/Node/Go и т.д. Запускается через [`aquasecurity/trivy-action@master`](https://github.com/aquasecurity/trivy-action).

- **DAST** — динамический анализ запущенного приложения. Поднимает контейнер, отправляет в него реальные HTTP‑запросы и анализирует ответы: missing security headers, отсутствие CSP, info disclosure, default Server header, кешируемое чувствительное содержимое.
  > - **OWASP ZAP Baseline** — passive‑скан без активных эксплойтов, идеально подходит для CI. Запускается через [`zaproxy/action-baseline@v0.12.0`](https://github.com/zaproxy/action-baseline).

- **Unified Report** — сводный HTML‑отчёт, который собирает все JSON‑артефакты в одну страницу: `pipeline/merge_reports.py` (Jinja2). Полезен для ревью человеком и приклеивается к каждому Actions‑run как артефакт.

***

## Pipeline (5 jobs)

`devsecops-lab09.yml` устроен так:

```text
   ┌─────────┐    ┌─────────┐
   │  sast   │    │   sca   │       (параллельно)
   └────┬────┘    └────┬────┘
        │              │
        └──────┬───────┘
               ▼
       ┌───────────────┐
       │ build-and-scan│  ← docker build + trivy
       └───────┬───────┘
               ▼
       ┌───────────────┐
       │     dast      │  ← docker compose up + zap baseline
       └───────┬───────┘
               ▼
       ┌───────────────┐
       │    report     │  ← merge_reports.py → unified-report.html
       └───────────────┘
```

Триггеры — push/PR в `develop` или `main` по путям:

```yaml
paths:
  - "labs/basic/lab09/app/**"
  - "labs/basic/lab09/pipeline/**"
  - "labs/basic/lab09/docker-compose.yml"
  - ".github/workflows/devsecops-lab09.yml"
```

Плюс `workflow_dispatch` для ручного перезапуска.

***

## Уязвимое приложение (lab07 vulnerable-app)

Скопировано из upstream `labs/basic/lab07/vulnerable-app/`. Это Flask‑приложение с **намеренно** оставленными уязвимостями, которые мы ранее находили вручную в лабах 7 и 8:

| Endpoint   | Уязвимость                                  | CWE     |
|------------|---------------------------------------------|---------|
| `/user`    | SQL Injection через f‑string                | CWE‑89  |
| `/search`  | Reflected XSS через f‑string в HTML‑ответе  | CWE‑79  |
| `/backup`  | Command Injection через `sh -c f"..."`      | CWE‑78  |
| `/debug`   | Info disclosure (`os.environ` + `headers`)  | CWE‑200 |
| globals    | Hardcoded creds (`DB_PASSWORD = "Super..."`)| CWE‑798 |
| `config.yaml` | `jwt_secret`, `default_admin_password`   | CWE‑798 |
| `requirements.txt` | Django 2.2.0, paramiko 2.4.1, urllib3 1.23, pyjwt 1.7.1, PyYAML 5.3.1, certifi 2018.4.16 | мешок CVE |

Кусок исходника (фрагмент `app/app.py`):

```python
DB_USER = "admin"
DB_PASSWORD = "SuperSecret123"      # ← hardcoded secret

@app.route("/user")
def get_user():
    username = request.args.get("name", "")
    cur = get_db().cursor()
    query = f"SELECT id, name, email FROM users WHERE name = '{username}'"  # ← SQLi
    rows = cur.execute(query).fetchall()
    ...

@app.route("/search")
def search():
    q = request.args.get("q", "")
    html = f"<h1>Results for: {q}</h1>"              # ← reflected XSS
    return make_response(html, 200)

@app.route("/backup")
def backup():
    target = request.args.get("target", "/tmp/backup.sql")
    cmd = ["sh", "-c", f"pg_dump mydb > {target}"]   # ← command injection
    subprocess.call(cmd)
    ...

@app.route("/debug")
def debug():
    return {"headers": dict(request.headers),
            "env_sample": {k: dict(os.environ)[k]
                           for k in list(os.environ)[:10]}}   # ← info disclosure
```

***

## Кастомные Semgrep-правила

Файл `pipeline/sast/semgrep-rules.yml` содержит **7 правил**, написанных специально под паттерны lab07:

| `id`                                 | Severity | Что ловит                                                              |
|--------------------------------------|----------|------------------------------------------------------------------------|
| `py-sql-injection-concat`            | ERROR    | `cur.execute(f"...{x}...")`, `cur.execute("..." + x)`, f‑string‑переменная → execute |
| `py-hardcoded-secret`                | ERROR    | regex `(password|api_key|db_password|jwt_secret)\s*=\s*"…"`            |
| `py-eval-user-input`                 | ERROR    | `eval(request.args.get(...))`                                          |
| `py-subprocess-shell-injection`      | ERROR    | `subprocess.X(f"...", shell=True)`, `subprocess.call(["sh","-c", f"..."])` |
| `py-reflected-xss-fstring-response`  | ERROR    | `make_response(f"...{x}...")` где `x = request.args.get(...)`          |
| `py-flask-debug-true`                | WARNING  | `app.run(debug=True)`, `app.config["DEBUG"] = True`                    |
| `py-debug-endpoint-exposes-env`      | WARNING  | возврат словаря с `os.environ` / `request.headers`                     |

***

## Шаг 1. Baseline (vulnerable из upstream): прогон CI

Закоммитили `labs/basic/lab09/app/*` ровно как в upstream `lab07/vulnerable-app/*`. Workflow стриггерился автоматически.

**Run:** [`#26027354238`](https://github.com/Drenajnayavoda/course_labs/actions/runs/26027354238) (commit `8d43aee`)

```text
SAST — Semgrep + Checkov: success
SCA — Dependency-Check:    success
Build + Trivy Image Scan:  success     (audit mode, exit-code=0)
DAST — OWASP ZAP:          success     (audit mode, fail_action=false)
Unified Report:            success
```

### Что нашёл Semgrep

```text
$ jq -r '.results[] | .check_id' semgrep-report.json | sort | uniq -c
      2 pipeline.sast.py-debug-endpoint-exposes-env
      1 pipeline.sast.py-hardcoded-secret
      1 pipeline.sast.py-reflected-xss-fstring-response
      1 pipeline.sast.py-sql-injection-concat
      1 pipeline.sast.py-subprocess-shell-injection
```

**Итог: 6 findings, 5 разных классов уязвимостей** — ровно те же, что мы помечали руками в lab07/lab08:
- SQLi в `/user`,
- reflected XSS в `/search`,
- command injection в `/backup`,
- hardcoded `DB_PASSWORD`,
- info disclosure `/debug` (сработали два паттерна — на `dict(os.environ)` и на возврат словаря, склеенный с `headers`).

### Что нашёл Checkov

```text
$ jq '.results.failed_checks | length' checkov-report.json
0
```

Dockerfile из upstream lab07 уже частично hardened: есть `USER appuser`, `HEALTHCHECK`, `COPY` (не `ADD`), `apt-get --no-install-recommends`. Поэтому Checkov на нём чист. Это нормальный результат — Checkov «закрывает» то, на что Dockerfile уже отвечает.

### Что нашёл OWASP Dependency-Check

```text
=== severity breakdown ===
CRITICAL — 2
HIGH     — 4
MEDIUM   — 2

=== CRITICAL/HIGH ===
CRITICAL | certifi:2018.4.16 | CVE-2023-37920
CRITICAL | PyYAML:5.3.1      | CVE-2020-14343
HIGH     | certifi:2018.4.16 | CVE-2022-23491
HIGH     | paramiko:2.4.1    | CVE-2018-1000805
HIGH     | pyjwt:1.7.1       | CVE-2022-29217
HIGH     | pyjwt:1.7.1       | CVE-2026-32597
```

**Итог: 8 CVE.** Источник — древний `requirements.txt` (Django 2.2.0, paramiko 2.4.1, urllib3 1.23, pyjwt 1.7.1, PyYAML 5.3.1, certifi 2018.4.16, requests 2.19.1 и т.д.). Часть этих пакетов в коде даже не используется — они тащатся «по инерции», но создают огромный CVE‑фон.

### Что нашёл Trivy (image scan)

```text
=== severity breakdown ===
CRITICAL — 10
HIGH     — 88

=== примеры CRITICAL ===
libgnutls30t64  3.8.9-3+deb13u3   CVE-2026-33845
libgnutls30t64  3.8.9-3+deb13u3   CVE-2026-42010
libssh2-1t64    1.11.1-1          CVE-2026-7598
Django          2.2               CVE-2019-14234
Django          2.2               CVE-2019-19844
Django          2.2               CVE-2020-7471
Django          2.2               CVE-2022-28346
Django          2.2               CVE-2022-28347
Django          2.2               CVE-2025-64459
PyYAML          5.3.1             CVE-2020-14343
```

**Итог: 98 уязвимостей HIGH+CRITICAL.** Trivy показывает целый «букет»:
- CVE в OS‑пакетах базового `python:3.11-slim` (libgnutls, libssh2, libxml2 и т.п.);
- CVE в Python‑пакетах, которые Dependency‑Check тоже видит, но Trivy даёт более широкое покрытие (Django, Flask‑Werkzeug, Jinja2 и др.).

### Что нашёл OWASP ZAP

```text
Medium (High)         | Content Security Policy (CSP) Header Not Set                (2)
Medium (Medium)       | Missing Anti-clickjacking Header                            (1)
Low (High)            | Server Leaks Version Information via "Server" HTTP Response (3)
Low (Medium)          | Cross-Origin-Embedder-Policy Header Missing or Invalid      (1)
Low (Medium)          | Cross-Origin-Opener-Policy Header Missing or Invalid       (1)
Low (Medium)          | Cross-Origin-Resource-Policy Header Missing or Invalid     (1)
Low (Medium)          | Permissions Policy Header Not Set                          (3)
Low (Medium)          | X-Content-Type-Options Header Missing                      (1)
Informational (Medium)| Storable and Cacheable Content                             (3)
```

**Итог: 9 alerts.** В lab07 / lab08 мы вручную писали, что у приложения нет ни одного security‑заголовка — здесь ZAP подтверждает это автоматом.

### Сводная таблица baseline

| Инструмент       | Total | Severity                       |
|------------------|------:|--------------------------------|
| Semgrep          |     6 | ERROR×4, WARNING×2             |
| Checkov          |     0 | —                              |
| Dependency-Check |     8 | CRITICAL×2, HIGH×4, MEDIUM×2   |
| Trivy            |    98 | CRITICAL×10, HIGH×88           |
| ZAP              |     9 | MEDIUM×2, LOW×6, INFO×1        |
| **Σ**            |**121**|                                |

Пайплайн без участия человека воспроизвёл **все** уязвимости, которые мы ранее находили вручную в лабах 7 и 8 — плюс ещё ворох CVE в зависимостях/OS, которые руками увидеть тяжело.

***

## Шаг 2. Fix-итерация

Применяем точечные исправления к тем самым уязвимостям, что нашёл пайплайн.

**Run:** [`#26027768091`](https://github.com/Drenajnayavoda/course_labs/actions/runs/26027768091) (commit `42144ea`)

### Изменения в `app/app.py`

- `/user` — параметризованный SQL:

```python
rows = cur.execute(
    "SELECT id, name, email FROM users WHERE name = ?", (username,)
).fetchall()
```

- `/search` — `markupsafe.escape()` перед подстановкой в HTML:

```python
safe_q = escape(q)
html = f"<h1>Results for: {safe_q}</h1>"
```

- `/backup` — allowlist целей + прямой вызов без `sh -c`:

```python
allowed_targets = {
    "default": "/tmp/backup.sql",
    "nightly": "/tmp/backup-nightly.sql",
}
target = allowed_targets[target_key]
subprocess.run(["pg_dump", "mydb", "-f", target], check=False)
```

- Креды — из переменных окружения:

```python
DB_USER     = os.environ.get("DB_USER", "app")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
```

- `/debug` endpoint **удалён** полностью.
- Добавлен `@app.after_request set_security_headers()` с CSP / X‑Frame‑Options / X‑Content‑Type‑Options / Permissions‑Policy / COOP / COEP / CORP / замена `Server` header — закрывает большинство ZAP findings.

### Изменения в `app/config.yaml`

Все секреты заменены на ссылки на env‑переменные, debug‑флаги выключены:

```yaml
database:
  user: "${DB_USER}"
  password_from_env: "DB_PASSWORD"
security:
  jwt_secret_from_env: "JWT_SECRET"
  enable_csrf_protection: true
  enable_rate_limit: true
```

### Изменения в `app/Dockerfile`

- `python:3.11-slim` → `python:3.12-slim` (свежее ядро, меньше CVE в OS).
- Удалены `ENV FLASK_ENV=development` и `ENV DEBUG=true`.
- `CMD ["python", "app.py"]` → `CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app", "--workers", "2"]`.

### Изменения в `app/requirements.txt`

Удалены пакеты, не использовавшиеся в коде, но создававшие CVE‑фон (Django 2.2.0, paramiko 2.4.1, urllib3 1.23, pyjwt 1.7.1, PyYAML 5.3.1, certifi 2018.4.16, requests 2.19.1, cryptography 3.2, six 1.15.0, idna 2.7, chardet 3.0.4, SQLAlchemy 1.3.23). Оставлен только Flask‑стек со свежими версиями:

```
Flask==3.0.3
Werkzeug==3.0.4
Jinja2==3.1.4
MarkupSafe==2.1.5
itsdangerous==2.2.0
click==8.1.7
gunicorn==23.0.0
PyYAML==6.0.2
```

### Изменения в `docker-compose.yml`

```yaml
environment:
  - DB_USER=${DB_USER:-app}
  - DB_PASSWORD=${DB_PASSWORD:-}      # больше не захардкожен
```

### Цифры после fix

| Инструмент       | Baseline | Fixed | Δ                              |
|------------------|---------:|------:|--------------------------------|
| Semgrep          |        6 |     0 | **−6 (100 %)**                 |
| Checkov          |        0 |     0 | —                              |
| Dependency-Check |        8 |     0 | **−8 (100 %)**                 |
| Trivy            |       98 |    54 | −44 (≈45 %)                    |
| ZAP              |        9 |     2 | **−7 (≈78 %)**                 |
| **Σ**            |  **121** |**56** | **−65**                        |

Что осталось:
- **Trivy 54** (CRITICAL×3, HIGH×51) — почти всё это CVE в OS‑пакетах базового `python:3.12-slim` (libgnutls/libssh2/libxml2 и т.п.), их закрывают только апгрейдом базового образа или регулярным `apt upgrade`/distroless. Это «honest backlog» — типичная ситуация в любой реальной CI.
- **ZAP 2 medium** — `CSP: Failure to Define Directive with No Fallback` (CSP стоит, но ZAP советует явно перечислить директивы `frame-ancestors`, `form-action` и т.д.) + 3 informational про `Storable and Cacheable Content`. Это уже косметика, не уязвимости.

Иначе говоря, **все уязвимости, которые лаба 7 и 8 находили руками, в фиксе закрыты на 100 %.**

***

## Шаг 3. Демонстрация блокирующего режима (strict mode)

В `devsecops-lab09.yml` поменяли:

```yaml
# Trivy
exit-code: "1"      # было "0"
# ZAP
fail_action: true   # было false
```

**Run:** [`#26028066869`](https://github.com/Drenajnayavoda/course_labs/actions/runs/26028066869) (commit `955cb15`)

```text
SAST — Semgrep + Checkov:  success
SCA — Dependency-Check:    success
Build + Trivy Image Scan:  FAILURE       ← блокировка
DAST — OWASP ZAP:          skipped       ← не запустился, потому что upstream-job упал
Unified Report:            success       (if: always())
```

Что мы тут видим:
- Semgrep / Dep‑Check / app‑code чисты, но Trivy зацепился за HIGH/CRITICAL в OS‑пакетах базового образа и упал с `exit-code: 1`.
- Из‑за `needs: build-and-scan` job `dast` автоматически становится **skipped** — это и есть «pipeline не пускает сборку дальше».
- `report` помечен `if: always()`, поэтому unified‑html всё равно собирается и доступен как артефакт.

Это поведение, которое мы и хотим в боевом DevSecOps: «если в образе CRITICAL — деплоиться нельзя, идём чинить или обновлять базу».

***

## Шаг 4. Возврат в audit-mode (финальный «зелёный» прогон)

В реальных проектах strict‑mode часто комбинируется с audit‑mode на дев‑ветке: на feature‑ветках pipeline просто собирает отчёт (audit), а перед мержем в `main`/release включают `exit-code: 1`. Возвращаем audit для демонстрации сборки полного набора артефактов.

**Run:** [`#26028170877`](https://github.com/Drenajnayavoda/course_labs/actions/runs/26028170877) (commit `86e4d6f`)

```text
SAST — Semgrep + Checkov:  success
SCA — Dependency-Check:    success
Build + Trivy Image Scan:  success
DAST — OWASP ZAP:          success
Unified Report:            success
```

Цифры идентичны fix‑итерации: Semgrep 0, Checkov 0, Dep‑Check 0, Trivy 54 (CRIT×3 / HIGH×51), ZAP 2 medium + 3 info.

***

## Артефакты

В каждом run видны (вкладка *Artifacts*):

| Артефакт          | Содержимое                                                |
|-------------------|-----------------------------------------------------------|
| `sast-reports`    | `semgrep-report.json`, `checkov-report.json`, копия правил|
| `sca-reports`     | `dependency-check-report.{json,html,sarif,xml,csv,...}`   |
| `trivy-report`    | `trivy-report.json` (полный JSON)                         |
| `dast-reports`    | `zap-report.{json,html,md}`                               |
| `unified-report`  | `unified-report.html` — сводный отчёт из `merge_reports.py` |

Скачиваются стандартно: `gh run download <run_id>`.

***

## Ответы на вопросы

**Q: Какие уязвимости пайплайн нашёл «сам», без нашего участия?**
A: Все, что в lab07/lab08 мы помечали руками — SQLi в `/user`, XSS в `/search`, command injection в `/backup`, hardcoded `DB_PASSWORD`, info disclosure в `/debug`. Плюс к этому 8 CVE в зависимостях (Dependency‑Check) и 98 CVE в собранном образе (Trivy), и 9 проблем с заголовками от ZAP — всё это видно в `unified-report.html`.

**Q: Зачем держать одновременно SCA (Dep‑Check) и image‑scan (Trivy)?**
A: SCA смотрит **манифесты** (`requirements.txt`) и ловит уязвимости в декларированных зависимостях ещё до сборки. Image‑scan смотрит **уже собранный образ** и видит то, что SCA не видит: CVE в OS‑пакетах базового образа, в transitive‑зависимостях, в самих исполняемых файлах. Лучшая практика — иметь оба.

**Q: Почему Checkov ничего не нашёл, хотя приложение «уязвимое»?**
A: Потому что уязвимости тут в `*.py` коде и в `requirements.txt`, а не в Dockerfile. Сам Dockerfile из upstream lab07 уже частично hardened (есть `USER`, `HEALTHCHECK`, `COPY` вместо `ADD`). Checkov ловит конкретно misconfig в IaC — здесь его «обижать» нечем, и это правильно.

**Q: Что делать с 54 HIGH/CRIT, которые остались в Trivy после фикса?**
A: Это CVE в OS‑пакетах `python:3.12-slim`. Стандартные пути:
1. Регулярно обновлять `FROM`‑тег (например, через Renovate/Dependabot).
2. Запускать `apt-get upgrade --no-install-recommends` в Dockerfile (что мы по сути и делаем через `apt-get update`).
3. Перейти на distroless или Chainguard‑image — там CVE‑фон в разы меньше.
4. Подавлять только конкретные CVE‑ID, у которых нет fix‑версии (`--ignore-unfixed` или `.trivyignore`).

**Q: Чем `pipeline/sast/semgrep-rules.yml` отличается от стандартного `--config=auto`?**
A: В правилах конкретно те паттерны, которые встречаются в lab07/lab08 — `cur.execute(f"...")`, `make_response(f"...")`, `subprocess.call(["sh","-c", f"..."])`, regex для `DB_PASSWORD = "…"` и т.д. Это даёт **детерминированное** число findings от запуска к запуску (важно для сравнения «до/после»), и позволяет проверять, что pipeline ловит ровно те же уязвимости, что мы маркировали руками.

***

## Что внутри `unified-report.html`

`pipeline/merge_reports.py` собирает все 5 JSON‑артефактов из `pipeline/artifacts/` и рендерит Jinja2‑шаблон в одну HTML‑страницу с разделами **SAST / SCA / Trivy / DAST**, table‑summary вверху и кликабельным списком всех findings. Удобно открывать локально и прикладывать к PR‑review.

***

## Структура итоговых артефактов в репозитории

```
labs/basic/lab09/
├── app/
│   ├── app.py            # после fix: SQLi/XSS/cmd-injection/secrets закрыты
│   ├── config.yaml       # секреты вынесены в env
│   ├── Dockerfile        # python:3.12-slim, gunicorn, без DEBUG=true
│   └── requirements.txt  # Flask 3.0.3 + минимум зависимостей
├── docker-compose.yml
├── pipeline/
│   ├── sast/
│   │   ├── semgrep-rules.yml
│   │   └── checkov-config.yaml
│   ├── sca/
│   │   └── dependency-check.sh
│   ├── dast/
│   │   ├── zap-baseline.conf
│   │   └── zap_scan.sh
│   └── merge_reports.py
├── .github/workflows/
│   └── devsecops.yml     # копия рабочего workflow (для документации)
└── REPORT/
    └── README.md         # этот файл
```

***

## TL;DR

- Уязвимое приложение взято **«как есть»** из upstream `labs/basic/lab07/vulnerable-app/`.
- Pipeline из 5 jobs (SAST + SCA + Image scan + DAST + Unified report) автоматически нашёл **все** уязвимости, что мы маркировали в lab07/lab08 руками, и плюс ещё около сотни CVE в зависимостях и OS‑пакетах.
- Fix‑итерация закрыла 100 % code‑уязвимостей и 100 % SCA‑CVE; в Trivy осталось 54 CVE в base‑image — это «honest backlog».
- Strict‑mode (`Trivy exit-code=1`, `ZAP fail_action=true`) показывает, как пайплайн **блокирует** деплой при HIGH/CRITICAL; audit‑mode — как просто собирает отчёты для review.
- Все 4 прогона (baseline / fix / strict / final) доступны в GitHub Actions: [#26027354238](https://github.com/Drenajnayavoda/course_labs/actions/runs/26027354238), [#26027768091](https://github.com/Drenajnayavoda/course_labs/actions/runs/26027768091), [#26028066869](https://github.com/Drenajnayavoda/course_labs/actions/runs/26028066869), [#26028170877](https://github.com/Drenajnayavoda/course_labs/actions/runs/26028170877).
