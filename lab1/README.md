# Лабораторная работа 1

При помощи плохого и хорошего Dockefile собирается образ контейнера, в котором запускается простенький http-сервер.

<center><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab1/images/web-server.PNG"/></center>

Хоть они оба выполняют одну и ту же функцию, разница между количеством используемой памяти образов очевидна.

<center><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab1/images/images.PNG"/></center>

## Плохой Dockerfile
все о плохом  

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
1. Использование latest при указании версии образа.

```
FROM python:latest
```

Лучше использовать конкретную версию.

```
FROM python:alpine
```

2. Установка лишних пакетов.

```
RUN apt-get update
RUN pip3 install numpy
```

Лучше не устанавливать лишние пакеты, так как пользы от них никакой, а место на диске занимать они будут.

3. Излишнее использование команд RUN, ADD и COPY.

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

Сборка и запуск.

<center><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab1/images/bad-app-image.PNG"/></center>

## Хороший Dockerfile
все о хорошем

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

Сборка и запуск.

<center><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab1/images/good-app-image.PNG"/></center>

## ⭐ 
все о ⭐