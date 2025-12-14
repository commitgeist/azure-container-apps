#!/bin/bash
# Script 02: Criação do Resource Group

source ./config.sh

echo "Criando Resource Group..."
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

echo "Resource Group '$RESOURCE_GROUP_NAME' criado com sucesso!"