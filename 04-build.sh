ACR_NAME="treinamentocontainerapps"

az acr login --name $ACR_NAME

docker build -t $ACR_NAME.azurecr.io/containerapps_nginx:v2 .
docker push $ACR_NAME.azurecr.io/getting-started:latest

az acr logout


docker tag old_image_name:latest new_image_name:latest