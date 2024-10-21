pipeline {
  agent any

  environment {
    GITHUB_CREDENTIALS_ID = 'github-credentials'
    DOCKER_CREDENTIALS_ID = 'dockerhub_credentials'
    DOCKER_COMPOSE_DEV = 'docker-compose.dev.yaml'
    DOCKER_COMPOSE_PROD = 'docker-compose.prod.yaml'
  }

  stages {
    stage('Checkout') {
      steps {
          script {
              git credentialsId: "${GITHUB_CREDENTIALS_ID}", url: 'https://github.com/Davelooper/Time_manager', branch: 'main'
          }
      }
    }
    stage('Login to DockerHub') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
            echo 'Logged into DockerHub'
          }
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          echo "Building and deploying for environment ${SERVICE_ENV}"
          sh "docker-compose -f ${DOCKER_COMPOSE_FILE} --env-file ${DOCKER_ENV_FILE} up -d --build"
        }
      }
    }
    post {
        always {
            sh 'docker-compose -f ${DOCKER_COMPOSE_FILE} down --volumes || true'
        }
    }
  }

}