#! /usr/bin/bash

echo "ECR Configuration"

# ecr_timesheet="ecr-fiap-hacka-time-sheet"
# ecr_report="ecr-fiap-hacka-report"
ecr_lambda="ecr-lambda-project"

ecr_nro="495428969620"

declare -a ecr_cluster
ecr_cluster[0]=$ecr_timesheet
ecr_cluster[1]=$ecr_report
ecr_cluster[2]=$ecr_lambda

declare -A ecrVarMap
ecrVarMap[$ecr_timesheet]=$ecr_nro".dkr.ecr.us-east-1.amazonaws.com/ecr-fiap-hacka-time-sheet"
ecrVarMap[$ecr_report]=$ecr_nro".dkr.ecr.us-east-1.amazonaws.com/ecr-fiap-hacka-report"
ecrVarMap[$ecr_lambda]=$ecr_nro".dkr.ecr.us-east-1.amazonaws.com/ecr-lambda-project"


declare -A pathVarMap
pathVarMap[$ecr_timesheet]="/home/silverton/Projects/hackaton-time-sheet"
pathVarMap[$ecr_report]="/home/silverton/Projects/hackaton-reports"
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
