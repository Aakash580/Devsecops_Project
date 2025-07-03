# DevSecOps Starbucks Clone Project

![Project Banner](https://img.shields.io/badge/DevSecOps-Project-blue?style=for-the-badge&logo=kubernetes)
![AWS](https://img.shields.io/badge/AWS-EKS-orange?style=for-the-badge&logo=amazon-aws)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-blue?style=for-the-badge&logo=jenkins)
![ArgoCD](https://img.shields.io/badge/ArgoCD-GitOps-green?style=for-the-badge&logo=argo)

## 📋 Project Overview

This project demonstrates the deployment of a Starbucks Clone application on Amazon EKS (Elastic Kubernetes Service) using comprehensive DevSecOps methodology. The implementation incorporates security scanning, monitoring, and GitOps practices to ensure a robust, secure, and scalable deployment pipeline.

## 🏗️ Architecture

The project follows a complete DevSecOps workflow:

1. **Source Code Management**: GitHub with webhook integration
2. **CI/CD Pipeline**: Jenkins with security scanning stages
3. **Security Tools**: SonarQube, OWASP Dependency Check, Trivy, Docker Scout
4. **Container Registry**: DockerHub
5. **Infrastructure**: AWS EKS cluster provisioned with Terraform
6. **Monitoring**: Prometheus and Grafana
7. **GitOps Deployment**: ArgoCD
![image](https://github.com/user-attachments/assets/b1c7f3b9-0ddc-47e0-879d-2f63e4667f11)

## 🛠️ Tech Stack

### Infrastructure & Orchestration
- **AWS EKS** - Kubernetes cluster management
- **Terraform** - Infrastructure as Code
- **Docker** - Containerization

### CI/CD & DevOps Tools
- **Jenkins** - CI/CD pipeline automation
- **ArgoCD** - GitOps deployment
- **GitHub** - Source code management with webhook integration

### Security Tools
- **SonarQube** - Static code analysis
- **OWASP Dependency Check** - Vulnerability scanning
- **Trivy** - Container security scanning
- **Docker Scout** - Container image analysis

### Monitoring & Observability
- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **Helm** - Kubernetes package management

### Development
- **Node.js** - Runtime environment
- **npm** - Package management

## 🚀 Getting Started

### Prerequisites

Before starting, ensure you have the following tools installed:

- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate permissions
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - Kubernetes command-line tool
- [Helm](https://helm.sh/docs/intro/install/) - Kubernetes package manager
- [Terraform](https://www.terraform.io/downloads) - Infrastructure provisioning
- [Docker](https://docs.docker.com/get-docker/) - Container platform

### AWS Permissions Required

Ensure your AWS user/role has permissions for:
- EC2 (for Jenkins server)
- EKS (for Kubernetes cluster)
- VPC and networking resources
- IAM roles and policies

## 📝 Implementation Steps

### Step 0: GitHub Webhook Configuration
1. Navigate to your GitHub repository settings
2. Go to **Webhooks** → **Add webhook**
3. Add your Jenkins URL in the webhook URL field
4. Set content type to `application/json`
5. Select "Just the push event" or customize as needed

### Step 1: Infrastructure Setup
Launch EC2 instance with required tools using Terraform:

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/Devsecops_Project.git
cd Devsecops_Project

# Deploy infrastructure
terraform init
terraform plan
terraform apply
```

The Terraform script will install:
- Jenkins
- SonarQube
- Docker
- Trivy

### Step 2: Jenkins Configuration
Access Jenkins at `http://YOUR_EC2_IP:8080` and install required plugins:

#### Required Jenkins Plugins:
1. NodeJS
2. Eclipse Temurin Installer
3. SonarQube Scanner
4. OWASP Dependency Check
5. Docker
6. Docker Commons
7. Docker Pipeline
8. Docker API
9. Docker-build-step

### Step 3: SonarQube Setup.
1. Access SonarQube at `http://YOUR_EC2_IP:9000`
2. Login with default credentials (admin/admin)
3. Create a new token: **Administration** → **Security** → **Users** → **Create Token**
4. Add token as Jenkins credential
5. Configure SonarQube in Jenkins: **Manage Jenkins** → **System** → **SonarQube Installation**

### Step 4: OWASP Dependency Check Configuration.
Configure in Jenkins: **Manage Jenkins** → **Tools** → **Dependency-Check Installations** → **Install automatically**

### Step 5: Docker Registry Setup.
1. Create DockerHub account
2. Add DockerHub credentials in Jenkins: **Manage Jenkins** → **Credentials** → **Global** → **Add Credentials**
3. Configure Docker in Jenkins: **Manage Jenkins** → **Tools** → **Docker Installations**

### Step 6: Jenkins Pipeline Creation.

Create a new pipeline job in Jenkins and use the provided Jenkinsfile. The pipeline includes:

#### Pipeline Stages:
- **Clean Workspace**: Prepare clean environment
- **Git Checkout**: Pull latest code
- **SonarQube Analysis**: Static code analysis
- **Quality Gate**: Ensure code quality standards
- **NPM Dependencies**: Install application dependencies
- **OWASP Scan**: Dependency vulnerability check
- **Trivy File Scan**: File system security scan
- **Docker Build**: Create container image
- **Docker Push**: Push to DockerHub registry
- **Docker Scout**: Container security analysis
- **Deploy**: Run container for testing

#### Email Notifications.
The pipeline includes HTML email notifications with:
- Build status
- Project information
- Trivy scan results attachment

### Step 7: EKS Cluster Deployment.
Use Terraform to create EKS cluster:

```bash
# Navigate to EKS terraform directory
cd terraform/eks

# Deploy EKS cluster
terraform init
terraform plan
terraform apply
```

### Step 8: Monitoring Setup (Prometheus & Grafana).

```bash
# Configure kubectl for EKS
aws eks update-kubeconfig --name "YOUR_CLUSTER_NAME" --region "YOUR_REGION"

# Add Helm repositories
helm repo add stable https://charts.helm.sh/stable
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Create namespace and install Prometheus stack
kubectl create namespace prometheus
helm install stable prometheus-community/kube-prometheus-stack -n prometheus

# Expose Prometheus and Grafana via LoadBalancer
kubectl edit svc kube-prometheus-stack-prometheus -n prometheus
kubectl edit svc kube-prometheus-stack-grafana -n prometheus
```

**Grafana Access:**
- Default credentials: admin/prom-operator
- Access via LoadBalancer external IP on port 80

### Step 9: ArgoCD GitOps Setup.

```bash
# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml

# Expose ArgoCD server
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Get ArgoCD server details
kubectl get svc argocd-server -n argocd
```

**ArgoCD Access:**
- Username: admin
- Password: Get using `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

## 📊 Monitoring & Observability.

### Prometheus Metrics.
- Cluster resource utilization
- Application performance metrics
- Node and pod health status

### Grafana Dashboards.
- Kubernetes cluster overview
- Application-specific metrics
- Security scan results visualization

## 🔐 Security Features.

### Code Security.
- **SonarQube**: Static analysis for code quality and security vulnerabilities
- **OWASP Dependency Check**: Identifies known vulnerabilities in dependencies

### Container Security.
- **Trivy**: Comprehensive vulnerability scanning for containers and filesystems
- **Docker Scout**: Container image security analysis and recommendations

### Runtime Security.
- Kubernetes security policies
- Network policies for pod-to-pod communication
- RBAC implementation

## 🔄 GitOps Workflow.

1. Developer pushes code to GitHub
2. GitHub webhook triggers Jenkins pipeline
3. Pipeline runs security scans and builds container
4. Container image pushed to DockerHub
5. ArgoCD detects changes in GitOps repository
6. ArgoCD deploys application to EKS cluster
7. Monitoring tools track application health

## 📈 Benefits.

- **Security**: Multiple layers of security scanning
- **Automation**: Fully automated CI/CD pipeline
- **Scalability**: Kubernetes-based deployment
- **Monitoring**: Comprehensive observability
- **GitOps**: Declarative deployment management
- **Compliance**: Security and quality gates

## 🤝 Contributing.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License.

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support.

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/Aakash580/Devsecops_Project/issues) page
2. Create a new issue with detailed description
3. Include logs and error messages

## 🙏 Acknowledgments.

- AWS for EKS platform
- Jenkins community for CI/CD capabilities
- ArgoCD team for GitOps implementation
- Security tool vendors (SonarQube, OWASP, Aqua Security)
- Prometheus and Grafana communities for monitoring solutions

---

**⭐ If you found this project helpful, please give it a star!**

![GitHub stars](https://img.shields.io/github/stars/Aakash580/Devsecops_Project?style=social)
![GitHub forks](https://img.shields.io/github/forks/Aakash580/Devsecops_Project?style=social)
