SHELL = /bin/zsh
SCRIPTS_PATH=scripts

all:
	@zsh $(SCRIPTS_PATH)/launch.sh

install:
	@zsh $(SCRIPTS_PATH)/install.sh

docker-build:
	@zsh $(SCRIPTS_PATH)/build_docker.sh

debug:
	@zsh setup.sh

stop:
	minikube stop

clean:
	@zsh $(SCRIPTS_PATH)/clean.sh

re: clean all

.PHONY: install debug stop clean re
