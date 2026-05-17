<div align="center">
<h1><a id="intro">Лабораторная работа №5</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Ласточкин_И._А.-8b9aff" alt="Contributor Badge"></a></div>

***

<br>Салют :wave:, </br>
Данная лабораторная работа посвещена изучению Docker и как с ним работать. Эта лабораторная работа послужит подпоркой для старта в выявлении и определении уязвимостей на уровне сканирования контейнеров при сборке приложений. 

Для сдачи данной работы также будет требоваться ответить на дополнительыне вопросы по описанным темам.

***

## Материал

- **Контейнеризация**

Сборка приложения включает создание контейнерного образа, в котором упаковано приложение с конфигурациями, что бы приложение функционировало. `Docker` основан на использовании общих функций ядра `ОС Linux` (`cgroups`, `namespace`) для изоляции и управления ресурсами.

> **Образ** — это статический, неизменяемый шаблон, на базе которого создаются контейнера с ОС, приложением, зависимостями, библиотекакм и конфигурационными файлами. Нужен для создания воспроизводимой, неизменяемой среды выполнения приложений в контейнерах.

Для сборки образов используется `Dockerfile`, где прописаны версии зависимостей и инструкции, минимизирующие разрешения и атаки. Это инструкции, где описывается, как собрать образ. Впоследствии собирается контейнер.

> **Контейнер** — это изолированная среда выполнения приложения с необходимыми зависимостями, кодом, системными утилитами, библиотеками и настройками. Исползует не собственну гостеву ОС, а ядро хостовой ОС и имеет своё собственное файловое пространство, процессы и сеть.

После сборки образа формируется контейнер, которые являются изолированными средами выполнения для достижения цели переносимости, воспроизведения.

> **Контейнеризация** — это технология, позволяющая упаковать приложение вместе со всеми его зависимостями, библиотеками, настройками и средой выполнения в единый изолированный виртуальный контейнер. 

- **Namespaces**

Необходимы для организации изолированных рабочих пространств, - контейнеров. Когда мы запускаем контейнер, `Docker` создает набор пространств имен для данного контейнера, что создает изолированный уровень в своем простанстве имен и не имеет доступа к внешней системе. Пространство имен:

> - pid: для изоляции процесса
> - net: для управления сетевыми интерфейсами
> - ipc: для управления IPC ресурсами. (ICP: InterProccess Communication)
> - mnt: для управления точками монтирования
> - utc: для изолирования ядра и контроля генерации версий(UTC: Unix timesharing system)

- **Cgroups**

Необходимы для контрольных групп в изоляции, где предоставляется приложению только те ресурсы, которые указываем. Позволяют разделять ресурсы железа и устанавливать пределы, ограничения.

```bash
$ docker container run d \
        —e NGINX_HOST xxx.xxx \
        —p 8080:80 \
        –-v "$PWD/html" usr/share/nginx/html \
        —memory=50m \
        —cpus="2.5" \
        nginx
```

-  **Основные проблемы**

    - образ может содержать устаревшие или уязвимые версии библиотек CVE (Common Vulnerabilities and Exposures)
    - поддельные и злонамеренные образы
    - отсутствие подписей и проверки целостности
    - ошибка конфигурации и избыток прав — образы с избыточными правами доступа, запуском от root или с небезопасными настройками
    - присутствие секретов и конфиденциальных данных в образах
    - отсутствие регулярного обновления из-за неподдерживаемых образов

-  **Контекст безопасности**

    - Не задавать пользователей с правами «root» для работы сервисов внутри контейнеров. 
        > Если для функционирования сервиса не требуются расширенные привилегии, то в Dockerfile необходимо явно прописать учетную запись пользователя с минимально необходимыми правами.
    - Не запускать контейнеры в привилегированном режиме. 
        > Ключ «--privileged» отключает все средства изоляции (наложенные cgroup – контроллером устройства) docker-контейнера. Запуск контейнера с таким ключом обеспечит ему доступ к файловой системе и блочным устройствам (например, жесткому диску) хоста. Контейнеры должны быть запущены в непривилегированном режиме. Если контейнеру нужны дополнительные привилегии для корректной работы, то необходимо явно прописать или удалить требуемые docker capabilities.
    - Не отключать профили безопасности Docker. 
        > По умолчанию для запуска контейнеров Docker использует профили безопасности Linux, лучше использовать профили AppArmor, SELinux, grsecurity, seccomp, - позволяют ограничить активности контейнера, обеспечивая контроль сети, использования дополнительных возможностей (docker capabilities), контроль обращений к файловой системе хоста и пр. Контейнеры должны работать с активными профилями безопасности Docker, не docker-default. Если необходимо использовать другой профиль, то это можно сделать с помощью --security-opt.
    - Не допускать запуск контейнеров, использующих тип сети «host»
        > В режиме Host контейнер использует ту же сеть, что и хост, т.е. контейнерная сеть не изолируется от сети Docker хоста и контейнер не получает собственный IP-адрес, что дает доступ к REST API daemon docker изнутри контейнера, а также к устройствам, расположенным в сети хоста. Для реализации сетевого взаимодействия между контейнерами, они должны запускаться в режиме bridge или none.
    - Не разрешать доступ к docker.socket изнутри контейнера. Не подключать docker socket в контейнер без необходимости, либо с использованием плагинов авторизации. 
    - Не использовать секреты в открытом виде в Docker-файлах образов. По возможности не использовать переменные окружения и не хранить секреты внутри контейнера. Хранение и управление секретами возложить на сторонний сервис.
    - Ограничивать и контролировать использование ресурсов контейнерами. Указывать ограничения на уровне самого ПО или на уровне контейнеров для использования ресурсов хоста.
    - Контролировать качество базовых образов контейнеров. Использовать официальные образы и использовать образы с минимально необходимым набором инструментов.
    - Сканировать образы на наличие уязвимостей и проверки требований ИБ (Compliance Checks)

- **Дополнительно**

В случае, если возникает проблема с вызовом `docker buildx` для macos `silicon`, следует использовать вот [это](https://gist.github.com/Aeonitis/cbd9f8b61eaec5a8a024c0a42f415ca3) описание из gistup для фикса `samelink`.

***

## Задание

- [x] 1. Поставьте `Docker` и `buildkit`

- [x] 2. Перейдите в `source` и выведите на терминале, далее проанализируйте следующие команды консоли

```bash
jvs@debian:~/course_labs/labs/lab05/source$ docker buildx build -t hello-appsec-world .
[+] Building 10.7s (13/13) FINISHED                              docker:default
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 443B                                       0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim        2.6s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load build context                                          0.0s
 => => transferring context: 63B                                           0.0s
 => [builder 1/4] FROM docker.io/library/python:3.11-slim@sha256:1dd3dca8  3.6s
 => => resolve docker.io/library/python:3.11-slim@sha256:1dd3dca85e22886e  0.0s
 => => sha256:d6c334210834c83bc9858624f5bf820185717657b3c 1.27MB / 1.27MB  1.0s
 => => sha256:e520b56ca06c357af399db1a3f56197a91b4dd3fd 14.31MB / 14.31MB  1.3s
 => => sha256:1dd3dca85e22886e44fcad1bb7ccab6691dfa83db 10.37kB / 10.37kB  0.0s
 => => sha256:b8129af7ea9a0969030638589dae3dcaf77fb3a7c65 1.75kB / 1.75kB  0.0s
 => => sha256:e1523b812f94df96c608086784fd00371e8b4902b18 5.49kB / 5.49kB  0.0s
 => => sha256:2ae15a20160209c6fd6cff4886e4ba2e666fa5bed 30.14MB / 30.14MB  1.5s
 => => sha256:fadbb2bb3227921a21310ec375def0aec3c9e3d199a0c84 249B / 249B  1.5s
 => => extracting sha256:2ae15a20160209c6fd6cff4886e4ba2e666fa5bedd7b54a2  1.2s
 => => extracting sha256:d6c334210834c83bc9858624f5bf820185717657b3cbe19b  0.1s
 => => extracting sha256:e520b56ca06c357af399db1a3f56197a91b4dd3fd26f6cc7  0.7s
 => => extracting sha256:fadbb2bb3227921a21310ec375def0aec3c9e3d199a0c846  0.0s
 => [builder 2/4] WORKDIR /hello                                           0.0s
 => [builder 3/4] COPY requirements.txt .                                  0.0s
 => [builder 4/4] RUN pip install --upgrade pip && pip wheel --wheel-dir=  3.1s
 => [stage-1 3/6] COPY --from=builder /wheels /wheels                      0.0s
 => [stage-1 4/6] COPY requirements.txt .                                  0.0s
 => [stage-1 5/6] RUN pip install --no-index --find-links=/wheels -r requ  1.1s
 => [stage-1 6/6] COPY hello.py .                                          0.0s
 => exporting to image                                                     0.1s
 => => exporting layers                                                    0.1s
 => => writing image sha256:6b1ea1fa416c6bba48bb81f9440aa9650d0724c12448e  0.0s
 => => naming to docker.io/library/hello-appsec-world


jvs@debian:~/course_labs/labs/lab05/source$ docker run hello-appsec-world
hello appsec world

jvs@debian:~/course_labs/labs/lab05/source$ docker run --rm -it hello-appsec-world
hello appsec world

jvs@debian:~/course_labs/labs/lab05/source$ docker save -o hello.tar hello-appsec-world

jvs@debian:~/course_labs/labs/lab05/source$ ls
Dockerfile  hello.py  hello.tar  requirements.txt

jvs@debian:~/course_labs/labs/lab05/source$ docker load -i hello.tar
Loaded image: hello-appsec-world:latest

jvs@debian:~/course_labs/labs/lab05/source$ docker load -i image.tar
open image.tar: no such file or directory

jvs@debian:~/course_labs/labs/lab05/source$ 

```

**`docker buildx build -t hello-appsec-world .`**: Создает образ Docker с именем `hello-appsec-world` из текущей директории.

**`docker run hello-appsec-world`**: Запускает контейнер из образа `hello-appsec-world`.

**`docker run --rm -it hello-appsec-world`**: Запускает контейнер в интерактивном режиме и удаляет его после остановки.

**`docker save -o hello.tar hello-appsec-world`**: Сохраняет образ `hello-appsec-world` в файл `hello.tar`.

**`docker load -i hello.tar`**: Загружает образ из файла `hello.tar`.

**`docker load -i image.tar`**: Загружает образ из файла `image.tar`.


- [x] 3. Откройте `Dockerfile` и сделайте его анализ. Сделайте `commit`

```bash
FROM python:3.11-slim AS builder          # Базовый образ Python, этап сборки зависимостей
WORKDIR /hello                          # Рабочая директория внутри контейнера
COPY requirements.txt .                  # Копируем файл зависимостей отдельно для кеширования
RUN pip install --upgrade pip && pip wheel --wheel-dir=/wheels -r requirements.txt  # обновляем pip, собираем зависимости в wheel-пакеты

FROM python:3.11-slim                     # Финальный минимальный runtime-образ
WORKDIR /hello                            # Рабочая директория приложения

COPY --from=builder /wheels /wheels       # Копируем собранные wheel-пакеты из builder-этапа
COPY requirements.txt .                  # Копируем файл зависимостей
RUN pip install --no-index --find-links=/wheels -r requirements.txt                  # Запрещаем загрузку пакетов из интернета, указываем локальный источник пакетов, устанавливаем зависимости
COPY hello.py .                           # Копируем основной Python-скрипт


ENV PYTHONUNBUFFERED=1                  # Вывод логов без буферизации
CMD ["python", "hello.py"]             # Команда запуска приложения
```

```bash
jvs@debian:~/course_labs/labs/lab05$ git add source/
jvs@debian:~/course_labs/labs/lab05$ git status
Текущая ветка: lab5
Ветка отстает от «origin/lab5» на 2 коммита и может быть быстро перемотана.
  (используйте «git pull», чтобы обновить вашу локальную ветку)

Изменения, которые будут включены в коммит:
  (используйте «git restore --staged <файл>...», чтобы убрать из индекса)
	новый файл:    source/hello.tar

jvs@debian:~/course_labs/labs/lab05$  git commit -m "add Dockerfile"
[lab5 56d8868] add Dockerfile
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 labs/lab05/source/hello.tar
jvs@debian:~/course_labs/labs/lab05$ 
```

- [x] 4. Замените в `Dockerfile`значение скрипта на `python` тем, который вы сделали ранее в прошлых лабораторных работах. Вложите свой файл `python` в директорию. Сделайте анализ своего измененного `Dockerfile` и внесите изменения. Сделайте `commit`. 

```bash
# Этап 1: сборка зависимостей
FROM python:3.11-slim AS builder

WORKDIR /hello

# Копируем файл с зависимостями
COPY requirements.txt .

# Устанавливаем pip и собираем зависимости в wheel-формате
RUN pip install --upgrade pip && pip wheel --wheel-dir=/wheels -r requirements.txt


# Этап 2: создаем финальный образ
FROM python:3.11-slim

# Устанавливаем необходимые системные библиотеки
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                libgl1 \
                libglib2.0-0 \
                libsm6 \
                libxext6 \
                libxrender1 \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /hello

# Копируем собранные wheel-пакеты из предыдущего этапа
COPY --from=builder /wheels /wheels

# Копируем файл с зависимостями
COPY requirements.txt .

# Устанавливаем зависимости из wheel-файлов
RUN pip install --no-index --find-links=/wheels -r requirements.txt \
        && rm -rf /wheels

# Копируем исходный код приложения
COPY typersteel.py ./

# Переменные окружения для улучшенной работы Python
ENV PYTHONUNBUFFERED=1 \
        SDL_AUDIODRIVER=dummy

# Определяем точку входа и команду по умолчанию
ENTRYPOINT ["python", "-u"]
CMD ["typersteel.py", "AppSec"]
```
```bash
jvs@debian:~/course_labs/labs/lab05/source$ git add Dockerfile 
jvs@debian:~/course_labs/labs/lab05/source$ git status
Текущая ветка: lab5
Ваша ветка и «origin/lab5» разделились
и теперь имеют 1 и 2 разных коммита в каждой соответственно.
  (use "git pull" if you want to integrate the remote branch with yours)

Изменения, которые будут включены в коммит:
  (используйте «git restore --staged <файл>...», чтобы убрать из индекса)
	изменено:      Dockerfile

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
	pygamesteel.py
	typersteel.py

jvs@debian:~/course_labs/labs/lab05/source$ git commit -m "remake Dockerfile"
[lab5 0faf61f] remake Dockerfile
 1 file changed, 39 insertions(+), 6 deletions(-)
jvs@debian:~/course_labs/labs/lab05/source$ 
```

- [x] 5. Выведите на терминале и проанализируйте следующие команды консоли. Сравните хеш сумму вашего архива с `image.tar` из репозитория, выведите на терминал.

```bash
jvs@debian:~/course_labs/labs/lab05/source$ docker buildx build -t hello-appsec-world .
[+] Building 0.7s (15/15) FINISHED                                                                       docker:default
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 827B                                                                               0.0s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                0.6s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 70B                                                                                   0.0s
 => [builder 1/4] FROM docker.io/library/python:3.11-slim@sha256:1dd3dca85e22886e44fcad1bb7ccab6691dfa83db52214cf  0.0s
 => CACHED [stage-1 2/7] RUN apt-get update         && apt-get install -y --no-install-recommends                  0.0s
 => CACHED [stage-1 3/7] WORKDIR /hello                                                                            0.0s
 => CACHED [builder 2/4] WORKDIR /hello                                                                            0.0s
 => CACHED [builder 3/4] COPY requirements.txt .                                                                   0.0s
 => CACHED [builder 4/4] RUN pip install --upgrade pip && pip wheel --wheel-dir=/wheels -r requirements.txt        0.0s
 => CACHED [stage-1 4/7] COPY --from=builder /wheels /wheels                                                       0.0s
 => CACHED [stage-1 5/7] COPY requirements.txt .                                                                   0.0s
 => CACHED [stage-1 6/7] RUN pip install --no-index --find-links=/wheels -r requirements.txt         && rm -rf /w  0.0s
 => CACHED [stage-1 7/7] COPY typersteel.py ./                                                                     0.0s
 => exporting to image                                                                                             0.0s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:f003c091eda10abe8725bf894313915f81c21ba85c10bfa64a0fa3123c086294                       0.0s
 => => naming to docker.io/library/hello-appsec-world                                                              0.0s
jvs@debian:~/course_labs/labs/lab05/source$ docker run hello-appsec-world
Привет, AppSec!

jvs@debian:~/course_labs/labs/lab05/source$ docker save -o my-hello-appsec.tar hello-appsec-world
jvs@debian:~/course_labs/labs/lab05/source$ docker load -i my-hello-appsec.tar
Loaded image: hello-appsec-world:latest
jvs@debian:~/course_labs/labs/lab05/source$ docker run hello-appsec-world
Привет, AppSec!

jvs@debian:~/course_labs/labs/lab05/source$ docker load -i image.tar
The image hello-appsec-world:latest already exists, renaming the old one with ID sha256:f003c091eda10abe8725bf894313915f81c21ba85c10bfa64a0fa3123c086294 to empty string
Loaded image: hello-appsec-world:latest
jvs@debian:~/course_labs/labs/lab05/source$ docker run hello-appsec-world
hello appsec world

jvs@debian:~/course_labs/labs/lab05/source$ sha256sum image.tar my-hello-appsec.tar
bbd81a06cc580c83d9dfbd1588612601a2ea91e217e4daa21f8a4cbf24f2d8d2  image.tar
d8b3b2f5daa5d03015ea5ea3dbe143e26bfd264ca3359231465b2825b689181e  my-hello-appsec.tar

```

**`docker buildx build -t hellow-appsec-world .`**: Создает образ Docker с именем `hellow-appsec-world` из текущей директории.

**`docker run hello-appsec-world`**: Запускает контейнер из образа `hello-appsec-world`.

**`docker save -o hello_ypur_project.tar hello-appsec-world`**: Сохраняет образ `hello-appsec-world` в файл `hello_ypur_project.tar`.

**`docker load -i hello_ypur_project.tar`**: Загружает образ из файла `hello_ypur_project.tar` в локальный реестр.

**`docker run hello-appsec-world`**: Запускает контейнер из загруженного образа `hello-appsec-world`.

**`docker load -i image.tar`**: Загружает другой образ из файла `image.tar`.

**`docker run hello-appsec-world`**: Запускает контейнер из вновь загруженного образа `hello-appsec-world`.

ХЭШ суммы не совпадают


- [x] 6. Доработайте свой `python` скрипт подключаемыми библиотеками, далее их необходимо разместить в `requirements.txt`. Размещение библиотек в следующем формате:

```
typer==0.20.0
```

- [x] 7. Сделайте `commit`. Повторите сборку приложения по вашему `Dockerfile` для доработанного скрипта `python`. Сохраните `image` в виде .`tar` архива. Сделайте `commit`.

```bash

jvs@debian:~/course_labs/labs/lab05/source$ git status
Текущая ветка: lab5
Ваша ветка и «origin/lab5» разделились
и теперь имеют 2 и 2 разных коммита в каждой соответственно.
  (use "git pull" if you want to integrate the remote branch with yours)

Изменения, которые будут включены в коммит:
  (используйте «git restore --staged <файл>...», чтобы убрать из индекса)
	изменено:      requirements.txt

Изменения, которые не в индексе для коммита:
  (используйте «git add/rm <файл>...», чтобы добавить или удалить файл из индекса)
  (используйте «git restore <файл>...», чтобы отменить изменения в рабочем каталоге)
	удалено:       hello.tar

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
	image.tar
	my-hello-appsec.tar
	pygamesteel.py
	typersteel.py

jvs@debian:~/course_labs/labs/lab05/source$ git commit -m "add requirements"
[lab5 e2de2be] add requirements
 1 file changed, 1 insertion(+)
jvs@debian:~/course_labs/labs/lab05/source$ 

jvs@debian:~/course_labs/labs/lab05/source$ docker save -o my-hello-appsec.tar hello-appsec-world
jvs@debian:~/course_labs/labs/lab05/source$ docker load -i my-hello-appsec.tar
Loaded image: hello-appsec-world:latest
jvs@debian:~/course_labs/labs/lab05/source$ git add my-hello-appsec.tar 
jvs@debian:~/course_labs/labs/lab05/source$ git status
Текущая ветка: lab5
Ваша ветка и «origin/lab5» разделились
и теперь имеют 3 и 2 разных коммитов в каждой соответственно.
  (use "git pull" if you want to integrate the remote branch with yours)

Изменения, которые будут включены в коммит:
  (используйте «git restore --staged <файл>...», чтобы убрать из индекса)
	новый файл:    my-hello-appsec.tar

Изменения, которые не в индексе для коммита:
  (используйте «git add/rm <файл>...», чтобы добавить или удалить файл из индекса)
  (используйте «git restore <файл>...», чтобы отменить изменения в рабочем каталоге)
	удалено:       hello.tar

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
	image.tar
	pygamesteel.py
	typersteel.py

jvs@debian:~/course_labs/labs/lab05/source$ git commit -m "add my-hello-appsec.tar"
[lab5 3384134] add my-hello-appsec.tar
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 labs/lab05/source/my-hello-appsec.tar

```

- [x] 8. Выведите на терминале и проанализируйте следующие команды консоли

```bash

jvs@debian:~/course_labs/labs/lab05/source$ docker login
Log in with your Docker ID or email address to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com/ to create one.
You can log in with your password or a Personal Access Token (PAT). Using a limited-scope PAT grants better security and is required for organizations using SSO. Learn more at https://docs.docker.com/go/access-tokens/

Username: endjvss
Password: 
WARNING! Your password will be stored unencrypted in /home/jvs/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
jvs@debian:~/course_labs/labs/lab05/source$ docker tag hello-appsec-world endjvss/hello-appsec-world
jvs@debian:~/course_labs/labs/lab05/source$ docker push endjvss/hello-appsec-world
Using default tag: latest
The push refers to repository [docker.io/endjvss/hello-appsec-world]
d03d2399ab33: Pushed 
00c2483012f2: Pushed 
afcb555ea284: Pushed 
3a935b6a0fac: Pushed 
2c69f4eea6c2: Pushed 
495a1e576b92: Pushed 
ee59a6a36791: Mounted from library/python 
8282c53409e3: Mounted from library/python 
fba572700288: Mounted from library/python 
48c19c2a881d: Mounted from library/python 
latest: digest: sha256:d061926c181c1f3d9113475692b152418f13c07418b4f2907550c86abc74622e size: 2413
jvs@debian:~/course_labs/labs/lab05/source$ docker inspect endjvss/hello-appsec-world
[
    {
        "Id": "sha256:f418e4b0db929fbd50fd7270be4cceed1b8a5a5e49c0e17fd8d0c4c71f0e6a87",
        "RepoTags": [
            "endjvss/hello-appsec-world:latest",
            "hello-appsec-world:latest"
        ],
        "RepoDigests": [
            "endjvss/hello-appsec-world@sha256:d061926c181c1f3d9113475692b152418f13c07418b4f2907550c86abc74622e"
        ],
        "Parent": "",
        "Comment": "buildkit.dockerfile.v0",
        "Created": "2026-01-11T00:00:20.825038413+03:00",
        "DockerVersion": "",
        "Author": "",
        "Config": {
            "Hostname": "",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "LANG=C.UTF-8",
                "GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D",
                "PYTHON_VERSION=3.11.14",
                "PYTHON_SHA256=8d3ed8ec5c88c1c95f5e558612a725450d2452813ddad5e58fdb1a53b1209b78",
                "PYTHONUNBUFFERED=1",
                "SDL_AUDIODRIVER=dummy"
            ],
            "Cmd": [
                "typersteel.py",
                "AppSec"
            ],
            "ArgsEscaped": true,
            "Image": "",
            "Volumes": null,
            "WorkingDir": "/hello",
            "Entrypoint": [
                "python",
                "-u"
            ],
            "OnBuild": null,
            "Labels": null
        },
        "Architecture": "arm64",
        "Variant": "v8",
        "Os": "linux",
        "Size": 378501969,
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/dg7xzgo49koxl1o11d0oykzwk/diff:/var/lib/docker/overlay2/gzddfzb1jb5b4y1wq27b16yfd/diff:/var/lib/docker/overlay2/oj093xdmkn1r900ouqqkigmuk/diff:/var/lib/docker/overlay2/f8etccwyga7az9weh54yu3tu3/diff:/var/lib/docker/overlay2/dw8ckahux2l2nxogbyltu7a0r/diff:/var/lib/docker/overlay2/46289f3793091098d4bd56a57c098de8aabcaf6951f0b2c1c3aaefdc6a8b2685/diff:/var/lib/docker/overlay2/72d55b97704e65d29f50810c3e1f1c6ce33fa9af1b08b70d0cea4c517ffa2e7f/diff:/var/lib/docker/overlay2/53c8c070a7d493c5e7fed3a70919efb273c0f2f583dc219101bb2b0150c4efc7/diff:/var/lib/docker/overlay2/efb153d3456f02f337e79f601a9ebb5f66100d11632933589e82913309699f67/diff",
                "MergedDir": "/var/lib/docker/overlay2/vz2ifmvcrgdwkwjao7vebajw6/merged",
                "UpperDir": "/var/lib/docker/overlay2/vz2ifmvcrgdwkwjao7vebajw6/diff",
                "WorkDir": "/var/lib/docker/overlay2/vz2ifmvcrgdwkwjao7vebajw6/work"
            },
            "Name": "overlay2"
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:48c19c2a881df039173a8f575853909f657a3d6541023638dca48313c2f124d7",
                "sha256:fba5727002889f1715f71beeb7468660d77674ebc3c7ddf426c0dac7448fa5f6",
                "sha256:8282c53409e3df6d93edfccafdbb61ba457672d9d80fcafdfeff75b81c6a3117",
                "sha256:ee59a6a367916fc15e7f327f1d85fc1d648cf7160eda3e9064989705edb5e8e3",
                "sha256:495a1e576b92188ddfa6468fa876ce36ee342b20191996de061f44e37a3fc4cb",
                "sha256:2c69f4eea6c2c1d5709a520029717e008c2847738a3ac5869e15a50106730df0",
                "sha256:3a935b6a0facfaace760c8f10905447574e54bc231b7bb6322b104c1be621e4c",
                "sha256:afcb555ea2846dc4bba05732c82593f9f21e2f1df517212d205f6db944ebafd0",
                "sha256:00c2483012f2bb597a34e831ecab2dde4584ac7ceddfd4bd3be8f6d1b32bfb16",
                "sha256:d03d2399ab33427bfee7450bc9972cb7ec4b4fffd0a9bc682109193be55bb47f"
            ]
        },
        "Metadata": {
            "LastTagTime": "2026-01-11T00:05:16.288121682+03:00"
        }
    }
]

jvs@debian:~/course_labs/labs/lab05/source$ docker container create --name first hello-appsec-world
e1c785eceb73dee279dc72b657eb27bf5c9f02f870804056277a6bdfe4809fd0

jvs@debian:~/course_labs/labs/lab05/source$ docker image pull geminishkvdev/hello-appsec-world
Using default tag: latest
latest: Pulling from geminishkvdev/hello-appsec-world
b89cf3ec7a3e: Pull complete 
89477b9ce6a6: Pull complete 
158b441f91fd: Pull complete 
44032d6d082a: Pull complete 
73c6786ffe40: Pull complete 
602731d4ffe4: Pull complete 
9673dc38d14b: Pull complete 
460204959e1c: Pull complete 
61170947d8ae: Pull complete 
Digest: sha256:f9db3113962ac3bb47d0123dc8f16b2baa3a27fdef5db67b0d1bd0d6c7bdcdf2
Status: Downloaded newer image for geminishkvdev/hello-appsec-world:latest
docker.io/geminishkvdev/hello-appsec-world:latest
jvs@debian:~/course_labs/labs/lab05/source$ docker inspect geminishkvdev/hello-appsec-world
[
    {
        "Id": "sha256:f386bd63aa82e8393bdd081873b60fa5d8938ffb1b7f53bed6bbbd947358f847",
        "RepoTags": [
            "geminishkvdev/hello-appsec-world:latest"
        ],
        "RepoDigests": [
            "geminishkvdev/hello-appsec-world@sha256:f9db3113962ac3bb47d0123dc8f16b2baa3a27fdef5db67b0d1bd0d6c7bdcdf2"
        ],
        "Parent": "",
        "Comment": "buildkit.dockerfile.v0",
        "Created": "2025-11-21T13:46:41.586622834Z",
        "DockerVersion": "",
        "Author": "",
        "Config": {
            "Hostname": "",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "LANG=C.UTF-8",
                "GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D",
                "PYTHON_VERSION=3.11.14",
                "PYTHON_SHA256=8d3ed8ec5c88c1c95f5e558612a725450d2452813ddad5e58fdb1a53b1209b78",
                "PYTHONUNBUFFERED=1"
            ],
            "Cmd": [
                "python",
                "hello.py"
            ],
            "ArgsEscaped": true,
            "Image": "",
            "Volumes": null,
            "WorkingDir": "/hello",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": null
        },
        "Architecture": "arm64",
        "Os": "linux",
        "Size": 160375439,
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/06a0c0d5f92ab64d0f9b575e39217b4d09d488e5eb39a29f2e98c8370417011f/diff:/var/lib/docker/overlay2/935d1a4b5f2f38808495f277c0a0566abd88b522dcb8d119be2086ce8c9ede7f/diff:/var/lib/docker/overlay2/43c15086503c980e1df9a82a5cf05ad61f597d8c8c5973f67d473ab24419a7ea/diff:/var/lib/docker/overlay2/a5e4de18c0f1538391821f40ca481b161f1e2a77a1c06f11dbb8733e13151521/diff:/var/lib/docker/overlay2/818e901cdac7fe8af167b7e70a80230ffe524700efac360865129067acb1d058/diff:/var/lib/docker/overlay2/b2db9a622a52e42b0f6b807fedeac106abd1754793b487b902c6bfec439c2122/diff:/var/lib/docker/overlay2/eb676dde75ab888007aee1f88ccffd6bc91433a769f611a6eb477241eeb1692e/diff:/var/lib/docker/overlay2/2b5d876a64e4df79be9c984bb78f1722872faaf22d2b4c18783c4b508e946874/diff",
                "MergedDir": "/var/lib/docker/overlay2/c8c7d62d3f187a4d98f756826a13e08a31b78a2f11a802147667c29676514108/merged",
                "UpperDir": "/var/lib/docker/overlay2/c8c7d62d3f187a4d98f756826a13e08a31b78a2f11a802147667c29676514108/diff",
                "WorkDir": "/var/lib/docker/overlay2/c8c7d62d3f187a4d98f756826a13e08a31b78a2f11a802147667c29676514108/work"
            },
            "Name": "overlay2"
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:f1b30ab9918326dc2f4c25f16c0e6c13e9a48427441ea41c0e4d8f3e6699da24",
                "sha256:c240010145420619581e4f7b7e4047e460c8555234e3e4db66f890a68e146f24",
                "sha256:7a4b2171e46dd80cd00f895405c44a867a96ab97e17b4e8c9651cc5e4f419369",
                "sha256:591779db32736fe4b356f6cecc88221a5fa8afa34cbced6e719e54584f63ef59",
                "sha256:efd49302dd30654a15a04a446a25ced6b712e90c6dd4e7791700e6cc57052500",
                "sha256:8fe7432c3de3dffd75d5c59ba9c0ab11f79fbafa983ee88df0ace1aa14d4a194",
                "sha256:e687a26fd0a6b3205299a590d71ae34d679adaaf2b653b0707449ebb676354b9",
                "sha256:71299f61dc2b0b021efdcf665174aae82972a5a8d32bc733c4e2fbc6f7c7a10f",
                "sha256:5b8b2e16a223e538a7cde134a8d2da34674bea14b95915fc1314cd8af5805608"
            ]
        },
        "Metadata": {
            "LastTagTime": "0001-01-01T00:00:00Z"
        }
    }
]
jvs@debian:~/course_labs/labs/lab05/source$ docker container create --name second hello-appsec-world
c0645cbd6ab5b3bef9a5a7344fdeb44b128b89513bffd4aae72d6400ba5502fd

```

**`docker login`**: Аутентифицирует пользователя в Docker Hub, позволяя загружать и получать доступ к образам.

**`docker tag hello-appsec-world yourusername/hello-appsec-world`**: Присваивает образу `hello-appsec-world` новое имя с указанием пользователя, формируя тег для дальнейшей отправки на Docker Hub.

**`docker push yourusername/hello-appsec-world`**: Загружает образ с тегом `yourusername/hello-appsec-world` на Docker Hub.

**`docker inspect yourusername/hello-appsec-world`**: Выводит подробную информацию о загруженном образе `yourusername/hello-appsec-world`, включая метаданные и конфигурацию.

**`docker container create --name first hello-appsec-world`**: Создает контейнер с именем `first` из образа `hello-appsec-world` и возвращает ID контейнера.

**`docker image pull geminishkv/hello-appsec-world`**: Загружает образ `geminishkv/hello-appsec-world` из Docker Hub в локальный реестр.

**`docker inspect geminishkvdev/hello-appsec-world`**: Выводит информацию о загруженном образе `geminishkvdev/hello-appsec-world`.

**`docker container create --name second hello-appsec-world`**: Создает второй контейнер с именем `second` из образа `hello-appsec-world`.

- [x] 9. Выведите на терминале и проанализируйте в консоли процессы, которые запущены, владельцев по пользователям

```bash 
jvs@debian:~/course_labs/labs/lab05/source$ docker container run -it ubuntu /bin/bash
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
97dd3f0ce510: Pull complete 
Digest: sha256:c35e29c9450151419d9448b0fd75374fec4fff364a27f176fb458d472dfc9e54
Status: Downloaded newer image for ubuntu:latest
root@45991b56e10c:/# whoami
root
root@45991b56e10c:/# id
uid=0(root) gid=0(root) groups=0(root)
root@45991b56e10c:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.1   4300  3636 pts/0    Ss   21:13   0:00 /bin/bash
root          12  100  0.1   7632  3656 pts/0    R+   21:15   0:00 ps aux
root@45991b56e10c:/# 

``` 

Запуск команды **`docker container run -it ubuntu /bin/bash`** создает интерактивный контейнер на базе образа Ubuntu, предоставляя доступ к оболочке bash.

Команда **`whoami`** позволяет узнать, кто является текущим пользователем внутри контейнера, который будет root.

Использование команды **`id`** выводит информацию о пользователе, подтверждая, что он имеет UID и GID 0, что соответствует пользователю root.

Команда **`ps aux`** отображает все запущенные процессы в контейнере, показывая, что в данный момент работает только процесс bash и сама команда **`ps aux`**.
 
- [x] 10. Выведите оба контейнера first и second на терминал

```bash
jvs@debian:~/course_labs/labs/lab05/source$ docker ps -a --filter "name=^/first$"
CONTAINER ID   IMAGE                COMMAND                  CREATED          STATUS    PORTS     NAMES
e1c785eceb73   hello-appsec-world   "python -u typerstee…"   42 seconds ago   Created             first
jvs@debian:~/course_labs/labs/lab05/source$ docker ps -a --filter "name=^/second$"
CONTAINER ID   IMAGE                COMMAND                  CREATED         STATUS    PORTS     NAMES
c0645cbd6ab5   hello-appsec-world   "python -u typerstee…"   5 minutes ago   Created             second
```

- [x] 11. Перейдите в основной корень `lab05` и выведите на терминале, и проанализируйте

```bash 
jvs@debian:~/course_labs/labs/lab05$ docker-compose up --build
WARN[0000] /home/jvs/course_labs/labs/lab05/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Building 17.9s (24/24) FINISHED                                                                                                            docker:default
 => [server internal] load build definition from Dockerfile                                                                                              0.0s
 => => transferring dockerfile: 431B                                                                                                                     0.0s
 => [client internal] load metadata for docker.io/library/python:3.11-slim                                                                               1.7s
 => [server auth] library/python:pull token for registry-1.docker.io                                                                                     0.0s
 => [server internal] load .dockerignore                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                          0.0s
 => [server internal] load build context                                                                                                                 0.0s
 => => transferring context: 859B                                                                                                                        0.0s
 => [client builder 1/4] FROM docker.io/library/python:3.11-slim@sha256:1dd3dca85e22886e44fcad1bb7ccab6691dfa83db52214cf9e20696e095f3e36                 0.0s
 => CACHED [client builder 2/4] WORKDIR /app                                                                                                             0.0s
 => [server builder 3/4] COPY requirements.txt .                                                                                                         0.0s
 => [server builder 4/4] RUN pip install --upgrade pip && pip wheel --wheel-dir=/wheels -r requirements.txt                                              5.2s
 => [server stage-1 3/6] COPY --from=builder /wheels /wheels                                                                                             0.0s 
 => [server stage-1 4/6] COPY requirements.txt .                                                                                                         0.0s 
 => [server stage-1 5/6] RUN pip install --no-index --find-links=/wheels -r requirements.txt                                                             1.5s 
 => [server stage-1 6/6] COPY app.py .                                                                                                                   0.0s 
 => [server] exporting to image                                                                                                                          0.1s 
 => => exporting layers                                                                                                                                  0.1s 
 => => writing image sha256:d2eb9470c6b7ab3c8351375f5b5593e9a6caff7b864af727b9f190ec84683b0c                                                             0.0s 
 => => naming to docker.io/library/lab05-server                                                                                                          0.0s 
 => [client internal] load build definition from Dockerfile                                                                                              0.0s 
 => => transferring dockerfile: 437B                                                                                                                     0.0s
 => [client internal] load .dockerignore                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                          0.0s
 => [client internal] load build context                                                                                                                 0.0s
 => => transferring context: 581B                                                                                                                        0.0s
 => [client builder 3/4] COPY requirements.txt .                                                                                                         2.6s
 => [client builder 4/4] RUN pip install --upgrade pip && pip wheel --wheel-dir=/wheels -r requirements.txt                                              4.7s
 => [client stage-1 3/6] COPY --from=builder /wheels /wheels                                                                                             0.0s 
 => [client stage-1 4/6] COPY requirements.txt .                                                                                                         0.0s 
 => [client stage-1 5/6] RUN pip install --no-index --find-links=/wheels -r requirements.txt                                                             1.4s 
 => [client stage-1 6/6] COPY client.py .                                                                                                                0.0s 
 => [client] exporting to image                                                                                                                          0.1s 
 => => exporting layers                                                                                                                                  0.1s 
 => => writing image sha256:dc05ccd0561b83572608badd85a0df64071f3cb7dfd973573524076ec47d2e74                                                             0.0s 
 => => naming to docker.io/library/lab05-client                                                                                                          0.0s 
[+] Running 1/2                                                                                                                                               
 ✔ Network lab05_app_net     Created                                                                                                                     0.1s 
 ⠋ Container lab05-server-1  Created                                                                                                                     0.0s 
 ⠋ Container lab05-client-1  Created                                                                                                                     0.0s 
Attaching to client-1, server-1
server-1  |  * Serving Flask app 'app'
server-1  |  * Debug mode: off
server-1  | WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
server-1  |  * Running on all addresses (0.0.0.0)
server-1  |  * Running on http://127.0.0.1:8000
server-1  |  * Running on http://172.19.0.2:8000
server-1  | Press CTRL+C to quit
server-1  | 172.19.0.3 - - [10/Jan/2026 21:19:44] "GET / HTTP/1.1" 200 -
client-1  | 
client-1  |     <html>
client-1  |     <head><title>Colorful Output</title></head>
client-1  |     <body style="font-family: monospace; font-size: 24px;">
client-1  |     <span style="color:red">h</span><span style="color:green">e</span><span style="color:yellow">l</span><span style="color:blue">l</span><span style="color:purple">o</span><span style="color:red"> </span><span style="color:green">a</span><span style="color:yellow">p</span><span style="color:blue">p</span><span style="color:purple">s</span><span style="color:red">e</span><span style="color:green">c</span><span style="color:yellow"> </span><span style="color:blue">w</span><span style="color:purple">o</span><span style="color:red">r</span><span style="color:green">l</span><span style="color:yellow">d</span>
client-1  |     </body>
client-1  |     </html>
client-1  |     
client-1 exited with code 0

```

Команда **`docker-compose up --build`** предназначена для сборки и запуска многоконтейнерного приложения, указанного в файле `docker-compose.yml`. При выполнении этой команды происходят следующие действия:

- Сборка Docker-образов для сервисов "server" и "client" на основе соответствующих Dockerfile.
- Создание сети с именем "lab05_app_net" для обеспечения взаимодействия между контейнерами.
- Создание и запуск контейнеров "lab05-server-1" и "lab05-client-1".
- Вывод логов работы контейнеров, включая информацию о запуске Flask-сервера и обработке HTTP-запросов.

- [x] 12. Откройте соседнее окно терминала и и выведите на терминале

```bash 
$ open -a "Google Chrome" http://localhost:8000
```

<img width="602" height="209" alt="Снимок экрана 2026-01-11 в 00 26 07" src="https://github.com/user-attachments/assets/c95aeeda-5988-4941-9a47-c9ac80c966ae" />


- [x] 13. Остановите работу `docker-compose`.

```bash 
jvs@debian:~/course_labs/labs/lab05$ docker ps -a
CONTAINER ID   IMAGE                 COMMAND                  CREATED                  STATUS                           PORTS                                       NAMES
17a8ce9faa98   registry:2            "/entrypoint.sh /etc…"   Less than a second ago   Up Less than a second            5000/tcp                                    registry.1.ews08vw6ha2qxwwe0vstcxodo
20e84e92f296   lab05-client          "python client.py"       7 minutes ago            Exited (0) 5 minutes ago                                                     lab05-client-1
4437b4e4c4ee   lab05-server          "python app.py"          7 minutes ago            Up 7 minutes                     0.0.0.0:8000->8000/tcp, :::8000->8000/tcp   lab05-server-1
e1c785eceb73   hello-appsec-world    "python -u typerstee…"   9 minutes ago            Created                                                                      first
45991b56e10c   ubuntu                "/bin/bash"              13 minutes ago           Exited (0) 11 minutes ago                                                    heuristic_zhukovsky
c0645cbd6ab5   hello-appsec-world    "python -u typerstee…"   14 minutes ago           Created                                                                      second
c968db171c1f   6b1ea1fa416c          "python hello.py"        48 minutes ago           Exited (0) 48 minutes ago                                                    flamboyant_wiles
86f5488aebfc   f003c091eda1          "python -u typerstee…"   49 minutes ago           Exited (0) 49 minutes ago                                                    frosty_vaughan
b1a92e92637e   f003c091eda1          "python -u typerstee…"   57 minutes ago           Exited (0) 57 minutes ago                                                    sweet_brahmagupta
79967caacc02   7a009fcdd714          "python -u typerstee…"   59 minutes ago           Exited (2) 59 minutes ago                                                    admiring_hertz
4915f2b0cb3b   b97e3c9b088d          "python -u pygameste…"   About an hour ago        Exited (130) About an hour ago                                               admiring_heyrovsky
1d2afd5948ab   b97e3c9b088d          "python -u pygameste…"   About an hour ago        Exited (130) About an hour ago                                               infallible_jang
93b7f97f04df   b97e3c9b088d          "python -u pygameste…"   About an hour ago        Exited (130) About an hour ago                                               focused_kare
89c9021ad33d   b97e3c9b088d          "python -u pygameste…"   About an hour ago        Exited (130) About an hour ago                                               heuristic_driscoll
ca77f9e3beab   41fa34f50cd4          "python -u pygameste…"   About an hour ago        Exited (1) About an hour ago                                                 objective_euler
2a3cc1018222   f558efd2b685          "python -u hello.py …"   About an hour ago        Exited (0) About an hour ago                                                 musing_khorana
c351aa59dbb2   6b1ea1fa416c          "python hello.py"        2 hours ago              Exited (0) 2 hours ago                                                       great_pasteur
217ee1f84d35   6b1ea1fa416c          "python hello.py"        2 hours ago              Exited (0) 2 hours ago                                                       kind_kare
a1c085894576   registry:2            "/entrypoint.sh /etc…"   2 weeks ago              Exited (2) 2 weeks ago                                                       registry.1.wpe5fkxzaa9gia8hvh1038ixp
41b3b378878d   registry:2            "/entrypoint.sh /etc…"   2 weeks ago              Exited (2) 2 weeks ago                                                       registry.1.xfogivs2hfhsvpm7axv95575t
733a795e1741   hellow-appsec-world   "python hello.py"        2 weeks ago              Exited (0) 2 weeks ago                                                       dazzling_cray
f9ddbf2b76a0   hellow-appsec-world   "python hello.py"        2 weeks ago              Exited (0) 2 weeks ago                                                       clever_shtern
d5b4fb201bf0   registry:2            "/entrypoint.sh /etc…"   2 weeks ago              Exited (2) 2 weeks ago                                                       registry.1.vbo9rxct2eo8sggi24g7s5o00
jvs@debian:~/course_labs/labs/lab05$ docker ps -q
17a8ce9faa98
4437b4e4c4ee
jvs@debian:~/course_labs/labs/lab05$ docker images
REPOSITORY                         TAG       IMAGE ID       CREATED             SIZE
lab05-client                       latest    dc05ccd0561b   8 minutes ago       163MB
lab05-server                       latest    d2eb9470c6b7   8 minutes ago       166MB
endjvss/hello-appsec-world         latest    f418e4b0db92   27 minutes ago      379MB
hello-appsec-world                 latest    f418e4b0db92   27 minutes ago      379MB
<none>                             <none>    7a009fcdd714   59 minutes ago      437MB
<none>                             <none>    f003c091eda1   59 minutes ago      437MB
<none>                             <none>    b97e3c9b088d   About an hour ago   437MB
<none>                             <none>    41fa34f50cd4   About an hour ago   364MB
<none>                             <none>    f558efd2b685   About an hour ago   364MB
<none>                             <none>    6b1ea1fa416c   2 hours ago         160MB
hellow-appsec-world                latest    119762be3272   2 weeks ago         160MB
geminishkvdev/hello-appsec-world   latest    f386bd63aa82   7 weeks ago         160MB
ubuntu                             latest    9a84ec2d5dd7   2 months ago        101MB
registry                           <none>    33eeff39e0aa   2 years ago         25MB
jvs@debian:~/course_labs/labs/lab05$ docker ps -q | xargs docker stop
17a8ce9faa98
4437b4e4c4ee
jvs@debian:~/course_labs/labs/lab05$ docker-compose down
WARN[0000] /home/jvs/course_labs/labs/lab05/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 3/3
 ✔ Container lab05-client-1  Removed                                                                                                                     0.0s 
 ✔ Container lab05-server-1  Removed                                                                                                                     0.0s 
 ✔ Network lab05_app_net     Removed                                                                                                                     0.2s
```
- [x] 14. Доработайте `docker-compose` и скрипт, который вы подготовили ранее, что бы вы смогли воспроизвести шаги п.11 по п.13 с демонстрацией. Сделайте `commit`.

<img width="707" height="392" alt="Снимок экрана 2026-01-11 в 01 03 03" src="https://github.com/user-attachments/assets/480dd069-5b52-440e-b9a8-66f4a3baf500" />


```bash
jvs@debian:~/course_labs/labs/lab05$ git commit -S -m "Доработал docker-compose и скрипт"
```

- [x] 15. Залейте изменения в свой удаленный репозиторий, проверьте историю `commit`.

```bash
jvs@debian:~/course_labs$ git push -u origin lab5
Перечисление объектов: 730, готово.
Подсчет объектов: 100% (730/730), готово.
При сжатии изменений используется до 2 потоков
Сжатие объектов: 100% (326/326), готово.
Запись объектов: 100% (730/730), 8.80 МиБ | 183.81 МиБ/с, готово.
Total 730 (delta 334), reused 724 (delta 329), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (334/334), done.
To https://github.com/Drenajnayavoda/course_labs.git
 + 8667485...2e55c5f lab5 -> lab5
branch 'lab5' set up to track 'origin/lab5'.

jvs@debian:~/course_labs$ git log
commit 81667472efd9b0fafc1dbdaf82aca0fe53d9c01f (HEAD -> lab5, origin/lab5)
Author: Drenajnayavoda <gadflyx307@gmail.com>
Date:   Tue Jan 13 19:14:51 2026 +0300

    Доработал docker-compose и скрипт

commit b47e83bc6d547ee89b9e692aaad84a15739035c8
Author: Drenajnayavoda <gadflyx307@gmail.com>
Date:   Tue Jan 13 19:07:29 2026 +0300

    add requirements

commit 6715dfc5a50ad16b588bd8151bc44db498aea8c7
Author: Drenajnayavoda <gadflyx307@gmail.com>
Date:   Tue Jan 13 19:04:43 2026 +0300

    remake Dockerfile

commit d00da28424b1495d28fa0c4f4bc13fac5240f58f
Author: Drenajnayavoda <gadflyx307@gmail.com>
Date:   Tue Jan 13 19:00:39 2026 +0300

    analyze Dockerfile

commit c84c6569e4e590e17539fd52422433cd76e346e5
Author: Drenajnayavoda <gadflyx307@gmail.com>
Date:   Tue Jan 13 18:58:20 2026 +0300

    add report
```


- [x] 16. Подготовьте отчет `gist`.

https://gist.github.com/Drenajnayavoda/c92039317f4c1511ec1adfc01151dc5e
 
***

Copyright (c) 2025 Ivan A Lastochkin


