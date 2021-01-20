# Process

> Kubernetes is a tool used to manage clusters of containerized applications. In computing, this process is often referred to as orchestration.  Much as a conductor would, Kubernetes coordinates lots of microservices that together form a useful application. Kubernetes automatically and perpetually monitors the cluster and makes adjustments to its components.  
Kubernetes, or k8s for short, is a system for automating application deployment. Modern applications are dispersed across clouds, virtual machines, and servers. Administering apps manually is no longer a viable option.  
K8s transforms virtual and physical machines into a unified API surface. A developer can then use the Kubernetes API to deploy, scale, and manage containerized applications. [(Source)](https://phoenixnap.com/kb/understanding-kubernetes-architecture-diagrams)  


We interact with the Kubernetes API that gives access to the resources describing the cluster configuration.

- node: a machine in the cluster
- pod: multiple containers running on the same node and sharing the same resources
  - IP addresses are associated with pods, not with individual containers [(source)](https://container.training/kube-selfpaced.yml.html)
- service: stable endpoint to connect to an application (multiple pods) from the outside of the cluster


`kubectl`: CLI tool Kubernetes API
