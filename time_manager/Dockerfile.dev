FROM bitwalker/alpine-elixir-phoenix:latest

# # Copier tout le contenu du dossier time_manager dans le conteneur
COPY . /time_manager
# Définir le répertoire de travail
WORKDIR /time_manager

# RUN mix deps.get

# Rendre le script entrypoint.sh exécutable
RUN chmod +x ./entrypoint.sh

# Installer les utilitaires PostgreSQL pour pg_isready (si nécessaire)
RUN apk --no-cache add postgresql-client

# Exécuter le script entrypoint.sh avec sh
CMD ["sh", "./entrypoint.sh"]
