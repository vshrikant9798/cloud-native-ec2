pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        TF_DIR = "infra"
        IMAGE_NAME = "myapp"
        ECR_URL = "936486080097.dkr.ecr.ap-south-1.amazonaws.com/bookstore-ec2"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vshrikant9798/cloud-native-ec2.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                        export AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=${AWS_REGION}

                        cd ${TF_DIR}
                        terraform init
                        terraform apply -auto-approve
                    """
                }
            }
        }

        stage('Fetch EC2 IP') {
            steps {
                script {
                    EC2_IP = sh(script: "cd ${TF_DIR} && terraform output -raw ec2_ip", returnStdout: true).trim()
                    echo "EC2 IP: ${EC2_IP}"
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Docker Login to ECR') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                        export AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=${AWS_REGION}

                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${ECR_URL}
                    """
                }
            }
        }

        stage('Docker Push to ECR') {
            steps {
                sh """
                    docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${ECR_URL}:${BUILD_NUMBER}
                    docker push ${ECR_URL}:${BUILD_NUMBER}
                """
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
                            sudo docker pull ${ECR_URL}:${BUILD_NUMBER}
                            sudo docker stop app || true
                            sudo docker rm app || true
                            sudo docker run -d --name app -p 80:3000 ${ECR_URL}:${BUILD_NUMBER}
                        '
                    """
                }
            }
        }
    }
}