#!/bin/sh

[ "$#" -eq 1 ] || \
  { echo "Missing argument: resourceName"; exit 1; }

NAME=$1

LB_NAME="${NAME}LB"
LB_RULE_NAME="${LB_NAME}RuleWeb"
LB_RULE_BE_POOL="${LB_NAME}BEPool"
LB_FRONTEND_NAME="loadBalancerFrontend"
LB_PIP_NAME="${LB_NAME}PublicIp"

echo "Creating resource group $NAME"
az group create -l westeurope -n $NAME

echo "Creating scale set $NAME"
az vmss create \
  --resource-group $NAME \
  --name $NAME \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --custom-data cloud-init.txt \
  --admin-username rifiel \
  --generate-ssh-keys

echo "Creating lb rule $LB_RULE_NAME for $LB_NAME with $LB_RULE_BE_POOL, $LB_FRONTEND_NAME"
az network lb rule create \
  --resource-group $NAME \
  --name $LB_RULE_NAME \
  --lb-name $LB_NAME \
  --backend-pool-name $LB_RULE_BE_POOL \
  --backend-port 80 \
  --frontend-ip-name $LB_FRONTEND_NAME \
  --frontend-port 80 \
  --protocol tcp

echo ""

echo "Getting public IP $LB_PIP_NAME"
az network public-ip show \
    --resource-group $NAME \
    --name $LB_PIP_NAME \
    --query [ipAddress] \
    --output tsv

echo ""

echo "Getting inbout NAT rules"
az network lb inbound-nat-rule list \
    --resource-group $NAME \
    --lb-name $LB_NAME \
    --query [*].[backendPort,frontendPort] \
    --output tsv
  
