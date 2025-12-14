#!/bin/bash
# Script 09: Habilitar ingress público

source ./config.sh

echo "Habilitando ingress público..."
az containerapp ingress enable \
  --name $CONTAINERAPPS_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --type external \
  --target-port 80 \
  --transport auto

echo "URL pública do Container App:"
az containerapp show \
  --name $CONTAINERAPPS_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query properties.configuration.ingress.fqdn \
  --output tsv