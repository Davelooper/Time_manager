pipeline {
  agent any

  environment {
    GITHUB_CREDENTIALS_ID = 'github_credentials'
    DOCKER_CREDENTIALS_ID = 'dockerhub_credentials'
    ENV_FILE = '.env'
  }

  stages {

    // Étape pour définir les variables Docker Compose et les variables d'environnement à partir du fichier .env
    stage('Set Docker Compose and Env Variables') {
      steps {
        script {
          // Charger les variables depuis le fichier .env avec `sh` et les affecter aux variables de Jenkins
          sh '''
            set -a
            source ${ENV_FILE}
            set +a
          '''
          script {
            if (env.BRANCH_NAME == 'alex') { // Main branch
              echo "Using production Docker Compose and Env"
              env.DOCKER_COMPOSE_FILE = 'docker-compose.prod.yaml'
              // Copier les valeurs pour PROD
              env.POSTGRES_USER = sh(script: "echo $POSTGRES_USER_PROD", returnStdout: true).trim()
              env.POSTGRES_PASSWORD = sh(script: "echo $POSTGRES_PASSWORD_PROD", returnStdout: true).trim()
              env.POSTGRES_DB = sh(script: "echo $POSTGRES_DB_PROD", returnStdout: true).trim()
            } else if (env.BRANCH_NAME == 'prealex') { // Dev branch
              echo "Using development Docker Compose and Env"
              env.DOCKER_COMPOSE_FILE = 'docker-compose.dev.yaml'
              // Copier les valeurs pour DEV
              env.POSTGRES_USER = sh(script: "echo $POSTGRES_USER_DEV", returnStdout: true).trim()
              env.POSTGRES_PASSWORD = sh(script: "echo $POSTGRES_PASSWORD_DEV", returnStdout: true).trim()
              env.POSTGRES_DB = sh(script: "echo $POSTGRES_DB_DEV", returnStdout: true).trim()
            } else {
              error "Unsupported branch: ${env.BRANCH_NAME}. Only 'alex' and 'prealex' are supported."
            }

            // Afficher les valeurs pour debug
            echo "Postgres User: ${POSTGRES_USER}"
            echo "Postgres DB: ${POSTGRES_DB}"
          }
        }
      }
    }
    stage('Check Docker Versions') {
      steps {
        script {
          echo "Checking Docker versions"
          sh '''docker --version && docker-compose --version'''
        }
      }
    }
    stage('Checkout') {
      steps {
        script {
          git credentialsId: "${GITHUB_CREDENTIALS_ID}", url: 'https://github.com/Davelooper/Time_manager', branch: "${env.BRANCH_NAME}"
        }
      }
    }
    stage('Install Elixir Dependencies') {
      steps {
        script {
          echo "Installing Elixir Dependencies"
          sh "cd backend && mix local.hex --force && mix local.rebar --force"
          sh "cd backend && mix deps.get"
        }
      }
    }
    stage('Start Database for Test') {
    steps { 
      script {
        echo "Env files"
        sh "cat ${ENV_FILE}"  // Affiche le contenu du fichier .env pour vérifier

        echo "Starting Postgres container for tests"
        sh "docker-compose -f ${DOCKER_COMPOSE_FILE} --env-file ${ENV_FILE} up -d db"

        // Attendre que Postgres soit prêt
        echo "Waiting for Postgres to be ready..."
        sh """
          until docker exec \$(docker-compose -f ${DOCKER_COMPOSE_FILE} ps -q db) pg_isready -h localhost -p 5432 -U ${POSTGRES_USER}; do
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
