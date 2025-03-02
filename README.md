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

Utilisation de Symfony 7.2 pour bénéficier des dernières fonctionnalités et optimisations.

# Installation des dépendances essentielles
Ajout des dépendances nécessaires pour la gestion de la base de données et des entités :

composer require symfony/orm-pack  # Ajout de Doctrine ORM pour gérer MariaDB

composer require --dev symfony/maker-bundle  # Génération rapide des entités et commandes

Doctrine ORM est indispensable pour gérer la base de données relationnelle (MariaDB).

Maker Bundle permet de générer rapidement les entités, contrôleurs et commandes.

# Gestion du dépôt Git et organisation du projet
Création d’un repository distant pour le projet EcoRide-BackEnd, intégré comme submodule dans un repository parent ECF qui contient les dossiers :

Front-End (HTML, SCSS, JavaScript)

Back-End (API Symfony)

Pourquoi ce choix ?

Permet une organisation claire entre le front-end et le back-end.

Facilite la gestion des versions séparées tout en maintenant un repository global.

#  Configuration des bases de données

Ajout des URLs des bases de données MariaDB et MongoDB dans les fichiers .env et .env.local.

.env : Paramètres généraux (souvent utilisés en production).

.env.local : Configuration spécifique à l'environnement local (base de données locale, etc.).

php bin/console cache:clear --env=dev #Se mettre en environnement de developpement

php bin/console cache:clear --env=prod #Se mettre en environnement de production

# Gestion des migrations et des schémas de base de données

Réinitialisation et mise à jour des bases de données :

del /s /q migrations\*  # Suppression des anciennes migrations

php bin/console doctrine:database:drop --force  # Suppression de la base de données

php bin/console doctrine:database:create # Recréation de la base de données

php bin/console make:migrations # Recréer les migrations

php bin/console doctrine:migrations:migrate  # Exécution des migrations

php bin/console doctrine:mongodb:schema:update  # Mise à jour du schéma MongoDB

Assure une base propre avant de recréer les entités et migrations.

Permet de synchroniser les schémas de base de données avec le code.

php bin/console cache:clear # A effectuer après un changement dans les controlleur ou les fichier de config pour être sur d'appliquer le changements à l'API

# Sécurité et authentification
Ajout du composant Security de Symfony et gestion des rôles utilisateur :

composer require symfony/security-bundle  # Installation du composant de sécurité

composer require lexik/jwt-authentication-bundle  # Gestion des tokens JWT

Security Bundle permet de gérer l’authentification et les permissions pour effectuer des requêtes sur certaines routes (permissions définis dans symfony/config/packages).

JWT (JSON Web Token) est utilisé pour sécuriser les échanges entre le client et l’API.

Initialisation des rôles dès le démarrage de l’API (dans la table rols).

# Gestion des fixtures et données initiales
Ajout d’orm-fixtures pour générer des données de test :

composer require --dev orm-fixtures  # Installation des fixtures

composer require --dev symfony/test-pack  # Installation des outils de test

Tests unitaires réalisés :

php bin/phpunit --filter UtilisateurTest

php bin/phpunit --filter CovoiturageTest

php bin/phpunit --filter AvisTest

Chargement des fixtures dans la base de données :

php bin/console doctrine:fixtures:load

# Gestion du dépôt Git

git checkout main # Une fois les fonctionnalités poussée sur le branches de développement fonctionnelles, se placer dans la branche principale

git merge developpement # Fusionner les commits de la branche developpement dans la branche main (localement)

git push origin main # Envoyer les changement dans la branche main distante

git branch -d developpement # Suppression locale de la branche de developpement (si souhaité)

git push origin --delete developpement # Suppression de la branche de developpement distante

git fetch origin # Si la branche distante contient des modifications non présentes en local, ce qui empêche de push des modifications locales, récupérer les mises à jour distantes sans les fusionner au local

git log HEAD..origin/main --oneline #Lister les modifications présentes sur la branche distantes et pas présentes en local

git pull origin main --rebase #Appliquer les modifications distantes avant les commits locaux

git push origin main

# Autres configurations

Suppression du bundle JWT après utilisation :

composer remove lexik/jwt-authentication-bundle (choix d'utilisation de OAuth finalement pour sécuriser l'accès aux différentes routes de l'API)

Activation de l'extension ZIP PHP (certaines installations de packages nécessitent que composer utilise l'extension zip) :

Décommenter l’extension zip dans php.ini

extension=zip 

Utilisation des logiciels pour la conception des interfaces :

Balsamiq pour les wireframes

Figma pour les mockups

Installation de Node.js et de bibliothèques pour le front-end :

npm install bootstrap  # Installation de Bootstrap

npm i bootstrap-icons  # Installation des icônes Bootstrap

Nouveau serveur pour prendre en charge le routage front end javascript :

npm install -g http-server # Installation du server 

http-server -c-1 --gzip --proxy http://localhost:8080?/  # Démarrage du serveur

Installation de CORS pour permette au front end de requeter via notre API Symfony :

composer require nelmio/cors-bundle  # Installation du bundle CORS

Configuration des règles CORS dans le fichier config/packages/nelmio_cors.yaml.

Installation de AWS SDK (Utilisé pour envoyer des photos depuis l'API vers un bucket Amazon S3 mais finalement opté pour l'entrée d'url via les formulaire du front):

npm install aws-sdk  # Installation du SDK AWS côté Node.js

composer require aws/aws-sdk-php  # Installation du SDK AWS côté PHP

# Deploiement en local

L'api est disponible dans le repository mbourema/EcoRide-BackEnd: Back end de l'application web EcoRide.

Il faut disposer d'un serveur comme apache, d'une version de php récente (PHP 8.2.12 a été utilisé), de Symfony CLI (version 5.10.6 utilisée) et d'une base de donnée mysql et mongodb (configurer les url dans .env.local).

En se rendant dans le dossier symfony, il faut exécuter la commande symfony server:start -d afin de lancer le serveur en arrière plan (terminal toujours utilisable) et la documentation de l'api sera disponible en locale en entrant /api/doc après l'adresse du serveur local dans un navigateur. Les routes sont toutes utilisables et commentée, mais certaines nécessitent une authentification à l'aide de l'api token retrouvé dans la table utilisateur pour un utilisateur ayant un role correspondant (tout les roles sont accessibles lors de la création d'un nouvel utilisateur (voir identifiant dans la table role). Il faut afin de pouvoir utiliser les différentes routes, creer la base de données EcoRide, faire les migrations et exécuter les commande SQL suivantes dans la base de données mySQL :

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

Le front end est disponible à : mbourema/EcoRide-FrontEnd: Front end de l'application web EcoRide. L'extension Live server de visual studio code ne permet pas de charger le système de routage qu'il comporte. 

L'utilisation de : npm install -g http-server permet d'actionner le système de routage en local. Il est nécessaire de réaliser les installations suivantes :

npm install bootstrap  # Installation de Bootstrap

npm i bootstrap-icons  # Installation des icônes Bootstrap

Ensuite ce rendre dans le dossier et entrer la commande http-server -c-1 --gzip --proxy http://localhost:8080?/, l'application web est alors accessible en local via : http://localhost:8080?/

Faire attention a renseigner la bonne valeur de d'adresse pour le serveur local qui héberge l'API dans le fichier JS/index.js ! export const apiUrl = {votre adresse de serveur}

# Deploiment en ligne

Installation du CLI heroku.

heroku login #connexion

php -v
composer -v
git --version # Checker le set up nécessaire

heroku create # Creation de l'appli heroku pour recevoir le code source

git push heroku main #Pousser l'application vers l'app heroku 

heroku open # visualiser l'appli a l'url générée

heroku addons:create jawsdb:kitefin --app <nom de l'app> #Ajouter l'addons jawsdb pour déployer une base de données mysql

heroku config:get JAWSDB_URL --app <nom de l'app> #Recupérer les informations de connection

Ensuite changer la variable DATABASE_URL dans Symfony, dans le fichier .env ou config/packages/doctrine.yaml ou .env.local (selon ou elle est définie)

mysqldump -u root -p ecoride > ecoride.sql #Exporter la base de donnée ecoride mysql en local dans un fichier SQL (changer USE Ecoride; pour USE <nom de la base de données déployée sur Heroku)

mysql -h -u -p database < ecoride.sql #Importer le fichier dans la base de donnée mysql déployée sur heroku

Pour la base de donnée mongodb créer une base MongoDB sur MongoDB Atlas.

Creer un cluster, ajouter un utilisateur et un mot de passe, récupérer l'url de connexion

heroku config:set MONGODB_URI="url avec nom et mot de passe"

Changer les connexions MongoDB dans symfony (config/package/doctrine_mongodb.yaml...)

Permettre dans mongo atlas d'autoriser les adresses IP à ce connecter à la base de données

Déployer le front :

Hébergeur utilisé : Always data avec FileZilla pour le protocole FTP puis Netlify

Prérequis : modifier dans le fichier index.js la variable "const apiUrl" selon la nouvelle url de l'API déployée via Heroku.

Configurer le routage du serveur pour utiliser le notre dans l'encadrer "Configuration avancée" lors de la création d'un nouveau site sur AlwaysData :
RewriteEngine On
RewriteRule ^/[a-zA-Z0-9]+[/]?$ /index.html [QSA,L]

Pour Netlify création d'un fichier dans le front : _redirect, qui contient : /*    /index.html   200, afin de rediriger toutes les pages vers index.html et utiliser
le système de routage défini côté client.

symfony/config/packages/nelmio_cors.yaml : donner les autorisations CORS au front déployé sur always data et netlify.

Développement continu : 

git add .

git commit -m "Message de modifications"

git push origin main (repository lié a netlify)

