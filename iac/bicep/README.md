# Execution

```bash

NAME=cdw-apimdemo-20210606
LOCATION=westus2

az group create -g $NAME -l $LOCATION

cd iac/bicep

az deployment group create \
-g $NAME \
-f ./main.bicep \
-p baseName=$NAME \
--verbose

```
