# Process

We interact with the Kubernetes API that gives access to the resources describing the cluster configuration.

- node: a machine in the cluster
- pod: multiple containers running on the same node and sharing the same resources
  - IP addresses are associated with pods, not with individual containers [(source)](https://container.training/kube-selfpaced.yml.html)
- service: how to connect to an application (multiple pods) from the outside of the cluster


`kubectl`: CLI tool Kubernetes API
