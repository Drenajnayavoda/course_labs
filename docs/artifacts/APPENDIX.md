<div align="center">
<h1><a id="intro">Приложение</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Шмаков_И._С.-8b9aff" alt="Contributor Badge"></a></div>

***

<details><summary><strong>Указатели</strong></summary><p>

- `HEAD` — указатель на текущий коммит или на текущую ветку (то есть, в любом случае, на коммит). Указывает на родителя коммита, который будет создан следующим.
- `ORIG_HEAD` — указатель на коммит, с которого вы только что переместили `HEAD` (командой `git reset` ..., например).
- Ветка (`master`, `develop` etc.) — указатель на коммит. При добавлении коммита, указатель ветки перемещается с родительского коммита на новый.
- Теги — простые указатели на коммиты. Не перемещаются.

 </p></details>
 
<details><summary><strong>ENV</strong></summary><p>

Команда git config позволяет управлять конфигурацией (примеры для --global)

- Локальный (--local) - только для текущего репозитория, файл .git/config
- Глобальный (--global) - для пользователя, файл ~/.gitconfig
- Системный (--system) - для всех пользователей /etc/gitconfig

 </p></details>

<details><summary><strong>Unix commands</strong></summary><p>

- [ar](https://en.wikipedia.org/wiki/Ar_(Unix))
- [cat](https://en.wikipedia.org/wiki/Cat_(Unix))
- [cd](https://en.wikipedia.org/wiki/Cd_(command))
- [cp](https://en.wikipedia.org/wiki/Cp_(Unix))
- [cut](https://en.wikipedia.org/wiki/Cut_(Unix))
- [echo](https://en.wikipedia.org/wiki/Echo_(command))
- [env](https://en.wikipedia.org/wiki/Env_(shell))
- [ex](https://en.wikipedia.org/wiki/Ex_(editor))
- [file](https://en.wikipedia.org/wiki/File_(command))
- [find](https://en.wikipedia.org/wiki/Find)
- [ls](https://en.wikipedia.org/wiki/Ls)
- [man](https://en.wikipedia.org/wiki/Man_page)
- [mkdir](https://en.wikipedia.org/wiki/Mkdir)
- [mv](https://en.wikipedia.org/wiki/Mv)
- [nm](https://en.wikipedia.org/wiki/Nm_(Unix))
- [ps](https://en.wikipedia.org/wiki/Ps_(Unix))
- [pwd](https://en.wikipedia.org/wiki/Pwd)
- [rm](https://en.wikipedia.org/wiki/Rm_(Unix))
- [sed](https://en.wikipedia.org/wiki/Sed)
- [touch](https://en.wikipedia.org/wiki/Touch_(Unix))

</p></details>

<details><summary><strong>Package Managers</strong></summary><p>

- [apt](http://help.ubuntu.ru/wiki/apt)
- [dnf](https://en.wikipedia.org/wiki/DNF_(software))
- [yum](https://fedoraproject.org/wiki/Yum/ru)
- [brew](https://brew.sh)
- [linuxbrew](http://linuxbrew.sh)
- [npm](https://docs.npmjs.com)

</p></details>

<details><summary><strong>Software</strong></summary><p>

- [curl](https://www.gitbook.com/book/bagder/everything-curl/details)
- [wget](https://www.gnu.org/software/wget/manual/wget.pdf)
- [openssl](https://www.openssl.org)
- [nano](https://www.nano-editor.org)
- [tree](https://linux.die.net/man/1/tree)
- [vim](http://www.vim.org)

</p></details>

<details><summary><strong>Политика безопасности проекта</strong></summary><p>

Введение

Данная политика безопасности описывает, как обрабатываем вопросы безопасности в этом проекте, а также как пользователи и участники могут сообщать о потенциальных уязвимостях. Стремимся обеспечить прозрачность и ответственность в вопросах безопасности для защиты пользователей и проекта.

## Как сообщить об уязвимости

Если вы обнаружили уязвимость или проблему безопасности:

1. Пожалуйста, не публикуйте её публично, чтобы предотвратить потенциальные злоупотребления.
2. Сообщите напрямую по электронной почте: shmakovis@inbox.ru
3. Предоставьте детальное описание уязвимости, включая:
   - Шаги воспроизведения
   - Версию проекта, где была обнаружена проблема
   - Ваши контакты для связи

Мы обязуемся ответить в течение 48 часов с подтверждением получения сообщения.

## Процесс рассмотрения и исправления уязвимостей

1. Получение и подтверждение уязвимости.
2. Анализ и оценка риска.
3. Разработка патча с последующим тестированием.
4. Выпуск обновления безопасности.
5. Уведомление общественности и пользователей после выпуска обновления.
6. Ведение журнала уязвимостей и исправлений (если применимо).

## Поддерживаемые версии проекта

- Поддерживается текущая основная ветка `develop`
- Рекомендуется обновляться до поддерживаемых версий для безопасности

## Рекомендации пользователям

- Всегда используйте последние стабильные версии проекта.
- Подписывайтесь на обновления безопасности в репозитории или используйте автоматическое обновление.
- Сообщайте о любых подозрительных действиях или проблемах безопасности.

## Политика раскрытия информации

- Мы стремимся к открытому диалогу и своевременному раскрытию информации.
- Информация о критических уязвимостях будет публиковаться после успешного выпуска патча.
- Мы приветствуем сотрудничество с исследователями безопасности и сообществом.

## Дополнительная информация

- Документирование и хранение журналов безопасности.
- Использование автоматизированных инструментов для сканирования кода на уязвимости.
- Регулярные аудиты безопасности и ревизии.

---

Если у вас возникли вопросы или предложения по безопасности проекта, пожалуйста, свяжитесь по контактным данным выше.

---

Спасибо за ваш вклад в безопасность нашего проекта!

</p></details>

<details><summary><strong>Contributor Covenant</strong></summary><p>

Это широко используемый кодекс поведения для участников открытых проектов. Его цель — создать приветливую, инклюзивную и свободную от домогательств среду для всех участников сообщества, включая представителей меньшинств и уязвимых групп.

Кодекс определяет ожидаемые модели поведения, такие как уважение, конструктивное общение и ответственность за свои действия. В нем также чётко описано, какие формы поведения считаются неприемлемыми: домогательства, дискриминация, оскорбления, преследования и разглашение личной информации без согласия.

Кроме того, Contributor Covenant устанавливает обязанности лидеров и сопровождающих проекта по обеспечению соблюдения этих правил, а также процесс реагирования на жалобы, включая конфиденциальное рассмотрение и принятие мер по устранению нарушений.

Этот кодекс применяется не только в рамках технических площадок проекта, но и когда кто-то представляет сообщество публично, помогая поддерживать здоровую и продуктивную атмосферу для совместной работы и развития проектов.

Широко принят в крупных open source проектах и организациях, таких как Linux Foundation, Python Software Foundation и многих других, Contributor Covenant способствует формированию уважительной и разнообразной среды разработки программного обеспечения.

</p></details>

***

Copyright (c) 2025 Elijah S Shmakov


![Logo](assets/logotype/logo.jpg)

