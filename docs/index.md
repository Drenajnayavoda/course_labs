<div align="center">

<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"></a>
<img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt="RA">
<img src="https://img.shields.io/badge/AppSec-2448a2" alt="AppSec">
<img src="https://img.shields.io/badge/type-education-7b61ff" alt="Education">
<img src="https://img.shields.io/badge/Contributor-Шмаков_И._С.-8b9aff" alt="Contributor Badge">
<a href="https://img.shields.io/github/license/geminishkv/course_labs"></a>
<img src="https://img.shields.io/github/license/geminishkv/course_labs" alt="License">
<img src="https://img.shields.io/badge/code%20style-ruff-5f97ff" alt="Code style: ruff">
<img src="https://img.shields.io/badge/status-active-success" alt="Status">
<img src="https://img.shields.io/github/repo-size/geminishkv/course_labs" alt="Repo Size">
<img src="https://img.shields.io/github/last-commit/geminishkv/course_labs" alt="Last commit">
<img src="https://img.shields.io/github/actions/workflow/status/geminishkv/course_labs/ci.yml?branch=develop" alt="CI">
<img src="https://img.shields.io/github/v/release/geminishkv/course_labs" alt="Release">

</div>

## Intro

<br>Салют :wave:,</br>
Отмечу основные моменты:

- Цель - сформировать навыки работы с `git`, `CI`, `CD`, `docker`, `packages`, `appsec toolchain`, `yml`, etc. 
- Часть работ базируется на на `Go`, `Python`, `JAVA`, `Shell` и и.д.
- Рассматриваются инструменты `SAST`, `SCA`, `Container Security`, `DAST`, `Secret Detection`, etc. 
- Работы направлены на углубление и изучение материалов анализа рисков и оценки защищенности приложений, которые необходимы для итерационной разработки, также дают дополнительно возможности для изучения паттернов программирования, прототипирования
- Каждый мини проект должен будет собран по формату из представленных лабораторных работ и размещен на сервисе `GitHub`, с формирование соответствующего отчета в виде `gistup` для демонстрации выполненной работы и скриншотами результатов (**где это требуется**). 
- Для каждой лабораторной работы следует создавать собственный репозиторий (возможно использование `fork` с родительского), в котором необходимо разместить исходный код проекта, далее составить отчет к нему в формате `gistup`. 

<div align="center"><h3>Stay tuned ;)</h3></div> 

***

## Этапы

1. Ознакомление с учебными материалами по лекциям
2. Ознакомиться с [примерами](artifacts/exmpls/)
3. Каждый репозиторий должен содержать `.gitignore`, `CODE_OF_CONDUCT`, `CONTRIBUTING`, `LICENSE`, `NOTICE`, `SECURITY` и должен быть адаптирован под конкретную лабораторную работу или проект
    - **Обратите внимание**, что тип лицензий должен быть подобран правильно при переиспользовании материалов проекта и следует ознакомиться с ними дополнительно.
    - Пример отчета [тут](https://gist.github.com/MishaBary/21ab63f83292a86268e039d484a86411).
4. Выполнить следующие работы по порядку
5. Реализовать итоговую работу и составить отчет по 'pet_project' – [Итоговая работа по оценке рисков ИБ и практическому использованию инструментов Application Security](labs/pet_project.md) *(обновление будет предоставлено позже)*

***

## Лабораторные работы

<table>
  <thead>
    <tr>
      <th style="width:5%;">№</th>
      <th style="width:70%;">Описание</th>
      <th style="width:25%;">Материалы</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>lab01</strong></td>
      <td>
        <a href="labs/lab01">
          Лабораторная работа посвящена изучению <strong>GitSCM</strong> и подготовительным материалам для последующих работ
        </a>
      </td>
      <td>
        <a href="https://github.com/geminishkv/course_labs/tree/develop/labs/lab01">Материалы в репозитории</a>
      </td>
    </tr>
    <tr>
      <td><strong>lab02</strong></td>
      <td>
        <a href="labs/lab02">
          Лабораторная работа посвящена изучению работы <em>*nix</em>, контролей прав доступа и управлению процессами
        </a>
      </td>
      <td>
        <a href="https://github.com/geminishkv/course_labs/tree/develop/labs/lab02">Материалы в репозитории</a>
      </td>
    </tr>
    <tr>
      <td><strong>lab03</strong></td>
      <td>
        <a href="labs/lab03">
          Лабораторная работа посвящена изучению <strong>nmap</strong> и анализа выявленных уязвимостей
        </a>
      </td>
      <td>
        <a href="https://github.com/geminishkv/course_labs/tree/develop/labs/lab03">Материалы в репозитории</a>
      </td>
    </tr>
    <tr>
      <td><strong>lab04</strong></td>
      <td>
        <a href="labs/lab04">
          Лабораторная работа посвящена практическому <strong>анализу и определению мер</strong> снижения рисков ИБ
        </a>
      </td>
      <td>—</td>
    </tr>
    <tr>
      <td><strong>lab05</strong></td>
      <td>
        <a href="labs/lab05">
          Лабораторная работа посвящена изучению <strong>Docker</strong> и работе с контейнерами
        </a>
      </td>
      <td>
        <a href="https://github.com/geminishkv/course_labs/tree/develop/labs/lab05">Материалы в репозитории</a>
      </td>
    </tr>
    <tr>
      <td><strong>lab06</strong></td>
      <td>
        <a href="labs/lab06">
          Лабораторная работа посвящена изучению <strong>Docker CIS Benchmark</strong> и аудиту Docker‑хоста
        </a>
      </td>
      <td>
        <a href="https://github.com/geminishkv/course_labs/tree/develop/labs/lab06">Материалы в репозитории</a>
      </td>
    </tr>
    <tr>
      <td><strong>lab07</strong></td>
      <td>
        <a href="labs/lab07">
          Лабораторная работа посвящена изучению <strong>SAST и SCA</strong> на примере Semgrep, Checkov, Dependency‑Check
        </a>
      </td>
      <td>
        <a href="https://github.com/geminishkv/course_labs/tree/develop/labs/lab01">Материалы в репозитории</a>
      </td>
    </tr>
    <tr>
      <td><strong>lab08</strong></td>
      <td>
        <a href="labs/lab08">
          Лабораторная работа посвящена изучению <strong>DAST (OWASP ZAP)</strong> и ручному тестированию уязвимого приложения
        </a>
      </td>
      <td>
        <a href="https://github.com/geminishkv/course_labs/tree/develop/labs/lab08">Материалы в репозитории</a>
      </td>
    </tr>
    <tr>
      <td><strong>lab09</strong></td>
      <td><em>будет опубликована позже</em></td>
      <td>—</td>
    </tr>
    <tr>
      <td><strong>lab10</strong></td>
      <td>
        <a href="labs/lab10">
          Лабораторная работа посвящена оценке анализа рисков ИБ и отработке практических знаний
        </a>
      </td>
      <td>—</td>
    </tr>
  </tbody>
</table>

***

## Формализованные требования 

<div style="display:flex; flex-wrap:wrap; gap:0.5rem 1.5rem; align-items:flex-start;">
  <span>✔️ Все функции по работе с деревом должны находиться в пространстве имен и единый стиль кода</span>
  <span>✔️ Оформление <code>README.md</code> в соответствии с содержанием проекта</span>
  <span>✔️ Оформление <code>.gitignore</code> в соответствии с содержанием проекта</span>
  <span>✔️ Оформление <code>.dockerignore</code> в соответствии с содержанием проекта</span>
  <span>✔️ Использовать подходящий тип <code>LICENSE</code> для проекта и <code>NOTICE</code></span>
  <span>✔️ Создать и использовать скрипты для автоматизации сборки проекта, примеров, тестов, пакетирования</span>
  <span>✔️ Обеспечить непрерывный процесс сборки проекта с использованием сервиса <code>GitHub Actions</code></span>
  <span>✔️ Написать документацию к проекту с использованием инструмента <code>doxygen</code></span>
  <span>✔️ Обеспечить размещение пакета проекта на сервисе <code>GitHub Release</code> при успешном слиянии ветки <code>develop</code></span>
  <span>✔️ Рефакторинг и поддержка лабораторных работ в процессной деятельности</span>
  <span>✔️ Все команды выполняются строго из терминала/консоли без использования <code>WebUI</code> (кроме токенов, ключей и специфичных настроек)</span>
</div>

***

## Замечание

- Лабораторные работы - обязательны к прохождению, сдаче и итерационной разработке, при любом уровне подготовки
- Необходимо скопировать этапы реализации и отмечать у себя именно те, которые были сделаны
- Каждая работа изначально должна итерационно разбиваться на коммиты изменений для их отслеживания
- Каждый отчет сдается индивидуально с защитой, каждая используемая команда должна иметь описание (пояснение) в отчете `gistup` и содержать вывод из терминала с пояснением команды в консоли
- В лабораторных рассматривается также использование инструментов требующих установки дополнительных пакетов `open-source`
- Для всех отчетов следует избегать скриншотов и делать со вставками вывода из консоли и описания используемых команд, флагов и что они означают для понимания принципа их работы

***

![Logo](artifacts/assets/logotypemd.jpg)