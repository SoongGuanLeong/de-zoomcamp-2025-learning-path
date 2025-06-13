Terraform is an infrastructure as code tool. It allows devs to define and plan hardware (storage, network, vm) written in files before deployment, which makes it easy to track and edit if anything goes wrong.

# Terraform basics
---
### Codes in main.tf is found by googling

## Example: 
### terraform google provider
### terraform google cloud storage bucket
### terraform bigquery dataset
---
## Commands used in the video

```bash
# a key is created using a google service account
# make code look neat
terraform fmt
```

```bash
# setup info you need whenever you have new provider added to main.tf
terraform init
```

```bash
# a dry run that show a blueprint/plan of all .tf files and create a terraform.tfstate
# show config settings without going through lengthy documentation
terraform plan
```

```bash
# run after terraform plan (apply the plan)
# create resources based on everything written in terraform.tfstate
terraform apply
```

```bash
# destroy resources based on everything written in terraform.tfstate
# backup the terraform.tfstate file as history
terraform destroy
```
