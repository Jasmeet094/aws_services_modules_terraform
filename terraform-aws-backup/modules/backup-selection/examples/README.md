# Advanced AWS Backup Vault example

Configuration in this directory creates the following Resources:
- AWS Backup Vault with Policy
- Backup Plan
- IAM Role for Backup Selection
- Backup Selection of Resources

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
