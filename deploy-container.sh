#!/bin/bash

# Azure Container Deployment Script
# Usage: Set environment variables before running:
# export DBT_PASSWORD="your-password"
# export ACR_PASSWORD="your-acr-password"

if [ -z "$DBT_PASSWORD" ] || [ -z "$ACR_PASSWORD" ]; then
    echo "Error: Please set DBT_PASSWORD and ACR_PASSWORD environment variables"
    echo "Example:"
    echo "export DBT_PASSWORD='your-dbt-password'"
    echo "export ACR_PASSWORD='your-acr-password'"
    echo "./deploy-container.sh"
    exit 1
fi

az container create \
    --resource-group adrez-poc-rg \
    --name adrez-dbt-runner-$(date +%Y%m%d-%H%M%S) \
    --image adrezpocacr.azurecr.io/adrez-dbt:latest \
    --registry-login-server adrezpocacr.azurecr.io \
    --registry-username adrezpocacr \
    --registry-password "$ACR_PASSWORD" \
    --secure-environment-variables "DBT_PASSWORD=$DBT_PASSWORD" \
    --restart-policy Never \
    --os-type Linux \
    --cpu 1 \
    --memory 2 \
    --command-line 'dbt run'