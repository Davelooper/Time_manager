#!/bin/sh
# set -e  # Arrête le script en cas d'erreur

echo "Répertoire actuel de PROD : "
ls  # Liste les fichiers du répertoire

# Suppression de l'ancien build
echo "Suppression de l'ancien build..."
rm -rf dist

# Installation des dépendances globales
echo "Installation des dépendances globales..."
npm install -g serve

# Installation des dépendances du projet
echo "Installation des dépendances du projet..."
npm install

# Lancement du build de production
echo "Lancement du build de production..."
npm run build || { echo 'Le build a échoué, arrêt du script'; exit 1; }

# Démarrage du serveur Vue.js seulement si le build est réussi
echo "Démarrage du serveur Vue.js..."
serve -s dist -l 8000
