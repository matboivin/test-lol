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
