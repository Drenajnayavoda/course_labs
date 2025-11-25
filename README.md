<div align="center">
<h1><a id="intro"> Лабораторные работы <sup><kbd>Course</kbd></sup></a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Шмаков_И._С.-8b9aff" alt="Contributor Badge"></a></div>

<br>Салют :wave:,</br>
Отмечу основные моменты:

*  Цель - сформировать навыки работы с `git`, `CI`, `CD`, `docker`, `packages`, `appsec toolchain`, `yml`, etc. 
*  *Часть работ базируется на на `Go`, `Python`, `JAVA`, `js` и и.д.
*  Рассматриваются инструменты `SAST`, `SCA`, `Container Security`, `DAST`, `Secret Detection`, etc. 
*  Работы направлены на углубление и изучение материалов анализа рисков и оценки защищенности приложений, которые необходимы для итерационной разработки, также дают дополнительно возможности для изучения паттернов программирования, прототипирования
*  Каждый мини проект должен будет собран по формату из представленных лабораторных работ и размещен на сервисе `GitHub`, с формирование соответствующего отчета в виде `gistup` для демонстрации выполненной работы и скриншотами результатов (**где это требуется**). 
*  Для каждой лабораторной работы следует создавать собственный репозиторий (возможно использование `fork` с родительского), в котором необходимо разместить исходный код проекта, далее составить отчет к нему в формате `gistup`. 
*  Все лабораторные работы должны быть выполнены в ветке develop и необходимо cделать [approve](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/requesting-a-pull-request-review) по `pull request` на [geminishkv](https://github.com/geminishkv), тем самым будет финально подтверждаться согласование изменений и правок, которые были внесены удаленно 

![Logo](assets/logotype/logo2.jpg)

**Замечание:** 
* Лабораторные работы - обязательны к прохождению, сдаче и итерационной разработке, при любом уровне подготовки
* Необходимо скопировать этапы реализации и отмечать у себя именно те, которые были сделаны
* Каждая работа изначально должна итерационно разбиваться на коммиты изменений для их отслеживания
* Каждый отчет сдается индивидуально с защитой, каждая используемая команда должна иметь описание (пояснение) в отчете `gistup` и содержать вывод из терминала с пояснением команды в консоли. 
* В лабораторных рассматривается также использование инструментов требующих установки дополнительных пакетов open-source. 

<div align="center"><h2>Stay tuned ;)</h3></div> 

### Этапы
    
1. Ознакомление с учебными материалами по [лекциям](artifacts/ppt/)
2. Ознакомиться с [примерами](artifacts/exmpls/)
3. Каждый репозиторий должен содержать `.gitignore`, `code of condact`, `contributing`, `license`, `notice`, `security` и должен быть адаптирован под конкретную лабораторную работу, проект.
    * **Обратите внимание**, что тип лицензий должен быть подобран правильно при переиспользовании материалов проекта и следует ознакомиться с ними дополнительно.
4. Выполнить следующие работы порядково:

-  [ ] lab01 - [Лабораторная работа посвящена изучению **gitscm** и подготовительными материалами для последующих работ](labs/lab01/README.md)
    -  Материалы для работы [тут](labs/lab01/)
-  [ ] lab02 - [Лабораторная работа посвящена изучению работы *nix, контролей прав доступа, оперированию процессов](labs/lab02/README.md)
    -  Материалы для работы [тут](labs/lab02/)
-  [ ] lab03 - [Лабораторная работа посвящена изучению **nmap** и анализа выявленных уязвимостей](labs/lab03/README.md)
    -  Материалы для работы [тут](labs/lab03/)
-  [ ] lab04 - [Данная лабораторная работа посвящена практическому **анализу и определению мер** снижения рисков ИБ](labs/lab04/README.md)
-  [ ] lab05 - [Данная лабораторная работа посвящена изучению **Docker** и как с ним работать](labs/lab05/README.md)
    -  Материалы для работы [тут](labs/lab05/)
-  [ ] **Обновление будет предоставлено позднее**

5. Реализовать итоговую работу и составить отчет

-  [ ] **Обновление будет предоставлено позднее** 

***

### Сопроводительные материалы:

* [Cheatsheet GitScm](artifacts/cheatsheet/CHEATSHEET_GIT.md)
* [Cheatsheet .gitignore](artifacts/cheatsheet/CHEATSHEET_GITIGNORE.md)
* [Cheatsheet GitHub CLI](artifacts/cheatsheet/CHEATSHEET_GH_CLI.md)
* [Cheatsheet Docker](artifacts/cheatsheet/CHEATSHEET_DOCKER.md)
* [Cheatsheet .dockerignore](artifacts/cheatsheet/CHEATSHEET_DOCKERIGNORE.md)
* [License Notice](./NOTICE.md)
* [Приложение](./APPENDIX.md)

***

### Формализованные требования 

- ✔️ Единый стиль кода
- ✔️ Все функции по работе с деревом должны находиться в пространстве имен
- ✔️ Оформление `README.md` в соответствии с содержанием проекта
- ✔️ Оформление `.gitignore` в соответствии с содержанием проекта
- ✔️ Использовать подходящий тип `LICENSE` для проекта
- ✔️ Создать и использовать скрипты для автоматизации сборки проекта, примеров, тестов, пакетирования
- ✔️ Обеспечить непрерывный процесс сборки проекта с использованием сервиса **Travis CI/ AppVeyor** (**community edition**)
- ✔️ Обеспечить 100% покрытие кода с использованием фреймворков
- ✔️ Написать документацию к проекту с использованием инструмента **doxygen** и разместить ее на сервисе GitHub Pages
- ✔️ Обеспечить размещение пакета проекта на сервисе GitHub Release при успешном слияние ветки develop и master
- ✔️ Проконтролировать корректную эксплуатацию проекта
- ✔️ Рефакторинг и поддержка лабораторных работ в процессной деятельности
- ✔️ Все команды выполняться строго из терминала/ консоли без использования WebUI за исключениям работы с токенами, ключами и специфичными настройками.

***

### Структура репозитория

```
├── APPENDIX.md
├── artifacts
│   ├── art_cheatsheet
│   │   ├── Docker_Image_Security_Best_Practices.pdf
│   │   └── gitscm.jpg
│   ├── cheatsheet
│   │   ├── CHEATSHEET_DOCKER.md
│   │   ├── CHEATSHEET_DOCKERIGNORE.md
│   │   ├── CHEATSHEET_GH_CLI.md
│   │   ├── CHEATSHEET_GIT.md
│   │   └── CHEATSHEET_GITIGNORE.md
│   ├── exmpls
│   │   ├── Аналитический отчет по уязвимости PrintNightmare.pdf
│   │   ├── Пример - Multisignature - Безопасности криптовалютных платежей.pdf
│   │   └── Пример_аналитических_отчетов_по_задачам_ИБ.pdf
│   ├── owasp
│   │   ├── OWASP_Top_10_CICD_Risks.pdf
│   │   ├── Авторизация (Authorization).pdf
│   │   ├── Атаки на клиентов (Client-side Attacks).pdf
│   │   ├── Аутентификация (Authentication).pdf
│   │   ├── Выполнение кода (Command Execution).pdf
│   │   ├── Логические атаки (Logical Attacks).pdf
│   │   └── Разглашение информации (Information Disclosure).pdf
│   └── ppt
│       └── Лекция_Управление Рисками ИБ_intro.pdf
├── assets
│   ├── logotype
│   │   ├── logo.jpg
│   │   └── logo2.jpg
│   └── style
│       └── style.css
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
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
│   │   └── README.md
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
│   │       ├── image.tar
│   │       └── requirements.txt
│   └── lab06
│       └── README.md
├── LICENSE.md
├── NOTICE.md
├── README.md
└── SECURITY.md
```

***

### Ресурсы:

* 📘  **Аннотационный материал:**

    * [OWASP TOP 10](artifacts/owasp/)
    * `gistup`

```bash
$ npm install -g gistup
$ gh <command> <subcommand> --help
$ gh gist create -d "my test gist" -f some_local_file.txt  test_gist
```

* 📦 **Releases**:

* **Links:**
    * [Google Sheets](https://www.google.ru/intl/ru/sheets/about/)
    * [Google Docs](https://www.google.ru/intl/ru/docs/about/)
    * [GitHub SSH Key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
    * [Markdown](https://stackedit.io)
    * [Gist](https://gist.github.com)
    * [GitHub Personal Token](https://github.com/settings/tokens/new)
    * [GitHub CLI](https://cli.github.com)
    * [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph)
    * [Docker](https://docs.docker.com/)
    * [Project Manager](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager)
    * [Code of Conduct](https://www.contributor-covenant.org)

Copyright (c) 2025 Elijah S Shmakov


![Logo](assets/logotype/logo.jpg)

