<div align="center">
<h1><a id="intro">CheatSheet</a><br></h1>
<a href="https://docs.github.com/en"><img src="https://img.shields.io/static/v1?logo=github&logoColor=fff&label=&message=Docs&color=36393f&style=flat" alt="GitHub Docs"></a>
<a href="https://daringfireball.net/projects/markdown"><img src="https://img.shields.io/static/v1?logo=markdown&logoColor=fff&label=&message=Markdown&color=36393f&style=flat" alt="Markdown"></a> 
<a href="https://symbl.cc/en/unicode-table"><img src="https://img.shields.io/static/v1?logo=unicode&logoColor=fff&label=&message=Unicode&color=36393f&style=flat" alt="Unicode"></a> 
<a href="https://shields.io"><img src="https://img.shields.io/static/v1?logo=shieldsdotio&logoColor=fff&label=&message=Shields&color=36393f&style=flat" alt="Shields"></a>
<a href="https://img.shields.io/badge/Risk_Analyze-2448a2"><img src="https://img.shields.io/badge/Course-Risk_Analysis-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/AppSec-2448a2" alt= "RA"></a> <img src="https://img.shields.io/badge/Contributor-Шмаков_И._С.-8b9aff" alt="Contributor Badge"></a></div>

***

- gitscm

```bash
$ git init # Инициализация пустого локального репозитория
$ git remote add origin URL_link # Связывание удалённого репозитория с именем "origin" по ссылке "URL_link" с локальным

$ git pull origin name_branch # Ветка из которой мы берем изменения для тестирования
$ git remote show # Показать подключенные удалённые репозитории
$ git status 	# Показывает состояние локального репозитория (отслеживаемые, изменённые, новые файлы и пр.)

$ git add . # Добавить в индекс все новые, изменённые, удалённые файлы из текущей директории и её поддиректорий
$ git commit -S -m"added sources" # Зафиксировать в коммите проиндексированные изменения (закоммитить), добавить сообщение

$ git push origin name_branch # Отправляем изменения из локального репозитория в удалённый в ветку "name_branch"
$ git show HEAD # Информация о последнем комите (git log -1)
$ git push --set-upstream origin new-name # Установка upstream (связывает локальную ветку с удаленной)
$ git push origin :old-name # Удаление старой ветки в удаленном репо
$ git push origin new-name # Публикация новой ветки

$ git log --oneline --graph --decorate --all
$ tree -I "katalog|katalog" # Вывод с исключением каталогов для дерева проекта
```

- gitscm index

```bash
$ git add text.txt # Добавить в индекс указанный файл (был изменён, был удалён или это новый файл)
$ git add -i # Запустить интерактивную оболочку для добавления в индекс только выбранных файлов
$ git add -p # Показать новые/изменённые файлы по очереди с указанием их изменений и вопросом об отслеживании/индексировании

$ git reset # Убрать из индекса все добавленные в него изменения (в рабочей директории все изменения сохранятся), антипод git add
$ git reset readme.txt # Убрать из индекса изменения указанного файла (в рабочей директории изменения сохранятся)
$ git reset --hard # ОПАСНО: отменить изменения; вернуть то, что в коммите, на который указывает HEAD (незакомиченные изменения удалены из индекса и из рабочей директории, неотслеживаемые файлы останутся на месте)
$ git reset --hard origin/<branch_name>

$ git checkout text.txt # ОПАСНО: отменить изменения в файле, вернуть состояние файла, имеющееся в индексе
$ git clean -df # Удалить неотслеживаемые файлы и директории
$ git clean -fdn # Удаляет неотслеживаемые файлы и каталоги с предварительным просмотром
```

- gitscm конфликты

```bash

$ git remote set-url origin ssh://git@github.com_gitlab.com/username/newRepoName.git # Замена URL
$ git remote -v # Проверка правильности указанного link
$ git remote set-head origin -a
$ git pull --rebase origin name_branch # Переинициализация

$ git reset HEAD file # Убирает файл из индекса
$ git reset HEAD~ # Отмена последнего commit $ git reset --hard HEAD~ # Удаление commit с изменениями

$ git push origin --delete name_branch / git branch -rD origin/name_branch
$ git branch -d name_branch # Удаление локального репо
$ git checkout -- file # Отменяет изменение

$ git clean -fdn # Удаляет неотслеживаемые файлы и каталоги с предварительным просмотром

# Установка новой master/main ветки
$ git fetch origin
$ git fetch origin # Жесткая перезапись репозитория

$ git branch -u origin/gpages gpages
$ git branch -m master gpages
```

- gh actions

```bash
$ gh auth login
$ gh repo create repo_name # Cоздание удаленного репозитория (без URL)
$ gh repo clone user/repo

$ gh pr create --title "Название" --body "Описание" --base main --head feature-branch
	 --title # Заголовок PR
	 --body # Описание
	 --base # Целевая ветка
	 --head # Ваша ветка
	 —assignee «nickname» 
	 --source=
	 --public
	 --private
	 --base main 
	 --head feature-branch # Индивидуальный pull request (можно -a)

$ gh pr create --title "Bug" --body "work" $ gh pr create --base base_name # head changed_branch
$ gh pr merge --squash

$ gh issue list # Список открытых issue
$ gh repo view --web # Открыть репозитория в web
```

- gistup

```bash
$ npm install -g gistup
$ gh <command> <subcommand> --help
$ gh gist create -d "my test gist" -f some_local_file.txt  test_gist
```

- .gitignore

```bash
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
.DS_Store
.AppleDouble
.LSOverride
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
*.icloud

# Coverage
lib-cov
.nyc_output

# Node
dist
node_modules
/node_modules
jspm_packages/
.lock-wscript
.node_repl_history
.webpack/

# yarn v2
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz
.pnp.*

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# Runtime data
pids
Icon
*.pid
*.seed
*.pid.lock
.npm
.vscode
.vscode-test

# Compiled source #
*.com
*.class
*.dll
*.exe
*.o
*.so

# Packages #
*.7z
*.dmg
*.gz
*.isof
*.jar
*.rar
*.tar
*.zip

# Logs and databases #
*.log
*.sql
*.sqlite
logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
.pnpm-debug.log*
report.[0-9]*.[0-9]*.[0-9]*.[0-9]*.json

# ENV
.env
.env.development.local
.env.test.local
.env.production.local
.env.local
```

- Docker

```bash
$ docker image ls all # все образы
$ docker container ls # все запущенные контейнеры
$ docker container ls -all # все контейнеры
$ docker run -d --privileged --name docker go:1.16 # привилегированный режим

$ docker compose build	 
$ docker compose build --no-cache # Создает образы без использования кэша
$ docker compose build <service> # Создает только определенную службу

$ docker compose up	
$ docker compose up -d	 # Запускает контейнеры в отсоединенном режиме в фоновом режиме
$ docker compose start	 # Запускает уже созданные контейнеры (не перестраивает и не создает заново)
$ docker compose up --build	# Создает изображения, а затем запускает контейнеры
$ docker compose up --force-recreate # Воссоздает контейнеры, даже если ничего не изменилось
$ docker compose up --build --force-recreate # Полностью перестраивает и воссоздает контейнеры

$ docker compose stop	
$ docker compose down	# Останавливает и удаляет контейнеры, сети и тома по умолчанию
$ docker compose down --volumes	 # Удаляет контейнеры, сети и именованные/анонимные тома
$ docker compose down --rmi all	 # Также удаляет все построенные изображения
$ docker compose rm	 # Удаляет остановленные контейнеры служб (после остановки)
$ docker compose kill # Принудительно останавливает запуск контейнеров

$ docker compose ps	# Списки запущенных служб и их состояние
$ docker compose logs # Отображение журналов для всех служб
$ docker compose logs -f	
$ docker compose exec <service> sh # Открывает оболочку внутри работающего контейнера
$ docker compose config

docker exec -it <container_name_or_id> <command> # выполнение команды
            -i  # интерактивный режим (позволяет передать ввод)
            -t  # выделяет псевдотерминал (tty) для взаимодействия.
            <container_name_or_id>  # имя или ID контейнера.
```

- .dockerignore

```
.git/
monitoring/
node_modules/
screenshots/
test/
build/reports/
dist/
vagrant/
logs/
Dockerfile
.npmrc
/bom.json
/bom.xml
frontend/node_modules/
frontend/dist/
```

***

Copyright (c) 2025 Elijah S Shmakov


![Logo](assets/logotype/logo.jpg)

