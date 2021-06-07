# Full API Management Demo

## Bastion Usage

```bash

az container create \
  -n $NAME-aci \
  -g $NAME \
  -l $LOCATION \
  --image cwiederspan/bastion:latest \
  --vnet $NAME-vnet \
  --subnet bastion-subnet

az container exec -n $NAME-aci -g $NAME --exec-command './bin/bash'

```
