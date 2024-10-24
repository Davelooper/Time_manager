pipeline {
  agent any

  environment {
    GITHUB_CREDENTIALS_ID = 'github_credentials'
    DOCKER_CREDENTIALS_ID = 'dockerhub_credentials'
    ENV_FILE = '.env'
  }



    // Étape pour définir les variables Docker Compose et les variables d'environnement à partir du fichier .env
    stages {
     stage('Check current directory files') {
      steps {
        script {
          echo "Listing files in the current directory:"
          sh "ls -la"
        }
      }
    }
    stage('Load .env Variables') {
      steps {
        script {
          echo "Loading environment variables from .env"
          sh '''
            bash -c 'set -o allexport; source ${ENV_FILE}; set +o allexport'
          '''
        }
      }
    }
    stage('Compile Elixir & Elixir Deps') {
      steps {
        script {
          echo "Installing Elixir Dependencies"
          sh "cd backend && mix deps.get"
          echo "Compiling Elixir"
          sh "cd backend && mix deps.compile"
          sh "cd backend && mix compile"
        }
      }
    }
    stage('Create and Populate BDD') {
      steps {
        script {
          echo "Create and Populate BDD"
          sh "cd backend && mix ecto.create"
          sh "cd backend && mix ecto.migrate"
        }
      }
    }
    stage('Run Backend Tests (Elixir) ') {
      steps {
        script {
          echo "Running Tests"
          sh "cd backend && mix test"
        }
      }
    }

    stage('Build Docker Images') {
      steps {
        script {
          echo "Building Docker Images using ${DOCKER_COMPOSE_FILE}"
          sh "docker-compose -f ${DOCKER_COMPOSE_FILE} --env-file ${ENV_FILE} build"
        }
      }
    }

    stage('Login to DockerHub for push on Docker Hub') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
            echo "Pushing Docker Images"
            sh "docker-compose -f ${DOCKER_COMPOSE_FILE} push"
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
