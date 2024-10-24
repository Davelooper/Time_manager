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
    stage('Set Docker Compose and Env Variables') {
      steps {
        script {
          // Définir les variables en fonction de la branche
          if (env.BRANCH_NAME == 'alex') { // Main branch
            echo "Using production Docker Compose and Env"
            env.DOCKER_COMPOSE_FILE = 'docker-compose.prod.yaml'
            withCredentials([
              string(credentialsId: 'POSTGRES_USER_PROD', variable: 'POSTGRES_USER'),
              string(credentialsId: 'POSTGRES_PASSWORD_PROD', variable: 'POSTGRES_PASSWORD'),
              string(credentialsId: 'POSTGRES_DB_PROD', variable: 'POSTGRES_DB')
            ]) {
              // Les variables sont disponibles ici
            }
          } else if (env.BRANCH_NAME == 'prealex') { // Dev branch
            echo "Using development Docker Compose and Env"
            env.DOCKER_COMPOSE_FILE = 'docker-compose.dev.yaml'
            withCredentials([
              string(credentialsId: 'POSTGRES_USER_DEV', variable: 'POSTGRES_USER'),
              string(credentialsId: 'POSTGRES_PASSWORD_DEV', variable: 'POSTGRES_PASSWORD'),
              string(credentialsId: 'POSTGRES_DB_DEV', variable: 'POSTGRES_DB')
            ]) {
              // Les variables sont disponibles ici
            }
          } else {
            error "Unsupported branch: ${env.BRANCH_NAME}. Only 'alex' and 'prealex' are supported."
          }

          // Afficher les valeurs pour debug (évite d'afficher les mots de passe)
          echo "Postgres User: ${env.POSTGRES_USER}"
          echo "Postgres DB: ${env.POSTGRES_DB}"
        }
      }
    }

    stage('Compile Elixir & Elixir Deps') {
      steps {
        script {
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
