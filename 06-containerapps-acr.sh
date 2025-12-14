
#!/bin/bash
# Script 06: Configurar ACR no Container App

source ./config.sh

echo "Configurando ACR no Container App..."
az containerapp registry set \
  --name $CONTAINERAPPS_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --server $ACR_NAME.azurecr.io \
  --identity system

echo "ACR configurado no Container App!"