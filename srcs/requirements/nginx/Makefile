SHELL = /bin/sh
DOCKER_USER := mboivin
IMAGE := nginx
DOCKER_NAME := nginx1
TAG = ft

docker-build:
	docker build -t $(IMAGE):$(TAG) .

docker-run:
	docker run -p 80:80 -p 443:443 --name $(DOCKER_NAME) $(IMAGE):$(TAG)

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
