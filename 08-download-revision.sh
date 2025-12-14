RESOURCE_GROUP_NAME="treinamento_container_apps"
LOCATION="eastus"
CONTAINERAPPS_NAME="gotobizcontainerapps"
az containerapp show  --name $CONTAINERAPPS_NAME   --resource-group $RESOURCE_GROUP_NAME   --output yaml >> revision.yaml