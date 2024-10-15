#!/bin/sh
# set -e  # S'interrompre en cas d'erreur

# Docker entrypoint

echo "Répertoire actuel DEV: "
ls  # Liste les fichiers du répertoire

echo "Variables d'environnement:"
echo "POSTGRES_USER: $POSTGRES_USER"
echo "POSTGRES_PASSWORD: $POSTGRES_PASSWORD"
echo "POSTGRES_HOST: $POSTGRES_HOST"
echo "POSTGRES_DB: $POSTGRES_DB"

# Recuperer les dependances
mix deps.get

# Attendre que PostgreSQL soit prêt
echo "Vérification si Postgres accepte les connexions sur $POSTGRES_HOST:5432"
until pg_isready -q -h "$POSTGRES_HOST" -p 5432 -U "$POSTGRES_USER"; do
  echo "$(date) - en attente de la base de données"
  sleep 2
done

exec mix ecto.reset

# Créer la base de données si elle n'existe pas
export PGPASSWORD=$POSTGRES_PASSWORD  # Ajouter le mot de passe pour psql
if [ -z "$(psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -At -c "\list" | grep "^$POSTGRES_DB$")" ]; then
  echo "La base de données $POSTGRES_DB n'existe pas. Création..."
  mix ecto.create
  echo "Base de données $POSTGRES_DB créée."
fi

# Exécuter les migrations, même si la base de données existe déjà
echo "Exécution des migrations..."
mix ecto.migrate

# Démarrer le serveur Phoenix
echo "Démarrage du serveur Phoenix..."
exec mix phx.server
