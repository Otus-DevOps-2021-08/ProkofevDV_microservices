docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post dmdeveloper77/post:1.0
docker run -d --network=reddit --network-alias=comment dmdeveloper77/comment:1.0
docker run -d --network=reddit -p 9292:9292 dmdeveloper77/ui:1.0
docker run -d --network=reddit -p 9090:9090 dmdeveloper77/prometheus