<div align="center">
<h1><a id="intro">Лабораторная работа №6</a><br></h1>
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

## Материал

- **Docker Bench Security** - официальным инструментом аудита безопасности от Docker, который проверяет наличие практик при развертывания на CIS Docker Benchmark. Фактически это скрипт проверяющий распространенные практики.

- **Рассматриваемые вопросы безопасности**
    - Привилегионные контейнера
    - Хост-сеть
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

***

## Задание

- [ ] 1. 
- [ ] 15. Залейте изменения в свой удаленный репозиторий, проверьте историю `commit`.
- [ ] 16. Подготовьте отчет `gist`.
 
***

## Links

- [Docker](https://docs.docker.com/)
- [Markdown](https://stackedit.io)
- [Gist](https://gist.github.com)
- [GitHub CLI](https://cli.github.com)

Copyright (c) 2025 Elijah S Shmakov

![Logo](../../assets/logotype/logo.jpg)