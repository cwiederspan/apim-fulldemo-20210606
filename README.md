# Full API Management Demo

This demo uses Terraform to create an Azure API Management service internally in a VNET. Primary points of interest include
generating SSL certificates on the fly wtih Let's Encrypt, and exposing the APIM service through an Application Gateway.

## Inner Loop Development

```bash

cd terraform

# Use remote storage
terraform init --backend-config ./backend-secrets.tfvars

# Run the plan to see the changes
terraform plan \
-var 'base_name=cdw-apimdemo-20210608' \
-var 'location=westus2' \
-var 'root_dns_name=something.com' \
-var 'contact_name=John Doe' \
-var 'contact_email=someemail@something.com' #\

#--var-file=secrets.tfvars


# Apply the script with the specified variable values
terraform apply \
-var 'base_name=cdw-apimdemo-20210608' \
-var 'location=westus2' \
-var 'root_dns_name=something.com' \
-var 'contact_name=John Doe' \
-var 'contact_email=email@something.com' #\

#--var-file=secrets.tfvars

```

## Automation with GitHub Actions

```bash

# Create some variables for reuse
AZURE_SUB_ID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
BASE_NAME=your-base-name
LOCATION=westus2
DNS_NAME=something.com
CONTACT_NAME='John Doe'
CONTACT_EMAIL=email@something.com

# Log into Azure
az login

# Create a Resource Group
az group create -n $BASE_NAME -l $LOCATION

# Create an SP for the Resource Group
AZURE_CREDS=$(az ad sp create-for-rbac \
    --name $BASE_NAME-sp \
    --role contributor \
    --scopes /subscriptions/$AZURE_SUB_ID/resourceGroups/$BASE_NAME \
    --sdk-auth)

# Set the values into a GitHub secrets
gh secret set AZURE_CREDENTIALS  -b"$AZURE_CREDS"

gh secret set TF_STATE_ACCOUNT   -b"<Azure Storage Account Name>"
gh secret set TF_STATE_CONTAINER -b"<Azure Storage Account Container>"
gh secret set TF_STATE_SECRET    -b"<Azure Storage Account Key>"

gh secret set PARAM_BASE_NAME     -b"$BASE_NAME"
gh secret set PARAM_LOCATION      -b"$LOCATION"
gh secret set PARAM_ROOT_DNS_NAME -b"$DNS_NAME"
gh secret set PARAM_CONTACT_NAME  -b"$CONTACT_NAME"
gh secret set PARAM_CONTACT_EMAIL -b"$CONTACT_EMAIL"

```

## Testing It Out

