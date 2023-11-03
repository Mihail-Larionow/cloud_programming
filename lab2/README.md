## Лабораторная работа №2 "Работа с K8s"

### Цель работы
Необходимо поднять локально _kubernetes_ кластер, в котором будет развернут сервер.

### Задачи
1. Используя 2-3 ресурса _k8s_, поднять кластер _minikube_.

## Ход работы

Для успешной работы необходимо, чтобы в системе были установлены _docker_, _kubectl_ и _minikube_.

Запускаем minikube при помощи команды:

```
minikube start --driver=docker
```

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/minikube.PNG"/></p>

В миникубе мы попробуем запустить http-сервер, который был поднят в прошлой лабораторной работе. _(P.S. Для удобства образ сервера был выложен на [DockerHub](https://hub.docker.com/repository/docker/larionow/webserver/general))_

Создадим файл webserver.yml:

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

В поле _kind_ указан ресурс _Deployment_, который управляет состоянием развертывания подов, описанное в манифесте, а также следит за удалением и созданием их экземпляров.  

Помимо этого, в манифесте в поле _replicas_ мы указали число 2, это означает, что в нашем кластере должно быть создано 2 экземпляра объекта.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/web-server-create.PNG"/></p>

Создадим service.yml:

```
apiVersion: v1
kind: Service

metadata:
  name: service

spec:
  type: LoadBalancer
  ports:
    - targetPort: 8080
      port: 8080
      nodePort: 30008
  selector:
    app: webserver
```

В качестве сервиса, мы использовали _LoadBalancer_, который распределяет нагрузку сети между нашими репликами, а также обеспечивает высокую доступность и маштабируемость.  

Мы могли, конечно, использовать _NodePort_, но данный сервис используется скорее для тестирования или разработки. Он, так сказать, внутренний балансировщик нагрузки, когда _LoadBalancer_ — внешний.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/service-create.PNG"/></p>

Перейдем по адресу и проверим работу нашего сервера.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/web-server-work.PNG"/></p>

Успех! 

## Вывод
В ходе лабораторной работы мы локально подняли кластер _minikube_, в котором развернули http-сервер. 

# ⭐

_Скоро здесь точно что-то появится!_