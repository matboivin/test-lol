SHELL = /bin/sh
DOCKER_USER := mboivin
IMAGE := mariadb
DOCKER_NAME := mariadb1
TAG = ft

docker-build:
	docker build -t $(IMAGE):$(TAG) .

docker-run:
	docker run -e MYSQL_ROOT_PASSWORD=user42 -e MYSQL_USER=user42 -e MYSQL_PASSWORD=user42 -e MYSQL_DATABASE=wordpress -p 3306:3306 --name $(DOCKER_NAME) $(IMAGE):$(TAG)

up: docker-build docker-run

docker-stop:
	docker stop $(DOCKER_NAME)

docker-rm: docker-stop
	docker rm $(DOCKER_NAME)

docker-rmi:
	docker rmi $(IMAGE):$(TAG)

clean: docker-rm docker-rmi

re: clean up

.PHONY: up clean re
