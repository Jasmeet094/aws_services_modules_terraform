# Simple ECS Task Definition with multiple containers example

Configuration in this directory creates the following ECS Resources (with Default values).
- ECS Task Definition (in EC2 mode)

## Usage

To run this example you need to execute inside this directory:

To add another container to the task definition, create a new `container_definition` module and add it to the `container_definitions` attribute in the task definition module.

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.