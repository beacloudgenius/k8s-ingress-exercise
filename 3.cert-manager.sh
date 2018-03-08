helm install \
    --name cm \
    --namespace kube-system \
    --set ingressShim.extraArgs='{--default-issuer-name=letsencrypt-prod,--default-issuer-kind=ClusterIssuer}' \
    stable/cert-manager

kubectl apply -f ingress/cluster-issuer.yaml
