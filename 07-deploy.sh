RESOURCE_GROUP_NAME="treinamento_container_apps"
LOCATION="eastus"
CONTAINERAPPS_NAME="gotobizcontainerapps"

az containerapp update \
  --name $CONTAINERAPPS_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --yaml deploy_website.yaml