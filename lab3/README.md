## Лабораторная работа №3 "Работа с CI/CD"

### Цель работы
Настроить Github Actions на автоматическую сборку докер образа на каждый 
push в репозиторий, а также на сохранение результата его сборки в 
общедоступный репозиторий образов контейнеров <font color="aqua">Dockerhub</font>.

### Задачи
1. Создать файл .yaml с будущим Github Action в директории .github в корне репозитория, 
обозначить триггер выполнения (на каждый push);
2. Создать Job "build_and_run" для выполнения сборки <font color="aqua">Docker</font> образа;
3. Создать Job "build_and_push_to_dockerhub" для выполнения сборки <font color="aqua">Docker</font> образа и отправления 
результата в <font color="aqua">Dockerhub</font>;


### Ход работы

#### 1. Создание файла конфигурации Github Action
В корне репозитория была создана директория `.github`, в ней был создан файл `ci.yaml`.
Было задано имя для Github Action, а также базовая конфигурация:
```yaml
name: CI Pipeline – lab3
on:
  push:
    branches:
      - main
```
Такая запись обозначает, что action будет вызываться на каждый push в ветку main.

#### 2. Создание Job "build_and_run"

Для того, чтобы выполнять сборку <font color="aqua">Docker</font> образа на каждый push в репозиторий,
была создана **конфигурация контейнера**. По пути `lab3/task_simple` был 
создан файл **Dockerfile**:

```dockerfile
FROM ubuntu:20.04

RUN echo "Built successfully 💋" > build.txt

CMD ["cat", "build.txt"]

```
>Note: Такая конфигурация <font color="aqua">Dockerfile</font> создаёт образ <font color="aqua">Docker</font> на основе образа Ubuntu 
версии 20.04. Текст _Built successfully 💋_ записывается в файл `build.txt`. Далее
выводится содержимое файла `build.txt`.

 
Для того, чтобы выполнять сборку файла на каждый push, в файл конфигурации Github Action было
добавлено следующее:
```yaml
name: CI Pipeline – lab3
on:
  push:
    branches:
      - main
    paths:
      - "lab3/**"

jobs:
  build_and_run:
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Build Docker image
        run: docker build -t lab3-app lab3/task_simple

      - name: Run lab3 docker image
        run: docker run lab3-app
```
Была добавлена Job для сборки образа, для ее выполнения были добавлены изменения:

 - `paths: - "lab3/**"` – workflow активируется только если были изменения в папке lab3/**;

 - `steps:` – определяет последовательность шагов, которые будут выполнены в рамках job:

   - **Checkout** – использует действие `actions/checkout@v2`для получения кода из текущего репозитория;

   - **Build Docker image** – строит образ из <font color="aqua">Dockerfile</font> и помечает его тегом **lab3-app**;

   - **Run lab3 docker image** – выполняет запуск созданного Docker образа. Поскольку в <font color="aqua">Dockerfile</font> указана команда `CMD`, 
   контейнер автоматически выведет содержимое файла `build.txt`.

#### 3. Создание Job "build_and_push_to_dockerhub"

Для выполнения сохранения образа в общедоступный репозиторий образов контейнеров <font color="aqua">Dockerhub</font>,
был создан новый Job:

```yaml
  build_and_push_to_dockerhub:
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Login to DockerHub
        uses: docker/login-action@v3
        with:
            username: ${{ secrets.DOCKERHUB_USERNAME }}
            password: ${{ secrets.DOCKERHUB_ACCESS_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v2
        with:
            context: lab3/task_simple
            push: true
            tags: lnikm/cloud_programming:latest
```
 - **Login to DockerHub** – авторизует пользователя на <font color="aqua">Dockerhub</font> с использованием учетных данных, хранящихся в секретах репозитория (`DOCKERHUB_USERNAME` и `DOCKERHUB_ACCESS_TOKEN`);

 - **Build and push Docker image** – использует действие docker/build-push-action@v2
для сборки Docker образа из контекста `lab3/task_simple`. Этот шаг публикует собранный образ 
на <font color="aqua">Dockerhub</font>. Параметр `push: true` указывает на необходимость публикации, а `tags: lnikm/cloud_programming:latest` 
задаёт тег, который будет использоваться для образа.

## Вывод
Таким образом, Github Actions были настроены на автоматическую сборку 
докер образа на каждый push в репозиторий, а также на сохранение результата его сборки в 
общедоступный репозиторий образов контейнеров <font color="aqua">Dockerhub</font>.

---
## ⭐ 
### Цель работы
цели пока нет
