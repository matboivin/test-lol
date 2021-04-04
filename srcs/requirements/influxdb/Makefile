SHELL = /bin/sh
DOCKER_USER := mboivin
IMAGE := influxdb
DOCKER_NAME := influxdb1
TAG = ft

docker-build:
	docker build -t $(IMAGE):$(TAG) .

docker-run:
	docker run -e INFLUXDB_DB=local_monitoring -e INFLUXDB_USER=user42 -e INFLUXDB_PASS=user42 -p 8086:8086 --name $(DOCKER_NAME) $(IMAGE):$(TAG)

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
