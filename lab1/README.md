## Лабораторная работа №1 "Работа с Dockerfile"

### Цель работы
Написать 2 Dockerfile с примерами плохих и хороших практик.

### Задачи
1. Написать Dockerfile с примерами плохих практик;
2. Написать Dockerfile с хорошими практиками, путем исправления плохих из предыдущего Dockerfile;
3. Объяснить почему используемые практики в Dockerfile 1 были плохие и как были исправлены в Dockerfile 2;

## Ход работы

При помощи плохого и хорошего Dockefile собирается образ контейнера, в котором запускается простенький http-сервер.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab1/images/web-server.PNG"/></p>

Хоть они оба выполняют одну и ту же функцию, разница между количеством используемой памяти образов очевидна.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab1/images/images.PNG"/></p>

### Плохой Dockerfile
Плохой Dockerfile содержит:

```
FROM python:latest

MAINTAINER LINM 
LABEL version="bad"

RUN apt-get update

RUN mkdir webserver
WORKDIR /home/webserver/

ADD ./web-server/index.html index.html
ADD ./web-server/server.py server.py
ADD ./web-server/serverup.png serverup.png

ENTRYPOINT ["python3", "server.py"]
EXPOSE 8080
```

В данном Dockerfile собраны топ 3 плохих практики:

**1. Использование latest при указании версии образа.** Использование данного тега может привести к тому, что исполняемый файл, используемый в образе, может не поддерживаться в последней версии Python, которая будет доступна на момент сборки контейнера. Также использование последней версии образа может привести к увеличению размера файла.
```
FROM python:latest
```

Лучше указывать конкретную версию образа.

```
FROM python:alpine
```

**2. Установка лишних пакетов.** Каждый установленный пакет добавляет дополнительные файлы и зависимости к образу, что может значительно увеличить его размер. Это может привести к увеличению времени загрузки, использованию больше дискового пространства и требованиям больших ресурсов хранения и обработки.

```
RUN apt-get update
RUN pip3 install numpy
```

Лучше не устанавливать лишние пакеты, так как пользы от них никакой, а место на диске занимать они будут.

**3. Излишнее использование команд RUN, ADD и COPY.** Команды RUN и ADD создают новый слой в образе Docker, что может привести к неэффективному использованию дискового пространства. Также они добавляют файлы и пакеты в образ, что ведет к увеличению его размера.

```
RUN mkdir webserver
WORKDIR /home/webserver/

ADD ./web-server/index.html index.html
ADD ./web-server/server.py server.py
ADD ./web-server/serverup.png serverup.png
```

Лучше объединять такие команды в цепочки. В нашем случае вообще можно ограничиться простым копированием папки. И создание каталога webserver отдельной командой тоже не требуется. 

```
WORKDIR /home/webserver/

COPY ./web-server .
```

#### Сборка и запуск.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab1/images/bad-app-image.PNG"/></p>

### Хороший Dockerfile

В хорошем Dockerfile были исправлены bad practices плохого Dockerfile.

```
FROM python:alpine

MAINTAINER LINM 
LABEL version="good"

WORKDIR /home/webserver/

COPY ./web-server .

ENTRYPOINT ["python3", "server.py"]
EXPOSE 8080
```

#### Сборка и запуск.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab1/images/good-app-image.PNG"/></p>

## Вывод
В ходе лабораторной работы мы написали 2 Dockerfile, с примерами хороших и плохих практик использования. Контейнеры данных образов работают одинаково, но есть ощутимая разница в весе файлов. Хороший Dockerfile весил 51,9 Мб, а плохой - 1,14 Гб.

## ⭐ 
### Цель работы
Целью лабораторной работы является разработка приложения с входными аргументами, записывающего изменения в базу данных при запуске контейнера и обеспечивает сохранность данных при остановке контейнера.

### Задачи
1. Разработать приложение, которое будет записывать изменения в базу данных в запущенном контейнере Docker. Приложение должно принимать команды на запись данных через аргументы при запуске контейнера;
2. Реализовать механизм сохранения данных при остановке контейнера, чтобы информация не терялась;
3. Создать файл, который будет содержать конфигурацию и скрипт сборки приложения, и назвать его отличным от Dockerfile именем.

## Ход работы
Для выполнения работы была выбрана база данных PostgreSQL версии 14.

#### SQL-скрипт для создания таблицы.
Был создан файл **/sql/create_tables.sql** с SQL-запросом для создания таблицы stars в PostgreSQL. Таблица содержит автогенерируемый id, name и size для каждой записи.

#### Разработка Dockerfile.
Был разработан Dockerfile с именем **no-docker-file**, начинающийся с указания образа, из которого будет строиться контейнер. В данном случае это образ PostgreSQL версии 14:
```
FROM postgres:14
```
Следующая строка копирует все SQL-файлы из каталога **./sql/** в каталог **/docker-entrypoint-initdb.d/** внутри образа Docker:
```
COPY ./sql/ /docker-entrypoint-initdb.d/
```
Этот каталог предназначен для инициализационных скриптов PostgreSQL, которые выполняются при первом запуске базы данных. Таким образом, при инициализации базы данных в контейнере будет запущен скрипт **/sql/create_tables.sql** для создания таблицы stars.

#### Переменные окружения.
В файле **config.env** были определены переменные окружения для PostgreSQL: имя пользователя, пароль, название базы данных и порт.

#### Разработка конфигурационного файла.
Далее был разработан конфигурационный файл **docker-compose.yml** для контейнера **lab1**.

Сервис использует образ PostgreSQL версии 14, название контейнера my_container. Сборка выполняется из контекста текущего каталога и Dockerfile с именем **no-docker-file** (с помощью явного указания имени файла удалось назвать его не Dockerfile).

Порт 5432 сервиса опубликован наружу через Docker, используя сопоставление портов 5432:5432. 

Значения переменных окружения загружаются из файла **config.env**. 

Volume в Docker – это механизм, который позволяет создавать постоянные хранилища данных внутри контейнеров. Это означает, что данные, хранящиеся на volume, будут сохраняться даже после остановки или удаления контейнера. Реализуется это с помощью монтирования файлов в каталог Docker.
Volume **lab1_volume** определяется в секции volumes конфигурационного файла **docker-compose.yml**. Его состояние не определено, поэтому его объем будет выбран только при добавлении в каталог контейнера.
Для сохранения данных PostgreSQL каталог **lab1_volume** монтируется в каталог контейнера **/var/lib/postgresql/data**.

#### Скрипты.
В директории tool были созданы три скрипта: **build.sh**, **start.sh** и **insert.sh**.

В скрипте **build.sh** создаётся контейнер и volume. Его следует запускать, если у пользователя нет контейнера my_container. В скрипте **start.sh** происходит запуск контейнера my_container.

В скрипте **insert.sh** реализован функционал вставки данных в таблицу star. 
Созданы две переменные – **FALLBACK_NAME** и **FALLBACK_SIZE**. Если при запуске данного скрипта пользователь не передаст аргументы, то будут использованы эти параметры. Далее выполняется вход в PostgerSQL, выбирается текущая база данных: **cloud_lab1_db** и выполняется вставка в таблицу stars. 

**!!!** Важно отметить, что этот скрипт успешно срабатывает только при запущенном контейнере my_container.

#### Результат запуска.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab1/images/img.png"/></p>

## Вывод
В процессе выполнения данной лабораторной работы было успешно разработано приложение, способное принимать аргументы из командной строки и сохранять изменения в базу данных внутри контейнера Docker. 

Благодаря использованию Docker volume, удалось реализовать механизм сохранения данных даже после остановки контейнера. Кроме того, был создан файл конфигурации и сборки с именем, отличающимся от Dockerfile, что облегчает процесс обновления и развертывания приложения в дальнейшем.
