# ProkofevDV_microservices
ProkofevDV microservices repository

yc compute instance create \
--name docker-host \
--zone ru-central1-a \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=15 \
--ssh-key ~/.ssh/appuser.pub

docker-machine create \
--driver generic \
--generic-ip-address=62.84.117.28 \
--generic-ssh-user yc-user \
--generic-ssh-key ~/.ssh/appuser \
docker-host

eval $(docker-machine env docker-host)

docker build -t reddit:latest .

docker run --name reddit -d --network=host reddit:latest

docker tag reddit:latest dmdeveloper77/otus-reddit:1.0

docker push dmdeveloper77/otus-reddit:1.0

docker run --name reddit -d -p 9292:9292 dmdeveloper77/otus-reddit:1.0

Сбилдить образы:
cd src
docker pull mongo:latest
docker build -t dmdeveloper77/post:1.0 ./post-py
docker build -t dmdeveloper77/comment:1.0 ./comment
docker build -t dmdeveloper77/ui:1.0 ./ui

Запустить собранные образы с нетворком:
docker network create reddit
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post dmdeveloper77/post:1.0
docker run -d --network=reddit --network-alias=comment dmdeveloper77/comment:1.0
docker run -d --network=reddit -p 9292:9292 dmdeveloper77/ui:1.0

зайдем
http://localhost:9292/
создадим несколько постов - все работает

для передачи значений переменный из env можно использовать -е параметр:

# with env example
docker run  -d  \
-e POST_DATABASE_HOST='post_db' \
-e POST_DATABASE='posts' \
--network=reddit  --network-alias=post dmdeveloper77/post:3.0


после остановки докеров записи из бд пропали, 
создадим volume

docker volume create reddit_db

перезапустим контейнеры через start_containers.sh

зайдем на
http://localhost:9292/
видим данные в бд есть.


запустим новый образ с сетью none
docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig

разница с выводом команды
docker-machine ssh docker-host ifconfig
в том что в последнем случае нет сетевых интерфейсов.

становить все запущенные контейнеры
docker kill $(docker ps -q)

создать сеть типа бридж
docker network create reddit --driver bridge

запустить контейнеры с бридж сетью
docker run -d --network=reddit mongo:latest
docker run -d --network=reddit dmdeveloper77/post:1.0
docker run -d --network=reddit dmdeveloper77/comment:1.0
docker run -d --network=reddit -p 9292:9292 dmdeveloper77/ui:1.0

запустить контейнеры, присвоив днс имя
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post dmdeveloper77/post:1.0
docker run -d --network=reddit --network-alias=comment dmdeveloper77/comment:1.0
docker run -d --network=reddit -p 9292:9292 dmdeveloper77/ui:1.0


запустим так чтобы ui е имел доступа к базе
Создадим docker-сети

> docker network create back_net --subnet=10.0.2.0/24
> docker network create front_net --subnet=10.0.1.0/24

Запустим контейнеры

> docker run -d --network=front_net -p 9292:9292 --name ui dmdeveloper77/ui:1.0
> docker run -d --network=back_net --name comment dmdeveloper77/comment:1.0
> docker run -d --network=back_net --name post dmdeveloper77/post:1.0
> docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest

Подключим контейнеры ко второй сети
> docker network connect front_net post
> docker network connect front_net comment 

Выполните:
> export USERNAME=dmdeveloper77
> docker-compose up -d
> docker-compose ps

Для переопределения необходимо передавать флаг --project-name, либо использовать COMPOSE_PROJECT_NAME в переменной окружения.
