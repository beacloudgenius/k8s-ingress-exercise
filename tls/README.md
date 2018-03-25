Inspect list of secrets

    kubectl get secrets --all-namespaces  | grep tls 

    kubectl get secrets -n default
    kubectl get secrets -n jenkins

    kubectl get secret jenkins.cloudgenius.co --namespace jenkins

    kubectl get secret tutumwp.cloudgenius.co --namespace default

Save kubernetes.io/tls secrets locally

    kubectl get secret jenkins.cloudgenius.co -n jenkins -o yaml > tls/jenkins.cloudgenius.co.yaml

    kubectl get secret tutumwp.cloudgenius.co -n default -o yaml > tls/tutumwp.cloudgenius.co.yaml

    kubectl get secret tcs.cloudgenius.co -n default -o yaml > tls/tcs.cloudgenius.co.yaml

Reuse kubernetes.io/tls secrets saved earlier

    kubectl apply -f tls/tutumwp.cloudgenius.co.yaml
    kubectl apply -f tls/tcs.cloudgenius.co.yaml

    kubectl create ns jenkins
    kubectl apply -f tls/jenkins.cloudgenius.co.yaml


Check cert logs

    kubectl get po -n kube-system
    kubectl logs cert-manager-cm-7bb467b45c-sz9zm -c cert-manager -n kube-system







    I0308 17:54:21.942523       1 leaderelection.go:174] attempting to acquire leader lease...
    I0308 17:54:21.945833       1 server.go:68] Listening on http://0.0.0.0:9402
    I0308 17:54:38.671154       1 leaderelection.go:184] successfully acquired lease kube-system/cert-manager-controller
    I0308 17:54:38.778169       1 controller.go:138] clusterissuers controller: syncing item 'letsencrypt-prod'
    I0308 17:54:39.305390       1 helpers.go:122] Setting lastTransitionTime for ClusterIssuer "letsencrypt-prod" condition "Ready" to 2018-03-08 17:54:39.305306538 +0000 UTC m=+17.465426218
    I0308 17:54:39.311852       1 controller.go:152] clusterissuers controller: Finished processing work item "letsencrypt-prod"
    I0308 17:54:39.313260       1 controller.go:138] clusterissuers controller: syncing item 'letsencrypt-prod'
    I0308 17:54:39.662611       1 controller.go:152] clusterissuers controller: Finished processing work item "letsencrypt-prod"
    I0308 17:54:43.114815       1 controller.go:187] certificates controller: syncing item 'jenkins/jenkins.cloudgenius.co'
    I0308 17:54:43.115449       1 sync.go:200] Certificate scheduled for renewal in 1437 hours
    I0308 17:54:43.116952       1 controller.go:201] certificates controller: Finished processing work item "jenkins/jenkins.cloudgenius.co"
    I0308 17:54:43.117135       1 controller.go:187] certificates controller: syncing item 'default/tutumwp.cloudgenius.co'
    I0308 17:54:43.117587       1 sync.go:200] Certificate scheduled for renewal in 1437 hours
    I0308 17:54:43.117927       1 controller.go:201] certificates controller: Finished processing work item "default/tutumwp.cloudgenius.co"
    I0308 17:54:43.710264       1 controller.go:187] certificates controller: syncing item 'default/tutumwp.cloudgenius.co'
    I0308 17:54:43.711033       1 sync.go:200] Certificate scheduled for renewal in 1437 hours
    I0308 17:54:43.711186       1 controller.go:201] certificates controller: Finished processing work item "default/tutumwp.cloudgenius.co"
    I0308 17:54:54.667609       1 controller.go:187] certificates controller: syncing item 'jenkins/jenkins.cloudgenius.co'
    I0308 17:54:54.670989       1 sync.go:200] Certificate scheduled for renewal in 1437 hours
    I0308 17:54:54.671402       1 controller.go:201] certificates controller: Finished processing work item "jenkins/jenkins.cloudgenius.co"
    I0308 17:55:16.325470       1 controller.go:187] certificates controller: syncing item 'default/tutumwp.cloudgenius.co'
    I0308 17:55:16.325875       1 sync.go:200] Certificate scheduled for renewal in 1437 hours
    I0308 17:55:16.325907       1 controller.go:201] certificates controller: Finished processing work item "default/tutumwp.cloudgenius.co"
    I0308 17:55:16.327687       1 controller.go:187] certificates controller: syncing item 'jenkins/jenkins.cloudgenius.co'
    I0308 17:55:16.328042       1 sync.go:200] Certificate scheduled for renewal in 1437 hours
    I0308 17:55:16.328063       1 controller.go:201] certificates controller: Finished processing work item "jenkins/jenkins.cloudgenius.co"
    I0308 18:41:25.652461       1 controller.go:187] certificates controller: syncing item 'default/tutumwp.cloudgenius.co'
    I0308 18:41:25.652996       1 sync.go:200] Certificate scheduled for renewal in 1436 hours
    I0308 18:41:25.653038       1 controller.go:201] certificates controller: Finished processing work item "default/tutumwp.cloudgenius.co"
    I0308 18:41:25.685642       1 controller.go:187] certificates controller: syncing item 'default/tutumwp.cloudgenius.co'
    E0308 18:41:25.685699       1 controller.go:218] certificate 'default/tutumwp.cloudgenius.co' in work queue no longer exists
    I0308 18:41:25.685727       1 controller.go:201] certificates controller: Finished processing work item "default/tutumwp.cloudgenius.co"
    I0308 18:42:29.607102       1 controller.go:187] certificates controller: syncing item 'default/tutumwp.cloudgenius.co'
    I0308 18:42:29.607567       1 sync.go:200] Certificate scheduled for renewal in 1436 hours
    I0308 18:42:29.607610       1 controller.go:201] certificates controller: Finished processing work item "default/tutumwp.cloudgenius.co"
    I0308 18:43:16.316631       1 controller.go:187] certificates controller: syncing item 'default/tutumwp.cloudgenius.co'
    I0308 18:43:16.317166       1 sync.go:200] Certificate scheduled for renewal in 1436 hours
    I0308 18:43:16.317207       1 controller.go:201] certificates controller: Finished processing work item "default/tutumwp.cloudgenius.co"
    I0308 19:54:58.497111       1 controller.go:187] certificates controller: syncing item 'default/tcs.cloudgenius.co'
    I0308 19:54:58.497835       1 sync.go:107] Error checking existing TLS certificate: secret "tcs.cloudgenius.co" not found
    I0308 19:54:58.498080       1 sync.go:238] Preparing certificate with issuer
    I0308 19:54:58.498904       1 prepare.go:239] Compare "" with "https://acme-v01.api.letsencrypt.org/acme/reg/30760937"
    I0308 19:55:29.974971       1 sync.go:248] Issuing certificate...
    I0308 19:55:46.723354       1 helpers.go:165] Setting lastTransitionTime for Certificate "tcs.cloudgenius.co" condition "Ready" to 2018-03-08 19:55:46.723322061 +0000 UTC m=+7284.883441740
    I0308 19:55:46.733085       1 sync.go:269] Certificated issued successfully
    I0308 19:55:46.741702       1 sync.go:200] Certificate scheduled for renewal in 1438 hours
    I0308 19:55:46.741918       1 controller.go:201] certificates controller: Finished processing work item "default/tcs.cloudgenius.co"
    I0308 19:55:46.742069       1 controller.go:187] certificates controller: syncing item 'default/tcs.cloudgenius.co'
    I0308 19:55:46.742559       1 sync.go:200] Certificate scheduled for renewal in 1438 hours
    I0308 19:55:46.742716       1 controller.go:201] certificates controller: Finished processing work item "default/tcs.cloudgenius.co"
