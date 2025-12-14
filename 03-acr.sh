#!/bin/bash
# Script 03: Criação do Azure Container Registry (ACR)

source ./config.sh

echo "Criando Azure Container Registry..."
az acr create --resource-group $RESOURCE_GROUP_NAME --name $ACR_NAME --sku Basic -l $LOCATION

echo "Habilitando admin no ACR..."
az acr update -n $ACR_NAME --admin-enabled true

echo "ACR '$ACR_NAME' criado e configurado!"