#!/bin/bash
# Script 01: Login no Azure e configuração da subscription

echo "Fazendo login no Azure..."
az login --use-device-code

SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az account set -s $SUBSCRIPTION_ID

echo "Você está logado na seguinte conta:"
az account show