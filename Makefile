SHELL = /bin/zsh
SCRIPTS_PATH=srcs/scripts

all:
	@zsh setup.sh

install:
	@zsh $(SCRIPTS_PATH)/install.sh

docker-build:
	@zsh $(SCRIPTS_PATH)/build_docker.sh

docker-stop:
	docker stop $(docker ps -a -q)

docker-clean:
	docker rm $(docker ps -a -q)
	docker rmi $(docker images -q)

stop:
	minikube stop

clean: docker-clean
	minikube delete

re: clean all

.PHONY: install debug stop clean re
