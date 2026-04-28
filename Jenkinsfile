pipeline {
    agent {
        label 'windows'
    }

    environment {
        AWS_REGION    = 'us-east-1'
        AWS_ACCOUNT   = credentials('aws-account-id')       // Jenkins secret text: your AWS account ID
        ECR_REPO      = "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/bmi-app"
        IMAGE_TAG     = "${BUILD_NUMBER}"
        EC2_USER      = 'ec2-user'
        EC2_HOST      = credentials('ec2-host')             // Jenkins secret text: EC2 public IP
        SSH_KEY       = credentials('ec2-ssh-key')          // Jenkins secret file: .pem key
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                bat "docker build -t bmi-app:%IMAGE_TAG% ."
            }
        }

        stage('Push to ECR') {
            steps {
                withAWS(region: "${AWS_REGION}", credentials: 'aws-credentials') {
                    bat """
                        aws ecr get-login-password --region %AWS_REGION% | ^
                        docker login --username AWS --password-stdin %ECR_REPO%
                    """
                    bat "docker tag bmi-app:%IMAGE_TAG% %ECR_REPO%:%IMAGE_TAG%"
                    bat "docker tag bmi-app:%IMAGE_TAG% %ECR_REPO%:latest"
                    bat "docker push %ECR_REPO%:%IMAGE_TAG%"
                    bat "docker push %ECR_REPO%:latest"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                bat """
                    ssh -o StrictHostKeyChecking=no -i "%SSH_KEY%" ^
                        %EC2_USER%@%EC2_HOST% ^
                        "aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %ECR_REPO% && ^
                         docker pull %ECR_REPO%:latest && ^
                         docker stop bmi-app 2>/dev/null || true && ^
                         docker rm bmi-app 2>/dev/null || true && ^
                         docker run -d --name bmi-app -p 8080:8080 --restart always %ECR_REPO%:latest"
                """
            }
        }
    }

    post {
        success {
            echo "Deployment successful -> http://${env.EC2_HOST}:8080"
        }
        failure {
            echo 'Pipeline failed. Check stage logs above.'
        }
        always {
            bat "docker rmi bmi-app:%IMAGE_TAG% 2>nul || exit 0"
        }
    }
}
