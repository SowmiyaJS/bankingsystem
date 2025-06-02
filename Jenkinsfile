pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "jayasowmiya/open-banking-web:latest"
    }
    stages {
        stage('Checkout') {  // Pull latest code from GitHub
            steps {
                git url: 'https://github.com/SowmiyaJS/bankingsystem.git', branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
        sh "docker build -t jayasowmiya/open-banking-web:latest -f ./docker/Dockerfile ."
            }
        }
        stage('Push to DockerHub') {  // Push container image to DockerHub
            steps {
                withDockerRegistry([ credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/' ]) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }
        stage('Deploy to Kubernetes') {  // Deploy microservice to Kubernetes
            steps {
                sh "kubectl apply -f k8s/deployment.yaml -n microservices"
            }
        }
    }
}