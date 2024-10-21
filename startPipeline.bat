@echo on
setlocal

REM Charger les variables d'environnement depuis le fichier .env
for /f "delims=" %%i in (.env) do set %%i

REM Afficher la variable d'environnement SERVICE_ENV pour débogage
echo SERVICE_ENV = %SERVICE_ENV%

REM Vérifier la variable d'environnement SERVICE_ENV
if "%SERVICE_ENV%" == "PROD" (
    echo Lancement de l'environnement de production...

    REM Arrêter et supprimer les conteneurs associés à docker-compose.prod.yaml
    docker-compose -f docker-compose.pipeline.yaml --env-file .env down

    @REM REM Supprimer les images associées aux services de docker-compose.prod.yaml
    @REM FOR /F "tokens=*" %%i IN ('docker-compose -f docker-compose.prod.yaml config --services') DO docker rmi %%i

    REM Relancer et reconstruire les services pour la production
    docker-compose -f docker-compose.pipeline.yaml --env-file .env up -d --build

) else (
    echo Lancement de l'environnement de développement...

    REM Arrêter et supprimer les conteneurs associés à docker-compose.dev.yaml
    docker-compose -f docker-compose.pipeline.yaml --env-file .env down

    @REM REM Supprimer les images associées aux services de docker-compose.dev.yaml
    @REM FOR /F "tokens=*" %%i IN ('docker-compose -f docker-compose.dev.yaml config --services') DO docker rmi %%i

    REM Relancer et reconstruire les services pour le développement
    docker-compose -f docker-compose.pipeline.yaml --env-file .env up -d --build
)

REM Pause pour garder la fenêtre ouverte et voir l'erreur
pause
