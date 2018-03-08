Inspect list of secrets

    kubectl get secrets --all-namespaces

    kubectl get secrets -n default
    kubectl get secrets -n jenkins

    kubectl get secret jenkins.cloudgenius.co --namespace jenkins

    kubectl get secret tutumwp.cloudgenius.co --namespace default

Save kubernetes.io/tls secrets locally

    kubectl get secret jenkins.cloudgenius.co -n jenkins -o yaml > tls/jenkins.cloudgenius.co.yaml

    kubectl get secret tutumwp.cloudgenius.co -n default -o yaml > tls/tutumwp.cloudgenius.co.yaml

Reuse kubernetes.io/tls secrets saved earlier

    kubectl apply -f tls/tutumwp.cloudgenius.co.yaml

    kubectl create ns jenkins
    kubectl apply -f tls/jenkins.cloudgenius.co.yaml
