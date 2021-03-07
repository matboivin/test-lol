# Notes

## API Resources

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

## Docker entrypoints

> This script uses the exec Bash command so that the final running application becomes the container’s PID 1. This allows the application to receive any Unix signals sent to the container. For more, see the ENTRYPOINT reference.  [Dockerfile reference for the ENTRYPOINT instruction](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint)
