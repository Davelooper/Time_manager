#!/bin/sh
# set -e  # S'interrompre en cas d'erreur

echo "Répertoire actuel de DEV : "
ls  # Liste les fichiers du répertoire
# Recuperer les dependances
echo "Installation des dépendances ..."
npm install

# Démarrer le serveur Phoenix
echo "Run ..."
npm run dev
