#!/bin/bash

# Afficher la variable d'environnement SERVICE_ENV pour débogage
echo "SERVICE_ENV = $SERVICE_ENV"

# Vérifier la variable d'environnement SERVICE_ENV
if [ "$SERVICE_ENV" = "PROD" ]; then
  echo "Lancement de l'environnement de production..."
  docker-compose -f docker-compose.prod.yml --env-file .env.prod up -d
else
  echo "Lancement de l'environnement de développement..."
  docker-compose -f docker-compose.dev.yml --env-file .env.dev up -d
fi
