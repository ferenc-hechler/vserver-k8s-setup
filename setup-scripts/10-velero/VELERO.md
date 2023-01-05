# Velero

see: https://velero.io/docs/v1.10/basic-install/#option-2-github-release

## Install Velero Client

```
wget https://github.com/vmware-tanzu/velero/releases/download/v1.9.5/velero-v1.9.5-linux-amd64.tar.gz
tar -xvzf velero-v1.9.5-linux-amd64.tar.gz
sudo mv velero-v1.9.5-linux-amd64/velero /usr/local/bin/
rm -rf velero-v1.9.5-linux-amd64.tar.gz velero-v1.9.5-linux-amd64
```

## Install Velero Server

see: https://vmware-tanzu.github.io/helm-charts/
https://velero.io/docs/v1.10/contributions/minio/

```
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
```

### create credentials file

create a user "velero" in minio with read/write policy and a bucket named velero. 
create access-key for user velero and store them in credentials-velero:

```
[default]
aws_access_key_id = minio
aws_secret_access_key = minio123
```

### install velero server

```
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.2.1 \
    --bucket velero \
    --secret-file ./credentials-velero \
    --use-volume-snapshots=false \
    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio-api-service.minio.svc:80
```

output:

```
CustomResourceDefinition/backups.velero.io: attempting to create resource
CustomResourceDefinition/backups.velero.io: attempting to create resource client
CustomResourceDefinition/backups.velero.io: created
CustomResourceDefinition/backupstoragelocations.velero.io: attempting to create resource
CustomResourceDefinition/backupstoragelocations.velero.io: attempting to create resource client
CustomResourceDefinition/backupstoragelocations.velero.io: created
CustomResourceDefinition/deletebackuprequests.velero.io: attempting to create resource
CustomResourceDefinition/deletebackuprequests.velero.io: attempting to create resource client
CustomResourceDefinition/deletebackuprequests.velero.io: created
CustomResourceDefinition/downloadrequests.velero.io: attempting to create resource
CustomResourceDefinition/downloadrequests.velero.io: attempting to create resource client
CustomResourceDefinition/downloadrequests.velero.io: created
CustomResourceDefinition/podvolumebackups.velero.io: attempting to create resource
CustomResourceDefinition/podvolumebackups.velero.io: attempting to create resource client
CustomResourceDefinition/podvolumebackups.velero.io: created
CustomResourceDefinition/podvolumerestores.velero.io: attempting to create resource
CustomResourceDefinition/podvolumerestores.velero.io: attempting to create resource client
CustomResourceDefinition/podvolumerestores.velero.io: created
CustomResourceDefinition/resticrepositories.velero.io: attempting to create resource
CustomResourceDefinition/resticrepositories.velero.io: attempting to create resource client
CustomResourceDefinition/resticrepositories.velero.io: created
CustomResourceDefinition/restores.velero.io: attempting to create resource
CustomResourceDefinition/restores.velero.io: attempting to create resource client
CustomResourceDefinition/restores.velero.io: created
CustomResourceDefinition/schedules.velero.io: attempting to create resource
CustomResourceDefinition/schedules.velero.io: attempting to create resource client
CustomResourceDefinition/schedules.velero.io: created
CustomResourceDefinition/serverstatusrequests.velero.io: attempting to create resource
CustomResourceDefinition/serverstatusrequests.velero.io: attempting to create resource client
CustomResourceDefinition/serverstatusrequests.velero.io: created
CustomResourceDefinition/volumesnapshotlocations.velero.io: attempting to create resource
CustomResourceDefinition/volumesnapshotlocations.velero.io: attempting to create resource client
CustomResourceDefinition/volumesnapshotlocations.velero.io: created
Waiting for resources to be ready in cluster...
Namespace/velero: attempting to create resource
Namespace/velero: attempting to create resource client
Namespace/velero: created
ClusterRoleBinding/velero: attempting to create resource
ClusterRoleBinding/velero: attempting to create resource client
ClusterRoleBinding/velero: created
ServiceAccount/velero: attempting to create resource
ServiceAccount/velero: attempting to create resource client
ServiceAccount/velero: created
Secret/cloud-credentials: attempting to create resource
Secret/cloud-credentials: attempting to create resource client
Secret/cloud-credentials: created
BackupStorageLocation/default: attempting to create resource
BackupStorageLocation/default: attempting to create resource client
BackupStorageLocation/default: created
Deployment/velero: attempting to create resource
Deployment/velero: attempting to create resource client
Deployment/velero: created
Velero is installed! ⛵ Use 'kubectl logs deployment/velero -n velero' to view the status.
```

verify success:

```
$ kubectl get backupstoragelocation -n velero

NAME      PHASE       LAST VALIDATED   AGE     DEFAULT
default   Available   8s               3m41s   true
```

## create first backup

```
$ velero create backup first-backup

Backup request "first-backup" submitted successfully.
Run `velero backup describe first-backup` or `velero backup logs first-backup` for more details.
```

```
$ velero backup describe first-backup

Name:         first-backup
Namespace:    velero
Labels:       velero.io/storage-location=default
Annotations:  velero.io/source-cluster-k8s-gitversion=v1.26.0
              velero.io/source-cluster-k8s-major-version=1
              velero.io/source-cluster-k8s-minor-version=26

Phase:  Completed

Errors:    0
Warnings:  0

Namespaces:
  Included:  *
  Excluded:  <none>

Resources:
  Included:        *
  Excluded:        <none>
  Cluster-scoped:  auto

Label selector:  <none>

Storage Location:  default

Velero-Native Snapshot PVs:  auto

TTL:  720h0m0s

Hooks:  <none>

Backup Format Version:  1.1.0

Started:    2023-01-05 18:27:51 +0100 CET
Completed:  2023-01-05 18:28:03 +0100 CET

Expiration:  2023-02-04 18:27:51 +0100 CET

Total items to be backed up:  730
Items backed up:              730

Velero-Native Snapshots: <none included>
```

```
$ velero backup get

NAME           STATUS      ERRORS   WARNINGS   CREATED                         EXPIRES   STORAGE LOCATION   SELECTOR
first-backup   Completed   0        0          2023-01-05 18:27:51 +0100 CET   29d       default            <none>
```

# test backup and restore for demoapp

``` 
$ velero backup create demoapp-backup --include-namespaces demoapp --ttl 2h
```

wait until finished

## delete demoapp

```
$ kubectl delete namespace demoapp

namespace "demoapp" deleted

```

## restore demoapp

```
$ velero restore create demoapp-restore-1 --from-backup demoapp-backup --include-namespaces demoapp 
```

```
$ kubectl get all -n demoapp

NAME                           READY   STATUS    RESTARTS   AGE
pod/demoapp-6fc94d4576-9t929   1/1     Running   0          12s

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/demoapp-service   ClusterIP   10.103.47.116   <none>        80/TCP    11s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/demoapp   1/1     1            1           11s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/demoapp-6fc94d4576   1         1         1       12s
```

