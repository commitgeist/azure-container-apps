RESOURCE_GROUP_NAME="treinamento_container_apps"
LOCATION="eastus"
CONTAINERAPPS_NAME="gotobizcontainerapps"

az containerapp ingress enable \
  --name $CONTAINERAPPS_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --type external \
  --target-port 80 \
  --transport auto

az containerapp show  --name $CONTAINERAPPS_NAME   --resource-group $RESOURCE_GROUP_NAME  --query properties.configuration.ingress.fqdn   --output tsv