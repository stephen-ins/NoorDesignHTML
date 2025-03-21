-- Création de la base de données NoorDesign
-- --------------------------------------------------------
CREATE
    DATABASE noordesign;

USE
    noordesign;

-- --------------------------------------------------------
-- Création de la table Client
-- --------------------------------------------------------
CREATE TABLE
    users
(
    id             INT AUTO_INCREMENT PRIMARY KEY,
    nom            VARCHAR(100)        NOT NULL,
    prenom         VARCHAR(100)        NOT NULL,
    email          VARCHAR(255) UNIQUE NOT NULL,
    mot_de_passe   VARCHAR(255)        NOT NULL,
    adresse        TEXT,
    ville          VARCHAR(100),
    code_postal    VARCHAR(20),
    pays           VARCHAR(100),
    telephone      VARCHAR(20),
    date_naissance DATE,
    genre          ENUM ('homme', 'femme'),
    date_creation  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



-- --------------------------------------------------------
-- Création de la table Categorie : Gestion des différents types de bijoux
-- --------------------------------------------------------
CREATE TABLE
    categories
(
    id            INT AUTO_INCREMENT PRIMARY KEY,
    nom           VARCHAR(100) NOT NULL,
    description   TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- Création de la table Produit : Gestion des bijoux
-- --------------------------------------------------------
CREATE TABLE
    products
(
    id           INT AUTO_INCREMENT PRIMARY KEY,
    nom          VARCHAR(255)   NOT NULL,
    description  TEXT,
    prix         DECIMAL(10, 2) NOT NULL,
    stock        INT            NOT NULL DEFAULT 0,
    image        VARCHAR(255),
    materiaux    VARCHAR(255),
    taille       VARCHAR(50),
    poids        DECIMAL(10, 2),
    categorie_id INT,
    date_ajout   TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categorie_id) REFERENCES categories (id)
);

-- --------------------------------------------------------
-- Création de la table Commande : Gestion des commandes
-- --------------------------------------------------------
CREATE TABLE
    orders
(
    id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT            NOT NULL,
    date_commande TIMESTAMP                                            DEFAULT CURRENT_TIMESTAMP,
    status        ENUM ('en attente', 'expédiée', 'livrée', 'annulée') DEFAULT 'en attente',
    total         DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- --------------------------------------------------------
-- Création de la table Commande_Produit : Gestion des produits dans les commandes
-- --------------------------------------------------------
CREATE TABLE
    order_details
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    order_id   INT            NOT NULL,
    product_id INT            NOT NULL,
    quantity   INT            NOT NULL,
    price      DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
);

-- --------------------------------------------------------
-- Création de la table Avis : Gestion des avis sur les produits
-- --------------------------------------------------------
CREATE TABLE
    reviews
(
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT,
    product_id  INT,
    note        INT CHECK (note BETWEEN 1 AND 5),
    commentaire TEXT,
    date_avis   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
);

-- --------------------------------------------------------
-- Création de la table Paiements : Gestion des paiements
-- --------------------------------------------------------
CREATE TABLE
    payments
(
    id            INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT                                  NOT NULL,
    montant       DECIMAL(10, 2)                       NOT NULL,
    date_paiement TIMESTAMP                               DEFAULT CURRENT_TIMESTAMP,
    mode_paiement ENUM ('carte', 'paypal', 'virement') NOT NULL,
    status        ENUM ('en attente', 'réussi', 'échoué') DEFAULT 'en attente',
    FOREIGN KEY (order_id) REFERENCES orders (id)
);

-- --------------------------------------------------------
-- Création de la table réductions/promotions : Gestion des réductions sur les produits
-- --------------------------------------------------------
CREATE TABLE
    discounts
(
    id                   INT AUTO_INCREMENT PRIMARY KEY,
    code                 VARCHAR(50) UNIQUE              NOT NULL,
    description          TEXT,
    type                 ENUM ('pourcentage', 'montant') NOT NULL,
    valeur               DECIMAL(10, 2)                  NOT NULL,
    date_debut           DATETIME                        NOT NULL,
    date_fin             DATETIME                        NOT NULL,
    utilisation_max      INT     DEFAULT NULL, -- Nombre max d'utilisations (NULL = illimité)
    utilisation_actuelle INT     DEFAULT 0,
    actif                BOOLEAN DEFAULT TRUE
);

-- --------------------------------------------------------
-- Création de la table association reduction/produit : Gestion des réductions sur les produits
-- --------------------------------------------------------
CREATE TABLE
    product_discounts
(
    id          INT AUTO_INCREMENT PRIMARY KEY,
    product_id  INT NOT NULL,
    discount_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products (id),
    FOREIGN KEY (discount_id) REFERENCES discounts (id)
);

-- --------------------------------------------------------
-- Création de la table favoris : Gestion des produits favoris
-- --------------------------------------------------------
CREATE TABLE
    wishlist
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    product_id INT NOT NULL,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, product_id), -- Empêche les doublons
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
);

-- --------------------------------------------------------
-- Création de la table gestion des retours : Gestion des retours de produits
-- --------------------------------------------------------
CREATE TABLE
    returns
(
    id           INT AUTO_INCREMENT PRIMARY KEY,
    order_id     INT NOT NULL,
    user_id      INT NOT NULL,
    product_id   INT NOT NULL,
    motif        ENUM (
        'défectueux',
        'non conforme',
        'taille incorrecte',
        'autre'
        )            NOT NULL,
    commentaire  TEXT,
    status       ENUM (
        'demandé',
        'en cours',
        'accepté',
        'refusé',
        'remboursé'
        )                  DEFAULT 'demandé',
    date_demande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
);

-- --------------------------------------------------------
-- Création de la table gestion des points de fidélité : Gestion des points de fidélité
-- --------------------------------------------------------
CREATE TABLE
    loyalty_points
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT,
    points     INT NOT NULL DEFAULT 0,
    date_ajout TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- --------------------------------------------------------
-- Création de la table gestion des notifications : Gestion des notifications
-- --------------------------------------------------------
CREATE TABLE
    notifications
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT,
    type       ENUM ('email', 'sms') NOT NULL,
    message    TEXT                  NOT NULL,
    statut     ENUM ('envoyé', 'échec') DEFAULT 'envoyé',
    date_envoi TIMESTAMP                DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);