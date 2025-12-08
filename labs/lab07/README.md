<div align="center">
<h1><a id="intro">Лабораторная работа №7</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Шмаков_И._С.-8b9aff" alt="Contributor Badge"></a></div>

***

<br>Салют :wave:, </br>
Данная лабораторная работа посвещена изучению аудита безопасности `Docker` при использовании `Docker Bench Security`. Мы рассмотрим как с ним работать. Мы разберем как проверить конфигурации безопасности и выявить их не корректность, как произвести чекап с `CIS Docker Benchmark v1.6.0`.

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

- 




cd sca
mvn dependency:resolve
mvn dependency:copy-dependencies -DoutputDirectory=./lib
mvn org.owasp:dependency-check-maven:check

http://localhost:8080

bash sca/dependency-check.sh --update

***

## Задание

- [ ] 1. 
- [ ] 9. Подготовьте отчет `gist`.
- [ ] 10. Почистите кеш от `venv` и остановите уязвимостей приложение, почистите контейнера

```bash
rm -rf venv
docker-compose -f demo-vulnerable-app.yml down
docker system prune -f
 ```
 - [ ] 10. Залить результаты в удаленный репозиторий
 - [ ] 

***

## Troobleshooting

- Права для исполнения скрипта

```bash
chmod +x xxx.sh # разрешение прав при permission denied
```

- На macOS/AArch64 docker-bench-security может не запускаться из‑за ограничений Docker Desktop и это работает для Linux‑VM. На Mac используем Trivy‑скан и разбор конфигурации compose‑файлов.

***

## Links

- [Docker](https://docs.docker.com/)
- [Markdown](https://stackedit.io)
- [Gist](https://gist.github.com)
- [GitHub CLI](https://cli.github.com)

Copyright (c) 2025 Elijah S Shmakov

![Logo](../../assets/logotype/logo.jpg)