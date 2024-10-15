#!/bin/sh
set -e  # S'interrompre en cas d'erreur

# Docker entrypoint

echo "Répertoire actuel PROD: "
ls  # Liste les fichiers du répertoire

echo "Variables d'environnement:"
echo "POSTGRES_USER: $POSTGRES_USER"
echo "POSTGRES_PASSWORD: $POSTGRES_PASSWORD"
echo "POSTGRES_HOST: $POSTGRES_HOST"
echo "POSTGRES_DB: $POSTGRES_DB"

# Attendre que PostgreSQL soit prêt
echo "Vérification si Postgres accepte les connexions sur $POSTGRES_HOST:5432"
until pg_isready -q -h "$POSTGRES_HOST" -p 5432 -U "$POSTGRES_USER"; do
  echo "$(date) - en attente de la base de données"
  sleep 2
done

# Créer la base de données si elle n'existe pas
export PGPASSWORD=$POSTGRES_PASSWORD  # Ajouter le mot de passe pour psql
DB_EXISTS=$(psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -lqt | cut -d \| -f 1 | grep -w "$POSTGRES_DB" | wc -l)

if [ "$DB_EXISTS" -eq 0 ]; then
  echo "La base de données $POSTGRES_DB n'existe pas. Création..."
  createdb -h "$POSTGRES_HOST" -U "$POSTGRES_USER" "$POSTGRES_DB"
  echo "Base de données $POSTGRES_DB créée."
  echo "Démarrage de l'application TimeManager..."
  /app/bin/time_manager eval "Application.ensure_all_started(:time_manager)"

  # Exécution des migrations avec Ecto
  echo "Exécution des migrations..."
  /app/bin/time_manager eval "Ecto.Migrator.run(TimeManager.Repo, 'priv/repo/migrations', :up, all: true)"
else
  echo "La base de données $POSTGRES_DB existe déjà."
fi

# Démarrer l'application pour les migrations

# Démarrer le serveur Phoenix via le release
echo "Démarrage du serveur Phoenix en production..."
exec "/app/bin/time_manager" start
