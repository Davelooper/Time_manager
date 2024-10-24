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
    stage('Load environment variables') {
      steps {
  script {
    echo "Loading .env file and expanding environment variables"

    // Utiliser explicitement bash pour s'assurer que source fonctionne
    sh '''
      # Charger les variables d'environnement depuis le fichier .env
      bash -c "
      set -o allexport
      source ${ENV_FILE}
      set +o allexport
      "
    '''

    // Charger les variables à partir du fichier `.env` et les utiliser dans Jenkins
    def envVars = readProperties file: "${ENV_FILE}"

    if (envVars == null || envVars.isEmpty()) {
      error "No environment variables loaded from ${ENV_FILE}!"
    }

    echo "Loaded environment variables:"

    // Afficher les variables chargées pour vérification
    envVars.each { key, value ->
      echo "${key}=${value}"
    }

    // Définir les variables en fonction de la branche
    if (env.BRANCH_NAME == 'alex') { // Main branch
      echo "Using production Docker Compose and Env"
      env.DOCKER_COMPOSE_FILE = 'docker-compose.prod.yaml'
      env.POSTGRES_USER = envVars['POSTGRES_USER_PROD']
      env.POSTGRES_PASSWORD = envVars['POSTGRES_PASSWORD_PROD']
      env.POSTGRES_DB = envVars['POSTGRES_DB_PROD']
    } else if (env.BRANCH_NAME == 'prealex') { // Dev branch
      echo "Using development Docker Compose and Env"
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
          echo "Loaded environment variables:"
          sh "env | grep -i ${ENV_FILE}"
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
