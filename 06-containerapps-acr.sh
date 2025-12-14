
CONTAINERAPPS_NAME=gotobizcontainerapps
RESOURCE_GROUP_NAME="treinamento_container_apps"
LOCATION="eastus"

az containerapp registry set \
  --name $CONTAINERAPPS_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --server nomedoseuacr.azurecr.io \
  --identity system