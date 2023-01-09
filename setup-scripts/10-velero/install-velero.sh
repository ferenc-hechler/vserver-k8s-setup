#!/bin/bash

set -xev
cd $(dirname -- $0)

### install client
# wget https://github.com/vmware-tanzu/velero/releases/download/v1.9.5/velero-v1.9.5-linux-amd64.tar.gz
# tar -xvzf velero-v1.9.5-linux-amd64.tar.gz
# sudo mv velero-v1.9.5-linux-amd64/velero /usr/local/bin/
# rm -rf velero-v1.9.5-linux-amd64.tar.gz velero-v1.9.5-linux-amd64


VELEROUSER_PASSWORD=$(00-utils/define-password.sh minio velerouser-secret velerouser-password)

cat <<EOF > credentials-velero
[default]
aws_access_key_id = velerouser
aws_secret_access_key = $VELEROUSER_PASSWORD
EOF

#velero install \
#    --provider aws \
#    --plugins velero/velero-plugin-for-aws:v1.2.1 \
#    --bucket velero-backup \
#    --secret-file ./credentials-velero \
#    --use-volume-snapshots=true \
#    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio-api-service.minio.svc:80 \
#    --snapshot-location-config region="minio",s3ForcePathStyle="true",s3Url=http://minio-api-service.minio.svc:80 \
#    --use-restic

velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.2.1 \
    --bucket velero \
    --secret-file ./credentials-velero \
    --use-volume-snapshots=true \
    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=https://s3.k8s2.feri.ai:443 \
    --snapshot-location-config region="minio" \
    --use-restic

    

#    --snapshot-location-config bucket=velero-snapshots,region="minio",s3ForcePathStyle="true",s3Url=http://minio-api-service.minio.svc:80 \

# velero snapshot-location create snapsloc --provider aws --config bucket=velero-snapshots,region=minio,s3ForcePathStyle="true",s3Url=http://minio-api-service.minio.svc:80


# velero backup create persistdemo-backup-9 --include-namespaces persistdemo --ttl 1h --snapshot-volumes --volume-snapshot-locations snapsloc 

velero schedule create daily-backup --schedule="40 * * * *" --snapshot-volumes
 

