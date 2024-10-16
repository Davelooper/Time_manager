#!/bin/sh
# set -e  # S'interrompre en cas d'erreur

echo "Répertoire actuel de PROD :"
ls  # Liste les fichiers du répertoire
# Recuperer les dependances
echo "Installation des dépendances ..."
npm install -g serve
npm install run-p
npm install

# Démarrer le serveur Phoenix
echo "Build ..."
npm run build

# Démarrer le serveur Vue.js
echo "Démarrage du serveur ..."
serve -s dist -l 8000