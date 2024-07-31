# Practical Terraform

## Sample Code

<https://github.com/tmknom/example-pragmatic-terraform>

## State File Path

```tf
terraform {
    backend "s3" {
        key = "practical-terraform/live/xxx/terraform.tfstate"
    }
}
```

## Command Help

```sh
cd $HOME\Documents\practical-terraform\live

aws-vault exec self-study -- terraform init -backend-config="$HOME\Documents\practical-terraform\backend.hcl"
aws-vault exec self-study -- terraform apply
```
