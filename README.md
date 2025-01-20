# AWS Cloud Infrastructure with EKS, Python App, and CI/CD

This project demonstrates a comprehensive AWS cloud infrastructure setup using Terraform, Kubernetes, and CircleCI. It features a modular infrastructure design, a Python-based microservice deployed on EKS, and a CI/CD pipeline to automate the deployment and management processes.

---

## 📜 Project Overview

![canary](https://github.com/user-attachments/assets/1589ce62-f23f-42e4-ad0d-21c291f16c0b)


### Key Components:
- **Infrastructure as Code (IaC)**: 
  - A modularized Terraform setup to provision AWS resources such as VPCs, EKS clusters, RDS, EFS, ALBs, and more.
  - Supports environment-specific configurations (e.g., production) and reusable modules.

- **Python Application**:
  - A Todo app deployed in EKS with Kubernetes manifests.
  - Uses AWS Secrets Manager for secure environment variables via External Secrets.
  - Features a canary deployment strategy managed by Flagger.

- **Logging and Monitoring**:
  - ELK Stack (Elasticsearch, Logstash, Filebeat, Kibana) for centralized logging.
  - Prometheus and Grafana for monitoring cluster metrics.
  - Integrated pod-level monitoring with Kubernetes' metrics server.

- **CI/CD Pipeline**:
  - CircleCI pipeline for continuous integration and deployment.
  - Automates Docker image builds, pushes to ECR, and Kubernetes deployments.
  - Utilizes ArgoCD for GitOps-based deployment management.

---

## 🧩 Technology Stack

| **Component**       | **Technology**                                 |
|----------------------|-----------------------------------------------|
| **Infrastructure**  | AWS, Terraform, EKS, ALB, EFS, RDS            |
| **Application**     | Python, Flask, Docker, AWS Secrets Manager    |
| **CI/CD**           | CircleCI, ArgoCD                              |
| **Logging**         | ELK Stack (Elasticsearch, Logstash, Kibana)   |
| **Monitoring**      | Prometheus, Grafana                           |

---

## 📂 Directory Structure

### Key Folders and Files:
```bash
.
├── argocd
│   └── application            # ArgoCD application configurations
├── infrastructure
│   ├── data                   # Resource-specific configurations (e.g., policies, bootstrap scripts)
│   ├── module                 # Terraform modules for modular resource creation
│   ├── production             # Environment-specific Terraform configurations
├── k8s                        # Kubernetes manifests for app deployment and monitoring
│   ├── extrenal-secrets       # External Secrets manifests for secret management
│   ├── deployment.yaml        # Application deployment configuration
│   ├── ingress.yaml           # Kubernetes ingress for ALB routing
│   └── pod-monitor.yaml       # Monitoring configurations for Prometheus
├── todo-app                   # Python Todo app source code
│   ├── app.py                 # Main application logic
│   ├── Dockerfile             # Dockerfile for building app image
│   └── requirements.txt       # App dependencies
└── LICENSE.md                 # License for the project
└── README.md                  # Documentation (this file)

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




