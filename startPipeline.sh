#!/bin/bash

# Charger les variables d'environnement depuis le fichier .env
set -o allexport
. ./.env
set +o allexport

# Afficher la variable d'environnement SERVICE_ENV pour débogage
echo "SERVICE_ENV = $SERVICE_ENV"

# Vérifier la variable d'environnement SERVICE_ENV
if [ "$SERVICE_ENV" = "PROD" ]; then  # Remplacer == par = 
    echo "Lancement de l'environnement de production..."

    # Arrêter et supprimer les conteneurs associés à docker-compose.pipeline.yaml
    docker compose -f docker-compose.pipeline.yaml --env-file .env down

    docker network create "shared-network" || true

    # Relancer et reconstruire les services pour la production
    docker compose -f docker-compose.pipeline.yaml --env-file .env up -d --build

else
    echo "Lancement de l'environnement de développement..."

    # Arrêter et supprimer les conteneurs associés à docker-compose.pipeline.yaml
    docker compose -f docker-compose.pipeline.yaml --env-file .env down

    docker network create "shared-network" || true

    # Relancer et reconstruire les services pour le développement
    docker compose -f docker-compose.pipeline.yaml --env-file .env up -d --build
fi

# Pause pour garder la fenêtre ouverte et voir l'erreur (équivalent de pause dans bash)
read -p "Appuyez sur une touche pour continuer..."
