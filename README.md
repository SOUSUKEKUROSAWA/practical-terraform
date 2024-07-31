# Practical Terraform

## Sample Code

<https://github.com/tmknom/example-pragmatic-terraform>

## Module Structure

- inputs.tf
  - モジュールの入力データ
- main.tf
  - モジュールの主要リソース群
- locals.tf
  - モジュール内で利用するデータ
- outputs.tf
  - モジュールの出力データ

## Command Help

```sh
cd $HOME\Documents\practical-terraform\examples\iam-role

# INIT
aws-vault exec self-study -- terraform init -backend-config="$HOME\Documents\practical-terraform\backend.hcl"

# APPLY
aws-vault exec self-study -- terraform apply

# DESTROY
aws-vault exec self-study -- terraform destroy

# STATE LIST
aws-vault exec self-study -- terraform state list
```
