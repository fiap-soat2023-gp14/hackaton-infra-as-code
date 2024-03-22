# infra-terraform for AWS Cloud

Este projeto é responsavel por criar toda infra na AWS Cloud do projeto da FIAP.


## Variaveis de ambientes necessárias:

export AWS_ACCESS_KEY_ID=

export AWS_SECRET_ACCESS_KEY=

export TF_VAR_docdb_password=

export TF_VAR_pgsql_password=

## Passos

Antes de rodar o terraform, execute o script para criar o ECR e dar o push da primeira versao para poder .

`./config_repo.bash create` para criar os ECR de cada projeto.

`./config_repo.bash push` para gerar os dockers e publicar as images nos ECRs criados.

`./config_repo.bash delete` para remover as images e o ECR.


## Comandos (tenha `terraform` instalado)

`terraform init` para fazer download de todas as depencias do terraform.

`terraform plan -out planTerraformFiap` para criar plano e testar a sintaxe que foi feita.

`terraform apply  "planTerraformFiap"` para aplicar o plano previamente criado

`terraform destroy` para remover o que foi aplicado no cloud 