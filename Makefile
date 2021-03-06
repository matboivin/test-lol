SHELL = /bin/zsh
SCRIPTS_PATH=srcs/scripts
DOCKERFILE_PATH=srcs/requirements
MANIFESTS_PATH=srcs/manifests

install:
	@zsh $(SCRIPTS_PATH)/install_minikube.sh
	@make -C $(DOCKERFILE_PATH)/nginx docker-build
	@make -C $(DOCKERFILE_PATH)/mysql docker-build
	@make -C $(DOCKERFILE_PATH)/phpmyadmin docker-build
	@make -C $(DOCKERFILE_PATH)/wordpress docker-build
	@make -C $(DOCKERFILE_PATH)/influxdb docker-build
	@make -C $(DOCKERFILE_PATH)/telegraf docker-build
	@make -C $(DOCKERFILE_PATH)/grafana docker-build
	@make -C $(DOCKERFILE_PATH)/ftps docker-build

start:
	@echo "⧗   Start the cluster ...\n"
	minikube start --driver=docker
	eval $(minikube docker-env)
	minikube addons enable metrics-server
	minikube addons enable dashboard
	minikube addons enable metallb
	@zsh $(SCRIPTS_PATH)/install_kubectl.sh

all:
	kubectl apply -f $(MANIFESTS_PATH)/00-namespace.yaml
	kubectl apply -f $(MANIFESTS_PATH)/secrets --recursive
	kubectl apply -f $(MANIFESTS_PATH)/configmaps --recursive
	kubectl apply -f $(MANIFESTS_PATH)/services --recursive

list:
	minikube service list

watch:
	kubectl get pods -A --watch

stop:
	minikube stop

clean:
	@zsh $(SCRIPTS_PATH)/clean.sh

.PHONY: install start stop list watch clean
