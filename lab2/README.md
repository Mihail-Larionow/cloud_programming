## Лабораторная работа №2 "Работа с Kubernetes"

### Цель работы
Необходимо поднять локально kubernetes кластер, в котором будет развернут сервер.

### Задачи
1. Используя 2-3 ресурса kubernetes, поднять кластер minikube.

## Ход работы

Для успешной работы необходимо, чтобы были установлены dokcer, kubectl и minikube.

Запускаем minikube при помощи команды:

```
minikube start --driver=docker
```

Создаем:

```
apiVersion: apps/v1
kind: Deployment

metadata:
  name: webserver
  labels:
    app: webserver

spec:
  selector:
    matchLabels:
      app: webserver

  replicas: 2

  template:
    metadata:
      name: webserver
      labels:
        app: webserver
    spec:
      containers:
        - name: webserver
          image: larionow/webserver
```

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/web-server-create.PNG"/></p>

Создаем сервис:

```
apiVersion: v1
kind: Service

metadata:
  name: service

spec:
  type: NodePort
  ports:
    - targetPort: 8080
      port: 8080
      nodePort: 30008
  selector:
    app: webserver
```

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/service-create.PNG"/></p>

Переходим через minikube service:

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/web-server-start.PNG"/></p>

Все работает!

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/web-server-work.PNG"/></p>

## Вывод
В ходе лабораторной работы мы локально подняли kubernetes кластер minikub, в котором развернули http сервер. 
