## Лабораторная работа №4 

### Цель работы

### Задачи

### Ход работы

#### 1. Установка Prometheus
Через консоль добавим репозиторий Prometheus. 

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

Теперь установим его и запустим сервис.

```
helm install prometheus prometheus-community/prometheus
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np
```

Откроем веб-интерфейс Prometheus.

```
minikube service prometheus-server-np
```

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab4/images/start_prometheus.PNG"/></p>

#### 2. Установка Grafana
Добавим репозиторий Grafana. 

```
helm repo add grafana https://grafana.github.io/helm-charts
```

Установим и запустим сервис.

```
helm install grafana grafana/grafana
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-np
```

Откроем веб-интерфейс Grafana.

```
minikube service grafana-np
```

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab4/images/start_grafana.PNG"/></p>

#### 3. Настройка
Через <font color=aqua>_Connections > Datasource_</font> свяжем Grafana с Prometheus.  
Результат.

<p align="center"><img src="https://github.com/Mihail-Larionow/cloud_programming/blob/main/lab4/images/working_grafana.PNG"/></p>

## Вывод
