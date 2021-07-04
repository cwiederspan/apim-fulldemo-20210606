# Full API Management Demo

This demo uses Terraform to create an Azure API Management service internally in a VNET. Primary points of interest include
generating SSL certificates on the fly wtih Let's Encrypt, and exposing the APIM service through an Application Gateway.

## Change Directory

```bash

cd terraform

```

## Terraform Init

```bash

# Use remote storage
terraform init --backend-config ./backend-secrets.tfvars

```

## Terraform Plan and Apply

```bash

# Run the plan to see the changes
terraform plan \
-var 'base_name=cdw-apimdemo-20210608' \
-var 'location=westus2' \
-var 'root_dns_name=apimdemo.com' \
-var 'contact_name=John Doe' \
-var 'contact_email=someemail@company.com' #\

#--var-file=secrets.tfvars


# Apply the script with the specified variable values
terraform apply \
-var 'base_name=cdw-apimdemo-20210608' \
-var 'location=westus2' \
-var 'root_dns_name=apimdemo.com' \
-var 'contact_name=John Doe' \
-var 'contact_email=someemail@company.com' #\

#--var-file=secrets.tfvars

```
