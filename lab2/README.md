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
А чтобы и вы смогли получить данный результат, вам необходимо запустить _minikube_, скачать данный репозиторий и выполнить следующие команды:

```
kubectl create -f webserver.yml
kubectl create -f service.yml
minikube service service
```

## Вывод
В ходе лабораторной работы мы локально подняли кластер _minikube_, в котором развернули раннее созданный http-сервер. 

# ⭐

### Цель работы
Настроить подключение к сервису в minicube через https, используя самоподписанный сертификат. 

### Задачи
1. Включить поддержку Ingress в minicube.
2. Создать файл конфигурации отдельного пространства имен для нового сервиса.
3. Создать файл конфигурации ingress с правилами проксирования трафика от внешнего источника до сервисов внутри кластера.
4. Создать файл конфигурции сервиса.
5. Подключить ingress nginx контроллер.
6. Выпустить самоподписанный сертификат используя openssl, добавить секрет в kubernetes и прописать его в конфигурации ingress.
7. Добавить в файл /etc/hosts на локальной машине IP-адрес миникуба и имя желаемого хоста.
8. Применить все файлы конфигурации.


## Ход работы

> В качестве запускаемого сервиса было решено использовать готовое решение — [httpd](https://hub.docker.com/_/httpd).  


Была включена поддержка Ingress:

```
minikube addons enable ingress
```

Чтобы изолировать новый сервис и обезопасить ресурсы, было создано пространство имён _webserver_, описанное в манифесте namespace.yml.

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

Для управления маршрутизацией HTTP и HTTPS к сервисам в Kubernetes, был выбран _Ingress Nginx Controller_, который был подключен к кластеру при помощи команды:

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/nginx-ingress.PNG"/></p>

При помощи утилиты `openssl` был выпущен самоподписанный сертификат.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/certificate-create.PNG"/></p>

С помощью сертификата был создан секрет Kubernetes.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/secret.PNG"/></p>

Данные созданного секрета были добавлены в `ingress.yml`.

```
  tls:
    - hosts:
        - minikube.webserver.ru
      secretName: webserver-tls
```

Для определения хоста `minikube.webserver.ru` к создаваемому сервису, в файле _/etc/hosts_ была добавлена строка:

```
$(minikube ip) minikube.webserver.ru
```

После применения всех манифестов, в браузере была выполнена попытка перехода по адресу https://minikube.webserver.ru.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/webserver-warning.PNG"/></p>

Система предупредила о том, что посещение данного сайта может быть небезопасно. Так происходит, потому что был использован самоподписанный сертификат, а по умолчанию Mozilla Firefox и многие другие современные браузеры не доверяют таким сертификатам.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/certificate.PNG"/></p>

Была выбрана опция принятия рисков, после чего сайт успешно открылся. Также можно было добавить самоподписанный сертификат в подтвержденные настройках браузера.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab2/images/webserver-working.PNG"/></p>

Успех!

Чтобы получить такой же результат, необходимо запустить _minikube_, скачать данный репозиторий и выполнить следующие команды:

```
kubectl apply -f namespace.yml
kubectl apply -f webserver.yml
kubectl apply -f ingress.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
kubectl create secret tls webserver-tls --cert=tls.crt --key=tls.key
```

Кроме того, важно добавить информацию в _/etc/hosts_ и включить addon _ingress_ в _minikube_, если он не включен.

## Вывод

Таким образом, были получены базовые навыки работы с платформой для автоматического развертывания, масштабирования и управления контейнеризованными приложениями Kubernetes. Были использованы разные объекты его API для выполнения работы – Service, Deployment, Ingress, Namespace. Было выполнено развертывание простого сервиса в кластере Kubernetes с использованием Docker в качестве драйвера на локальной машине. Было также выполнено развертывание стороннего сервиса httpd с самоподписанным сертификатом на хосте `minikube.webserver.ru`.
