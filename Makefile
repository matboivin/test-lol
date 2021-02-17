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

docker-rm:
	docker rm $(docker ps -a -q)

docker-rmi:
	docker rmi $(docker images -q)

stop:
	minikube stop

clean:
	@zsh $(SCRIPTS_PATH)/clean.sh

re: clean all

.PHONY: install stop clean re
