#!/bin/bash
# Script 08: Download da configuração atual (revision)

source ./config.sh

echo "Baixando configuração atual do Container App..."
az containerapp show \
  --name $CONTAINERAPPS_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --output yaml > revision.yaml

echo "Configuração salva em 'revision.yaml'!"