export CWD=$(pwd)

deployDocker() {
    ACCOUNTID=$(aws sts get-caller-identity | jq -r ".Account")
    aws ecr get-login-password | docker login --username AWS --password-stdin $(aws sts get-caller-identity | jq -r ".Account").dkr.ecr.$AWS_REGION.amazonaws.com
    ECR_URL=$(aws ssm get-parameter --name "/${SERVICE}/${BUILD_STAGE}/ecr_url" | jq -r .Parameter.Value)
    docker build --build-arg password=${SYNDIO_PASSWORD} -t ${ECR_URL}:latest .
    # docker build -t ${ECR_URL}:latest .
    docker tag ${ECR_URL}:latest ${ECR_URL}:latest
    docker push ${ECR_URL}:latest
}

deployDocker
