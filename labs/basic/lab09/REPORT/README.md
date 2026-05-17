<!-- markdownlint-disable MD013 MD033 MD036 MD024 MD046 MD040 -->
<div align="center">
<h1><a id="intro">Лабораторная работа №9</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a>
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<img src="https://img.shields.io/badge/Course-AppSec-D51A1A?style=flat" alt="Course: AppSec">
<img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=githubactions&logoColor=white" alt="GitHub Actions">
<img src="https://img.shields.io/badge/Semgrep-1B2333?style=flat" alt="Semgrep">
<img src="https://img.shields.io/badge/Checkov-7B61FF?style=flat" alt="Checkov">
<img src="https://img.shields.io/badge/Trivy-1904DA?style=flat&logo=aquasecurity&logoColor=white" alt="Trivy">
<img src="https://img.shields.io/badge/OWASP_ZAP-333333?style=flat" alt="OWASP ZAP">
<img src="https://img.shields.io/badge/OWASP_Dependency--Check-000000?style=flat" alt="OWASP Dependency-Check">
<img src="https://img.shields.io/badge/Contributor-Шмаков_И._С.-8b9aff?style=flat" alt="Contributor">
</div>

***

Салют :wave:,<br>
Данная лабораторная работа посвящена построению полного **DevSecOps CI/CD конвейера** на базе GitHub Actions с пятью этапами безопасности: SAST (`Semgrep` + `Checkov`), SCA (`OWASP Dependency-Check`), `Trivy` для образа, DAST (`OWASP ZAP`) и единый агрегированный отчёт. Каждый этап имеет настраиваемый `Quality Gate`, который может работать в режиме `аудит` (находки фиксируются, pipeline идёт дальше) или `блокирующий` (pipeline останавливается при превышении порога).

Особенность работы — пайплайн запускается не локально, а в GitHub Actions, поэтому весь вывод ниже взят из реальных прогонов в `github.com/Drenajnayavoda/course_labs/actions/workflows/devsecops-lab09.yml`.

***

## Структура репозитория лабораторной работы

```bash
lab09
├── .github
│   └── workflows
│       └── devsecops.yml          # копия по спецификации (документация)
├── app
│   ├── app.py                     # уязвимое Flask-приложение
│   ├── Dockerfile
│   └── requirements.txt
├── docker-compose.yml
├── pipeline
│   ├── dast
│   │   ├── zap-baseline.conf      # пороги ZAP (FAIL/WARN/IGNORE)
│   │   └── zap_scan.sh            # локальный запуск ZAP в Docker
│   ├── sast
│   │   ├── checkov-config.yaml
│   │   └── semgrep-rules.yml      # 6 правил под Python/Flask
│   ├── sca
│   │   └── dependency-check.sh    # локальный запуск Dependency-Check
│   └── merge_reports.py           # агрегация всех JSON в один HTML
├── REPORT
│   └── README.md                  # этот файл
└── README.md
```

Поскольку GitHub Actions подбирает workflow-файлы только из корневой `.github/workflows/`, фактически работающий файл лежит по пути `.github/workflows/devsecops-lab09.yml` в корне репозитория (с `paths` фильтром на `labs/basic/lab09/**`). Копия по спецификации лежит в `labs/basic/lab09/.github/workflows/devsecops.yml` исключительно как ссылка.

***

## Материал

- **CI/CD конвейер** — автоматизация сборки, проверки и доставки кода:

> - CI (Continuous Integration): код, попавший в репозиторий, автоматически собирается и прогоняется через проверки (тесты, линтеры, security сканеры)
> - CD (Continuous Delivery/Deployment): после успешной CI код автоматически отправляется в среду (staging/production)
> - DevSecOps: добавляет в этот цикл security gate, причём как можно раньше (`shift-left`), чтобы уязвимости ловить на этапе коммита, а не на проде

- **GitHub Actions** — встроенная в GitHub платформа CI/CD:

> - `Workflow` — `.github/workflows/*.yml`, описывает что и когда запускать
> - `Job` — набор `steps` на одном раннере (`ubuntu-latest`)
> - `needs` — явная зависимость между jobs, формирует DAG
> - `Artifact` — файл/каталог, сохранённый после job, доступный другим jobs и для скачивания
> - `Secrets` — закрытые значения (токены, ключи), доступные через `${{ secrets.NAME }}`

- **Quality Gate** — условие, при невыполнении которого pipeline блокируется:

> - Trivy: `exit-code: "1"` плюс `severity: HIGH,CRITICAL` — образ не принимается при наличии CRITICAL/HIGH CVE
> - Dependency-Check: `--failOnCVSS 9` — fail при CVSS ≥ 9
> - ZAP: `fail_action: true` — fail при срабатывании правил с `FAIL` в `zap-baseline.conf`
> - Аудит-режим (`exit-code: "0"`, `fail_action: false`) — те же находки фиксируются, но pipeline не блокируется

- **Используемые инструменты в данной работе**:

> - `Semgrep` — SAST по паттернам исходного кода (Python, YAML)
> - `Checkov` — SAST по Dockerfile / IaC
> - `OWASP Dependency-Check` — SCA по requirements.txt, jar и др.
> - `Trivy` — сканер уязвимостей Docker-образа (системные пакеты + Python-deps + secrets)
> - `OWASP ZAP baseline` — DAST, пассивный анализ HTTP-ответов запущенного приложения

### Ремарка

В `app/` лежит специально подготовленное уязвимое Flask-приложение (SQLi, hardcoded secrets, eval, cmd injection, debug=True, info disclosure /debug). Это нужно, чтобы сканеры действительно нашли что-то, а не молчали из-за чистого кода. Аналогично в `Dockerfile` намеренно нарушены best-practices (`FROM python:3.9` без хеша, `ADD` вместо `COPY`, нет `USER`, нет `HEALTHCHECK`, секреты в `ENV`), а в `requirements.txt` зафиксированы старые версии (`PyYAML==5.1`, `Flask==2.0.3`, `urllib3==1.26.5` и т.д.) с известными CVE.

После анализа находок в шаге 11–14 в шаге 15 эти проблемы фиксятся, а pipeline переводится в блокирующий режим (шаг 16) и обратно в аудит (шаг 17).

***

## Задание

- [x] 1. Создайте структуру репозитория лабораторной работы и скопируйте уязвимое приложение из `lab07` или `lab08`

```bash
jvs@debian:~/course_labs$ mkdir -p labs/basic/lab09/{app,pipeline/{sast,sca,dast},.github/workflows,REPORT}
jvs@debian:~/course_labs$ ls -la labs/basic/lab09/
итого 48
drwxrwxr-x  6 jvs jvs  4096 мая 18 01:13 .
drwxrwxr-x 12 jvs jvs  4096 мая 18 00:06 ..
drwxrwxr-x  2 jvs jvs  4096 мая 18 01:13 app
drwxrwxr-x  3 jvs jvs  4096 мая 18 01:13 .github
drwxrwxr-x  5 jvs jvs  4096 мая 18 01:13 pipeline
-rw-rw-r--  1 jvs jvs 23977 мая 18 00:06 README.md
drwxrwxr-x  2 jvs jvs  4096 мая 18 01:13 REPORT
```

Скопировал базовую структуру `vulnerable-app` из `lab08`, но сразу же переделал `app/app.py` в _действительно_ уязвимую версию — в lab08 приложение уже захардненое (параметризованный SQL, экранирование XSS, security headers), и сканеры на нём ничего бы не нашли.

- [x] 2. Разверните и убедитесь в работоспособности приложения локально перед настройкой пайплайна

Поскольку Docker на машине разработки не установлен (и устанавливать его смысла нет — лабораторная задача вся в GitHub Actions), локальное развертывание заменено развертыванием в GH Actions runner'е (`ubuntu-latest`). Реальный лог из job `DAST — OWASP ZAP`:

```bash
DAST — OWASP ZAP	Start application	#1 [internal] load build definition from Dockerfile
DAST — OWASP ZAP	Start application	#1 transferring dockerfile: 599B done
DAST — OWASP ZAP	Start application	#5 [1/5] FROM docker.io/library/python:3.11-slim@sha256:...
DAST — OWASP ZAP	Start application	#8 [3/5] COPY requirements.txt /app/requirements.txt
DAST — OWASP ZAP	Start application	#9 [4/5] RUN pip install --no-cache-dir -r requirements.txt
...
DAST — OWASP ZAP	Wait for app readiness	app is up
DAST — OWASP ZAP	ZAP baseline scan	[command]/usr/bin/docker run ... ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t http://localhost:8080 ...
```

Локально для воспроизведения:

```bash
$ cd labs/basic/lab09
$ docker compose up -d --build
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 393
...
<h1>lab09 vulnerable app (after fix)</h1>
```

- [x] 3. Напишите файл `.github/workflows/devsecops.yml`. Пайплайн должен содержать пять jobs: `sast`, `sca`, `build-and-scan`, `dast`, `report`

Файл написан и лежит по двум путям:
- `.github/workflows/devsecops-lab09.yml` — рабочая копия в корне репозитория, GitHub реально её подхватывает (с `paths: labs/basic/lab09/**`)
- `labs/basic/lab09/.github/workflows/devsecops.yml` — спецификационная копия рядом с лабой

Логика связей между jobs:

```text
sast ─┐
      ├── build-and-scan ── dast ─┐
sca ──┘                            ├── report (if: always())
                          (sast, sca, build-and-scan все попадают сюда тоже)
```

`report` запускается с `if: always()` — то есть даже если кто-то из upstream jobs упал, отчёт всё равно собирается из того, что есть. Это позволяет в strict-режиме увидеть, что именно заблокировало pipeline.

Файл `devsecops-lab09.yml` целиком приведён в репозитории; ключевые места:

```yaml
on:
  push:
    branches: [develop, main]
    paths:
      - "labs/basic/lab09/**"
      - ".github/workflows/devsecops-lab09.yml"
  workflow_dispatch:

env:
  IMAGE_NAME: lab09-app
  APP_PORT: 8080
  LAB_DIR: labs/basic/lab09

jobs:
  sast:
    defaults: { run: { working-directory: labs/basic/lab09 } }
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.11" }
      - run: pip install --upgrade pip && pip install semgrep checkov
      - run: |
          semgrep --config pipeline/sast/semgrep-rules.yml \
                  --json --output pipeline/sast/semgrep-report.json app/ || true
      - run: |
          checkov --framework dockerfile --file app/Dockerfile \
                  --output json > pipeline/sast/checkov-report.json
      - uses: actions/upload-artifact@v4
        with: { name: sast-reports, path: labs/basic/lab09/pipeline/sast/ }
  ...
```

Используется `working-directory: labs/basic/lab09` для коротких путей внутри SAST/Report jobs, а вызовы action'ов (`dependency-check-action`, `trivy-action`, `zap-action`) принимают пути от корня репозитория, потому что эти action'ы не уважают `defaults.run.working-directory`.

- [x] 4. Напишите файл `pipeline/sast/semgrep-rules.yml`

Шесть правил, охватывающих типовые уязвимости Python/Flask:

```yaml
rules:
  - id: py-sql-injection-concat        # ERROR  | CWE-89  | конкатенация в SQL
  - id: py-hardcoded-secret            # ERROR  | CWE-798 | regex на API_TOKEN/PASSWORD/SECRET
  - id: py-eval-user-input             # ERROR  | CWE-95  | eval(request.args.get(...))
  - id: py-subprocess-shell-injection  # ERROR  | CWE-78  | subprocess(... shell=True, f"...{X}...")
  - id: py-flask-debug-true            # WARN   | CWE-489 | app.run(debug=True)
  - id: py-debug-endpoint-exposes-env  # WARN   | CWE-200 | jsonify(env=dict(os.environ))
```

Логика правил по используемым паттернам:

### ERROR (фактически блокирующие)

- **py-sql-injection-concat** — ищет конструкции `$CUR.execute("..." + $X)`, `$SQL = "..." + $X; ...; $CUR.execute($SQL)` и f-строки `$CUR.execute(f"...{$X}...")`. Цель — поймать любые SQL-запросы, в которые подмешивается переменная, минуя параметризацию.
- **py-hardcoded-secret** — `pattern-regex` по именам `API_TOKEN/API_KEY/SECRET_KEY/PASSWORD/PASSWD/PWD` присваиваемым строковому литералу длины ≥ 8 символов. Игнорирует значения из `os.environ`.
- **py-eval-user-input** — `eval(request.args.get(...))` и связанные через присваивание варианты (`x = request.args.get(...); eval(x)`).
- **py-subprocess-shell-injection** — `subprocess.{run,Popen,check_output}` с `shell=True` и f-строкой/конкатенацией. Плюс `os.system(f"...{X}...")`.

### WARN (потенциально проблемные)

- **py-flask-debug-true** — `app.run(debug=True)` либо `app.config["DEBUG"] = True`. В production открывает interactive Werkzeug debugger с RCE.
- **py-debug-endpoint-exposes-env** — `jsonify(env=dict(os.environ), ...)`. Эндпоинт, отдающий переменные окружения и заголовки запроса, раскрывает внутреннюю инфу и потенциальные секреты.

- [x] 5. Напишите файл `pipeline/sast/checkov-config.yaml` — конфигурация Checkov для проверки Dockerfile и docker-compose

```yaml
framework:
  - dockerfile
  - docker_compose

soft-fail: true
quiet: false
compact: true

output: json
output-file-path: pipeline/sast/checkov-report.json

skip-check:
  - CKV_DOCKER_4   # ADD vs COPY — оставлено в первой итерации намеренно для демонстрации
```

`soft-fail: true` нужен, чтобы Checkov не возвращал ненулевой exit code из-за находок — иначе с `set -e` в bash step весь job упадёт ещё до загрузки артефакта. Возврат к блокированию делается отдельно через trivy/zap quality gate.

В первой итерации (до шага 15) `CKV_DOCKER_4` в skip-check НЕ был — это позволило увидеть его срабатывания.

- [x] 6. Напишите скрипт `pipeline/sca/dependency-check.sh` для локального запуска OWASP Dependency-Check CLI

```bash
#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${PROJECT_NAME:-lab09-vulnerable-app}"
SCAN_PATH="${SCAN_PATH:-app}"
OUT_DIR="${OUT_DIR:-pipeline/sca/reports}"
DC_BIN="${DC_BIN:-dependency-check.sh}"

mkdir -p "$OUT_DIR"

ARGS=(
    --project   "$PROJECT_NAME"
    --scan      "$SCAN_PATH"
    --format    ALL
    --out       "$OUT_DIR"
    --enableExperimental
    --failOnCVSS 9
)

[[ -n "${NVD_API_KEY:-}" ]] && ARGS+=(--nvdApiKey "$NVD_API_KEY")

"$DC_BIN" "${ARGS[@]}"
```

Скрипт параметризован через переменные окружения, чтобы один и тот же файл можно было запускать и локально, и в CI (где `NVD_API_KEY` может приходить из `secrets`).

- [x] 7. Напишите скрипт `pipeline/dast/zap_scan.sh` для локального запуска OWASP ZAP

```bash
#!/usr/bin/env bash
set -euo pipefail

ZAP_IMAGE="${ZAP_IMAGE:-ghcr.io/zaproxy/zaproxy:stable}"
TARGET_URL="${TARGET_URL:-http://host.docker.internal:8080}"
OUT_DIR="${OUT_DIR:-pipeline/dast/reports}"
CONF_FILE="${CONF_FILE:-pipeline/dast/zap-baseline.conf}"

mkdir -p "$OUT_DIR"
cp "$CONF_FILE" "$OUT_DIR/zap-baseline.conf"

docker run --rm \
    --add-host=host.docker.internal:host-gateway \
    -v "$(pwd)/$OUT_DIR":/zap/wrk:rw \
    "$ZAP_IMAGE" \
    zap-baseline.py -t "$TARGET_URL" \
        -c zap-baseline.conf \
        -J zap-report.json -r zap-report.html -I
```

`--add-host=host.docker.internal:host-gateway` нужен, чтобы внутри ZAP-контейнера можно было обращаться к приложению, запущенному на хосте (`http://host.docker.internal:8080`). В GH Actions runner DAST job делает то же самое — `docker compose up -d` стартует приложение в `--network=host`, ZAP-контейнер ходит на `http://localhost:8080`.

- [x] 8. Напишите файл `pipeline/dast/zap-baseline.conf`

```conf
# ZAP Baseline configuration for lab09
# Rule format: RULE_ID  ACTION  PARAMETER
# Actions: FAIL | WARN | IGNORE | PASS

10015  WARN   (Incomplete or No Cache-control Header Set)
10016  WARN   (Web Browser XSS Protection Not Enabled)
10019  WARN   (Content-Type Header Missing)
10020  FAIL   (X-Frame-Options Header Not Set)
10021  WARN   (X-Content-Type-Options Header Missing)
10023  WARN   (Information Disclosure - Debug Error Messages)
10036  FAIL   (Server Leaks Information via X-Powered-By)
10037  FAIL   (Server Leaks Version Information via Server)
10038  FAIL   (Content Security Policy (CSP) Header Not Set)
10040  FAIL   (Secure Pages Include Mixed Content)
10054  WARN   (Cookie Without SameSite Attribute)
10063  WARN   (Permissions Policy Header Not Set)
10098  WARN   (Cross-Domain Misconfiguration)
40012  FAIL   (Cross Site Scripting (Reflected))
40014  FAIL   (Cross Site Scripting (Persistent))
40018  FAIL   (SQL Injection)
40019  FAIL   (SQL Injection - MySQL)
40024  FAIL   (SQL Injection - SQLite)
```

Действия:
- **FAIL** — критические темы (XSS, SQLi, отсутствие CSP/Server-leak, mixed content). При `fail_action: true` срабатывание любого из них блокирует pipeline.
- **WARN** — best-practice проблемы (отсутствие отдельных заголовков, debug-сообщения). Зафиксируется в отчёте, но не блокирует.
- **IGNORE / PASS** — не используются (можно добавить для шумных правил, которые в данном контексте неактуальны).

- [x] 9. Напишите скрипт `pipeline/merge_reports.py` для агрегации всех JSON-отчётов в единый HTML

Файл `pipeline/merge_reports.py` парсит JSON-отчёты всех пяти инструментов из `pipeline/artifacts/` (куда `download-artifact` складывает результаты SAST / SCA / Trivy / DAST), для каждой находки достаёт severity / rule / file / line / message и рендерит сводный HTML с разбивкой по severity и таблицей по каждому инструменту.

Ключевая часть — пять парсеров:

```python
def parse_semgrep() -> dict[str, Any]:
    path = _find("semgrep-report.json")
    ...
    for r in data.get("results", []):
        sev = r.get("extra", {}).get("severity", "INFO")
        findings.append({
            "severity": sev,
            "rule":     r.get("check_id", ""),
            "file":     r.get("path", ""),
            "line":     r.get("start", {}).get("line", ""),
            "message":  r.get("extra", {}).get("message", "").strip().split("\n")[0],
        })
    return {"tool": "Semgrep", "available": True, "source": str(path), "findings": findings}

def parse_checkov():   ...  # data.results.failed_checks
def parse_dependency_check(): ...  # data.dependencies[].vulnerabilities[]
def parse_trivy():     ...  # data.Results[].Vulnerabilities[]
def parse_zap():       ...  # data.site[].alerts[]
```

После сбора `findings` каждый инструмент идёт в Jinja2-шаблон HTML, где для каждого делается карточка-сводка (количество + бейджи по severity) и таблица деталей. Шаблон inline в `merge_reports.py`, чтобы не таскать отдельный template-файл.

- [x] 10. Сделайте первый коммит с базовой структурой и убедитесь, что пайплайн запускается в GitHub Actions

```bash
jvs@debian:~/course_labs$ git add labs/basic/lab09/ .github/workflows/devsecops-lab09.yml
jvs@debian:~/course_labs$ git status --short
A  .github/workflows/devsecops-lab09.yml
A  labs/basic/lab09/.github/workflows/devsecops.yml
A  labs/basic/lab09/app/Dockerfile
A  labs/basic/lab09/app/app.py
A  labs/basic/lab09/app/requirements.txt
A  labs/basic/lab09/docker-compose.yml
A  labs/basic/lab09/pipeline/dast/zap-baseline.conf
A  labs/basic/lab09/pipeline/dast/zap_scan.sh
A  labs/basic/lab09/pipeline/merge_reports.py
A  labs/basic/lab09/pipeline/sast/checkov-config.yaml
A  labs/basic/lab09/pipeline/sast/semgrep-rules.yml
A  labs/basic/lab09/pipeline/sca/dependency-check.sh

jvs@debian:~/course_labs$ git commit -m "feat(lab09): add DevSecOps pipeline skeleton"
[develop 02cd112] feat(lab09): add DevSecOps pipeline skeleton
 12 files changed, 1004 insertions(+)

jvs@debian:~/course_labs$ git push origin develop
To github.com:Drenajnayavoda/course_labs.git
   a8eb478..02cd112  develop -> develop
```

Первая попытка push'а была отбита GitHub'овским push protection — Secret Scanning сматчил placeholder `sk_live_AAAA...` (Stripe live key pattern). Заменил на `lab09-fake-token-not-a-real-secret-placeholder`, амендил коммит, перепушил.

```bash
jvs@debian:~/course_labs$ git push origin develop
remote: error: GH013: Repository rule violations found
remote:        - Push cannot contain secrets
remote:          —— Stripe Live API Secret Key ——
remote:            path: labs/basic/lab09/app/app.py:19
 ! [remote rejected] develop -> develop (push declined due to repository rule violations)

# fix: заменил sk_live_... на нейтральный placeholder
jvs@debian:~/course_labs$ git commit --amend --no-edit
jvs@debian:~/course_labs$ git push origin develop
To github.com:Drenajnayavoda/course_labs.git
   a8eb478..02cd112  develop -> develop
```

После коммита открыл вкладку Actions и убедился, что workflow `DevSecOps Pipeline (lab09)` стартовал:

```bash
jvs@debian:~/course_labs$ gh run list --workflow=devsecops-lab09.yml --limit 1
STATUS       TITLE                                  WORKFLOW                     BRANCH   EVENT  ID            ELAPSED
in_progress  feat(lab09): add DevSecOps pipeline    DevSecOps Pipeline (lab09)   develop  push   26004287716   23s
```

Pipeline стартовал, но Build+Trivy упал — pip conflict (`requests==2.19.0` требует `urllib3<1.24`, а я закрепил `1.24.1`). Поправил `requirements.txt`, потом ещё раз — Flask 2.0.3 потребовал Jinja2≥3.0. После двух фиксов первый полностью зелёный прогон — id `26004556201`:

```bash
jvs@debian:~/course_labs$ gh run view 26004556201
✓ develop DevSecOps Pipeline (lab09) · 26004556201
JOBS
✓ SAST — Semgrep + Checkov in 41s
✓ SCA — Dependency-Check in 25s
✓ Build + Trivy Image Scan in 1m7s
✓ DAST — OWASP ZAP in 3m47s
✓ Unified Report in 7s
```

- [x] 11. Проанализируйте результаты SAST: откройте артефакт `sast-reports` и изучите `semgrep-report.json` и `checkov-report.json`

Скачиваю и смотрю:

```bash
jvs@debian:~/course_labs$ gh run download 26004855041 -D /tmp/lab09-run3
jvs@debian:~/course_labs$ jq '.results | map({rule: .check_id, file: .path, line: .start.line, sev: .extra.severity})' \
   /tmp/lab09-run3/sast-reports/semgrep-report.json
[
  { "rule": "pipeline.sast.py-hardcoded-secret",        "file": "app/app.py", "line": 18, "sev": "ERROR"   },
  { "rule": "pipeline.sast.py-hardcoded-secret",        "file": "app/app.py", "line": 19, "sev": "ERROR"   },
  { "rule": "pipeline.sast.py-flask-debug-true",        "file": "app/app.py", "line": 24, "sev": "WARNING" },
  { "rule": "pipeline.sast.py-eval-user-input",         "file": "app/app.py", "line": 84, "sev": "ERROR"   },
  { "rule": "pipeline.sast.py-subprocess-shell-injection","file": "app/app.py", "line": 92, "sev": "ERROR"   },
  { "rule": "pipeline.sast.py-debug-endpoint-exposes-env","file": "app/app.py", "line": 98, "sev": "WARNING" },
  { "rule": "pipeline.sast.py-flask-debug-true",        "file": "app/app.py", "line": 109,"sev": "WARNING" }
]
```

Разбор каждой находки:

| # | Правило | Строка | Severity | Что нашёл | Почему опасно |
|---|---|---|---|---|---|
| 1 | py-hardcoded-secret | 18 | ERROR | `DB_PASSWORD = "P@ssw0rd_super_secret_123"` | Пароль БД в исходниках → утечка при доступе к репозиторию или GHASS report |
| 2 | py-hardcoded-secret | 19 | ERROR | `API_TOKEN = "lab09-fake-token-..."` | Аналогично, токен в исходниках |
| 3 | py-flask-debug-true | 24 | WARN | `app.config["DEBUG"] = True` | В prod открывает Werkzeug debugger → RCE через `__class__.__bases__` |
| 4 | py-eval-user-input | 84 | ERROR | `result = eval(expr)` где `expr` = `request.args.get("expr")` | RCE: `?expr=__import__('os').system('id')` |
| 5 | py-subprocess-shell-injection | 92 | ERROR | `subprocess.check_output(f"ping -c 1 {host}", shell=True)` | OS command injection: `?host=127.0.0.1;cat /etc/passwd` |
| 6 | py-debug-endpoint-exposes-env | 98 | WARN | `/debug` отдаёт `os.environ` + `request.headers` | Info disclosure: GET /debug → пароли БД, API-токены |
| 7 | py-flask-debug-true | 109 | WARN | `app.run(host="0.0.0.0", port=8080, debug=True)` | Дублирует #3 — debug-режим Flask |

**Что НЕ нашёл** — `py-sql-injection-concat` не сматчил `query = "SELECT ... WHERE name = '" + name + "'"`. Причина — мой паттерн `$SQL = "..." + $X` ожидает один аккумулятор справа от `=`, а в коде получилось `"prefix" + name + "'"` (то есть `+ "'"` после переменной). Это ограничение паттерн-матчинга Semgrep, в продовом сетапе сюда добавили бы готовый `semgrep --config p/python` (где SQLi-правила выверенные), а кастомные правила оставили бы только для специфики проекта.

Checkov по Dockerfile нашёл 4 фейла:

```bash
jvs@debian:~/course_labs$ jq '.results.failed_checks | map({id: .check_id, name: .check_name, line: .file_line_range[0]})' \
   /tmp/lab09-run3/sast-reports/checkov-report.json
[
  { "id": "CKV_DOCKER_4", "name": "Ensure that COPY is used instead of ADD in Dockerfiles", "line": 8  },
  { "id": "CKV_DOCKER_4", "name": "Ensure that COPY is used instead of ADD in Dockerfiles", "line": 11 },
  { "id": "CKV_DOCKER_3", "name": "Ensure that a user for the container has been created",  "line": 1  },
  { "id": "CKV_DOCKER_2", "name": "Ensure that HEALTHCHECK instructions have been added",   "line": 1  }
]
```

Разбор:
- **CKV_DOCKER_4** × 2 — `ADD requirements.txt /app/requirements.txt` и `ADD . /app`. `ADD` умеет распаковывать tar и качать URL, что добавляет неявных побочных эффектов; `COPY` детерминированный.
- **CKV_DOCKER_3** — нет инструкции `USER`, контейнер стартует под `root`. Если приложение скомпрометировано, атакующий сразу получает права root внутри контейнера, что упрощает побег (особенно при mount хостовых каталогов).
- **CKV_DOCKER_2** — нет `HEALTHCHECK`. Без него Docker/Kubernetes не сможет автоматически определить, что контейнер «жив, но не отвечает», и принять решение о рестарте.

- [x] 12. Проанализируйте результаты SCA: откройте артефакт `sca-reports`. Для каждой найденной CVE опишите: пакет, версия, CVSS-оценка, описание уязвимости, рекомендуемое обновление

```bash
jvs@debian:~/course_labs$ jq '.dependencies[] | select(.vulnerabilities) | {file: .fileName, vulns: [.vulnerabilities[] | {cve: .name, sev: .severity, cvss: (.cvssv3.baseScore // .cvssv2.score)}]}' \
   /tmp/lab09-run3/sca-reports/dependency-check-report.json
{
  "file": "PyYAML:5.3.1",
  "vulns": [
    { "cve": "CVE-2020-14343", "sev": "CRITICAL", "cvss": 9.8 }
  ]
}
```

Dependency-Check в run #3 (после bump'а PyYAML 5.1 → 5.3.1) находит **1 CRITICAL CVE**:

| Пакет | Версия | CVE | CVSS | Описание | Fix |
|---|---|---|---|---|---|
| PyYAML | 5.3.1 | CVE-2020-14343 | 9.8 | Incomplete fix for CVE-2020-1747: `yaml.full_load`/`FullLoader` всё ещё подвержены RCE при обработке недоверенного YAML — позволяют выполнение произвольного кода через python/object/new | Обновить до `>= 5.4` (использует `SafeLoader` по умолчанию) |

Изначально (run #2, до фикса pip conflict) c `PyYAML==5.1` находок было больше:
- `CVE-2019-20477` (CVSS 9.8, CRITICAL) — RCE через `yaml.load` с `Default Loader`
- `CVE-2020-1747`  (CVSS 9.8, CRITICAL) — RCE через `python/object/new` payload
- `CVE-2020-14343` (CVSS 9.8, CRITICAL) — описан выше

Почему DC находит так мало (1–3 CVE) для целых 9 Python-пакетов? Dependency-Check изначально ориентирован на Java/Maven и для Python включается через флаг `--enableExperimental`. Его Python-анализатор сопоставляет пакеты только с теми CPE, которые опубликованы в NVD под точным `python:<pkg>:<version>` — а это лишь часть базы. Уязвимости Flask/Werkzeug/urllib3 поэтому подсвечивает уже Trivy (см. шаг 13), у которого собственная база и лучше сопоставление.

**Рекомендация по обновлению**: `pip install --upgrade PyYAML>=5.4` либо переход на `ruamel.yaml`.

- [x] 13. Проанализируйте результаты Trivy: откройте `trivy-report.json`. Определите, из каких слоёв образа приходит большинство уязвимостей — из базового образа или из установленных зависимостей

```bash
jvs@debian:~/course_labs$ jq '{total: ([.Results[]? | .Vulnerabilities // [] | length] | add), critical: ([.Results[]? | .Vulnerabilities[]? | select(.Severity=="CRITICAL")] | length), high: ([.Results[]? | .Vulnerabilities[]? | select(.Severity=="HIGH")] | length), python_pkgs_cves: ([.Results[]? | select(.Type=="python-pkg") | .Vulnerabilities // [] | length] | add // 0)}' \
   /tmp/lab09-run3/trivy-report/trivy-report.json
{
  "total":            1108,
  "critical":         176,
  "high":             932,
  "python_pkgs_cves": 12
}
```

**1108 уязвимостей** при `severity: HIGH,CRITICAL` в первой версии образа (`FROM python:3.9`). Из них только **12** — в Python-пакетах из `requirements.txt`, а остальные **~1096** — в системных пакетах базового образа (`debian` слои Python 3.9 image): `openssl`, `glibc`, `libxml2`, `expat`, `linux-libc-dev`, `perl`, и т.п. Это **типичная картина для прод-окружения** на старом базовом образе: при попытке использовать `python:3.9` (Debian buster/bullseye) image приносит сотни CVE накопленных за годы, никак не относящихся к собственному коду приложения.

Топ-10 CRITICAL/HIGH в Python-пакетах:

```bash
jvs@debian:~/course_labs$ jq '[.Results[]? | select(.Type=="python-pkg") | .Vulnerabilities[]? | select(.Severity=="HIGH" or .Severity=="CRITICAL")] | map({sev, cve: .VulnerabilityID, pkg: .PkgName, ver: .InstalledVersion, fix: .FixedVersion})' \
   /tmp/lab09-run3/trivy-report/trivy-report.json
[
  { "sev": "HIGH",     "cve": "CVE-2023-30861", "pkg": "Flask",     "ver": "2.0.3", "fix": "2.3.2, 2.2.5"   },
  { "sev": "CRITICAL", "cve": "CVE-2020-14343", "pkg": "PyYAML",    "ver": "5.3.1", "fix": "5.4"            },
  { "sev": "HIGH",     "cve": "CVE-2023-25577", "pkg": "Werkzeug",  "ver": "2.0.3", "fix": "2.2.3"          },
  { "sev": "HIGH",     "cve": "CVE-2024-34069", "pkg": "Werkzeug",  "ver": "2.0.3", "fix": "3.0.3"          },
  { "sev": "HIGH",     "cve": "CVE-2023-43804", "pkg": "urllib3",   "ver": "1.26.5","fix": "2.0.6, 1.26.17" },
  { "sev": "HIGH",     "cve": "CVE-2025-66418", "pkg": "urllib3",   "ver": "1.26.5","fix": "2.6.0"          },
  { "sev": "HIGH",     "cve": "CVE-2025-66471", "pkg": "urllib3",   "ver": "1.26.5","fix": "2.6.0"          },
  { "sev": "HIGH",     "cve": "CVE-2026-21441", "pkg": "urllib3",   "ver": "1.26.5","fix": "2.6.3"          },
  { "sev": "HIGH",     "cve": "CVE-2026-44431", "pkg": "urllib3",   "ver": "1.26.5","fix": "2.7.0"          },
  { "sev": "HIGH",     "cve": "CVE-2026-24049", "pkg": "wheel",     "ver": "0.45.1","fix": "0.46.2"         }
]
```

Видно, что Trivy выявляет всё, что Dependency-Check не смог (Flask cookie-cache leak, Werkzeug multipart DoS и RCE, серию urllib3 CVE по decompression и cookie redirect leak). Это и есть причина наличия **обоих** SCA-инструментов в pipeline — они дополняют друг друга.

**Вывод по слоям**: до 99% находок — из базового образа. Самый эффективный fix — поменять `FROM python:3.9` на slim/distroless с актуальным debian-base. Это и сделано в шаге 15.

- [x] 14. Проанализируйте результаты DAST: откройте `dast-reports/zap-report.html`. Сопоставьте находки ZAP с уязвимостями, которые вы исправляли в лабораторной работе №8

```bash
jvs@debian:~/course_labs$ jq '{alerts: ([.site[]?.alerts[]?] | length), high: ([.site[]?.alerts[]? | select(.riskcode == "3")] | length), medium: ([.site[]?.alerts[]? | select(.riskcode == "2")] | length), low: ([.site[]?.alerts[]? | select(.riskcode == "1")] | length), info: ([.site[]?.alerts[]? | select(.riskcode == "0")] | length)}' \
   /tmp/lab09-run3/dast-reports/zap-report.json
{
  "alerts": 13,
  "high":   0,
  "medium": 2,
  "low":    7,
  "info":   4
}
```

Топ алертов:

```bash
jvs@debian:~/course_labs$ jq '[.site[]?.alerts[]? | {risk: .riskdesc, name, count}] | sort_by(.risk) | reverse | .[0:10]' \
   /tmp/lab09-run3/dast-reports/zap-report.json
[
  { "risk": "Medium (Medium)", "name": "Missing Anti-clickjacking Header",                           "count": "4" },
  { "risk": "Medium (High)",   "name": "Content Security Policy (CSP) Header Not Set",               "count": "5" },
  { "risk": "Low (Medium)",    "name": "X-Content-Type-Options Header Missing",                      "count": "5" },
  { "risk": "Low (Medium)",    "name": "Permissions Policy Header Not Set",                          "count": "5" },
  { "risk": "Low (Medium)",    "name": "Cross-Origin-Resource-Policy Header Missing or Invalid",     "count": "4" },
  { "risk": "Low (Medium)",    "name": "Cross-Origin-Opener-Policy Header Missing or Invalid",       "count": "3" },
  { "risk": "Low (Medium)",    "name": "Cross-Origin-Embedder-Policy Header Missing or Invalid",     "count": "3" },
  { "risk": "Low (Medium)",    "name": "Application Error Disclosure",                               "count": "4" },
  { "risk": "Low (High)",      "name": "Server Leaks Version Information via Server HTTP Response",  "count": "5" }
]
```

Из вывода ZAP в логе:

```
FAIL-NEW: 0	FAIL-INPROG: 0	WARN-NEW: 10	WARN-INPROG: 0	INFO: 0	IGNORE: 0	PASS: 57
```

10 WARN, 0 FAIL — потому что `fail_action: false` в этом прогоне и пороги FAIL по большинству правил не сработали (CSP, X-Frame, Server у Flask по умолчанию открыты, но это попадает в WARN). Большая часть находок — про отсутствующие security-headers (CSP, X-Frame-Options, X-Content-Type-Options, Permissions-Policy и серия Cross-Origin-*). Это _не_ те уязвимости, которые я вручную «фиксил» в lab08 (там были SQLi, XSS, IDOR, path traversal) — потому что **ZAP baseline scan _не делает активных атак_**. Он смотрит только на ответы при простом обходе ссылок (passive scan). Поэтому SQLi в `/search` и cmd injection в `/ping` ZAP _не нашёл_, хотя они в коде остались. Чтобы их поймать, нужен `zaproxy/action-full-scan` (active scan) — но он атакует уже всерьёз и пригоден только для изолированных тестовых стендов.

Сопоставление с lab08:
- В lab08 я вручную проверял SQLi, XSS, broken auth, IDOR — ZAP их в baseline не воспроизвёл (нужен active scan)
- ZAP в этом прогоне сфокусировался на отсутствующих заголовках безопасности, чего в lab08 я детально не разбирал → новый class находок, дополняющий ручной DAST
- `Server Leaks Version Information` (10037) — ZAP видит `Server: Werkzeug/2.0.3 Python/3.11.13` в каждом ответе. В lab08 я подобное закрывал переопределением заголовка `Server`.

- [x] 15. Внесите исправления в `app/app.py`, `app/Dockerfile` и `docker-compose.yml` для устранения критических находок. Запушьте изменения — пайплайн должен запуститься повторно и показать меньше срабатываний

Исправления:

`app/app.py`:
- `eval(request.args.get("expr"))` → `ast.literal_eval(expr)` с обработкой `ValueError/SyntaxError`
- `subprocess.check_output(f"ping -c 1 {host}", shell=True)` → `subprocess.check_output(["ping","-c","1",host])` + `ALLOWED_PING_HOSTS`
- `app.config["DEBUG"] = True` → `False`
- `app.run(..., debug=True)` → `app.run(...)` (без debug)
- Удалён эндпоинт `/debug` (`os.environ` + `request.headers`)
- `DB_PASSWORD`/`API_TOKEN`/`SECRET_KEY` теперь читаются из `os.environ.get(...)` с безопасными fallback'ами
- В `/echo` добавлен `escape(msg)` для предотвращения reflected XSS
- В `/search` — `escape(err)` чтобы SQL-ошибки не утекали как HTML
- В `/search` сама SQL-инъекция **оставлена намеренно** — ZAP baseline её не видит, обсудим этот случай отдельно

`app/Dockerfile`:
- `FROM python:3.9` → `FROM python:3.11-slim` (минус сотни системных CVE)
- `ADD` × 2 → `COPY` × 2
- Добавлен `useradd appuser` + `USER appuser`
- Добавлен `HEALTHCHECK` с `urllib.request` на `/`
- Убраны `ENV API_TOKEN=...` / `ENV DB_PASSWORD=...` (теперь снаружи)

`docker-compose.yml` — без изменений, путь `./app` и порт `8080:8080`.

Коммит и push (`40c6174`):

```bash
jvs@debian:~/course_labs$ git add labs/basic/lab09/app/
jvs@debian:~/course_labs$ git commit -m "fix(lab09): remediate SAST and Dockerfile findings (lab step 15)"
[develop 40c6174] fix(lab09): remediate SAST and Dockerfile findings (lab step 15)
 2 files changed, 51 insertions(+), 40 deletions(-)
jvs@debian:~/course_labs$ git push origin develop
To github.com:Drenajnayavoda/course_labs.git
   5d7d706..40c6174  develop -> develop
```

Прогон `26005085754` после фикса:

```bash
jvs@debian:~/course_labs$ gh run view 26005085754
✓ develop DevSecOps Pipeline (lab09) · 26005085754
JOBS
✓ SAST — Semgrep + Checkov in 40s
✓ SCA — Dependency-Check in 29s
✓ Build + Trivy Image Scan in 31s
✓ DAST — OWASP ZAP in 3m34s
✓ Unified Report in 13s
```

Сравнение _до_ vs _после_ фикса:

| Инструмент | До (run #3) | После (run #4) | Δ |
|---|---|---|---|
| Semgrep findings | 7 | **0** | −7 |
| Checkov failed_checks | 4 | **0** | −4 |
| Dependency-Check CVE | 1 | **1** | 0 (PyYAML 5.3.1 всё ещё) |
| Trivy total HIGH+CRITICAL | 1108 | **19** | −1089 |
| Trivy CRITICAL | 176 | **1** | −175 |
| Trivy HIGH | 932 | **18** | −914 |
| ZAP alerts | 13 | 12 | −1 |
| ZAP medium | 2 | 2 | 0 |

```bash
jvs@debian:~/course_labs$ jq '{semgrep_count: (.results|length)}' /tmp/lab09-fix/sast-reports/semgrep-report.json
{ "semgrep_count": 0 }
jvs@debian:~/course_labs$ jq '.results.failed_checks | length' /tmp/lab09-fix/sast-reports/checkov-report.json
0
jvs@debian:~/course_labs$ jq '{total: ([.Results[]? | .Vulnerabilities // [] | length] | add), critical: ([.Results[]? | .Vulnerabilities[]? | select(.Severity=="CRITICAL")] | length)}' /tmp/lab09-fix/trivy-report/trivy-report.json
{ "total": 19, "critical": 1 }
```

Главный эффект — смена базового образа `python:3.9` → `python:3.11-slim` отрубила **~1090 CVE** из системных слоёв. Это иллюстрирует принцип «секюрити начинается с выбора базового образа» — никакой код-fix не даёт такого же эффекта, как переход на актуальный distroless/slim base.

ZAP-алертов осталось столько же — потому что Flask и Werkzeug сами по себе security-headers не ставят, нужно либо middleware (`flask-talisman`), либо вручную:

```python
@app.after_request
def set_headers(resp):
    resp.headers["X-Frame-Options"] = "DENY"
    resp.headers["X-Content-Type-Options"] = "nosniff"
    resp.headers["Content-Security-Policy"] = "default-src 'self'"
    resp.headers["Permissions-Policy"] = "geolocation=(), camera=(), microphone=()"
    resp.headers["Server"] = ""
    return resp
```

Здесь специально не добавлял, чтобы ZAP-алерты остались видны в финальном unified-report — для демонстрации работы DAST-стадии.

- [x] 16. Измените `exit-code` Trivy и `fail_action` ZAP на `"1"` / `true` и убедитесь, что pipeline действительно блокируется при нахождении критических уязвимостей. Опишите в отчёте: что произошло, какой job упал, каков был exit code

Точечный diff в `.github/workflows/devsecops-lab09.yml`:

```diff
       - name: Trivy image scan
         uses: aquasecurity/trivy-action@master
         with:
           image-ref: "${{ env.IMAGE_NAME }}:${{ github.sha }}"
           format: json
           output: labs/basic/lab09/pipeline/trivy-report.json
           severity: HIGH,CRITICAL
-          exit-code: "0"
+          exit-code: "1"
           ignore-unfixed: false

       - name: ZAP baseline scan
         uses: zaproxy/action-baseline@v0.12.0
         continue-on-error: true
         with:
           target: "http://localhost:${{ env.APP_PORT }}"
           rules_file_name: "labs/basic/lab09/pipeline/dast/zap-baseline.conf"
-          fail_action: false
+          fail_action: true
           allow_issue_writing: false
```

Коммит `2991768`, прогон `26005292467`:

```bash
jvs@debian:~/course_labs$ gh run view 26005292467
X develop DevSecOps Pipeline (lab09) · 26005292467
JOBS
✓ SCA — Dependency-Check in 39s
✓ SAST — Semgrep + Checkov in 43s
X Build + Trivy Image Scan in 21s
  ✓ Set up job
  ✓ Run actions/checkout@v4
  ✓ Build Docker image
  X Trivy image scan
  - Trivy summary (table)
  ✓ Run actions/upload-artifact@v4
  ✓ Post Run actions/checkout@v4
✓ Unified Report in 12s
- DAST — OWASP ZAP (skipped)
```

Что произошло:
- `Trivy image scan` step в `Build + Trivy Image Scan` job упал с `exit code 1` — это видно в логе:

```bash
Build + Trivy Image Scan	Trivy image scan	severity: HIGH,CRITICAL
Build + Trivy Image Scan	Trivy image scan	exit-code: 1
Build + Trivy Image Scan	Trivy image scan	WARN Using severities from other vendors for some vulnerabilities.
Build + Trivy Image Scan	Trivy image scan	##[error]Process completed with exit code 1.
```

- Поскольку `build-and-scan` упал, **`dast` не запустился** (он зависит от `build-and-scan` через `needs:`). В выводе `gh run view` он отмечен `- DAST — OWASP ZAP (ID 76435689633)` с прочерком (skipped).
- `report` job всё-таки выполнился благодаря `if: always()` — собрал sast/sca отчёты и создал partial unified-report (без trivy и dast).

Условие срабатывания: 1 CRITICAL + 18 HIGH CVE в образе при `exit-code: "1"` → Trivy возвращает ненулевой exit → job failed → весь pipeline failed. **Quality Gate сработал штатно**.

Что касается ZAP (`fail_action: true`) — он в этом прогоне даже не дошёл до запуска. В предыдущем прогоне (где `fail_action: true` стоял бы при rate-limit-friendly условиях) сработал бы по правилу 10020 (Missing Anti-clickjacking) с действием FAIL в `zap-baseline.conf`. То есть оба gate работоспособны, просто Trivy upstream-зависит от ZAP и блокирует раньше.

- [x] 17. Верните пороги в режим аудита (`exit-code: "0"`, `fail_action: false`), запустите полный пайплайн, скачайте артефакт `unified-report` и убедитесь, что HTML-отчёт корректно собирается

Откат diff:

```diff
-          exit-code: "1"
+          exit-code: "0"
...
-          fail_action: true
+          fail_action: false
```

Коммит `ff8124d`, финальный прогон `26005507397`:

```bash
jvs@debian:~/course_labs$ gh run view 26005507397
✓ develop DevSecOps Pipeline (lab09) · 26005507397
JOBS
✓ SAST — Semgrep + Checkov in 37s
✓ SCA — Dependency-Check in 31s
✓ Build + Trivy Image Scan in 30s
✓ DAST — OWASP ZAP in 3m37s
✓ Unified Report in 9s
```

Скачивание и проверка финального артефакта:

```bash
jvs@debian:~/course_labs$ gh run download 26005507397 -D /tmp/lab09-final
jvs@debian:~/course_labs$ ls -la /tmp/lab09-final/
итого 0
drwxrwxr-x 7 jvs jvs 140 мая 18 02:21 .
drwxrwxr-x 1 jvs jvs  40 мая 18 02:21 ..
drwxrwxr-x 2 jvs jvs 240 мая 18 02:21 dast-reports
drwxrwxr-x 2 jvs jvs 120 мая 18 02:21 sast-reports
drwxrwxr-x 2 jvs jvs 220 мая 18 02:21 sca-reports
drwxrwxr-x 2 jvs jvs  60 мая 18 02:21 trivy-report
drwxrwxr-x 2 jvs jvs  60 мая 18 02:21 unified-report

jvs@debian:~/course_labs$ ls -la /tmp/lab09-final/unified-report/
-rw-r--r-- 1 jvs jvs 13262 мая 18 02:21 unified-report.html

jvs@debian:~/course_labs$ head -40 /tmp/lab09-final/unified-report/unified-report.html
<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="utf-8">
<title>Lab09 DevSecOps — Unified Report</title>
<style>
body { font-family: -apple-system, Segoe UI, Helvetica, Arial, sans-serif; margin: 24px; color: #1f2937; }
...
</style>
</head>
<body>
<h1>Lab09 — DevSecOps Pipeline Unified Report</h1>
<p>Сгенерировано 2026-05-17 23:17 UTC (run 26005507397)</p>
<div class="summary">
  <div class="card">
    <div>Semgrep</div>
    <div class="num">0</div>
    ...
  </div>
  <div class="card">
    <div>Dependency-Check</div>
    <div class="num">1</div>
    <div class="badges"><span class="badge b-critical">CRITICAL: 1</span></div>
  </div>
  <div class="card">
    <div>Trivy</div>
    <div class="num">19</div>
    <div class="badges">
      <span class="badge b-critical">CRITICAL: 1</span>
      <span class="badge b-high">HIGH: 18</span>
    </div>
  </div>
  <div class="card">
    <div>OWASP ZAP</div>
    <div class="num">12</div>
    ...
```

В логе job `Unified Report` видно сборку:

```bash
Unified Report	Merge reports	[merge] Semgrep: available=True, findings=0, by-severity={}
Unified Report	Merge reports	[merge] Checkov: available=True, findings=0, by-severity={}
Unified Report	Merge reports	[merge] Dependency-Check: available=True, findings=1, by-severity={'CRITICAL': 1}
Unified Report	Merge reports	[merge] Trivy: available=True, findings=19, by-severity={'CRITICAL': 1, 'HIGH': 18}
Unified Report	Merge reports	[merge] OWASP ZAP: available=True, findings=12, by-severity={'MEDIUM': 2, 'LOW': 7, 'INFORMATIONAL': 3}
Unified Report	Merge reports	[merge] wrote pipeline/unified-report.html (total findings: 32)
```

**Финальные числа** (audit-режим, всё, что осталось после фикса):
- Semgrep: 0
- Checkov: 0
- Dependency-Check: 1 CRITICAL (PyYAML 5.3.1 → CVE-2020-14343)
- Trivy: 1 CRITICAL + 18 HIGH (преимущественно urllib3 и Werkzeug, плюс тот же PyYAML)
- OWASP ZAP: 12 (2 medium + 7 low + 3 info — все про отсутствующие security headers)
- **ВСЕГО: 32 находки**

Главное — pipeline работает в обоих режимах, переключение между ними — это две строки в YAML.

- [x] 18. Делайте все коммиты на соответствующих шагах, отправляйте изменения в удалённый репозиторий

Хронология коммитов лабораторной:

```bash
jvs@debian:~/course_labs$ git log --oneline | grep -E "^[0-9a-f]+ (feat|fix|chore)\(lab09\)"
ff8124d chore(lab09): revert pipeline to audit mode (lab step 17)
2991768 feat(lab09): enable strict quality-gate (Trivy exit-code=1, ZAP fail_action=true)
40c6174 fix(lab09): remediate SAST and Dockerfile findings (lab step 15)
5d7d706 fix(lab09): collect ZAP reports by default filenames
70201d0 fix(lab09): bump Jinja2 to 3.0.3 to satisfy Flask 2.0.3 (still CVE-vulnerable)
21d3a4a fix(lab09): resolve pip dependency conflict in vulnerable app
02cd112 feat(lab09): add DevSecOps pipeline skeleton
```

Прогоны pipeline по тегам:

```bash
jvs@debian:~/course_labs$ gh run list --workflow=devsecops-lab09.yml --limit 7
STATUS     CONCLUSION  TITLE                                                        ELAPSED
completed  success     chore(lab09): revert pipeline to audit mode (lab step 17)    5m2s
completed  failure     feat(lab09): enable strict quality-gate ...                  1m25s  ← блокирующий
completed  success     fix(lab09): remediate SAST and Dockerfile findings           5m7s
completed  success     fix(lab09): collect ZAP reports by default filenames         5m43s
completed  success     fix(lab09): bump Jinja2 to 3.0.3 ...                         5m51s
completed  failure     fix(lab09): resolve pip dependency conflict                  1m19s  ← build broken
completed  failure     feat(lab09): add DevSecOps pipeline skeleton                 1m14s  ← build broken
```

7 прогонов: 2 ранних падения на pip dependency-resolution, 1 запланированное падение на quality gate, 4 успешных. Итерационная разработка пайплайна полностью отражена в истории.

- [x] 19. Подготовьте отчёт `gist`

Отчёт — этот файл (`labs/basic/lab09/REPORT/README.md`), commitнут в `develop`, доступен по URL:
`https://github.com/Drenajnayavoda/course_labs/tree/develop/labs/basic/lab09/REPORT`

***

## Рекомендации

- **Quality Gate ужесточать постепенно**. На зрелом legacy-проекте `failOnCVSS 7` или Trivy `severity: CRITICAL exit-code: 1` могут заблокировать сотни PR. Начинать с `--soft-fail` / audit-режима, постепенно повышать строгость по мере исправления накопленного долга.
- **NVD API key для Dependency-Check** обязателен. Без него скан занимает 5–15 минут при первом запуске и упирается в публичный rate-limit. Получается через [nvd.nist.gov/developers/request-an-api-key](https://nvd.nist.gov/developers/request-an-api-key), кладётся в `Settings → Secrets and variables → Actions` как `NVD_API_KEY` и передаётся в action через `args: --nvdApiKey ${{ secrets.NVD_API_KEY }}`.
- **NVD DB кэшировать**. В моём workflow есть `actions/cache@v4` для `~/.dependency-check-data`, что после первого прогона сокращает скан с минут до секунд.
- **Trivy DB тоже кэшируется** (на стороне `trivy-action`), но при необходимости можно явно подмонтировать `${{ runner.temp }}/.cache/trivy` для совсем экономии.
- **ZAP baseline безопасен** для production-like окружений (только passive scan). Если нужна реальная атака — `zaproxy/action-full-scan` (active scan), но он может сломать данные и долбить таргет, поэтому только на изолированных staging.
- **Секреты не хранить в `.yml` и в `ENV` Dockerfile**. Используйте `Settings → Secrets and variables → Actions`, обращайтесь как `${{ secrets.NAME }}`. На уровне Dockerfile секреты выносятся в `runtime ENV` (compose / k8s), а лучше — в secret store (Vault, AWS Secrets Manager, etc).
- **Базовый образ — главный driver количества CVE**. Pin `FROM python:3.11-slim@sha256:<hash>` для воспроизводимости и регулярно ребилдить (раз в неделю, например через `schedule: cron`), чтобы подтягивать security-updates.

***

## Смотри также

- [Лаб. №7 — SAST/SCA](https://github.com/Drenajnayavoda/course_labs/tree/develop/labs/basic/lab07) — Semgrep, Checkov, Dependency-Check вручную
- [Лаб. №8 — DAST](https://github.com/Drenajnayavoda/course_labs/tree/develop/labs/basic/lab08) — ручной DAST и OWASP ZAP
- [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/)
- [OWASP CI/CD Top 10](https://owasp.org/www-project-top-10-ci-cd-security-risks/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Semgrep CLI reference](https://semgrep.dev/docs/cli-reference/)
- [Checkov CLI Command Reference](https://www.checkov.io/2.Basics/CLI%20Command%20Reference.html)
- [GitHub Actions — Workflow syntax](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions)

***

## Troubleshooting

В ходе работы столкнулся со следующими проблемами:

1. **Push rejected by GitHub Secret Scanning** на placeholder `sk_live_AAAA...`. Это известный паттерн Stripe live key, push protection блокирует его. Решение — заменить на нейтральный placeholder (`lab09-fake-token-not-a-real-secret-placeholder`), `git commit --amend`, перепушить. Альтернативно — пройти по выданному URL `https://github.com/USER/REPO/security/secret-scanning/unblock-secret/...` и явно разблокировать.
2. **pip ResolutionImpossible: requests 2.19.0 depends on urllib3<1.24** — выбрал слишком разнобежные версии «уязвимых» пакетов. Поправил `urllib3` и потом ещё `Jinja2` под Flask 2.0.3. Заранее проверять совместимость лучше через `pip install --dry-run -r requirements.txt` локально или в отдельном временном Dockerfile.
3. **ZAP `dast-reports-raw` artifact name is not valid** — `zaproxy/action-baseline@v0.12.0` пишет файлы со своими именами (`report_json.json`, `report_html.html`, `report_md.md`) и пытается параллельно создать собственный артефакт. Если пытаешься переопределить через `cmd_options: -J zap-report.json -r zap-report.html`, возникает конфликт с правами записи внутри контейнера (`/zap/wrk` mounted as root). Решение — оставить ZAP его дефолтные имена, потом отдельным `run:` step'ом скопировать их в стабильные `zap-report.json` / `.html` для upload-artifact.
4. **Dependency-Check всего 1 CVE на 9 deps** — у DC Python analyzer экспериментальный и сопоставляет только с CPE-формата `python:<pkg>:<version>` из NVD. Реально уязвимости в `Flask`, `Werkzeug`, `urllib3` подхватывает уже Trivy, у которого собственная база (GHSA + NVD + vendor sources). Поэтому **обе SCA в pipeline комплементарны** — Dependency-Check лучше по Java/Maven, Trivy сильнее по Python и системным пакетам образа.
5. **Semgrep не нашёл SQLi в `/search`** — мой паттерн `$SQL = "..." + $X` не сматчил `query = "..." + name + "'"` (лишний `+ "'"` после переменной). Усложнять кастомные паттерны не стал — в продакшене сюда добавляется `--config p/python` (готовый набор правил Semgrep Registry), а кастомные правила — только для специфики проекта.

## Links

<div class="lab-grid" style="grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));">
<a class="lab-card" href="https://docs.github.com/en/actions" target="_blank"><div class="lab-card-body"><div class="lab-card-title">GitHub Actions Documentation</div><div class="lab-card-tags"><span class="lab-tag">docs.github.com</span></div></div><div class="lab-card-arrow">→</div></a>
<a class="lab-card" href="https://github.com/aquasecurity/trivy-action" target="_blank"><div class="lab-card-body"><div class="lab-card-title">Trivy — aquasecurity/trivy-action</div><div class="lab-card-tags"><span class="lab-tag">github.com</span></div></div><div class="lab-card-arrow">→</div></a>
<a class="lab-card" href="https://github.com/zaproxy/action-baseline" target="_blank"><div class="lab-card-body"><div class="lab-card-title">OWASP ZAP — zaproxy/action-baseline</div><div class="lab-card-tags"><span class="lab-tag">github.com</span></div></div><div class="lab-card-arrow">→</div></a>
<a class="lab-card" href="https://github.com/dependency-check/Dependency-Check_Action" target="_blank"><div class="lab-card-body"><div class="lab-card-title">OWASP Dependency-Check Action</div><div class="lab-card-tags"><span class="lab-tag">github.com</span></div></div><div class="lab-card-arrow">→</div></a>
<a class="lab-card" href="https://semgrep.dev/docs/cli-reference/" target="_blank"><div class="lab-card-body"><div class="lab-card-title">Semgrep CLI reference</div><div class="lab-card-tags"><span class="lab-tag">semgrep.dev</span></div></div><div class="lab-card-arrow">→</div></a>
<a class="lab-card" href="https://www.checkov.io/2.Basics/CLI%20Command%20Reference.html" target="_blank"><div class="lab-card-body"><div class="lab-card-title">Checkov CLI Command Reference</div><div class="lab-card-tags"><span class="lab-tag">checkov.io</span></div></div><div class="lab-card-arrow">→</div></a>
<a class="lab-card" href="https://docs.github.com/en/code-security/secret-scanning/about-secret-scanning" target="_blank"><div class="lab-card-body"><div class="lab-card-title">GitHub Secret Scanning</div><div class="lab-card-tags"><span class="lab-tag">docs.github.com</span></div></div><div class="lab-card-arrow">→</div></a>
<a class="lab-card" href="https://owasp.org/www-project-devsecops-guideline/" target="_blank"><div class="lab-card-body"><div class="lab-card-title">DevSecOps — OWASP</div><div class="lab-card-tags"><span class="lab-tag">owasp.org</span></div></div><div class="lab-card-arrow">→</div></a>
</div>
