pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "207613818218"
        AWS_REGION = "ap-south-1"
        IMAGE_NAME = "html-website"  // <-- this matches your ECR repo
        ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/yashvireddyy/adjt_integration'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME% .'
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '207613818218']]) {
                    bat """
                    aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com
                    """
                }
            }
        }

        stage('Push to ECR') {
            steps {
                bat """
                docker tag %IMAGE_NAME%:latest %ECR_REPO%:latest
                docker push %ECR_REPO%:latest
                """
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '207613818218']]) {
                    bat 'terraform init'
            }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '207613818218']]) {
                    bat 'terraform apply -auto-approve'
            }
            }
        }
    }
}
