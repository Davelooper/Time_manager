pipeline {
  agent any

  environment {
    GITHUB_CREDENTIALS_ID = 'github_credentials'
    DOCKER_CREDENTIALS_ID = 'dockerhub_credentials'
    ENV_FILE = '.env'
  }

  stages {

    // Étape conditionnelle pour définir si c'est la branche main ou dev
    stage('Set Docker Compose File DEV/PROD') {
      steps {
        script {
          // Vérifie si on est sur la branche main ou dev
          if (env.BRANCH_NAME == 'main') {
            echo "Using production Docker Compose"
            env.DOCKER_COMPOSE_FILE = 'docker-compose.prod.yaml'
          } else if (env.BRANCH_NAME == 'dev') {
            echo "Using development Docker Compose"
            env.DOCKER_COMPOSE_FILE = 'docker-compose.dev.yaml'
          } else {
            error "Unsupported branch: ${env.BRANCH_NAME}. Only 'main' and 'dev' are supported."
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
    stage('Install Elixir DependenciesS') {
      steps {
        script {
          echo "Installing Elixir Dependencies"
          sh "cd backend && mix local.hex --force && mix local.rebar --force"
          sh "cd backend && mix deps.get"
        }
      }
    }
      stage('Start Database for Tests') {
        steps {
          script {
            echo "Env files"
            sh "cat ${ENV_FILE}"
            // Démarrer le conteneur Postgres
            echo "Starting Postgres container for tests"
            sh "docker-compose -f ${DOCKER_COMPOSE_FILE} --env-file ${ENV_FILE} up -d db"

            // Attendre que Postgres soit prêt
            echo "Waiting for Postgres to be ready..."
            sh '''
              until docker exec $(docker-compose -f ${DOCKER_COMPOSE_FILE} ps -q db) pg_isready -h localhost -p 5432 -U ${POSTGRES_USER_DEV}; do
                echo "Waiting for Postgres..."
                sleep 2
              done
              echo "Postgres is ready!"
            '''
          }
        }
      }
    stage('Compile Elixir & Elixir Deps') {
      steps {
        script {
          echo "Compiling Elixir"
          sh "cd backend && mix deps.compile"
          sh "cd backend && mix compile"
          sh "cd backend && "
        }
      }
    }
    stage('Create and Populate BDD') {
      steps {
        script {
          echo "Create and Populate BDD"
          sh "cd backend && ecto.create"
          sh "cd backend && ecto.migrate"
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
