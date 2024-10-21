pipeline {
  agent any

  environment {
    // SERVICE_ENV = 'PROD'
    GITHUB_CREDENTIALS_ID = 'github_credentials'
    DOCKER_CREDENTIALS_ID = 'dockerhub_credentials'
    DOCKER_COMPOSE_DEV = 'docker-compose.dev.yaml'
    DOCKER_COMPOSE_PROD = 'docker-compose.prod.yaml'
    ENV_FILE = '.env'
  }

  stages {
    stage('Checkout') {
      steps {
          script {
              git credentialsId: "${GITHUB_CREDENTIALS_ID}", url: 'https://github.com/Davelooper/Time_manager', branch: 'main'
          }
      }
    }

    stage('Build Docker Images') {
      steps {
        script {
          echo "Building Docker Images"
          sh "docker compose -f ${DOCKER_COMPOSE_PROD} --env-file ${ENV_FILE} build"
        }
      }
    }

    stage('Login to DockerHub for push') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
            echo 'Logged into DockerHub'
            echo "Pushing Docker Images"
            sh "docker-compose -f ${DOCKER_COMPOSE_PROD} push"
            echo "Docker Images pushed to DockerHub"
          }
        }
      }
    }
  }
  post {
    always {
      script {
        sh 'docker-compose -f ${DOCKER_COMPOSE_FILE} down --volumes || true'
      }
    }
  }

}