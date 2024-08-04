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

Terraform

```sh
cd $HOME\Documents\practical-terraform\examples\iam-role
cd $HOME\Documents\practical-terraform\examples\bucket\private
cd $HOME\Documents\practical-terraform\examples\bucket\public
cd $HOME\Documents\practical-terraform\examples\network\vpc-2az
cd $HOME\Documents\practical-terraform\examples\network\security-group
cd $HOME\Documents\practical-terraform\examples\alb
cd $HOME\Documents\practical-terraform\examples\ecs-fargate
cd $HOME\Documents\practical-terraform\live

# INIT
aws-vault exec self-study -- terraform init -backend-config="$HOME\Documents\practical-terraform\backend.hcl"

# APPLY
aws-vault exec self-study -- terraform apply

# DESTROY
aws-vault exec self-study -- terraform destroy

# STATE LIST
aws-vault exec self-study -- terraform state list

# FORCE UNLOCK
$lockId = xxx
aws-vault exec self-study -- terraform force-unlock $lockId
```

AWS CLI

```sh
# GET ECS LOG
$logGroupName = "/ecs/example"
aws-vault exec self-study -- aws logs filter-log-events --log-group-name $logGroupName

# GET ECS TASK STATUS
$clusterName = "practical-terraform"
$serviceName = "practical-terraform"
aws-vault exec self-study -- aws ecs list-tasks --cluster $clusterName --service-name $serviceName

$taskArn = xxx
aws-vault exec self-study -- aws ecs describe-tasks --cluster $clusterName --tasks $taskArn
```

## Trouble Shooting

### ECSデプロイ時に，タスクが以下のエラーで起動しない

#### エラー

```sh
CannotPullContainerError: pull image manifest has been retried 5 time(s): failed to resolve ref docker.io/library/nginx:latest
```

#### 原因

NATゲートウェイがプライベートサブネットに配置されてしまっていた

#### 対処

NATゲートウェイをパブリックサブネットに配置するようにする
