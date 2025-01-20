# AWS Cloud Infrastructure with EKS, Python App, and CI/CD

This project provides a robust cloud infrastructure solution built on AWS. The setup includes an Amazon EKS cluster, integrated with a Python-based microservice, a complete CI/CD pipeline powered by CircleCI, and a Terraform-based Infrastructure as Code (IaC) module. The project emphasizes scalability, security, and efficient resource management.

---

## 📜 Project Overview

### Key Components:
- **Terraform Modules**: 
  - Automates the provisioning of AWS resources such as VPC, EKS cluster, RDS, EFS, ALBs, NAT Gateways, and more.
  - Modular design for reusable and manageable configurations.
  - Handles networking, compute, and storage in a secure and isolated environment.

- **Python Application**:
  - Microservice deployed in EKS with 4 replicas.
  - Retrieves secrets securely from AWS Secrets Manager using External Secrets.
  - Connects to an RDS MySQL database and Elasticsearch for data storage and search.
  - Exposed to external users through an AWS ALB ingress.

- **ELK Stack**:
  - Deployed using Helm in the EKS cluster.
  - Components:
    - Elasticsearch (using shared EFS storage)
    - Logstash (processing logs)
    - Filebeat (collecting and forwarding logs)
    - Kibana (UI for data visualization)
  - Centralized logging and monitoring of cluster activities.

- **CI/CD Pipeline**:
  - **CircleCI**:
    - Automates code testing, building, and deployment.
    - Pulls code from GitHub, builds Docker images, and deploys them to EKS.
    - Deployment strategy includes Flagger for progressive rollouts and monitoring.

- **Monitoring and Alerting**:
  - kube-prometheus-stack (installed via Helm).
  - Grafana (external UI) and Prometheus for monitoring Kubernetes metrics.
  - Alertmanager for internal notifications.

---

## 🛠️ Features

- **Scalable Cloud Infrastructure**: Deploys an EKS cluster with 4 private worker nodes across availability zones.
- **Secure Networking**:
  - Bastion host for secure management in public subnets.
  - NAT Gateway for private subnets' internet access.
  - AWS ALB for handling external traffic.
- **Infrastructure as Code**:
  - Reproducible and version-controlled Terraform modules.
- **Modern CI/CD**:
  - Continuous Deployment with CircleCI and ArgoCD for GitOps.
- **Comprehensive Logging**:
  - ELK stack integrated for log aggregation and analysis.
- **Highly Available Storage**:
  - EFS shared storage for Elasticsearch and other components.

---

## 🚀 Getting Started

### Prerequisites
- AWS Account with proper IAM permissions.
- Terraform installed locally.
- CircleCI account integrated with GitHub.
- AWS CLI and kubectl configured locally.

### Setup Instructions

#### 1. Clone the Repository
```bash
git clone https://github.com/ziyad-tarek1/canary-todo-python-app.git
cd canary-todo-python-app
```

#### 2. Initialize Terraform
```bash
cd terraform
terraform init
terraform apply
```
#### 3. Deploy the Python App
Use the kustomization.yaml file in the app directory to deploy the app:
```bash
kubectl apply -k ./k8s/
```

#### 4. Configure CircleCI
    Add the CircleCI config:
    Edit .circleci/config.yml to configure deployment pipelines.
    Connect CircleCI to your GitHub repo.
    Update AWS credentials in CircleCI project settings.

### 🧩 Technology Stack
| Component     |                Technology                       |
|---------------|-------------------------------------------------|
| Infrastructure| AWS, Terraform, EKS, VPC, ALB, EFS, RDS         |
| Application   | Python, AWS Secrets Manager, External Secrets   |
| CI/CD         | CircleCI, Docker, ArgoCD                        |
| Monitoring    | Prometheus, Grafana, ELK Stack                  |

### 📂 Directory Structure

```bash
.
├── argocd
│   └── application
├── infrastructure
│   ├── data
│   │   ├── alb_data
│   │   │   ├── podrole-autoscaler.json
│   │   │   └── policy-autoscaler.json
│   │   ├── argocd_data
│   │   │   └── argocd.yaml
│   │   ├── autoscaler_data
│   │   │   ├── podrole-autoscaler.json
│   │   │   └── policy-autoscaler.json
│   │   ├── bastion_data
│   │   │   ├── bastion-bootstrap.sh
│   │   │   ├── bastion-provisioner.sh
│   │   │   └── create_table.sql
│   │   ├── elk_stack
│   │   │   ├── Elasticsearch
│   │   │   │   └── values.yml
│   │   │   ├── Filebeat
│   │   │   │   └── values.yml
│   │   │   ├── Kibana
│   │   │   │   └── values.yml
│   │   │   └── Logstash
│   │   │       └── values.yml
│   │   ├── metrics_server_data
│   │   │   └── metrics-server.yaml
│   │   └── prometheus_data
│   │       └── promethousvalues.yaml
│   ├── module
│   │   ├── alb
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── app
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── autoscaler
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── bastion_host
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── eks
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   ├── policies
│   │   │   │   ├── alb-policy.json
│   │   │   │   ├── autoscaler-policy copy.json
│   │   │   │   ├── autoscaler-policy.json
│   │   │   │   ├── ec2-policy.json
│   │   │   │   └── eks-policy.json
│   │   │   └── variables.tf
│   │   ├── elk
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   ├── README.md
│   │   │   └── variables.tf
│   │   ├── istio_flagger
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── promethous-and-grafana
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── rds
│   │   │   ├── create_table.sql
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── template
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   └── vpc
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   ├── production
│   │   ├── ecr.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfstate
│   │   ├── terraform.tfstate.backup
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── test_module
│       └── isto
│           └── template
│               ├── main.tf
│               ├── output.tf
│               └── variables.tf
├── k8s
│   ├── canary.yaml
│   ├── deployment.yaml
│   ├── ingress.yaml
│   ├── manual_secrets.yaml
│   ├── pod-monitor.yaml
│   ├── rbac.yaml
│   ├── rds-secret-provider
│   └── service.yaml
├── LICENSE.md
├── README.md
└── todo-app
    ├── app.py
    ├── Dockerfile
    ├── requirements.txt
    ├── templates
    │   └── index.html
    └── test_app.py
```

### 📖 Usage Cases

- **Infrastructure Deployment**:  
  Reuse Terraform modules to set up a secure and scalable infrastructure in different environments (e.g., dev, staging, production).

- **Application Deployment**:  
  Quickly deploy and manage the Python app with Kubernetes manifests and ArgoCD GitOps.

- **Monitoring and Troubleshooting**:  
  Use Kibana and Grafana for log visualization and system health monitoring.


### 👨‍💻 License
This project is licensed under a custom license. Unauthorized use, distribution, or modification is prohibited. Refer to the LICENSE file for details.

### 💡 Contributors
    - Ziyad Tarek Saeed - Author and Maintainer.




