#!/bin/bash
# Script 07: Deploy/Update do Container App

source ./config.sh

echo "Fazendo deploy do Container App..."
az containerapp update \
  --name $CONTAINERAPPS_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --yaml deploy_website.yaml

echo "Deploy realizado com sucesso!"