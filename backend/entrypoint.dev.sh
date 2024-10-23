#!/bin/sh
# set -e  # S'interrompre en cas d'erreur

# Docker entrypoint

echo "Répertoire actuel DEV: "
ls  # Liste les fichiers du répertoire

ls ./config
echo "Variables d'environnement:"
echo "POSTGRES_USER: $POSTGRES_USER"
echo "POSTGRES_PASSWORD: $POSTGRES_PASSWORD"
echo "POSTGRES_HOST: $POSTGRES_HOST"
echo "POSTGRES_DB: $POSTGRES_DB"

echo "Utilisateur actuel : $(whoami)"
ls -l ./config

# Recuperer les dependances
mix deps.get

# Attendre que PostgreSQL soit prêt
echo "Vérification si Postgres accepte les connexions sur $POSTGRES_HOST:5432"
until pg_isready -q -h "$POSTGRES_HOST" -p 5432 -U "$POSTGRES_USER"; do
  echo "$(date) - en attente de la base de données"
  sleep 2
done

mix ecto.reset

echo "La base de données $POSTGRES_DB n'existe pas. Création..."
mix ecto.create
echo "Base de données $POSTGRES_DB créée."

# Exécuter les migrations, même si la base de données existe déjà
echo "Exécution des migrations..."
mix ecto.migrate

# echo "JE FAIS MON TEST UNITAIRE"
# mix test test/backend/user_test.exs


echo "svp je crée mes données :D"
mix run priv/repo/seeds.exs

# Démarrer le serveur Phoenix
echo "Démarrage du serveur Phoenix..."
mix phx.server
