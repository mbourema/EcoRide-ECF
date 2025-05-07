### Application déployée : https://ecoridespaacetree.netlify.app
### BackEnd de l'application : https://github.com/mbourema/EcoRide-BackEnd
### FrontEnd de l'application : https://github.com/mbourema/EcoRide-FrontEnd

# Installation et configuration de Symfony

L’installation de Symfony a été réalisée en utilisant Symfony CLI et Composer pour garantir un environnement propre et fonctionnel :

scoop install symfony-cli  # Installation de Symfony CLI

symfony check:requirements  # Vérification des prérequis

symfony new symfony --version="7.2.x"  # Création du projet Symfony (version 7.2)

Symfony CLI simplifie la gestion des projets Symfony.

Vérifier les prérequis système permet d'éviter des erreurs pendant le développement.

# Installation des dépendances essentielles

Ajout des dépendances nécessaires pour la gestion de la base de données et des entités :

composer require symfony/orm-pack  # Ajout de Doctrine ORM pour gérer MariaDB

composer require --dev symfony/maker-bundle  # Génération rapide des entités et commandes

# Gestion du dépôt Git et organisation du projet

Création d’un repository distant ECF contenant un MCD pour la base de donnée relationnelle, un MPD, les requêtes SQL préalable pour remplir les tables Role et Marque de la base de données, les liens vers l'application déployée et les repository du front end et du back end de l'application :

Front-End (HTML, SCSS, JavaScript)

Back-End (API Symfony)

Se déplacer vers les dossiers contenant les projets :

git init 

git add .

git -m "message commit"

Créer un repository distant sur github et copier son url :

git remote add origin url

git push -u origin main

git branch developpement # Ajouter une branche developpement

git checkout developpement # S'y déplacer

#  Configuration des bases de données

Ajout des URLs des bases de données MariaDB et MongoDB dans les fichiers .env et .env.local.

.env : URLs des bases de données mongodb et mariadb déployées.

.env.local : URLs des bases de données mongodb et mariadb sur le serveur local (apache via XAMPP).

php bin/console cache:clear --env=dev #Se mettre en environnement de developpement

php bin/console cache:clear --env=prod #Se mettre en environnement de production

# Gestion des migrations et des schémas de base de données

Réinitialisation et mise à jour des bases de données :

del /s /q migrations\*  # Suppression des anciennes migrations

php bin/console doctrine:database:drop --force  # Suppression de la base de données (si conflit dans les migrations et données non importantes)

php bin/console doctrine:database:create # Recréation de la base de données

php bin/console make:migrations # Recréer les migrations

php bin/console doctrine:migrations:migrate  # Exécution des migrations

Si on ne souhaite pas utiliser makerbundle remplacer : php bin/console make:migrations par : php bin/console doctrine:migrations:diff #Creer les migration

Puis migrer avec : php bin/console doctrine:migrations:migrate #Migrer

php bin/console doctrine:mongodb:schema:update  # Mise à jour du schéma MongoDB

php bin/console cache:clear # A effectuer après un changement dans les controlleur ou les fichier de config pour être sur d'appliquer les changements à l'API

# Sécurité et authentification

Ajout du composant Security de Symfony et gestion des rôles utilisateur :

composer require symfony/security-bundle  # Installation du composant de sécurité

Security Bundle permet de gérer l’authentification et les permissions pour effectuer des requêtes sur certaines routes (permissions définis dans symfony/config/packages).

Initialisation des rôles dès le démarrage de l’API (grâce à la table roles).

Choix d'utilisation de OAuth pour sécuriser l'accès aux différentes routes de l'API avec un api_token généré dans la table Utilisateur pour chaque utilisateurs à son inscription.

# Tests unitaires

Tests unitaires réalisés :

php bin/phpunit --filter UtilisateurTest

php bin/phpunit --filter CovoiturageTest

php bin/phpunit --filter AvisTest

# Gestion du dépôt Git

git checkout main # Une fois les fonctionnalités poussées sur la branche de développement et fonctionnelles, se placer dans la branche principale

git merge developpement # Fusionner les commits de la branche developpement dans la branche main (localement)

git push origin main # Envoyer les changements dans la branche main distante

git branch -d developpement # Suppression locale de la branche de developpement (si souhaité)

git push origin --delete developpement # Suppression de la branche de developpement distante

git fetch origin # Si la branche distante contient des modifications non présentes en local, ce qui empêche de push des modifications locales, récupérer les mises à jour distantes sans les fusionner au local

git log HEAD..origin/main --oneline #Lister les modifications présentes sur la branche distante et pas présentes en local

git pull origin main --rebase #Appliquer les modifications distantes avant les commits locaux

git push origin main

# Autres configurations

- Activation de l'extension ZIP PHP (certaines installations de packages nécessitent que composer utilise l'extension zip) :

Décommenter l’extension zip dans php.ini

extension=zip 

- Utilisation des logiciels pour la conception des interfaces :

Balsamiq pour les wireframes

Figma pour les mockups

- Installation de Node.js et de bibliothèques pour le front-end :

npm install bootstrap  # Installation de Bootstrap

npm i bootstrap-icons  # Installation des icônes Bootstrap (finalement obté pour l'utilisation de svg depuis le site bootstrap)

Utilisation de la bibliothèque sweetalert pour des alertes ne nécessitant par d'action de la part de l'utilisateur et plus esthétiques

- Nouveau serveur pour prendre en charge le routage front end javascript :

npm install -g http-server # Installation du server 

http-server -c-1 --gzip --proxy http://localhost:8080?/  # Démarrage du serveur

- Installation de CORS pour permette au front end de requeter via notre API Symfony :

composer require nelmio/cors-bundle  # Installation du bundle CORS

Configuration des règles CORS dans le fichier config/packages/nelmio_cors.yaml.

- Installation du composant symfony/mailer pour envoyer des mails aux utilisateur depuis l'API

composer require symfony/mailer

- Installation de AWS SDK (Utilisé pour envoyer des photos depuis l'API vers un bucket Amazon S3 mais finalement opté pour l'entrée d'url via les formulaire du front):

npm install aws-sdk  # Installation du SDK AWS côté Node.js

composer require aws/aws-sdk-php  # Installation du SDK AWS côté PHP

# Conteneurisation avec Docker

- Front End :

Création d'un Dockerfile pour générer une image de l'application, exposer un port HTTP pour la rendre accessible, démarrer et maintenir le conteneur actif, faire appel au serveur http NGINX.

Création fichier nginx.conf pour configurer le serveur nginx (configuration d'un serveur Nginx qui écoute sur le port 80 pour servir les fichiers statiques, utilisation de la compression GZIP pour améliorer les performances, désactivation de la mise en cache pour permettre le développement et rediriger les erreurs 404 vers un fichier spécifique, utilisation d'un fichier de configuration pour déterminer les types MIME et optimiser la gestion des fichiers)

Build de l'image Docker avec la commande : docker build -t nom-projet-frontend .

Lancer un conteneur docker basé sur l'image construite en arrière plan sur le port 8080 (mappé avec le port 80, accessible à l'url http://localhost:8080/) : docker run -d -p 8080:80 --name frontend-container frontend

Lister les conteneurs en cours d'exécution : docker ps

Arrêter le conteneur : docker stop nom-container

Supprimmer le conteneur : docker rm nom-container

Nettoyer les volumes : docker-compose down -v 

- Back End :

  Configuration du projet Symfony pour fonctionner avec MariaDB et MongoDB dans un environnement Docker :

    Renommage du fichier .env de Symfony en .env.symfony pour séparer les variables de l'application des variables utilisées par Docker Compose.
    
    Ceci permet de créer un fichier .env à la racine du projet dédié à Docker, contenant :
    - Les identifiants de MariaDB
    - Les identifiants de MongoDB
    
  Ajout des variables nécessaires dans .env.symfony pour configurer Symfony :
    
    - DATABASE_URL pour MariaDB avec la bonne version serveur, charset, et désactivation du SSL
    - MONGODB_URL et MONGODB_DB pour ODM MongoDB
    
      Configuration des bundles lock, cors, etc.

  Création d’un fichier compose.yaml :
  
    Définit l’architecture multi-conteneurs suivante :
    - database : image mariadb:10.4.32, avec healthcheck, port local exposé sur 3307
    - mongodb : image mongo:6.0, root user/pass init, healthcheck avec mongosh
    - php : construit via un Dockerfile PHP 8.2-FPM-Alpine avec extensions nécessaires (pdo_mysql, mongodb, gd, etc.), Composer, montage du code source Symfony
    - nginx : image nginx:stable-alpine, configuré pour pointer sur public/ via le fichier nginx.conf

  Contenu du Dockerfile pour le service PHP :
  
    Ajout de toutes les extensions nécessaires à Symfony, MySQL, MongoDB, GD, etc.
    
    Installation de Composer
    
    Suppression du MakerBundle et installation des dépendances Symfony optimisées (--no-dev, --optimize-autoloader)
    
    Définition de APP_ENV=prod et APP_DEBUG=0
    
    Port FPM exposé à 9000

  Fichier nginx.conf :
  
    Serveur écoutant sur le port 80, avec :
    
    - Serveur web statique pointant sur /var/www/public
    
    - Redirection des routes Symfony vers index.php
    
    - Bloc pour interpréter les fichiers .php avec FastCGI
    
    - Passage des variables APP_ENV et APP_DEBUG à PHP
    
    - Logs configurés (access_log, error_log)

  Commandes utiles pendant le développement :
    Lancer l’ensemble des services :
    docker compose up -d
    
    Forcer le rebuild complet (en cas de modifs du Dockerfile) :
    docker compose up -d --build
    
    Redémarrer un service :
    docker compose restart php
    
    Accéder au conteneur PHP :
    docker exec -it symfony-php-1 sh
    
    Mettre à jour le schéma de la base MySQL :
    docker exec -it symfony-php-1 sh -c "php bin/console doctrine:schema:update --force"
    
    Se connecter à Mongo en ligne de commande :
    docker exec -it symfony-mongodb-1 mongosh --username root --password example --authenticationDatabase admin --eval "db.stats()"
    
    Se connecter à MariaDB depuis PHP :
    mariadb --ssl=0 -h database -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}

    Afficher les logs PHP :
    docker compose logs -f php
    
    Supprimer tous les volumes (utile si reset complet des DBs) :
    docker compose down -v
    
    Recompiler les variables d’environnement Symfony :
    composer dump-env prod
    
    Vérifier les variables d’environnement chargées :
    docker exec -it symfony-php-1 sh -c "printenv | grep DATABASE_URL && printenv | grep MYSQL_"


# Deploiement en local

- Back End : 

L'api est disponible dans le repository mbourema/EcoRide-BackEnd: Back end de l'application web EcoRide.

Il faut disposer d'un serveur comme apache, d'une version de php récente (PHP 8.2.12 a été utilisé), de Symfony CLI (version 5.10.6 utilisée) et d'une base de donnée mysql/mariadb et mongodb (configurer les url dans .env.local).

En se rendant dans le dossier symfony, il faut exécuter la commande symfony server:start -d afin de lancer le serveur en arrière plan (terminal toujours utilisable) et la documentation de l'api sera disponible en local à l'url : adresse du serveur/api/doc. Les routes sont toutes utilisables et commentées, mais certaines nécessitent une authentification à l'aide de l'api token retrouvé dans la table utilisateur pour un utilisateur ayant un role correspondant (tout les roles sont accessibles lors de la création d'un nouvel utilisateur via l'API (voir identifiant dans la table role). Il faut afin de pouvoir utiliser les différentes routes, creer la base de données EcoRide, faire les migrations et exécuter les commande SQL suivantes dans la base de données mariaDB :

-- Requetes d'insertion pour la table Role

INSERT INTO role (libelle) VALUES ('ROLE_ADMIN'); 
INSERT INTO role (libelle) VALUES ('ROLE_EMPLOYE');
INSERT INTO role (libelle) VALUES ('ROLE_CONDUCTEUR');
INSERT INTO role (libelle) VALUES ('ROLE_PASSAGER');

-- Requetes d'insertion pour la table Marque

INSERT INTO marque (libelle) VALUES ('Alfa Romeo'); 
INSERT INTO marque (libelle) VALUES ('Audi');
INSERT INTO marque (libelle) VALUES ('BMW');
INSERT INTO marque (libelle) VALUES ('Dacia');
INSERT INTO marque (libelle) VALUES ('Fiat'); 
INSERT INTO marque (libelle) VALUES ('Peugeot');
INSERT INTO marque (libelle) VALUES ('Renault');
INSERT INTO marque (libelle) VALUES ('Volkswagen');
INSERT INTO marque (libelle) VALUES ('Mercedes'); 
INSERT INTO marque (libelle) VALUES ('Ford');
INSERT INTO marque (libelle) VALUES ('Nissan');
INSERT INTO marque (libelle) VALUES ('Opel');
INSERT INTO marque (libelle) VALUES ('Volvo');

Ceci va remplir les tables Marque et Role qui sont essentielles à l'initialisation d'enregistrements dans les autres tables ainsi que pour le fonctionnement du front (formulaires d'inscriptions et d'ajout de voitures).

- Front End :

Le front end est disponible à : mbourema/EcoRide-FrontEnd: Front end de l'application web EcoRide. L'extension Live server de visual studio code ne permet pas de charger le système de routage javascript qu'il comporte. 

L'utilisation de : npm install -g http-server permet d'actionner le système de routage en local. Il est nécessaire de réaliser les installations suivantes :

npm install bootstrap  # Installation de Bootstrap

npm i bootstrap-icons  # Installation des icônes Bootstrap

Ensuite ce rendre dans le dossier et entrer la commande http-server -c-1 --gzip --proxy http://localhost:8080?/, l'application web est alors accessible en local via : http://localhost:8080?/

Faire attention a renseigner la bonne valeur de d'adresse pour le serveur local qui héberge l'API dans le fichier JS/index.js ! export const apiUrl = {votre adresse de serveur}

# Deploiment en ligne

- Déployer le Back End : 

Installation du CLI heroku.

heroku login #connexion

php -v
composer -v
git --version # Checker le set up nécessaire

heroku create # Creation de l'appli heroku pour recevoir le code source

git push heroku main #Pousser l'application vers l'app heroku 

heroku open # visualiser l'appli a l'url générée

heroku addons:create jawsdb:kitefin --app <nom de l'app> # Ajouter l'addons jawsdb pour déployer une base de données mysql

heroku config:get JAWSDB_URL --app <nom de l'app> # Recupérer les informations de connection

Ensuite changer la variable DATABASE_URL dans Symfony, dans le fichier .env ou config/packages/doctrine.yaml 

mysqldump -u root -p ecoride > ecoride.sql # Exporter la base de donnée ecoride mysql en local dans un fichier SQL

mysql -h (adresse de l'hote de la base de données) -u (utilisateur) -p (mot de passe) database < ecoride.sql # Importer le fichier dans la base de donnée mysql déployée sur heroku

Pour la base de donnée mongodb créer une base MongoDB sur MongoDB Atlas.

Creer un cluster, ajouter un utilisateur et un mot de passe, récupérer l'url de connexion

heroku config:set MONGODB_URI="url avec nom et mot de passe"

Changer les connexions MongoDB dans symfony (config/package/doctrine_mongodb.yaml, .env)

Permettre dans mongo atlas d'autoriser les adresses IP à ce connecter à la base de données

- Déployer le Front End : 

Hébergeur utilisé : Netlify

Prérequis : modifier dans le fichier index.js la variable "const apiUrl" selon la nouvelle url de l'API déployée via Heroku.

Configurer le routage du serveur pour utiliser le notre :

Création d'un fichier dans le front : _redirect, qui contient : /*    /index.html   200, afin de rediriger toutes les pages vers index.html et ainsi utiliser le système de routage défini côté client.

symfony/config/packages/nelmio_cors.yaml : donner les autorisations CORS au front déployé sur netlify.

Déploiement continu du Back End : 

git add .

git commit -m "Message de modifications"

git push heroku main

Déploiement continu du Front End : 

git add .

git commit -m "Message de modifications"

git push origin main (repository lié a netlify)

