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