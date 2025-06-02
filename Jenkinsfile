pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "jayasowmiya/open-banking-web:latest"
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/SowmiyaJS/bankingsystem.git', branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }
        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([ credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/' ]) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl apply -f k8s/deployment.yaml -n microservices"
            }
        }
    }
}