-- ==========================================
-- SGDA - Schema SQL complet (MySQL 8.0+)
-- Systeme de Gestion des Demandes Academiques
-- ==========================================
SET NAMES utf8mb4;
SET time_zone = '+00:00';

DROP TABLE IF EXISTS historique_transition;
DROP TABLE IF EXISTS piece_jointe;
DROP TABLE IF EXISTS commentaire;
DROP TABLE IF EXISTS demande;
DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS type_demande;
DROP TABLE IF EXISTS etat_demande;
DROP TABLE IF EXISTS role;

-- 1) Tables de reference
CREATE TABLE role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(30) NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    actif TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT uq_role_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE etat_demande (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(30) NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    ordre INT NOT NULL,
    actif TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT uq_etat_demande_code UNIQUE (code),
    CONSTRAINT uq_etat_demande_ordre UNIQUE (ordre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE type_demande (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(30) NOT NULL,
    libelle VARCHAR(120) NOT NULL,
    description TEXT NULL,
    actif TINYINT(1) NOT NULL DEFAULT 1,
    cree_le TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_type_demande_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2) Utilisateurs
CREATE TABLE utilisateur (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT NOT NULL,
    username VARCHAR(60) NOT NULL,
    email VARCHAR(120) NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    nom VARCHAR(80) NOT NULL,
    prenom VARCHAR(80) NOT NULL,
    actif TINYINT(1) NOT NULL DEFAULT 1,
    cree_le TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dernier_login_le TIMESTAMP NULL DEFAULT NULL,
    CONSTRAINT uq_utilisateur_username UNIQUE (username),
    CONSTRAINT uq_utilisateur_email UNIQUE (email),
    CONSTRAINT fk_utilisateur_role
        FOREIGN KEY (role_id) REFERENCES role(id)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_utilisateur_role ON utilisateur(role_id);

-- 3) Demandes
CREATE TABLE demande (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(40) NOT NULL,
    etudiant_id BIGINT NOT NULL,
    agent_id BIGINT NULL,
    type_demande_id BIGINT NOT NULL,
    etat_id BIGINT NOT NULL,
    objet VARCHAR(200) NOT NULL,
    description TEXT NULL,
    date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_soumission TIMESTAMP NULL DEFAULT NULL,
    date_prise_en_charge TIMESTAMP NULL DEFAULT NULL,
    date_decision TIMESTAMP NULL DEFAULT NULL,
    date_archivage TIMESTAMP NULL DEFAULT NULL,
    motif_refus TEXT NULL,
    version INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_demande_code UNIQUE (code),
    CONSTRAINT fk_demande_etudiant
        FOREIGN KEY (etudiant_id) REFERENCES utilisateur(id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_demande_agent
        FOREIGN KEY (agent_id) REFERENCES utilisateur(id)
        ON UPDATE RESTRICT ON DELETE SET NULL,
    CONSTRAINT fk_demande_type
        FOREIGN KEY (type_demande_id) REFERENCES type_demande(id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_demande_etat
        FOREIGN KEY (etat_id) REFERENCES etat_demande(id)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_demande_etudiant ON demande(etudiant_id);
CREATE INDEX idx_demande_agent ON demande(agent_id);
CREATE INDEX idx_demande_type ON demande(type_demande_id);
CREATE INDEX idx_demande_etat ON demande(etat_id);
CREATE INDEX idx_demande_date_creation ON demande(date_creation);

-- 4) Commentaires
CREATE TABLE commentaire (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    demande_id BIGINT NOT NULL,
    auteur_id BIGINT NOT NULL,
    contenu TEXT NOT NULL,
    cree_le TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_commentaire_demande
        FOREIGN KEY (demande_id) REFERENCES demande(id)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_commentaire_auteur
        FOREIGN KEY (auteur_id) REFERENCES utilisateur(id)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_commentaire_demande ON commentaire(demande_id);
CREATE INDEX idx_commentaire_auteur ON commentaire(auteur_id);

-- 5) Pieces jointes
CREATE TABLE piece_jointe (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    demande_id BIGINT NOT NULL,
    uploade_par_id BIGINT NOT NULL,
    nom_original VARCHAR(255) NOT NULL,
    mime_type VARCHAR(120) NOT NULL,
    taille_octets BIGINT NOT NULL,
    chemin_stockage VARCHAR(500) NOT NULL,
    sha256 VARCHAR(64) NULL,
    cree_le TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_piece_jointe_demande
        FOREIGN KEY (demande_id) REFERENCES demande(id)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_piece_jointe_uploade_par
        FOREIGN KEY (uploade_par_id) REFERENCES utilisateur(id)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_piece_jointe_demande ON piece_jointe(demande_id);
CREATE INDEX idx_piece_jointe_uploade_par ON piece_jointe(uploade_par_id);

-- 6) Historique du workflow
CREATE TABLE historique_transition (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    demande_id BIGINT NOT NULL,
    de_etat_id BIGINT NULL,
    vers_etat_id BIGINT NOT NULL,
    acteur_id BIGINT NOT NULL,
    commentaire TEXT NULL,
    cree_le TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historique_demande
        FOREIGN KEY (demande_id) REFERENCES demande(id)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_historique_de_etat
        FOREIGN KEY (de_etat_id) REFERENCES etat_demande(id)
        ON UPDATE RESTRICT ON DELETE SET NULL,
    CONSTRAINT fk_historique_vers_etat
        FOREIGN KEY (vers_etat_id) REFERENCES etat_demande(id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_historique_acteur
        FOREIGN KEY (acteur_id) REFERENCES utilisateur(id)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_historique_demande ON historique_transition(demande_id);
CREATE INDEX idx_historique_date ON historique_transition(cree_le);
CREATE INDEX idx_historique_acteur ON historique_transition(acteur_id);

-- 7) Donnees de reference
INSERT INTO role(code, libelle, actif) VALUES
('ETUDIANT', 'Etudiant', 1),
('AGENT', 'Agent administratif', 1),
('ADMIN', 'Administrateur', 1);

INSERT INTO etat_demande(code, libelle, ordre, actif) VALUES
('BROUILLON', 'Brouillon', 1, 1),
('SOUMISE', 'Soumise', 2, 1),
('EN_ATTENTE', 'En attente', 3, 1),
('VALIDEE', 'Validee', 4, 1),
('REFUSEE', 'Refusee', 5, 1),
('ARCHIVEE', 'Archivee', 6, 1);

INSERT INTO type_demande(code, libelle, description, actif) VALUES
('ATTESTATION', 'Attestation de scolarite', 'Demande d attestation officielle de scolarite.', 1),
('RELEVE_NOTES', 'Releve de notes', 'Demande de releve de notes semestriel ou annuel.', 1),
('STAGE', 'Convention de stage', 'Demande liee a l edition ou validation d une convention de stage.', 1);

-- 8) Comptes de demonstration
-- Mot de passe admin: Admin123!
-- Mot de passe agent: Agent123!
-- Mot de passe etudiant: Etudiant123!
INSERT INTO utilisateur(role_id, username, email, mot_de_passe, nom, prenom, actif) VALUES
((SELECT id FROM role WHERE code = 'ADMIN'), 'admin', 'admin@sgda.local', '65536:38AsrhUe60Fjf/30tzBkVA==:2g7mtWh4Uo+d54Z4ITky7YK779+FScoJI/6bM9ulC3g=', 'Systeme', 'Admin', 1),
((SELECT id FROM role WHERE code = 'AGENT'), 'agent1', 'agent@sgda.local', '65536:DuTYPyjK6x9z6jsEeyQ6QA==:3pWSFzmQ+JeINt6YqZ9NRMEpwU8Po0Tzr9/4SVkSQ8s=', 'Kouassi', 'Agent', 1),
((SELECT id FROM role WHERE code = 'ETUDIANT'), 'etudiant1', 'etudiant@sgda.local', '65536:9D8AFTwVq/9dIlqISqftPA==:dwCJskTQV3d/32Jxrxf4O+cZdKklBQ1ne+TOF1AiPjM=', 'Ndiaye', 'Etudiant', 1);
