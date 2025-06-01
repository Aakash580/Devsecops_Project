# Devsecops_Project
Deploying a StarBucks-Clone on EKS using DevSecOps methodology
In this project I am deploying StarBucks-Clone application on an EKS cluster using DevSecOps methodology. I am making use of security tools like SonarQube, OWASP Dependency Check and Trivy. I am monitoring EKS cluster using monitoring tools like Prometheus and Grafana. Most importantly I am deploying the Application using ArgoCD for the Deployment. image

# Step 0 : ADD the github WEBHOOK in the github REpo Setting --> Add the jenkins URL in The Webhook URL
# Step 1: Launch an EC2 Instance and install Jenkins, SonarQube, Docker and Trivy
I am making use of Terraform to launch the EC2 instance. We would be adding a script as userdata for the installation of Jenkins, SonarQube, Trivy and Docker.

# Step 2: Access Jenkins at port 8080 and install required plugins
Install the following plugins:

1.NodeJS 2.Eclipse Temurin Installer 3.SonarQube Scanner 4.OWASP Dependency Check 5.Docker 6.Docker Commons 7.Docker Pipeline 8.Docker API 9.Docker-build-step

# Step 3: Set up SonarQube
For the SonarQube Configuration, first access the Sonarqube Dashboard using the url http://elastic_ip:9000

Create the token Administration -> Security -> Users -> Create a token

Add this token as a credential in Jenkins

Go to Manage Jenkins -> System -> SonarQube installation Add URL of SonarQube and for the credential select the one added in step 2.

Go to Manage Jenkins -> Tools -> SonarQube Scanner Installations -> Install automatically.

# Step 4: Set up OWASP Dependency Check
Go to Manage Jenkins -> Tools -> Dependency-Check Installations -> Install automatically

# Step 5: Set up Docker for Jenkins
Go to Manage Jenkins -> Tools -> Docker Installations -> Install automatically

And then go to Manage Jenkins -> Credentials -> System -> Global Credentials -> Add credentials. Add username and password for the docker registry (You need to create an account on Dockerhub).

# Step 6: Create a pipeline in order to build and push the dockerized image securely using multiple security tools
Go to Dashboard -> New Item -> Pipeline

Use the code written as the Jenkins pipeline.txt

# Step 7: Create an EKS Cluster using Terraform
Prerequisite: Install kubectl and helm before executing the commands below .

# Step 8: Deploy Prometheus and Grafana on EKS
In order to access the cluster use the command below:

aws eks update-kubeconfig --name "Cluster-Name" --region "Region-of-operation"

We need to add the Helm Stable Charts for your local.
helm repo add stable https://charts.helm.sh/stable

Add prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

Create Prometheus namespace
kubectl create namespace prometheus

Install kube-prometheus stack
helm install stable prometheus-community/kube-prometheus-stack -n prometheus

Edit the service and make it LoadBalancer
kubectl edit svc kube-prometheus-stack-prometheus -n prometheus

Edit the grafana service too to change it to LoadBalancer
kubectl edit svc kube-prometheus-stack-grafana -n prometheus

# Step 9: Deploy ArgoCD on EKS to fetch the manifest files to the cluster
Create a namespace argocd
kubectl create namespace argocd

Add argocd repo locally
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml

By default, argocd-server is not publically exposed. In this scenario, we will use a Load Balancer to make it usable:
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

We get the load balancer hostname using the command below:
kubectl get svc argocd-server -n argocd -o json

Once you get the load balancer hostname details, you can access the ArgoCD dashboard through it.
