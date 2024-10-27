
# T-POO-700-NCY_6

### Lien utile 
GIT public : https://github.com/Davelooper/Time_manager

Backend dockerisé local : localhost:4000
Frontend dockerisé local: localhost:8000
Postgres dockerisé local :  localhost:5432


### Prérequis 
- Avoir NodeJS
- Avoir Docker Desktop / Docker Engine
- Avoir une connexion internet
- Avoir un ordinateur 

### Documentation technique 
#### Environnement de travail

Ce projet a été développer sous `Windows` et `Linux` gràce a Docker avec :

     Serveur : 
        - Postgres ( Base de données)
        - Jenkins
        - Docker / Docker copose
     Backend (API) :
        - Elixir/Pheonix
     Frontend : 
        - VueJS
        - TailwindCSS
        - Javascript
    
L'application est sécurisé, et utilise différences technologies pour s'y assurer :

 - Pointage via oAuth
 - Hashage des mots de passe.
 - Sécurisation des utilisateurs via JWT & oAuth
 - Utilisation de token pour identifier l'utilisateur lors des requetes importantes. (JsonWebToken et oAuth)

### Manuel d'utilisation

#### Utilisation

vous pouvez

- Vous connecter 
- Accéder a des options suplémentaire via le compte administrateur
- Pointer votre heure d'arriver et de départ, et visualiser votre planning

Le .env a été mis dans le projet seulement pour la facilité le travail mais ne doit pas être inclus dans un projet officiel.