SHELL = /bin/sh
DOCKER_USER := mboivin
IMAGE := ftps-server
DOCKER_NAME := ftps1
TAG = 1.0.0

docker-build:
	docker build -t $(IMAGE) .

docker-run:
	docker run -it -p 20:20 -p 21:21 --name $(DOCKER_NAME) $(IMAGE) sh

up: docker-build docker-run

docker-stop:
	docker stop $(DOCKER_NAME)

docker-rm: docker-stop
	docker rm $(DOCKER_NAME)

docker-rmi:
	docker rmi $(IMAGE)

clean: docker-rm docker-rmi

re: clean up

.PHONY: up clean re
