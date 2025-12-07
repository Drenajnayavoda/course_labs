<div align="center">
<h1><a id="intro">Лабораторная работа №2</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Ласточкин_И._А.-8b9aff" alt="Contributor Badge"></a></div>

***

<br>Салют :wave:, </br>
Данная лабораторная работа посвещена изучению *nix машин и как они работают, позволяет приобрести навыки для работы с терминалом/ консолью и приобрести знания по работе ОС. В лабоработрной работе описываются материалы по командам, скриптам и подключаемым приложениям.

***

## Задание

- [X] 1. Выведите на терминале и проанализируйте следующие команды консоли

<img width="1045" height="604" alt="Снимок экрана 2025-11-30 в 19 31 24" src="https://github.com/user-attachments/assets/cb151365-e40f-49e0-a5ca-00070ab07efc" />

who — показывает, кто сейчас в системе.

wc -l — считает строки.

в итоге получаем количество активных пользователей/сессий.

id показывает: uid, gid, группы, пригодится для понимания прав.

whoami выводит текущего пользователя (всегда = $USER).

hostnamectl показывает hostname, ОС, ядро, виртуализация, архитектура

- [X] 2. Выведите утилитой `tree` список вложенности дерева диреторий для каталога своего пользователя. Далее используйте `ls -a` и укажите отличие от `ls -l`.

<img width="860" height="794" alt="Снимок экрана 2025-11-30 в 19 32 39" src="https://github.com/user-attachments/assets/ee575736-b5b8-44d0-849b-20a529b1e720" />

tree ~ выводит полную структуру домашнего каталога.

ls -a все файлы включая скрытые (. и .., dotfiles)

ls -l детальный вывод: права, владелец, группа, размер, дата

- [X] 3. Используйте утилиту `file` и `df` для определения какая файловая система на разделе `/dev/sda1`.

<img width="909" height="190" alt="Снимок экрана 2025-11-30 в 19 36 58" src="https://github.com/user-attachments/assets/a82be371-82fa-46cb-b0dc-0df34a6665b2" />

file -s покажет структуру файловой системы (ext4 / xfs / btrfs и т.п.)

df -Th покажет тип ФС и размер раздела.

- [X] 4. Выведите на терминале и проанализируйте следующие команды консоли

<img width="1080" height="534" alt="Снимок экрана 2025-11-30 в 19 44 59" src="https://github.com/user-attachments/assets/dd60ba6d-488c-4218-8ae4-d0b1c50b71fd" />

which vi показывает путь до бинарника

locate сначала ичего не показал, тк база locate обновляется через updatedb, после этого locate начинает находить новые файлы

<img width="1156" height="576" alt="Снимок экрана 2025-11-30 в 19 45 40" src="https://github.com/user-attachments/assets/dc63a6d3-f0ad-49e5-b4db-bc7d3d4e688e" />

find найдёт сразу. locate до обновления базы — нет.

- [X]  5. Используйте конструкцию и вставьте ее в созданный файл ранее. Подключите `pygame` - используем исключительно для стилизации окна.

<img width="877" height="530" alt="Снимок экрана 2025-11-30 в 22 55 26" src="https://github.com/user-attachments/assets/c38b939b-0d24-4b06-8189-45fed28d5945" />

- [X] 6. Сделайте `commit` и `push` в свой репозиторий с изменениями в `master branch`. На следующих лабораторных работах мы вернемся к этому файлу.

<img width="711" height="345" alt="Снимок экрана 2025-12-07 в 16 20 43" src="https://github.com/user-attachments/assets/8d60ac1b-c717-4a46-b8e1-a4ec4820ca44" />

- [X] 7. Выведите на терминале и проанализируйте следующие команды консоли

<img width="984" height="466" alt="Снимок экрана 2025-11-30 в 20 17 20" src="https://github.com/user-attachments/assets/9cb8eaa1-d603-4082-b2d2-8b18a17cba61" />

groups — показываем группы текущего пользователя.

useradd smallman - создаём пользователя smallman.

userdel -rf smallman - удаляем пользователя smallman и его домашний каталог.

useradd smallman — создаём пользователя smallman заново.

passwd smallman — устанавливаем пароль для пользователя smallman.

usermod smallman -c '........' — добавляем комментарий (ФИО, контакты) для пользователя smallman.

passwd smallman — снова устанавливаем пароль для пользователя smallman.

id smallman — смотрим UID, GID и группы пользователя smallman.

groupadd -g 1500 readgroup — создаём группу readgroup с GID 1500.

usermod -aG readgroup smallman — добавляем пользователя smallman в группу readgroup.

chmod 666 screen — делаем файл screen доступным для чтения и записи всем пользователям.

- [X] 8. Выведите группу прав для `screen` и измените, что бы файл был доступен только для чтения созданному пользователю и выведите права этого польователя для измененного файла только используя `readgroup`.

<img width="614" height="178" alt="Снимок экрана 2025-11-30 в 20 35 49" src="https://github.com/user-attachments/assets/2009f31b-4f0c-41c2-aedf-bc3a058787aa" />

Теперь только readgroup имеет доступ, пользователь smallman может читать, другие не могут

- [X] 9. Используйте `POSIX ACL`. Выведите на терминале и проанализируйте следующие команды консоли

<img width="602" height="355" alt="Снимок экрана 2025-11-30 в 20 36 41" src="https://github.com/user-attachments/assets/b3a9df38-4b89-44db-b219-d7ecc5ae6d13" />

setfacl -m u:smallman:rw nmapres.txt - выдаём пользователю smallman права чтения и записи на файл.

setfacl -m g:readgroup:r nmapres.txt - выдаём группе readgroup право только на чтение файла.

getfacl nmapres.txt — просматриваем расширенные ACL‑права файла.

- [X] 10. Сохраните файл внутри локального репозитория, так как следующая работа будет подразумевать запись в нее данных о nmap.

<img width="711" height="345" alt="Снимок экрана 2025-12-07 в 16 20 43" src="https://github.com/user-attachments/assets/9ed6ff2b-f51c-4abb-a096-70eb2dad6a11" />

- [X] 11. Для закрепления выведите все списки групп пользователей на вашей ОС и права на верхнеуровневые каталоги.
- [X] 12. Выведите все права для файлов и директорий локального репозитория которые имеют различные пользователи  (без использования длинных путей)

Группы:

<img width="600" height="714" alt="Снимок экрана 2025-11-30 в 20 45 17" src="https://github.com/user-attachments/assets/deac12a8-a2de-4299-a6ad-9694fac4b04c" />

Права на верхний уровень - ls -ld /*, Права файлов репозитория - ls -l:

<img width="743" height="604" alt="Снимок экрана 2025-11-30 в 20 45 25" src="https://github.com/user-attachments/assets/5f68f1b6-4f23-423b-9f94-517216fab2c8" />

- [X] 13. Выведите процессы которые у вас запущены в термине и вне его.

<img width="1029" height="669" alt="Снимок экрана 2025-11-30 в 20 45 48" src="https://github.com/user-attachments/assets/df53dbf7-484e-43f8-ae75-ef82c74ecc01" />

ps -a только привязанные к терминалу

ps -e все процессы

<img width="1058" height="738" alt="Снимок экрана 2025-11-30 в 20 46 05" src="https://github.com/user-attachments/assets/527a7921-364c-47df-a2fc-85fae42d1fec" />

- [X] 14. Оформить `README.md` по аналогии и использовать `shield`, etc.

- [X] 15. Составить `gist` отчет и отправить ссылку личным сообщением

***
