#!/bin/bash
# Script 10: Criar novo Container App (getting-started)

source ./config.sh

echo "Criando novo Container App (getting-started)..."
az containerapp create \
  --name getting-started-app \
  --resource-group $RESOURCE_GROUP_NAME \
  --yaml deploy_getting_started.yaml

echo "Container App 'getting-started-app' criado com sucesso!"