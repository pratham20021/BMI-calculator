pipeline {
    agent any

    environment {
        ECR_REPO           = '753668405724.dkr.ecr.ap-south-1.amazonaws.com/bmi-app'
        AWS_REGION         = 'ap-south-1'
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        EC2_USER           = 'ec2-user'
        EC2_HOST           = credentials('ec2-host')
        SSH_KEY            = credentials('ec2-ssh-key')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                bat "docker build -t bmi-app:%BUILD_NUMBER% ."
            }
        }

        stage('Push to ECR') {
            steps {
                bat "aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %ECR_REPO%"
                bat "docker tag bmi-app:%BUILD_NUMBER% %ECR_REPO%:%BUILD_NUMBER%"
                bat "docker tag bmi-app:%BUILD_NUMBER% %ECR_REPO%:latest"
                bat "docker push %ECR_REPO%:%BUILD_NUMBER%"
                bat "docker push %ECR_REPO%:latest"
            }
        }

        stage('Deploy to EC2') {
            steps {
                bat """
                    ssh -o StrictHostKeyChecking=no -i "%SSH_KEY%" %EC2_USER%@%EC2_HOST% "aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %ECR_REPO% && docker pull %ECR_REPO%:latest && docker stop bmi-app 2>/dev/null; docker rm bmi-app 2>/dev/null; docker run -d --name bmi-app -p 8080:8080 --restart always %ECR_REPO%:latest"
                """
            }
        }
    }

    post {
        success {
            echo 'Deployment successful -> http://[EC2_HOST]:8080'
        }
        failure {
            echo 'Pipeline failed. Check stage logs above.'
        }
        always {
            bat "docker rmi bmi-app:%BUILD_NUMBER% 2>nul & exit 0"
        }
    }
}
