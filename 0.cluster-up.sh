export MY_ADDR=$(curl -s https://api.ipify.org)/32
echo "Your public facing IP is: " $MY_ADDR

export MY_PROJECT=$(gcloud config get-value project 2> /dev/null)
echo "Your selected gcloud project is: " $MY_PROJECT

#---------------------------------------------------
# Bring up a cluster using MY_ADDR for Master Authorized Networks
#---------------------------------------------------
gcloud container clusters create "bingo" \
    --project "$MY_PROJECT" \
    --zone "us-west1-a" \
    --cluster-version "1.9.3-gke.0" \
    --machine-type "n1-standard-1" \
    --image-type "COS" \
    --disk-size "100" \
    --scopes "https://www.googleapis.com/auth/bigquery","https://www.googleapis.com/auth/bigtable.admin","https://www.googleapis.com/auth/bigtable.data","https://www.googleapis.com/auth/cloud_debugger","https://www.googleapis.com/auth/cloud-platform","https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/datastore","https://www.googleapis.com/auth/devstorage.full_control","https://www.googleapis.com/auth/logging.admin","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/pubsub","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management","https://www.googleapis.com/auth/source.full_control","https://www.googleapis.com/auth/sqlservice.admin","https://www.googleapis.com/auth/taskqueue","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/userinfo.email" \
    --min-cpu-platform "Intel Skylake" \
    --num-nodes "3" \
    --network "cloudgenius" \
    --enable-cloud-logging \
    --enable-cloud-monitoring \
    --enable-ip-alias \
    --subnetwork=cg \
    --cluster-secondary-range-name=cg-pods \
    --services-secondary-range-name=cg-services \
    --enable-network-policy \
    --enable-master-authorized-networks \
    --master-authorized-networks "$MY_ADDR" \
    --enable-autoscaling \
    --min-nodes "1" \
    --max-nodes "11" \
    --enable-autoupgrade \
    --enable-autorepair \
    --maintenance-window "08:00" \
    --addons HttpLoadBalancing \
    --addons HorizontalPodAutoscaling \
    --addons KubernetesDashboard \
    --no-enable-basic-auth
