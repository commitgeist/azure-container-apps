RESOURCE_GROUP_NAME="treinamento_container_apps"
LOCATION="eastus"
ACR_NAME="treinamentocontainerapps"

az acr create --resource-group $RESOURCE_GROUP_NAME --name $ACR_NAME --sku Basic -l $LOCATION


az acr update -n $ACR_NAME --admin-enabled true