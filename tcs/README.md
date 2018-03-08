helm install --name tcs ./tcs \
    --set image.repository="cloudgenius/wordpress" \
    --set image.tag="4.9.1" \
    --namespace tcs



helm delete --purge tcs




helm upgrade tcs ./tcs   --install --namespace tcs


NAME:   tcs
LAST DEPLOYED: Thu Mar  8 11:54:58 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME  TYPE       CLUSTER-IP   EXTERNAL-IP  PORT(S)  AGE
tcs   ClusterIP  10.94.19.26  <none>       80/TCP   0s

==> v1beta2/Deployment
NAME  DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
tcs   1        1        1           0          0s

==> v1beta1/Ingress
NAME  HOSTS               ADDRESS  PORTS  AGE
tcs   tcs.cloudgenius.co  80, 443  0s

==> v1/Pod(related)
NAME                  READY  STATUS             RESTARTS  AGE
tcs-57595598f5-dp22s  0/1    ContainerCreating  0         0s
tcs-57595598f5-vb7fl  0/1    Terminating        0         2m


NOTES:
1. Get the application URL by running these commands:
  https://tcs.cloudgenius.co/
