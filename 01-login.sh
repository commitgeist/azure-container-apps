az login --use-device-code

SUBSCRIPTION_ID=$(az account show --query id -o tsv)

az account set -s $SUBSCRIPTION_ID

echo "Você está logado na seguinte conta:"
az account show