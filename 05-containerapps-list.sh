RESOURCE_GROUP_NAME="treinamento_container_apps"
LOCATION="eastus"


az containerapp list -g $RESOURCE_GROUP_NAME -o table -l $LOCATION