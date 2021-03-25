# Notes

## Docker entrypoints

> This script uses the exec Bash command so that the final running application becomes the container’s PID 1. This allows the application to receive any Unix signals sent to the container. For more, see the ENTRYPOINT reference.  [Dockerfile reference for the ENTRYPOINT instruction](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint)

## API Resources

> The resources will be created in the order they appear in the file. Therefore, it's best to specify the service first, since that will ensure the scheduler can spread the pods associated with the service as they are created by the controller(s), such as Deployment.  [(Source)](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)

| NAME                   | SHORTNAMES | APIGROUP | NAMESPACED | KIND                  | VERBS                                                        |
| :--------------------  | :--------- | :------- | :--------- | :-------------------- | :----------------------------------------------------------- |
| configmaps             | cm         |          | true       | ConfigMap             | [create delete deletecollection get list patch update watch] |
| deployments            | deploy     | apps     | true       | Deployment            | [create delete deletecollection get list patch update watch] |
| namespaces             | ns         |          | false      | Namespace             | [create delete get list patch update watch]                  |
| persistentvolumeclaims | pvc        |          | true       | PersistentVolumeClaim | [create delete deletecollection get list patch update watch] |
| persistentvolumes      | pv         |          | false      | PersistentVolume      | [create delete deletecollection get list patch update watch] |
| pods                   | po         |          | true       | Pod                   | [create delete deletecollection get list patch update watch] |
| secrets                |            |          | true       | Secret                | [create delete deletecollection get list patch update watch] |
| services               | svc        |          | true       | Service               | [create delete get list patch update watch]                  |

### API Server

To get API resources supported by your Kubernetes cluster:

```console
kubectl api-resources -o wide
```

To get API versions supported by your Kubernetes cluster:

```console
kubectl api-versions
```

```console
kubectl explain <resource>
kubectl explain deploy --api-version apps/v1
```

## Debug MetalLB

```console
kubectl logs <controller> -n metallb-system
```

## Services and ports

> Port definitions in Pods have names, and you can reference these names in the targetPort attribute of a Service. This works even if there is a mixture of Pods in the Service using a single configured name, with the same network protocol available via different port numbers. This offers a lot of flexibility for deploying and evolving your Services. For example, you can change the port numbers that Pods expose in the next version of your backend software, without breaking clients.  [(Source)](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service)

## ConfigMap

Create a ConfigMap from a file:

```console
kubectl create configmap name --from-file=file.conf
```
