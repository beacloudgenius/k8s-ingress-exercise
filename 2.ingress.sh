#sleep 60 #more at https://github.com/kubernetes/helm/blob/master/docs/rbac.md

#export STATIC_IP=$(gcloud compute addresses list | awk '{print $3}' | awk '!/ADDRESS/')

#echo The static IP assigned to your cluster is: $STATIC_IP

helm install --name ng stable/nginx-ingress \
    --set rbac.create=true \
    --set controller.image.repository="quay.io/kubernetes-ingress-controller/nginx-ingress-controller" \
    --set controller.service.loadBalancerIP="$STATIC_IP" \
    --set controller.image.tag="0.11.0"
