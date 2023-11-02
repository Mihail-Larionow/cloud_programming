## Лабораторная работа №2 "Работа с Kubernetes"

### Цель работы
Необходимо поднять локально kubernetes кластер, в котором будет развернут сервер.

### Задачи
1. Используя 2-3 ресурса k8s, поднять кластер minikube.

## Ход работы

Для успешной работы необходимо, чтобы в системе были установлены docker, kubectl и minikube.

Запускаем minikube при помощи команды:

```
minikube start --driver=docker
```

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/minikube.PNG"/></p>

В миникубе мы попробуем запустить http-сервер, который был поднят в прошлой лабораторной работе. _(P.S. Для удобства образ сервера был выложен на DockerHub.)_

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

В поле _kind_ был указан ресурс _Deployment_, который управляет состоянием развертывания подов, описанное в манифесте, а также следит за удалением и созданием их экземпляров.  
Помимо этого, в манифесте мы указали, что

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

В качестве сервиса, мы использовали _LoadBalancer_, который распределяет нагрузку сети между нашими репликами, а также обеспечивает высокую доступность и маштабируемость.  

Мы могли, конечно, использовать _NodePort_, но данный сервис используется скорее для тестирования или разработки. Он, так сказать, внутренний балансировщик нагрузки, когда _LoadBalancer_ — внешний.

При помощи команды _minikube service_ находим адрес нашего сервера:

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/web-server-start.PNG"/></p>

Все работает!

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/web-server-work.PNG"/></p>

## Вывод
В ходе лабораторной работы мы локально подняли kubernetes кластер minikub, в котором развернули http сервер. 

# ⭐

_Скоро здесь тосно что-то появится!_