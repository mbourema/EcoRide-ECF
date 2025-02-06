-- Table Utilisateur
CREATE TABLE Utilisateur (
    utilisateur_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(50) UNIQUE,
    mdp VARCHAR(255), -- Pour hacher les mots de passe
    telephone VARCHAR(20),
    adresse VARCHAR(100),
    date_naissance DATE,
    photo BLOB,
    pseudo VARCHAR(50) UNIQUE
);

-- Table Role (Passager, Chauffeur, Employé, Admin)
CREATE TABLE Role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) UNIQUE
);

-- Table d’association Utilisateur_Role (Un utilisateur peut avoir plusieurs rôles)
CREATE TABLE Utilisateur_Role (
    utilisateur_id INT,
    role_id INT,
    PRIMARY KEY (utilisateur_id, role_id),
    CONSTRAINT fk_utilisateur_role_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(utilisateur_id),
    CONSTRAINT fk_utilisateur_role_role FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

-- Table Marque (Marques de voitures)
CREATE TABLE Marque (
    marque_id INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) UNIQUE
);

-- Table Voiture (Détails des véhicules des chauffeurs)
CREATE TABLE Voiture (
    voiture_id INT AUTO_INCREMENT PRIMARY KEY,
    modele VARCHAR(50),
    immatriculation VARCHAR(20) UNIQUE,
    energie VARCHAR(255),
    couleur VARCHAR(30),
    date_premiere_immatriculation DATE,
    nb_places INT,
    utilisateur_id INT,
    marque_id INT,
    CONSTRAINT fk_voiture_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(utilisateur_id),
    CONSTRAINT fk_voiture_marque FOREIGN KEY (marque_id) REFERENCES Marque(marque_id)
);

-- Table Covoiturage (Détails des trajets)
CREATE TABLE Covoiturage (
    covoiturage_id INT AUTO_INCREMENT PRIMARY KEY,
    date_depart DATETIME,
    lieu_depart VARCHAR(100),
    date_arrivee DATETIME,
    lieu_arrivee VARCHAR(100),
    statut VARCHAR(255),
    nb_places INT,
    prix_personne FLOAT,
    voiture_id INT,
    CONSTRAINT fk_covoiturage_voiture FOREIGN KEY (voiture_id) REFERENCES Voiture(voiture_id)
);

-- Table d’association Utilisateur_Covoiturage (Pour associer passagers aux trajets)
CREATE TABLE Utilisateur_Covoiturage (
    utilisateur_id INT,
    covoiturage_id INT,
    PRIMARY KEY (utilisateur_id, covoiturage_id),
    CONSTRAINT fk_utilisateur_covoiturage_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(utilisateur_id),
    CONSTRAINT fk_utilisateur_covoiturage_covoiturage FOREIGN KEY (covoiturage_id) REFERENCES Covoiturage(covoiturage_id)
);

-- Table Paiements / Crédits (Gestion des transactions)
CREATE TABLE Paiement (
    paiement_id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT,
    montant FLOAT,
    date_paiement DATETIME,
    avancement VARCHAR(255),
    CONSTRAINT fk_paiement_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(utilisateur_id)
);

-- Table Employés (Validation d'avis et gestion administrative)
CREATE TABLE Employe (
    employe_id INT AUTO_INCREMENT PRIMARY KEY
);

-- Table Sanctions / Suspensions (Gestion des bannissements)
CREATE TABLE Suspension (
    suspension_id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT,
    employe_id INT,
    raison VARCHAR(255),
    date_debut DATETIME,
    date_fin DATETIME,
    sanction VARCHAR(255),
    CONSTRAINT fk_suspension_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(utilisateur_id),
    CONSTRAINT fk_suspension_employe FOREIGN KEY (employe_id) REFERENCES Employe(employe_id)
);
