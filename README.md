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
