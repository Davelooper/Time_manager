#!/bin/bash

# Afficher la variable d'environnement SERVICE_ENV pour débogage
echo "SERVICE_ENV = $SERVICE_ENV"

# Fonction pour supprimer les conteneurs, volumes, images et réseaux d'un fichier docker-compose
cleanup() {
  local compose_file=$1
  echo "Arrêt et suppression des conteneurs, volumes et conteneurs orphelins pour $compose_file..."
  docker-compose -f $compose_file --env-file .env down --volumes --remove-orphans

  echo "Suppression des images associées aux services de $compose_file..."
  docker-compose -f $compose_file config --services | xargs -I {} docker rmi -f {}

  echo "Nettoyage des réseaux inutilisés..."
  docker network prune -f

  echo "Nettoyage des volumes inutilisés..."
  docker volume prune -f
}

# Vérifier la variable d'environnement SERVICE_ENV
if [ "$SERVICE_ENV" = "PROD" ]; then
  echo "Lancement de l'environnement de production..."

  # Nettoyage pour l'environnement de production
  cleanup "docker-compose.prod.yaml"

  # Relancer et reconstruire les services pour la production
  echo "Redémarrage des services en production..."
  docker compose -f docker-compose.prod.yaml --env-file .env up -d

else
  echo "Lancement de l'environnement de développement..."

  # Nettoyage pour l'environnement de développement
  cleanup "docker-compose.dev.yaml"

  # Relancer et reconstruire les services pour le développement
  echo "Redémarrage des services en développement..."
  docker compose -f docker-compose.dev.yaml --env-file .env up -d --build
fi