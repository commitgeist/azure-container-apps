#!/bin/bash
# Script 04: Build e push das imagens Docker

source ./config.sh

echo "Fazendo login no ACR..."
az acr login --name $ACR_NAME

echo "Fazendo build da imagem nginx..."
docker build -t $ACR_NAME.azurecr.io/nginx-app:latest ./nginx-app/
docker push $ACR_NAME.azurecr.io/nginx-app:latest

echo "Fazendo build da imagem getting-started..."
docker build -t $ACR_NAME.azurecr.io/getting-started:latest ./getting-started/
docker push $ACR_NAME.azurecr.io/getting-started:latest

echo "Fazendo logout do ACR..."
az acr logout

echo "Imagens enviadas para o ACR com sucesso!"