pipeline {
  agent any

  environment {
    GITHUB_CREDENTIALS_ID = 'github_credentials'
    DOCKER_CREDENTIALS_ID = 'dockerhub_credentials'
    ENV_FILE = '.env'
    NETWORK_NAME = 'shared-network'  // Nom du réseau partag
  }

  stages {
    stage('Check current directory files') {
      steps {
        script {
          echo 'Listing files in the current directory:'
          sh 'ls -la'
        }
      }
    }
    stage('Load environment variables') {
      steps {
        script {
          echo 'Loading .env file and expanding environment variables'

          // Lire le fichier .env et charger les variables dans envVars
          def envVars = [:]
          def envFile = readFile('.env').split('\n')

          for (line in envFile) {
            if (line.trim() && !line.startsWith('#')) {
              def keyValue = line.split('=')
              if (keyValue.length == 2) {
                envVars[keyValue[0].trim()] = keyValue[1].trim()
              }
            }
          }

          // Définir les variables en fonction de la branche
          if (env.BRANCH_NAME == 'alex') { // Main branch
            echo 'Using production Docker Compose and Env'
            env.DOCKER_COMPOSE_FILE = 'docker-compose.prod.yaml'
            env.POSTGRES_USER = envVars['POSTGRES_USER_PROD']
            env.POSTGRES_PASSWORD = envVars['POSTGRES_PASSWORD_PROD']
            env.POSTGRES_DB = envVars['POSTGRES_DB_PROD']
          } else if (env.BRANCH_NAME == 'prealex') { // Dev branch
            echo 'Using development Docker Compose and Env'
            env.DOCKER_COMPOSE_FILE = 'docker-compose.dev.yaml'
            env.POSTGRES_USER = envVars['POSTGRES_USER_DEV']
            env.POSTGRES_PASSWORD = envVars['POSTGRES_PASSWORD_DEV']
            env.POSTGRES_DB = envVars['POSTGRES_DB_DEV']
          } else {
            error "Unsupported branch: ${env.BRANCH_NAME}. Only 'alex' and 'prealex' are supported."
          }

          // Afficher les valeurs pour debug
          echo "Postgres User: ${POSTGRES_USER}"
          echo "Postgres DB: ${POSTGRES_DB}"
        }
      }
    }
    stage('Show loaded env variable') {
      steps {
        script {
          echo 'Loaded environment variables:'
          sh 'env | grep -i POSTGRES_'
        }
      }
    }
    stage('Create Network if not exists') {
      steps {
        script {
          echo "Checking if network ${NETWORK_NAME} exists"

          // Vérifier si le réseau existe
          def networkExists = sh(script: "docker network ls --filter name=${NETWORK_NAME} -q", returnStdout: true).trim()
          // if(networkExists) {
          //   // Supprimer le réseau
          //   // echo "Network ${NETWORK_NAME} already exists. Removing it..."
          //   sh "docker network rm ${NETWORK_NAME}"
          // }
          // Si le réseau n'existe pas, le créer
          if (!networkExists) {
              echo "Network ${NETWORK_NAME} does not exist. Creating it..."
              sh "docker network create ${NETWORK_NAME}"
          } else {

              echo "Network ${NETWORK_NAME} already exists."
          }
        }
      }
    }
    stage('Start Database for Test') {
      steps {
        script {
          echo "Starting Postgres container for tests"
          sh "docker-compose -f ${DOCKER_COMPOSE_FILE} --env-file ${ENV_FILE} up -d db"

          // Attendre que Postgres soit prêt
          echo "Waiting for Postgres to be ready..."
          sh """
            until docker exec \$(docker-compose -f ${DOCKER_COMPOSE_FILE} ps -q db) pg_isready -h db -p 5432 -U ${POSTGRES_USER}; do
              echo "Waiting for Postgres..."
              sleep 2
            done
            echo "Postgres is ready!"
          """
        }
      }
    }
    stage('Compile Elixir & Elixir Deps') {
      steps {
        script {
          echo 'Installing Elixir Dependencies'
          sh 'cd backend && mix deps.get'
          echo 'Compiling Elixir'
          sh 'cd backend && mix deps.compile'
          sh 'cd backend && mix compile'
        }
      }
    }
    stage('Create and Populate BDD') {
      steps {
        script {
          echo 'Create and Populate BDD'
          sh 'cd backend && mix ecto.create'
          sh 'cd backend && mix ecto.migrate'
        }
      }
    }

    stage('Run Backend Tests (Elixir) ') {
      steps {
        script {
          echo 'Running Tests'
          sh 'cd backend && mix test'
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
            echo 'Pushing Docker Images'
            sh "docker-compose -f ${DOCKER_COMPOSE_FILE} push"
            echo 'Docker Images pushed to DockerHub'
          }
        }
      }
    }
  }

  // post {
  //   always {
  //     script {
  //       sh 'docker-compose -f ${DOCKER_COMPOSE_FILE} down --volumes || true'
  //     }
  //   }
  // }
}
