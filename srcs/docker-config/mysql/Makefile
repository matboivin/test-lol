SHELL = /bin/sh
DOCKER_USER := mboivin
IMAGE := mysql1
DOCKER_NAME := mysql1
TAG = dev

docker-build:
	docker build -t $(IMAGE) .

docker-run:
	docker run -it -p 3306:3306 --name $(DOCKER_NAME) $(IMAGE) sh

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
