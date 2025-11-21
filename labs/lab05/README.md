<div align="center">
<h1><a id="intro">Лабораторная работа №5</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Шмаков_И._С.-8b9aff" alt="Contributor Badge"></a></div>

***

<br>Салют :wave:, </br>
Данная лабораторная работа посвещена изучению Docker и как с ним работать. Эта лабораторная работа послужит подпоркой для старта в выявлении и определении уязвимостей на уровне сканирования контейнеров при сборке приложений. 

Для сдачи данной работы также будет требоваться ответить на дополнительыне вопросы по описанным темам.

***

## Материал

- **Контейнеризация**

Сборка приложения включает создание контейнерного образа, в котором упаковано приложение с конфигурациями, что бы приложение функционировало. Docker основан на использовании общих функций ядра ОС Linux (cgroups, namespace) для изоляции и управления ресурсами.

> **Образ** — это статический, неизменяемый шаблон, на базе которого создаются контейнера с ОС, приложением, зависимостями, библиотекакм и конфигурационными файлами. Нужен для создания воспроизводимой, неизменяемой среды выполнения приложений в контейнерах.

Для сборки образов используется `Dockerfile`, где прописаны версии зависимостей и инструкции, минимизирующие разрешения и атаки. Это инструкции, где описывается, как собрать образ. Впоследствии собирается контейнер.

> **Контейнер** — это изолированная среда выполнения приложения с необходимыми зависимостями, кодом, системными утилитами, библиотеками и настройками. Исползует не собственну гостеву ОС, а ядро хостовой ОС и имеет своё собственное файловое пространство, процессы и сеть.

После сборки образа формируется контейнер, которые являются изолированными средами выполнения для достижения цели переносимости, воспроизведения.

> **Контейнеризация** — это технология, позволяющая упаковать приложение вместе со всеми его зависимостями, библиотеками, настройками и средой выполнения в единый изолированный виртуальный контейнер. 

- **Команды**



-  **Контекст Безопасности**

1.Уязвимости в образах — образ может содержать устаревшие или уязвимые версии библиотек и программного обеспечения, которые открывают двери для атак, включая удалённое выполнение кода, обход аутентификации и пр.
	1. Поддельные и злонамеренные образы — если образы берутся из ненадёжных источников, существует риск попасть на заражённые или преднамеренно модифицированные образы с бекдорами или вредоносным ПО.
	2. Отсутствие подписей и проверки целостности — неподписанные образы сложно проверить на целостность, что повышает риск использования скомпрометированной версии.
	3. Ошибка конфигурации и избыток прав — образы с избыточными правами доступа, запуском от root или с небезопасными настройками способствуют расширению атаки в случае компрометации.
	4. Присутствие секретов и конфиденциальных данных в образах — иногда в образах могут случайно оказаться токены, пароли или ключи, что приводит к утечке при распространении.
	5. Отсутствие регулярного обновления — неподдерживаемые образы быстро устаревают, появляются новые уязвимости, а отсутствие своевременного обновления повышает риск эксплуатации.
	6. образы Представляют потенциальные вектора атак, если в них содержатся устаревшие или уязвимые компоненты CVE (Common Vulnerabilities and Exposures)

- **Дополнительно**

В случае, если возникает проблема с вызовом `docker buildx`, следует использовать вот [это](https://gist.github.com/Aeonitis/cbd9f8b61eaec5a8a024c0a42f415ca3) описание из gistup для фикса `samelink`.

***


```dockerfile
FROM python:3.11-slim AS builder # Этап 1: сборка зависимостей
WORKDIR /hello
COPY requirements.txt . # Копируем файл с зависимостями
RUN pip install --upgrade pip && pip wheel --wheel-dir=/wheels -r requirements.txt # Устанавливаем зависимости в отдельную директорию wheelhouse для кеширования

FROM python:3.11-slim # Этап 2: запускаемый образ
WORKDIR /hello
COPY --from=builder /wheels /wheels # Копируем собранные wheel-пакеты
COPY requirements.txt . # Копируем файл с зависимостями
RUN pip install --no-index --find-links=/wheels -r requirements.txt # Устанавливаем зависимости из wheel-пакетов
COPY hello.py . # Копируем исходный код приложения

ENV PYTHONUNBUFFERED=1 # Переменные окружения для улучшенной работы Python
CMD ["python", "hello.py"] # Запускаем приложение
```


## Задание

- [ ] 1. Перейдите в `source` Выведите на терминале и проанализируйте следующие команды консоли


## Tutorial
Преднастройка переменных окружения
```ShellSession
$ export GITHUB_USERNAME=geminishkv
```
Преднастройка удаленного репозитория GitHub
```ShellSession
$ git clone https://github.com/${GITHUB_USERNAME}/lab12 lab13
$ cd lab13
$ git remote remove origin
$ git remote add origin https://github.com/${GITHUB_USERNAME}/lab13
```
Настройка конфигурационного файла docker - образа для построения
```ShellSession
$ cat > Dockerfile <<EOF
FROM ubuntu:16.04 # Образ из ubuntu:16.04
EOF
```
Обновление менеджера пакетов и установка g++
```ShellSession
$ cat >> Dockerfile <<EOF

RUN apt update # обновление пакетов
RUN apt install -yy gcc g++ cmake # установка пакетов g++
EOF
```
Перенос в print для выполнения в образе
```ShellSession
$ cat >> Dockerfile <<EOF

COPY . print/ # копирование файлов в директорию print
WORKDIR print # предопределение каталога для исполнения команд
EOF
```
Сборка проектной части в образе
```ShellSession
$ cat >> Dockerfile <<EOF
# предопределение исполнения команд в образе
RUN cmake -H. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=_install
RUN cmake --build _build
RUN cmake --build _build --target install
EOF
```
Предопределение LOG_PATH - пути сохранения файлов логирования
```ShellSession
$ cat >> Dockerfile <<EOF

ENV LOG_PATH /home/logs/log.txt
EOF
```
Монтирование каталога внутри контейнера
```ShellSession
$ cat >> Dockerfile <<EOF

VOLUME /home/logs
EOF
```
Смена каталога с исполняемым файлом
```ShellSession
$ cat >> Dockerfile <<EOF

WORKDIR _install/bin
EOF
```
Исполнение бинарного файла
```ShellSession
$ cat >> Dockerfile <<EOF

CMD ./demo
EOF
```
Построение образа проектной части в каталоге с использованием Dockerfile
```ShellSession
$ docker build -t logger . # -t -- задание названия 
Sending build context to Docker daemon 122.4 kB
Step 1/12 : FROM ubuntu:16.04
 ---> f975c5035748
Step 2/12 : RUN apt update
 ---> Using cache
 ---> 53f29f1e394d
Step 3/12 : RUN apt install -yy gcc g++ cmake
 ---> Using cache
 ---> 3331ca46af87
Step 4/12 : COPY . print/
 ---> a16ab781bdfb
Removing intermediate container 3ac9fa87f6b5
Step 5/12 : WORKDIR print
 ---> 8a32419ee634
Removing intermediate container 7805ee8f24c9
Step 6/12 : RUN cmake -H. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=_install
 ---> Running in f8c946ccbb50
-- [hunter] Initializing Hunter workspace (116a39be623b7cf2e85a3d229babcec07506406a)
-- [hunter]   https://github.com/geminishkv/hunter/archive/v0.19.137.1.tar.gz
-- [hunter]   -> /root/.hunter/_Base/Download/Hunter/0.19.137/116a39b
-- The C compiler identification is GNU 5.4.0
-- The CXX compiler identification is GNU 5.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- [hunter] Calculating Toolchain-SHA1
-- [hunter] Calculating Config-SHA1
-- [hunter] HUNTER_ROOT: /root/.hunter
-- [hunter] [ Hunter-ID: 116a39b | Toolchain-ID: e1266bb | Config-ID: 83da1ac ]
-- [hunter] PRINT_ROOT: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Install (ver.: 0.1.0.0)
-- [hunter] Building print
loading initial cache file /root/.hunter/_Base/116a39b/e1266bb/83da1ac/cache.cmake
loading initial cache file /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/args.cmake
-- The C compiler identification is GNU 5.4.0
-- The CXX compiler identification is GNU 5.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Build
Scanning dependencies of target print-Release
[  6%] Creating directories for 'print-Release'
[ 12%] Performing download step (download, verify and extract) for 'print-Release'
-- downloading...
     src='https://github.com/geminishkv/lab09/archive/v0.1.0.0.tar.gz'
     dst='/root/.hunter/_Base/Download/print/0.1.0.0/f6b8ff0/v0.1.0.0.tar.gz'
     timeout='none'
-- [download 0% complete]
-- [download 1% complete]
-- [download 2% complete]
-- [download 3% complete]
-- [download 4% complete]
-- [download 5% complete]
-- [download 6% complete]
-- [download 7% complete]
-- [download 8% complete]
-- [download 9% complete]
-- [download 10% complete]
-- [download 11% complete]
-- [download 12% complete]
-- [download 13% complete]
-- [download 14% complete]
-- [download 15% complete]
-- [download 16% complete]
-- [download 17% complete]
-- [download 18% complete]
-- [download 19% complete]
-- [download 20% complete]
-- [download 21% complete]
-- [download 22% complete]
-- [download 23% complete]
-- [download 24% complete]
-- [download 25% complete]
-- [download 26% complete]
-- [download 27% complete]
-- [download 28% complete]
-- [download 29% complete]
-- [download 30% complete]
-- [download 31% complete]
-- [download 32% complete]
-- [download 33% complete]
-- [download 34% complete]
-- [download 35% complete]
-- [download 36% complete]
-- [download 37% complete]
-- [download 38% complete]
-- [download 39% complete]
-- [download 40% complete]
-- [download 41% complete]
-- [download 42% complete]
-- [download 43% complete]
-- [download 44% complete]
-- [download 45% complete]
-- [download 46% complete]
-- [download 47% complete]
-- [download 48% complete]
-- [download 49% complete]
-- [download 50% complete]
-- [download 51% complete]
-- [download 52% complete]
-- [download 53% complete]
-- [download 54% complete]
-- [download 55% complete]
-- [download 56% complete]
-- [download 57% complete]
-- [download 58% complete]
-- [download 59% complete]
-- [download 60% complete]
-- [download 61% complete]
-- [download 62% complete]
-- [download 63% complete]
-- [download 64% complete]
-- [download 65% complete]
-- [download 66% complete]
-- [download 67% complete]
-- [download 68% complete]
-- [download 69% complete]
-- [download 70% complete]
-- [download 71% complete]
-- [download 72% complete]
-- [download 73% complete]
-- [download 74% complete]
-- [download 75% complete]
-- [download 76% complete]
-- [download 77% complete]
-- [download 78% complete]
-- [download 79% complete]
-- [download 80% complete]
-- [download 81% complete]
-- [download 82% complete]
-- [download 83% complete]
-- [download 84% complete]
-- [download 85% complete]
-- [download 86% complete]
-- [download 87% complete]
-- [download 88% complete]
-- [download 89% complete]
-- [download 90% complete]
-- [download 91% complete]
-- [download 92% complete]
-- [download 93% complete]
-- [download 94% complete]
-- [download 95% complete]
-- [download 96% complete]
-- [download 97% complete]
-- [download 98% complete]
-- [download 99% complete]
-- [download 100% complete]
-- downloading... done
-- verifying file...
     file='/root/.hunter/_Base/Download/print/0.1.0.0/f6b8ff0/v0.1.0.0.tar.gz'
-- verifying file... done
-- extracting...
     src='/root/.hunter/_Base/Download/print/0.1.0.0/f6b8ff0/v0.1.0.0.tar.gz'
     dst='/root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Source'
-- extracting... [tar xfz]
-- extracting... [analysis]
-- extracting... [rename]
-- extracting... [clean up]
-- extracting... done
[ 18%] No patch step for 'print-Release'
[ 25%] No update step for 'print-Release'
[ 31%] Performing configure step for 'print-Release'
loading initial cache file /root/.hunter/_Base/116a39b/e1266bb/83da1ac/cache.cmake
loading initial cache file /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/args.cmake
-- The C compiler identification is GNU 5.4.0
-- The CXX compiler identification is GNU 5.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compile features
-- Detecting CXX compile features - done
CMake Warning at /usr/share/cmake-3.5/Modules/CPack.cmake:293 (message):
  CPack.cmake has already been included!!
Call Stack (most recent call first):
  CPackConfig.cmake:26 (include)
  CMakeLists.txt:63 (include)
-- Configuring done
-- Generating done
-- Build files have been written to: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Build/print-Release-prefix/src/print-Release-build
[ 37%] Performing build step for 'print-Release'
Scanning dependencies of target print
[ 50%] Building CXX object CMakeFiles/print.dir/sources/print.cpp.o
[100%] Linking CXX static library libprint.a
[100%] Built target print
[ 43%] Performing install step for 'print-Release'
[100%] Built target print
Install the project...
-- Install configuration: "Release"
-- Installing: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/lib/libprint.a
-- Installing: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/include
-- Installing: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/include/print.hpp
-- Installing: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/cmake/print-config.cmake
-- Installing: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/cmake/print-config-release.cmake
loading initial cache file /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/args.cmake
[ 50%] Completed 'print-Release'
[ 50%] Built target print-Release
Scanning dependencies of target print-Debug
[ 56%] Creating directories for 'print-Debug'
[ 62%] Performing download step (download, verify and extract) for 'print-Debug'
-- verifying file...
     file='/root/.hunter/_Base/Download/print/0.1.0.0/f6b8ff0/v0.1.0.0.tar.gz'
-- verifying file... done
-- extracting...
     src='/root/.hunter/_Base/Download/print/0.1.0.0/f6b8ff0/v0.1.0.0.tar.gz'
     dst='/root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Source'
-- extracting... [tar xfz]
-- extracting... [analysis]
-- extracting... [rename]
-- extracting... [clean up]
-- extracting... done
[ 68%] No patch step for 'print-Debug'
[ 75%] No update step for 'print-Debug'
[ 81%] Performing configure step for 'print-Debug'
loading initial cache file /root/.hunter/_Base/116a39b/e1266bb/83da1ac/cache.cmake
loading initial cache file /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/args.cmake
-- The C compiler identification is GNU 5.4.0
-- The CXX compiler identification is GNU 5.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compile features
-- Detecting CXX compile features - done
CMake Warning at /usr/share/cmake-3.5/Modules/CPack.cmake:293 (message):
  CPack.cmake has already been included!!
Call Stack (most recent call first):
  CPackConfig.cmake:26 (include)
  CMakeLists.txt:63 (include)
-- Configuring done
-- Generating done
-- Build files have been written to: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Build/print-Debug-prefix/src/print-Debug-build
[ 87%] Performing build step for 'print-Debug'
Scanning dependencies of target print
[ 50%] Building CXX object CMakeFiles/print.dir/sources/print.cpp.o
[100%] Linking CXX static library libprintd.a
[100%] Built target print
[ 93%] Performing install step for 'print-Debug'
[100%] Built target print
Install the project...
-- Install configuration: "Debug"
-- Installing: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/lib/libprintd.a
-- Up-to-date: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/include
-- Up-to-date: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/include/print.hpp
-- Installing: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/cmake/print-config.cmake
-- Installing: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/Install/cmake/print-config-debug.cmake
loading initial cache file /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print/args.cmake
[100%] Completed 'print-Debug'
[100%] Built target print-Debug
-- [hunter] Build step successful (dir: /root/.hunter/_Base/116a39b/e1266bb/83da1ac/Build/print)
-- [hunter] Cache saved: /root/.hunter/_Base/Cache/raw/2f0c796a434ecea76f894c0fdc9d98c2ae79beac.tar.bz2
-- Configuring done
-- Generating done
-- Build files have been written to: /print/_build
 ---> 7c195990db51
Removing intermediate container f8c946ccbb50
Step 7/12 : RUN cmake --build _build
 ---> Running in dd47401d27b0
Scanning dependencies of target demo
[ 50%] Building CXX object CMakeFiles/demo.dir/sources/demo.cpp.o
[100%] Linking CXX executable demo
[100%] Built target demo
 ---> d06094aca8fc
Removing intermediate container dd47401d27b0
Step 8/12 : RUN cmake --build _build --target install
 ---> Running in 6e11b08c2282
[100%] Built target demo
Install the project...
-- Install configuration: "Release"
-- Installing: /print/_install/bin/demo
 ---> ae15fee6dfb2
Removing intermediate container 6e11b08c2282
Step 9/12 : ENV LOG_PATH /home/logs/log.txt
 ---> Running in 5bbd9fe4a85a
 ---> a2f5161c68fa
Removing intermediate container 5bbd9fe4a85a
Step 10/12 : VOLUME /home/logs
 ---> Running in 9aa1822e22be
 ---> 626946c2f18b
Removing intermediate container 9aa1822e22be
Step 11/12 : WORKDIR _install/bin
 ---> e83e72384dce
Removing intermediate container a8bdcac5f742
Step 12/12 : CMD ./demo
 ---> Running in 8600fc961e07
 ---> 463be0bee42f
Removing intermediate container 8600fc961e07
Successfully built 463be0bee42f
Successfully tagged logger:latest
```
Вывод на интерпретатор установленного списка образов
```ShellSession
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
logger              latest              463be0bee42f        About a minute ago   449 MB
<none>              <none>              f52e6b4ab792        12 minutes ago       449 MB
ubuntu              16.04               f975c5035748        4 weeks ago          112 MB

```
Итерация исполнения контейнера
```ShellSession
$ mkdir logs
$ docker run -it -v "$(pwd)/logs/:/home/logs/" logger
#-v -- монтирование каталога в контейнер
text1
text2
text3
<C-D>
```
Вывод на интерпретатор информации об образе
```ShellSession
$ docker inspect logger
[
    {
        "Id": "sha256:463be0bee42fff8689849b1ae8b5874762b339ac3fe5b4e67eae1c15e91d452b",
        "RepoTags": [
            "logger:latest"
        ],
        "RepoDigests": [],
        "Parent": "sha256:e83e72384dce01ff3f6aa418d62e33b945b605e518d163773b032a3e7c28b3f7",
        "Comment": "",
        "Created": "2018-04-04T12:17:20.802455891Z",
        "Container": "8600fc961e078764b3e66549c4048128aa6d96dfd56b7470bb57d3b2bf113239",
        "ContainerConfig": {
            "Hostname": "3ac9fa87f6b5",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "LOG_PATH=/home/logs/log.txt"
            ],
            "Cmd": [
                "/bin/sh",
                "-c",
                "#(nop) ",
                "CMD [\"/bin/sh\" \"-c\" \"./demo\"]"
            ],
            "ArgsEscaped": true,
            "Image": "sha256:e83e72384dce01ff3f6aa418d62e33b945b605e518d163773b032a3e7c28b3f7",
            "Volumes": {
                "/home/logs": {}
            },
            "WorkingDir": "/print/_install/bin",
            "Entrypoint": null,
            "OnBuild": [],
            "Labels": {}
        },
        "DockerVersion": "1.13.1",
        "Author": "",
        "Config": {
            "Hostname": "3ac9fa87f6b5",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "LOG_PATH=/home/logs/log.txt"
            ],
            "Cmd": [
                "/bin/sh",
                "-c",
                "./demo"
            ],
            "ArgsEscaped": true,
            "Image": "sha256:e83e72384dce01ff3f6aa418d62e33b945b605e518d163773b032a3e7c28b3f7",
            "Volumes": {
                "/home/logs": {}
            },
            "WorkingDir": "/print/_install/bin",
            "Entrypoint": null,
            "OnBuild": [],
            "Labels": {}
        },
        "Architecture": "amd64",
        "Os": "linux",
        "Size": 449166290,
        "VirtualSize": 449166290,
        "GraphDriver": {
            "Name": "aufs",
            "Data": null
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:a94e0d5a7c404d0e6fa15d8cd4010e69663bd8813b5117fbad71365a73656df9",
                "sha256:88888b9b1b5b7bce5db41267e669e6da63ee95736cb904485f96f29be648bfda",
                "sha256:52f389ea437ebf419d1c9754d0184b57edb45c951666ee86951d9f6afd26035e",
                "sha256:52a7ea2bb533dc2a91614795760a67fb807561e8a588204c4858a300074c082b",
                "sha256:db584c622b50c3b8f9b8b94c270cc5fe235e5f23ec4aacea8ce67a8c16e0fbad",
                "sha256:d0556a020fd1a0117c6e0bacd7730845713f43c2e35e86bb97963065ac9cc1ff",
                "sha256:9e8d92f1ff92a2b856e75061cbda7868b5c20e515c07b28eab37bde0f782ac9e",
                "sha256:f30f88fd0ea681dc922ddf44b32b50197c081f7cf4500f49315ef318562d9b5c",
                "sha256:343d9d3d44c30e51d7358ae104ad792b73b6f1b952589f21f3e858bfa68c46c2",
                "sha256:b9ad340d2a9336ae930c64fed56de115cd3cd34da11f7505b67b5442fe1cd0e0",
                "sha256:e7f06886bdb61e4560d99ae38dab2fe3bf752408d59d05e7aa290cdab4840f75"
            ]
        }
    }
]

```
Вывод на интерпретатор информации log.txt
```ShellSession
$ cat logs/log.txt
text1
text2
text3
```
Изменение номера лабораторной работы по vim ru редактору
```ShellSession
$ vim README.md
:s/lab12/lab13/g<CR>
# :s /lab11/lab12/g -- замена lab11 на lab12, g -- глобально в файл
:wq
```
Редактируем файл конфигурации .travis.yml
```ShellSession
$ vim .travis.yml
/lang<CR>o
services:
  - docker<ESC>
jVGddo
script:
  - docker build -t logger .<ESC>
# j -- сдвиг на строку вниз
# V -- выделение построчно
# G -- переход на последнюю строку
# dd -- удаление строки
```
Формирование выгрузки в "удаленный" репозиторий
```ShellSession
$ git add Dockerfile # добавление Dockerfile
$ git add .travis.yml # добавление .travis.yml
$ git commit -m"adding Dockerfile"
$ git push origin master
```
Преднастройка логирование и доступа к проектной части по travis
```ShellSession
$ travis login --auto
$ travis enable
```

## Report

```ShellSession
$ cd ~/workspace/labs/
$ export LAB_NUMBER=13
$ git clone https://github.com/tp-labs/lab${LAB_NUMBER} tasks/lab${LAB_NUMBER}
$ mkdir reports/lab${LAB_NUMBER}
$ cp tasks/lab${LAB_NUMBER}/README.md reports/lab${LAB_NUMBER}/REPORT.md
$ cd reports/lab${LAB_NUMBER}
$ edit REPORT.md
$ gistup -m "lab${LAB_NUMBER}"
```


***

## Links

- [Docker](https://docs.docker.com/)
- [Markdown](https://stackedit.io)
- [Gist](https://gist.github.com)
- [GitHub CLI](https://cli.github.com)

Copyright (c) 2025 Elijah S Shmakov

![Logo](../../assets/logotype/logo.jpg)