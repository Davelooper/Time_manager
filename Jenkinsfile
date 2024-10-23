pipeline {
  agent any

  environment {
    GITHUB_CREDENTIALS_ID = 'github_credentials'
    DOCKER_CREDENTIALS_ID = 'dockerhub_credentials'
    ENV_FILE = '.env'
  }



    // Étape pour définir les variables Docker Compose et les variables d'environnement à partir du fichier .env
    stages {

    stage('Set Docker Compose and Env Variables') {
      steps {
        script {
          // Charger les variables depuis le fichier .env et les injecter dans Jenkin
          sh '''
            # Charger le fichier .env et exporter les variables dans Jenkins
            set -a
            . ./${ENV_FILE}  # Charge les variables
            echo "POSTGRES_USER_DEV=$POSTGRES_USER_DEV" > env_output
            echo "POSTGRES_PASSWORD_DEV=$POSTGRES_PASSWORD_DEV" >> env_output
            echo "POSTGRES_DB_DEV=$POSTGRES_DB_DEV" >> env_output
            echo "POSTGRES_USER_PROD=$POSTGRES_USER_PROD" >> env_output
            echo "POSTGRES_PASSWORD_PROD=$POSTGRES_PASSWORD_PROD" >> env_output
            echo "POSTGRES_DB_PROD=$POSTGRES_DB_PROD" >> env_output
            set +a
          '''

          // Lire les variables exportées
          def envVars = readFile('env_output').split('\n').collectEntries { entry ->
              def pair = entry.split('=')
              [(pair[0]): pair[1]]
          }

          // Définir les variables en fonction de la branche
          if (env.BRANCH_NAME == 'alex') { // Main branch
            echo "Using production Docker Compose and Env"
            env.DOCKER_COMPOSE_FILE = 'docker-compose.prod.yaml'
            // Utiliser les valeurs PROD
            env.POSTGRES_USER = envVars['POSTGRES_USER_PROD']
            env.POSTGRES_PASSWORD = envVars['POSTGRES_PASSWORD_PROD']
            env.POSTGRES_DB = envVars['POSTGRES_DB_PROD']
          } else if (env.BRANCH_NAME == 'prealex') { // Dev branch
            echo "Using development Docker Compose and Env"
            env.DOCKER_COMPOSE_FILE = 'docker-compose.dev.yaml'
            // Utiliser les valeurs DEV
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
