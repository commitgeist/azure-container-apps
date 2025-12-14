#!/bin/bash
# Script 05: Listar Container Apps existentes

source ./config.sh

echo "Listando Container Apps no Resource Group..."
az containerapp list -g $RESOURCE_GROUP_NAME -o table