SHELL = /bin/sh
DOCKER_USER := mboivin
IMAGE := vsftpd
DOCKER_NAME := vsftpd1
TAG = ft

docker-build:
	docker build -t $(IMAGE):$(TAG) .

docker-run:
	docker run -e FTP_USER=user42 -e FTP_PASS=user42 -p 21:21 -p 20:20 -p 20000-20001:20000-20001 --name $(DOCKER_NAME) $(IMAGE):$(TAG)

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
