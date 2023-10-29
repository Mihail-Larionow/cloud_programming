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

Хоть они оба выполняют одну и ту же функцию, но разница между количеством используемой памяти образов очевидна.

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
все о ⭐
