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

В миникубе мы попробуем запустить http-сервер, который был поднят в прошлой лабораторной работе. _(P.S. Для удобства образ сервера был выложен на [DockerHub](https://hub.docker.com/r/larionow/webserver))_

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
В ходе лабораторной работы мы локально подняли кластер _minikube_, в котором развернули раннее созданный http-сервер. 

# ⭐

### Цель работы

### Задачи

## Ход работы
В этот раз, в качестве запускаемого сервиса, было решено использовать уже готовое решение — [httpd](https://hub.docker.com/_/httpd).  

Чтобы изолировать и обезопасить ресурсы, было создано пространство имён _webserver_, описанное в манифесте namespace.yml.

```
apiVersion: v1
kind: Namespace

metadata:
  name: webserver
  labels:
    app: webserver
```

Для управления внешним доступом к приложениям в кластере был создан ресурс _Ingress_.

```
apiVersion: networking.k8s.io/v1
kind: Ingress

metadata:
  name: webserver-ingress
  namespace: webserver

spec:
  ingressClassName: nginx
  rules:
    - host: minikube.webserver.ru
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: webserver-service
                port:
                  number: 80
```

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/webserver-namespace.PNG"/></p>

В качестве контроллера, мы использовали _Ingress Nginx Controller_, который подключили к кластеру при помощи команды:

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/nginx-ingress.PNG"/></p>

Помимо этого, был подключен _cert-manager_:

```
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml
```

При помощи утилиты openssl мы выпустили самоподписанный сертификат.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/certificate-create.PNG"/></p>

Затем, используя данный сертификат, мы создали секрет.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/secret.PNG"/></p>

После чего, добавили информацию о нем в ingress.yml.

```
  tls:
    - hosts:
        - minikube.webserver.ru
      secretName: webserver-tls
```

Также, для верного определения хоста, в файле _/etc/hosts_ была добавлена строка:

```
$(minikube ip) minikube.webserver.ru
```

Применив все манифесты, в браузере попробуем перейти по адресу https://minikube.webserver.ru.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/webserver-warning.PNG"/></p>

Как мы видим, система нас предупреждает о том, что посещение данного сайта может быть небезопасно. Так происходит, потому что мы используем самоподписанный сертификат, а по умолчанию Mozilla Firefox не доверяет таким сертификатам.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/certificate.PNG"/></p>

Согласшаемся с рисками (или добавляем наш сертификат в настройках браузера) и видим, что все успешно работает.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/webserver-working.PNG"/></p>

## Вывод