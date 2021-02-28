SHELL = /bin/zsh
SCRIPTS_PATH=srcs/scripts

install:
	@zsh $(SCRIPTS_PATH)/install_minikube.sh
	@zsh $(SCRIPTS_PATH)/build_docker.sh

start:
	@echo "⧗   Start the cluster ...\n"
	minikube start --driver=docker
	eval $(minikube docker-env)
	minikube addons enable metrics-server
	minikube addons enable dashboard
	minikube addons enable metallb
	@zsh $(SCRIPTS_PATH)/install_kubectl.sh

all:
	@kubectl apply -f $MANIFESTS_PATH --recursive

list:
	minikube service list

watch:
	kubectl get pods -A --watch

stop:
	minikube stop

clean:
	@zsh $(SCRIPTS_PATH)/clean.sh

.PHONY: install start stop list watch clean
