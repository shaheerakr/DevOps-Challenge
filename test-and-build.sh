#!/bin/bash

set -e  # fail on error

# 1. Run the test inside container
echo " Running tests..."
python tests/test.py

# 2. Build the docker image
docker build -t devops-challenge:v1 .

# 4. Copy image to Minikube’s Docker daemon: 
minikube image load devops-challenge:v1

# 3. Deploy with Helm if tests pass
helm upgrade --install devops-challenge ./devops-challenge


