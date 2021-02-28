SHELL = /bin/sh
DOCKER_USER := mboivin
IMAGE := telegraf
DOCKER_NAME := telegraf1
TAG = ft

docker-build:
	docker build -t $(IMAGE):$(TAG) .

docker-run:
	docker run -it -p 8125:8125/udp --name $(DOCKER_NAME) $(IMAGE):$(TAG) sh

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
