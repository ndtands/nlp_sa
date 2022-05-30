# nlp_sa
- BERT + Sentiment analysis
- Bert model save in gg drive: https://drive.google.com/uc?export=download&id=1MH4PyjkcmrfhCcpqvO8iVfFf-pkOiM5y
- Api with flaskAPI

## 1. Setup in gcp
- Create VM:
  + E2-standard4
  + ubuntu20.4 20GB
- Create VPC Network
  + Port range: 5000 - 8000
- Open SSH of VM and setup:
```
sudo apt-get update
sudo apt-get install docker.io
gcloud auth configure-docker
sudo -s
apt-get update
apt-get install -y protobuf-compiler python3-pil python3-lxml python3-pip python3-dev git
pip3 install -U pip
```
- Build docker and run container
```
sudo docker build -t nlp-sa:latest .
sudo docker run --rm -p 5002:5002 nlp-sa:latest
```
- Run app with url: http://[EXTERNAL_IP]:5002



## 2. Deployment app to kubernets in GCP
Open Cloud Console and run step by step:
### 2.1 Install kubectl
```
gcloud components install kubectl
```

### 2.2 Create a repository
```
#Set project_id
export PROJECT_ID=mlops-concept

# Set your project ID for Google Cloud CLI
gcloud config set project $PROJECT_ID

#Create nlp-repo on artifacts register
gcloud artifacts repositories create nlp-repo \
   --repository-format=docker \
   --location=us-central1 \
   --description="Docker repository"
   
```
### 2.3 Building the container image
```
git clone https://github.com/ndtands/nlp_sa.git
cd nlp_sa
docker build -t us-central1-docker.pkg.dev/${PROJECT_ID}/nlp-repo/nlp-app:v1 .

#Check image
docker images

#Run your contianer locally
docker run --rm -p 5002:5002 us-central1-docker.pkg.dev/${PROJECT_ID}/nlp-repo/nlp-app:v1
```
you can check app by : http://localhost:5002

### 2.4 Pushing the Docker image to Artifact Registry
```
#Config the Docker to authenticate to Artifact Registry
gcloud auth configure-docker us-central1-docker.pkg.dev

#Push Docker image 
docker push us-central1-docker.pkg.dev/${PROJECT_ID}/nlp-repo/nlp-app:v1

```

### 2.5 Creating a GKE cluster
```
#Config zone and region
gcloud config set compute/zone us-central1-a
gcloud config set compute/region us-central1

#Create new cluster
gcloud container clusters create nlp-cluster

#check nodes 
kubectl get nodes
```

### 2.6 Deploying the app to GKE
```
#Check connect with your GKE cluster
gcloud container clusters get-credentials nlp-cluster --zone us-central1-a

#Create a kubernets Deployment for your nlp-app Docker image
kubectl create deployment nlp-app --image=us-central1-docker.pkg.dev/${PROJECT_ID}/nlp-repo/nlp-app:v1

#Setting some config
kubectl scale deployment nlp-app --replicas=3

#Deploy HorizontalPodAutoscaler
kubectl autoscale deployment nlp-app --cpu-percent=80 --min=1 --max=5

#Check pods
kubectl get pods

#Using LoadBalancer 
kubectl expose deployment nlp-app --name=nlp-app-service --type=LoadBalancer --port 5002 --target-port 8080

#Check svc
kubectl get service
```
=> Try app using: http:[external-ip]:5002
```
#You can update with new image
kubectl set image deployment/nlp-app nlp-app=us-central1-docker.pkg.dev/${PROJECT_ID}/nlp-repo/nlp-app:v2

```
### 2.7 Clean up
```
#Delete Scv
kubectl delete service nlp-app-service

#Delete cluster
gcloud container clusters delete nlp-cluster --zone us-central1-a

#Delete your container images
gcloud artifacts docker images delete \
    us-central1-docker.pkg.dev/${PROJECT_ID}/nlp-repo/nlp-app:v1 \
    --delete-tags --quiet
```
