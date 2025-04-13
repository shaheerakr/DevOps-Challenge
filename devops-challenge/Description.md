# Helm Chart Description: TradeByte DevOps Challenge

## Overview

This Helm chart is designed to deploy a robust, production-ready, and scalable Kubernetes deployment for the TradeByte DevOps Challenge application. The chart leverages Kubernetes best practices to ensure scalability, performance, and security. It includes configurations for replicas, autoscaling, environment variable management, and resource optimization.

### Tools Used
- **Helm**: For templating and managing Kubernetes resources.
- **Kubernetes**: For container orchestration.
- **Minikube**: For running a local Kubernetes cluster.
- **Docker**: For containerizing the application.
- **Redis**: As a backend database for the application.
- **Python**: For the Tornado-based web application.

---

## Commands

### 1. Run Tests and Deploy the Application
Use the `test-and-build.sh` script to run the tests and deploy the application using Helm:
```bash
bash test-and-build.sh
```

### 2. Access the Application
If you're using Minikube, expose the service using the following command:
```bash
minikube service devops-challenge
```

Alternatively, if you're using a NodePort service, access the application using:
```bash
http://<NODE_IP>:31000
```
Replace `<NODE_IP>` with the output of `minikube ip` or the IP of your Kubernetes node.

---

## Features of the Helm Chart

### 1. **Replicas**
The Helm chart ensures high availability by deploying at least 3 replicas of the application:
```yaml
replicaCount: 3
```

### 2. **Autoscaling**
The chart includes a Horizontal Pod Autoscaler (HPA) to automatically scale the application based on CPU utilization:
```yaml
autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50
```

### 3. **Secure Environment Variables**
Environment variables are managed securely using the values.yaml file. However, for sensitive variables such as database credentials or API keys, Kubernetes Secrets should be used. Secrets provide an additional layer of security by storing sensitive data in an encoded format and restricting access to only authorized pods.

Why Use Secrets?
Security: Secrets are base64-encoded and stored securely in Kubernetes, reducing the risk of accidental exposure.
Access Control: Secrets can be restricted to specific pods or namespaces, ensuring only authorized components can access them.
Flexibility: Secrets can be updated independently of the application, allowing for seamless updates without redeploying the application.

Example: Creating Secrets
To create a Kubernetes Secret for sensitive environment variables, use the following command:
```
kubectl create secret generic devops-challenge-env \
  --from-literal=REDIS_HOST=localhost \
  --from-literal=REDIS_PORT=6379 \
  --from-literal=REDIS_DB=0
```

### 4. **Scalability and Performance**
- Resource requests and limits are defined to ensure optimal performance and prevent resource overuse:
  ```yaml
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: 500m
      memory: 256Mi
  ```
- Redis is deployed as a separate service to decouple the application logic from the database.

---

## Future Enhancements

### 1. **Monitoring**
Integrate monitoring tools like Prometheus and Grafana to track application performance and resource usage. Add the following components:
- **Prometheus**: For collecting metrics.
- **Grafana**: For visualizing metrics.
- **Kubernetes Metrics Server**: To enable HPA and provide resource metrics.

### 2. **CI/CD Workflows**
Set up CI/CD pipelines using tools like GitHub Actions, Jenkins, or GitLab CI/CD:
- **Build and Test**: Automatically build the Docker image and run tests on every commit.
- **Helm Deployment**: Deploy the Helm chart to a staging or production environment.
- **Rollback**: Implement rollback strategies for failed deployments.

Example GitHub Actions Workflow:
```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Set up Kubernetes
        uses: azure/setup-kubectl@v3

      - name: Run Tests
        run: test-and-build.sh

      - name: Deploy with Helm
        run: helm upgrade --install devops-challenge ./devops-challenge
```

---

This `Description.md` file provides an overview of the Helm chart, its features, and commands to manage the deployment. It also outlines future enhancements for monitoring and CI/CD workflows.