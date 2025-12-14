#!/bin/bash
# Configurações centralizadas para o treinamento Azure Container Apps

export RESOURCE_GROUP_NAME="treinamento_container_apps"
export LOCATION="eastus"
export ACR_NAME="treinamentocontainerapps"
export CONTAINERAPPS_NAME="gotobizcontainerapps"
export ENVIRONMENT_NAME="treinamento-env"

echo "Configurações carregadas:"
echo "   Resource Group: $RESOURCE_GROUP_NAME"
echo "   Location: $LOCATION"
echo "   ACR Name: $ACR_NAME"
echo "   Container App: $CONTAINERAPPS_NAME"