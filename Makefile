SHELL = /bin/zsh
KUBECTL_VERSION=v1.20.2
SCRIPTS_PATH=scripts
DOCKERFILE_PATH=requirements
MANIFESTS_PATH=manifests
export KUBERNETES_HOST=$(shell minikube ip)

all: install start build_docker
	@echo "⧗   4/4Configure cluster\n"
	@sed --in-place 's/__IP__/'$(KUBERNETES_HOST)'/g' $(MANIFESTS_PATH)/configmaps/metallb-cm.yaml
	@kubectl apply -f $(MANIFESTS_PATH)/00-namespace.yaml
	@kubectl apply -f $(MANIFESTS_PATH)/secrets
	@kubectl apply -f $(MANIFESTS_PATH)/configmaps --recursive
	@kubectl apply -f $(MANIFESTS_PATH)/statefulsets
	@kubectl apply -f $(MANIFESTS_PATH)/deployments
	@kubectl apply -f $(MANIFESTS_PATH)/daemonsets
	@kubectl config set-context --current --namespace=dev
	@echo "\n√   SETUP DONE\n"

install: clean
	@zsh $(SCRIPTS_PATH)/install_minikube.sh

start:
	@echo "⧗   Start the cluster ...\n"
	minikube start --driver=docker --kubernetes-version=$(KUBECTL_VERSION)
	@minikube addons enable metrics-server
	@minikube addons enable dashboard
	@minikube addons enable metallb

build_docker:
	@zsh $(SCRIPTS_PATH)/build_docker.sh

stop:
	minikube stop

clean:
	minikube delete

.PHONY: install start stop clean
