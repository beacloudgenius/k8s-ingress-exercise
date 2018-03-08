setup gcloud sdk

    sudo apt-get update && sudo apt-get --only-upgrade install kubectl google-cloud-sdk google-cloud-sdk-datastore-emulator google-cloud-sdk-pubsub-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-app-engine-java google-cloud-sdk-app-engine-python google-cloud-sdk-cbt google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-python-extras google-cloud-sdk-datalab

configure gcloud

    gcloud auth login
    gcloud projects create cloudgeniuslabs

    The name `cloudgeniuslabs` is taken. so try appending a random string like `cloudgeniuslabs-123`

    gcloud projects create cloudgeniuslabs-123
    gcloud config set project cloudgeniuslabs-123
    gcloud config set compute/zone us-west1-a
    gcloud config set container/new_scopes_behavior true

    export CLOUDSDK_COMPUTE_REGION=us-west1
    export CLOUDSDK_COMPUTE_ZONE=us-west1-a
    export MY_PROJECT=$(gcloud info |tr -d '[]' | awk '/project:/ {print $2}')

    rm -rf ~/.kube
    gcloud config list

        [compute]
        region = us-west1
        zone = us-west1-a
        [container]
        new_scopes_behavior = true
        [core]
        account = you@gmail.com
        disable_usage_reporting = True
        project = cloudgeniuslabs-123

        Your active configuration is: [default]


Establish a virtual private network

    gcloud compute networks create cloudgenius \
        --project=$MY_PROJECT  \
        --subnet-mode=auto

        API [compute.googleapis.com] not enabled on project [452310984214].
        Would you like to enable and retry?  (y/N)?  Y

        Enabling service compute.googleapis.com on project 452310984214...
        ERROR: (gcloud.compute.networks.create) FAILED_PRECONDITION: Operation does not satisfy the following requirements: billing-enabled {Billing must be enabled for activation of service '' in project 'cloudgeniuslabs-123' to proceed., https://console.developers.google.com/project/cloudgeniuslabs-123/settings}

You need to enable billing for your selected project and run the command again.

It might prompt you to enable api so please enable and retry.
        API [compute.googleapis.com] not enabled on project [452310984214].
        Would you like to enable and retry?  (y/N)?  y

In a short time, you would see that it created a network named `cloudgenius` for you.

You can inspect that creation by running

    gcloud compute networks list

        NAME         SUBNET_MODE  BGP_ROUTING_MODE  IPV4_RANGE  GATEWAY_IPV4
        cloudgenius  AUTO         REGIONAL
        default      AUTO         REGIONAL


Create firewall rules

    gcloud compute --project=$MY_PROJECT firewall-rules create cloudgenius-allow-icmp \
      --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. \
      --direction=INGRESS \
      --priority=65534 \
      --network=cloudgenius \
      --action=ALLOW \
      --rules=icmp \
      --source-ranges=0.0.0.0/0

    Creating firewall...done.
    NAME                    NETWORK      DIRECTION  PRIORITY  ALLOW  DENY
    cloudgenius-allow-icmp  cloudgenius  INGRESS    65534     icmp

    gcloud compute --project=$MY_PROJECT firewall-rules create cloudgenius-allow-internal \
      --description=Allows\ connections\ from\ any\ source\ in\ the\ network\ IP\ range\ to\ any\ instance\ on\ the\ network\ using\ all\ protocols. \
      --direction=INGRESS \
      --priority=65534 \
      --network=cloudgenius \
      --action=ALLOW \
      --rules=all \
      --source-ranges=10.128.0.0/9

    Creating firewall...done.
    NAME                        NETWORK      DIRECTION  PRIORITY  ALLOW  DENY
    cloudgenius-allow-internal  cloudgenius  INGRESS    65534     all

    gcloud compute --project=$MY_PROJECT firewall-rules create cloudgenius-allow-ssh \
      --description=Allows\ TCP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 22. \
      --direction=INGRESS \
      --priority=65534 \
      --network=cloudgenius \
      --action=ALLOW \
      --rules=tcp:22 \
      --source-ranges=0.0.0.0/0

    Creating firewall...done.
    NAME                   NETWORK      DIRECTION  PRIORITY  ALLOW   DENY
    cloudgenius-allow-ssh  cloudgenius  INGRESS    65534     tcp:22

Carve a subnet

    gcloud compute networks subnets create cg \
        --network=cloudgenius \
        --range 10.64.0.0/19 \
        --secondary-range cg-pods=10.52.0.0/14 \
        --secondary-range cg-services=10.94.0.0/18

    Created [https://www.googleapis.com/compute/v1/projects/cloudgeniuslabs-123/regions/us-west1/subnetworks/cg].
    NAME  REGION    NETWORK      RANGE
    cg    us-west1  cloudgenius  10.64.0.0/19

Enable Kubernetes Engine API

    The Kubernetes Engine API is not enabled for project cloudgeniuslabs-123 by default. Please ensure it is enabled in the Google Cloud Console at https://console.cloud.google.com/apis/api/container.googleapis.com/overview?project=cloudgeniuslabs-123


Stand up a cluster

    sh 0.cluster-up.sh

    Creating cluster bingo...done.
    Created [https://container.googleapis.com/v1/projects/cloudgeniuslabs-123/zones/us-west1-a/clusters/bingo].
    To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-west1-a/bingo?project=cloudgeniuslabs-123
    kubeconfig entry generated for bingo.
    NAME   LOCATION    MASTER_VERSION  MASTER_IP      MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
    bingo  us-west1-a  1.9.3-gke.0     35.227.144.50  n1-standard-1  1.9.3-gke.0   3          RUNNING


Save credentials

    gcloud container clusters get-credentials bingo --zone us-west1-a --project $MY_PROJECT

Make typing easier

    alias k=kubectl

Confirm the context

    kubectl config current-context


Reserve a static IP address

    gcloud compute --project $MY_PROJECT \
        addresses create cg --region=us-west1


Note the reserved IP address

    gcloud compute addresses list

    NAME  REGION    ADDRESS        STATUS
    cg    us-west1  35.230.33.236  RESERVED

Save static ip in an environment variable

    export STATIC_IP=$(gcloud compute addresses list | awk '{print $3}' | awk '!/ADDRESS/')

    echo The static IP assigned to your cluster is: $STATIC_IP

Assign this IP as an `A Record` to a DNS name in your domain.

    `*.cloudgenius.co       A           35.199.151.173`

Setup helm

    sh 1.helm.sh

Set up nginx ingress and cert-manager using helm

    sh 2.ingress.sh

Watch if IP is properly assigned to the ingress

    kubectl get services -o wide -w ng-nginx-ingress-controller

    Break previous watch step by pressing control-C

Set up cert-manager using helm

    sh 3.cert-manager.sh

Now you can bring up any services you like within your cluster and automatically expose then via HTTPS endpoint..

Let's look at a Jenkins example

    helm --namespace jenkins --name jenkins -f jenkins/jenkins-values.yaml install stable/jenkins

Grab Jenkins admin password

    printf $(kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo


    mg6rvOEOlA

    open https://jenkins.cloudgenius.co

Delete jenkins

    helm delete --purge jenkins

Remove the cluster

    sh cluster-down.sh
