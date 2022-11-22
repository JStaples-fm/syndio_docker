export CWD=$(pwd)

deployDocker() {
    ACCOUNTID=$(aws sts get-caller-identity | jq -r ".Account")
    aws ecr get-login-password | docker login --username AWS --password-stdin $(aws sts get-caller-identity | jq -r ".Account").dkr.ecr.$AWS_REGION.amazonaws.com
    ECR_URL=$(aws ssm get-parameter --name "/${SERVICE}/${BUILD_STAGE}/ecr_url" | jq -r .Parameter.Value)
    SM_PASSWORD = $(aws secretsmanager get-secret-value --secret-id syndio | jq --raw-output .SecretString | jq -r ."password")
    
    docker build --build-arg HELLO=${SM_PASSWORD} -t ${ECR_URL}:latest .
    docker tag ${ECR_URL}:latest ${ECR_URL}:latest
    docker push ${ECR_URL}:latest
}

deployDocker
