#!/bin/sh

echo "Répertoire actuel PROD: "
ls

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
export PGPASSWORD=$POSTGRES_PASSWORD
DB_EXISTS=$(psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -lqt | cut -d \| -f 1 | grep -w "$POSTGRES_DB" | wc -l)

if [ "$DB_EXISTS" -eq 0 ]; then
  echo "La base de données $POSTGRES_DB n'existe pas. Création..."
  createdb -h "$POSTGRES_HOST" -U "$POSTGRES_USER" "$POSTGRES_DB"
  echo "Base de données $POSTGRES_DB créée."
else
  echo "La base de données $POSTGRES_DB existe déjà."
fi

# Exécution des migrations avec la release
echo "Exécution des migrations..."
/app/bin/backend eval "Backend.Release.migrate"

# Démarrer le serveur Phoenix via le release
echo "Démarrage du serveur Phoenix en production..."
exec "/app/bin/backend" "start"
