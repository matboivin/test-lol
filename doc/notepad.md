# Notes

## Docker entrypoints

> This script uses the exec Bash command so that the final running application becomes the container’s PID 1. This allows the application to receive any Unix signals sent to the container. For more, see the ENTRYPOINT reference. [(Source)](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint)

- [What purpose does using exec in docker entrypoint scripts serve?](https://stackoverflow.com/a/32255981)

## API Resources

> The resources will be created in the order they appear in the file. Therefore, it's best to specify the service first, since that will ensure the scheduler can spread the pods associated with the service as they are created by the controller(s), such as Deployment.  [(Source)](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)

To get API resources supported by your Kubernetes cluster:

```console
kubectl api-resources -o wide
```

| NAME                   | SHORTNAMES | APIGROUP | NAMESPACED | KIND                  | VERBS                                                        |
| :--------------------  | :--------- | :------- | :--------- | :-------------------- | :----------------------------------------------------------- |
| configmaps             | cm         |          | true       | ConfigMap             | [create delete deletecollection get list patch update watch] |
| deployments            | deploy     | apps     | true       | Deployment            | [create delete deletecollection get list patch update watch] |
| statefulsets           | sts        | apps     | true       | StatefulSet           | [create delete deletecollection get list patch update watch] |
| daemonsets             | ds         | apps     | true       | DaemonSet             | [create delete deletecollection get list patch update watch] |
| namespaces             | ns         |          | false      | Namespace             | [create delete get list patch update watch]                  |
| persistentvolumeclaims | pvc        |          | true       | PersistentVolumeClaim | [create delete deletecollection get list patch update watch] |
| persistentvolumes      | pv         |          | false      | PersistentVolume      | [create delete deletecollection get list patch update watch] |
| pods                   | po         |          | true       | Pod                   | [create delete deletecollection get list patch update watch] |
| secrets                |            |          | true       | Secret                | [create delete deletecollection get list patch update watch] |
| services               | svc        |          | true       | Service               | [create delete get list patch update watch]                  |

### API Server

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

## Short and long options

`adduser`

```
Usage: adduser [OPTIONS] USER [GROUP]

Create new user, or add USER to GROUP

	-h	--home				DIR		Home directory
	-g	--gecos				GECOS	GECOS field
	-s	--shell				SHELL	Login shell
	-G	--ingroup			GRP		Group
	-S	--system			Create a system user
	-D	--disabled-password	Don't assign a password
	-H	--no-create-home	Don't create home directory
	-u	--uid				UID		User id
	-k						SKEL	Skeleton directory (/etc/skel)
```

`addgroup`

```
Usage: addgroup [-g GID] [-S] [USER] GROUP

Add a group or add a user to a group

	-g	--gid		GID	Group id
	-S	--system	Create a system group
```

`chpasswd`

```
Usage: chpasswd [--md5|--encrypted|--crypt-method|--root]

Read user:password from stdin and update /etc/passwd

	-e,--encrypted		Supplied passwords are in encrypted form
	-m,--md5		Encrypt using md5, not des
	-c,--crypt-method ALG	des,md5,sha256/512 (default sha512)
	-R,--root DIR		Directory to chroot into
```
