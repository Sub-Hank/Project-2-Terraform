Terraform Infrastructure Project — Docker + Kubernetes



This project demonstrates Infrastructure-as-Code (IaC) using Terraform with two environments:



Local Cloud using Docker



Kubernetes Cluster using k3d



Both parts include enhancements, testing, and documentation.



------------------------------------------------------------

PART 1 — Terraform Docker Project

------------------------------------------------------------

Overview



This part provisions a small “local cloud” using Docker and Terraform.

Terraform manages all containers, networks, and images.



Components



Frontend: Nginx (exposed on localhost:8080)



Backend: Python Flask microservice



Database: PostgreSQL



Custom Docker network: terraform-net



Project Structure

terraform-docker-project/

├─ backend-app/

│  ├─ app.py

│  └─ Dockerfile

├─ docker-project/

│  ├─ main.tf

│  ├─ modules/

│  │  ├─ frontend/

│  │  ├─ backend/

│  │  └─ database/

│  ├─ terraform.tfstate

│  └─ versions.tf

└─ README.md



Requirements



Docker installed



Terraform installed



Python 3.11+



Git



Setup

1\. Clone the repo

git clone <your-repo-url>

cd terraform-docker-project/docker-project



2\. (Optional) Create secrets.tfvars

db\_host     = "tf\_postgres"

db\_user     = "appuser"

db\_password = "S3cretPassw0rd"

db\_name     = "appdb"



3\. Build backend Docker image

cd ../backend-app

docker build -t backend-app .

cd ../docker-project



4\. Initialize Terraform

terraform init



5\. Apply the configuration

terraform apply -var-file="secrets.tfvars"



Type yes when prompted.



Verification

Check running containers

docker ps





Expected:



tf\_frontend



tf\_backend



tf\_postgres



Test backend API

curl http://localhost:5000/





Expected:



{"status":"ok","db":true}



est frontend



Open browser:

http://localhost:8080



Enhancement



Backend health check endpoint verifying realtime DB connectivity.



Custom Docker network improves isolation \& communication.



PART 2 — Kubernetes Terraform Project (k3d)

------------------------------------------------------------

Overview



This part provisions Kubernetes resources using Terraform on a k3d cluster.



Terraform Deploys:



Namespace



Deployment (nginx)



Service (NodePort)



ConfigMap (custom nginx.conf)



Mounted volume from ConfigMap



Project Structure

k8s-project/

├─ main.tf

├─ k3d-tf-cluster.kubeconfig

└─ README.md



Requirements



k3d installed



kubectl installed



Terraform installed



1\. Create k3d cluster

k3d cluster create tf-cluster --servers 1 --agents 1 --port "8080:80@loadbalancer"



2\. Export kubeconfig

k3d kubeconfig write tf-cluster > k3d-tf-cluster.kubeconfig



3\. Verify kubectl

kubectl get nodes



4\. Deploy with Terraform

cd k8s-project

terraform init

terraform apply



Verification

Get all resources

kubectl get all -n example-namespace



Expected Output



Deployment: nginx (1/1 ready)



Service: NodePort on port 30969



ConfigMap: nginx-config



Test the service

curl http://localhost:30969



Expected:

Hello from Nginx ConfigMap!



Enhancement



✔ Custom Nginx configuration delivered via ConfigMap

✔ Volume mount into the container

✔ Resource requests and limits set



------------------------------------------------------------

Testing

------------------------------------------------------------

Docker



Verified all containers run correctly



API reachable on port 5000



Frontend reachable at port 8080



Kubernetes



Verified pod running in namespace



NodePort service accessible externally



Nginx serving custom response from ConfigMap



------------------------------------------------------------

Reflection

------------------------------------------------------------



This project gave me hands-on experience using Terraform for real infrastructure deployments in both Docker and Kubernetes environments. I learned how to structure Terraform modules, manage state, configure providers, deploy containerized apps, expose services, and work with ConfigMaps and volumes in Kubernetes. This project strengthened my understanding of IaC, modular deployment patterns, and the differences between local container orchestration and Kubernetes orchestration.

