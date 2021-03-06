SHELL = /bin/zsh
SCRIPTS_PATH=srcs/scripts
DOCKERFILE_PATH=srcs/requirements
MANIFESTS_PATH=srcs/manifests
NAMESPACE_DEV=ft-services

all: install start
	@eval $(minikube docker-env)
	kubectl apply -f $(MANIFESTS_PATH)/00-namespace.yaml
	kubectl apply -f $(MANIFESTS_PATH)/secrets --recursive
	kubectl apply -f $(MANIFESTS_PATH)/configmaps --recursive
	kubectl apply -f $(MANIFESTS_PATH)/services --recursive
	kubectl config set-context --current --namespace=$(NAMESPACE_DEV)

install: clean
	@zsh $(SCRIPTS_PATH)/install_minikube.sh

start:
	@echo "⧗   Start the cluster ...\n"
	minikube start --driver=docker --kubernetes-version v1.20.2
	minikube addons enable metrics-server
	minikube addons enable dashboard
	minikube addons enable metallb
	@zsh $(SCRIPTS_PATH)/build_docker.sh

list:
	minikube service list

watch:
	kubectl get pods -A --watch

stop:
	minikube stop

clean:
	minikube delete

.PHONY: install start stop list watch clean
