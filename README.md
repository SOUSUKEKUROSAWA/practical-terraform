# Practical Terraform

## Sample Code

<https://github.com/tmknom/example-pragmatic-terraform>

## Module Structure

ディレクトリ構成

- examples/*
  - モジュールの利用例
- live/*
  - 実際に利用されるリソース群
- modules/*
  - モジュール
- setup/*
  - liveをApplyする前にApplyする必要のあるリソース群

各モジュール内

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
cd $HOME\Documents\practical-terraform\examples\ecs-scheduled-tasks
cd $HOME\Documents\practical-terraform\examples\master-key
cd $HOME\Documents\practical-terraform\examples\parameter-store
cd $HOME\Documents\practical-terraform\examples\rds
cd $HOME\Documents\practical-terraform\examples\cache
cd $HOME\Documents\practical-terraform\examples\ecr
cd $HOME\Documents\practical-terraform\live
cd $HOME\Documents\practical-terraform\setup

# INIT
aws-vault exec self-study -- terraform init -backend-config="$HOME\Documents\practical-terraform\backend.hcl"

# APPLY
aws-vault exec self-study -- terraform apply

# DESTROY
aws-vault exec self-study -- terraform destroy

# STATE LIST
aws-vault exec self-study -- terraform state list

# FORCE UNLOCK
$lockId = "xxx"
aws-vault exec self-study -- terraform force-unlock $lockId
```

AWS CLI

```sh
# GET ECS LOG
$logGroupName = "xxx"
aws-vault exec self-study -- aws logs filter-log-events --log-group-name $logGroupName

# GET ECS TASK STATUS
$clusterName = "xxx"
$serviceName = "xxx"
aws-vault exec self-study -- aws ecs list-tasks --cluster $clusterName --service-name $serviceName

$taskArn = "xxx"
aws-vault exec self-study -- aws ecs describe-tasks --cluster $clusterName --tasks $taskArn

# CREATE SSM PARAMETER（平文で保存する場合は --type String, 暗号化する場合は --type SecureString を指定）
$parameterName = 'xxx'
aws-vault exec self-study -- aws ssm put-parameter --name $parameterName --value 'xxx' --type String/SecureString

# GET SSM PARAMETE（暗号化した値を復号して参照するには --with-decryption を追加する）
aws-vault exec self-study -- aws ssm get-parameter --name $parameterName --query Parameter.Value --output text --with-decryption

# UPDATE SSM PARAMETER（平文で保存する場合は --type String, 暗号化する場合は --type SecureString を指定）
aws-vault exec self-study -- aws ssm put-parameter --name $parameterName --value 'xxx' --overwrite --type String/SecureString

# UPDATE DB PASSWORD
$identifier 'xxx'
aws-vault exec self-study -- aws rds modify-db-instance --db-instance-identifier $identifier --master-user-password 'xxx'

# LOGIN ECR
aws-vault exec self-study -- aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 862764932655.dkr.ecr.us-east-2.amazonaws.com

# ADD IMAGE TAG
docker tag <local_image>:latest 862764932655.dkr.ecr.us-east-2.amazonaws.com/<repository_name>:latest

# PUSH IMAGE
docker push 862764932655.dkr.ecr.us-east-2.amazonaws.com/<repository_name>:latest
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
