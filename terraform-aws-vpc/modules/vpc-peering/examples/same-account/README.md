# Simple VPC Peering example

Configuration in this directory creates the following VPC Connection Peering configuration.
- Requester VPC
- Accepter VPC
- VPC Peering Connection

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Notes
- that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
- the vpc and the vpc peering modules must be created on different workspaces if not an `Error: Invalid count argument` will prompted
