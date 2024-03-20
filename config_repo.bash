#! /usr/bin/bash

echo "ECR Configuration"

ecr_checkout="ecr-fiap-checkout"
ecr_client="ecr-fiap-client"
ecr_product="ecr-fiap-product"
ecr_payment="ecr-fiap-payment"
ecr_lambda="ecr-lambda-project"

ecr_nro="495428969620"

declare -a ecr_cluster
ecr_cluster[0]=$ecr_checkout
ecr_cluster[1]=$ecr_client
ecr_cluster[2]=$ecr_product
ecr_cluster[3]=$ecr_payment
ecr_cluster[4]=$ecr_lambda

declare -A ecrVarMap
ecrVarMap[$ecr_checkout]=$ecr_nro".dkr.ecr.us-east-1.amazonaws.com/ecr-fiap-checkout"
ecrVarMap[$ecr_client]=$ecr_nro".dkr.ecr.us-east-1.amazonaws.com/ecr-fiap-client"
ecrVarMap[$ecr_product]=$ecr_nro".dkr.ecr.us-east-1.amazonaws.com/ecr-fiap-product"
ecrVarMap[$ecr_payment]=$ecr_nro".dkr.ecr.us-east-1.amazonaws.com/ecr-fiap-payment"
ecrVarMap[$ecr_lambda]=$ecr_nro".dkr.ecr.us-east-1.amazonaws.com/ecr-lambda-project"


declare -A pathVarMap
pathVarMap[$ecr_checkout]="/home/silverton/Projects/soat23-gp14-pedido/fiap-application"
pathVarMap[$ecr_client]="/home/silverton/Projects/soat23-gp14-cliente"
pathVarMap[$ecr_product]="/home/silverton/Projects/soat23-gp14-produto"
pathVarMap[$ecr_payment]="/home/silverton/Projects/soat23-gp14-pagamento"
pathVarMap[$ecr_lambda]="/home/silverton/Projects/soat23-gp14-serverless"

if [ "$1" == "push" ]
    then
        echo "Pushing images..."
        for idx in ${ecr_cluster[@]}
        do
            echo "Project["$idx"] -> "${ecrVarMap[$idx]}

            cd ${pathVarMap[$idx]}
            echo "Path: "$PWD

            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ecrVarMap[$idx]}

                docker build -t $idx .


            docker tag $idx:latest ${ecrVarMap[$idx]}:latest
            
            docker push ${ecrVarMap[$idx]}:latest
            echo "Finished: ["$idx"] -----------------------------------------"
        done
    else if [ "$1" == "delete" ]
        then
            echo "Deleting images..."
            for idx in ${ecr_cluster[@]}
            do
                echo "deleting ["$idx:latest"]"
                images=$(aws ecr batch-delete-image --repository-name $idx --image-ids imageTag=latest --region us-east-1  --query "imageIds" --output text)
                echo "images: "$images
                dltResult=$(aws ecr delete-repository --repository-name $idx  --region us-east-1 --output text --query "repository.repositoryName" --output text)
                echo "Delete Result: "$dltResult
            done
        else if [ "$1" == "create" ]
            then
                for idx in ${ecr_cluster[@]}
                    do
                        echo "Project["$idx"]"


                        aws ecr describe-repositories --repository-names $idx 2>&1 > /dev/null
                        status=$?
                        echo status: $status
                            if [[ ! "${status}" -eq 0 ]]; 
                                then
                                    echo "Creating repository..."
                                    repositoryUri=$( aws ecr --region us-east-1 create-repository --repository-name $idx --query "repository.repositoryUri" --output text)
                                    echo "Repository URI: "$repositoryUri
                                else    
                                    echo "Repository already exists"
                                fi
                        done
            else
                echo "No command found, please use create, push or delete"
                exit
            fi
        fi
    fi 
