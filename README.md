# SGDA — Système de Gestion des Demandes Académiques

> Plateforme web multi-tiers développée en Jakarta EE 10 pour la gestion structurée des demandes académiques à l'Université Polytechnique de Gitega.

---

## Table des matières

1. [Présentation du projet](#1-présentation-du-projet)
2. [Architecture technique](#2-architecture-technique)
3. [Technologies utilisées](#3-technologies-utilisées)
4. [Prérequis](#4-prérequis)
5. [Installation et configuration](#5-installation-et-configuration)
6. [Structure du projet](#6-structure-du-projet)
7. [Entités JPA](#7-entités-jpa)
8. [Workflow des demandes](#8-workflow-des-demandes)
9. [Rôles et permissions](#9-rôles-et-permissions)
10. [Fonctionnalités par rôle](#10-fonctionnalités-par-rôle)
11. [Services EJB](#11-services-ejb)
12. [Sécurité](#12-sécurité)
13. [Interface utilisateur](#13-interface-utilisateur)
14. [API JSON internes](#14-api-json-internes)
15. [Base de données](#15-base-de-données)
16. [Déploiement](#16-déploiement)
17. [Gestion de versions Git](#17-gestion-de-versions-git)
18. [Équipe](#18-équipe)

---

## 1. Présentation du projet

**SGDA** est une application web d'entreprise développée dans le cadre du cours de **Java EE — BAC4 Génie Logiciel** à l'Université Polytechnique de Gitega, année universitaire 2025–2026.

### Problème résolu

Les demandes académiques (relevés de notes, attestations de scolarité, conventions de stage, certifications, inscriptions…) étaient traitées de façon manuelle, sans traçabilité et sans circuit clair. SGDA centralise l'ensemble du processus dans un environnement numérique sécurisé.

### Public cible

| Acteur | Rôle dans le système |
|--------|----------------------|
| **Étudiant** | Crée, soumet et suit ses demandes académiques |
| **Agent académique** | Traite les demandes reçues (prise en charge, validation, refus) |
| **Administrateur** | Supervise toute la plateforme, gère les utilisateurs et les types de demandes |

### Points forts

- Workflow complet avec **6 états** distincts et historique de transitions
- Architecture **multi-tiers stricte** : Présentation → Métier (EJB) → Persistance (JPA)
- Interface moderne **mode clair / mode sombre**
- Graphiques dynamiques (Chart.js) rechargés sans rafraîchissement de page
- Sécurité basée sur **HttpSession + Filtre Servlet**
- Aucun framework interdit (pas de Spring, JSF, Thymeleaf, REST)

---

## 2. Architecture technique

```
┌─────────────────────────────────────────────────────────────┐
│                     COUCHE PRÉSENTATION                      │
│  Servlets (doGet/doPost)  ·  JSP + JSTL  ·  EL              │
│  Filtre d'authentification (AuthFilter)                      │
└────────────────────┬────────────────────────────────────────┘
                     │ @Inject (CDI)
┌────────────────────▼────────────────────────────────────────┐
│                     COUCHE MÉTIER (EJB)                      │
│  AuthService  ·  DemandeService  ·  UtilisateurService       │
│  TypeDemandeService  ·  DashboardService  ·  AbstractService │
└────────────────────┬────────────────────────────────────────┘
                     │ EntityManager (JPA / EclipseLink)
┌────────────────────▼────────────────────────────────────────┐
│                   COUCHE PERSISTANCE (JPA)                   │
│  Entités JPA  ·  JPQL  ·  Relations @OneToMany @ManyToOne   │
│  DataSource JTA (jdbc/SGDADS)  ·  MySQL 8                    │
└─────────────────────────────────────────────────────────────┘
```

Le serveur d'applications est **GlassFish 7** (Jakarta EE 10).

---

## 3. Technologies utilisées

| Catégorie | Technologie | Version |
|-----------|-------------|---------|
| Serveur d'applications | GlassFish | 7.x |
| Jakarta EE | Jakarta EE API | 10.0.0 |
| Persistance | JPA / EclipseLink | 4.0.x |
| Injection | CDI (Weld) | intégré GlassFish 7 |
| Sessions métier | EJB Stateless | Jakarta EJB 4.0 |
| Vues | JSP + JSTL | Jakarta JSTL 3.0 |
| Build | Apache Maven | 3.x |
| Base de données | MySQL | 8.x |
| Graphiques | Chart.js | 4.4.0 (CDN) |
| Langue | Java | 21 |
| Chiffrement | javax.crypto (SHA-256 + sel) | JDK intégré |

---

## 4. Prérequis

Avant d'installer le projet, assurez-vous d'avoir :

- **Java JDK 21** installé et la variable `JAVA_HOME` configurée
- **GlassFish 7** installé (ex. `C:\GlassFish\glassfish7`)
- **MySQL 8** (via XAMPP ou installation standalone)
- **Apache Maven 3.x** installé et accessible depuis le terminal
- **MySQL Connector/J 9.x** (driver JDBC copié dans `glassfish/domains/domain1/lib/`)
- **VS Code** avec l'extension Tasks configurée (`.vscode/tasks.json`)

---

## 5. Installation et configuration

### 5.1 Cloner le dépôt

```bash
git clone https://github.com/Chanciella1234/sgda.git
cd sgda
git checkout develop
```

### 5.2 Créer la base de données

```sql
CREATE DATABASE IF NOT EXISTS sgda CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Puis importer le script de données initiales :

```bash
mysql -u root sgda < sgda.sql
```

### 5.3 Installer le driver MySQL dans GlassFish

Copier `mysql-connector-j-X.X.X.jar` dans :

```
C:\GlassFish\glassfish7\glassfish\domains\domain1\lib\
```

### 5.4 Configurer la datasource GlassFish

Démarrer GlassFish puis exécuter dans le terminal :

```bash
# Créer le pool de connexions
asadmin create-jdbc-connection-pool \
  --datasourceclassname=com.mysql.cj.jdbc.MysqlDataSource \
  --restype=javax.sql.DataSource \
  --property user=root:password=VOTRE_MOT_DE_PASSE:databaseName=sgda:serverName=localhost:portNumber=3306:useSSL=false:allowPublicKeyRetrieval=true \
  SGDAPool

# Créer la ressource JDBC
asadmin create-jdbc-resource --connectionpoolid SGDAPool jdbc/SGDADS

# Tester la connexion
asadmin ping-connection-pool SGDAPool
```

### 5.5 Compiler et déployer

Depuis VS Code :

```
Ctrl+Shift+P → Tasks: Run Task → Build + Deploy
```

Ou depuis le terminal :

```bash
# Compiler
mvn clean package -DskipTests

# Déployer sur GlassFish
asadmin deploy --force=true target/sgda.war
```

### 5.6 Accéder à l'application

| URL | Description |
|-----|-------------|
| `http://localhost:8080/sgda` | Application principale |
| `http://localhost:4848` | Console d'administration GlassFish |

---

## 6. Structure du projet

```
sgda/
├── .vscode/
│   └── tasks.json                    # Tâches VS Code (Start, Stop, Deploy, Build)
├── src/
│   └── main/
│       ├── java/com/sgda/
│       │   ├── domain/               # Entités JPA
│       │   │   ├── enums/
│       │   │   │   ├── EtatDemandeCode.java
│       │   │   │   └── RoleCode.java
│       │   │   ├── Commentaire.java
│       │   │   ├── Demande.java
│       │   │   ├── EtatDemande.java
│       │   │   ├── HistoriqueTransition.java
│       │   │   ├── PieceJointe.java
│       │   │   ├── Role.java
│       │   │   ├── TypeDemande.java
│       │   │   └── Utilisateur.java
│       │   ├── service/              # EJB Session Beans (logique métier)
│       │   │   ├── dto/
│       │   │   │   ├── AdminDashboardData.java
│       │   │   │   ├── AgentDashboardData.java
│       │   │   │   ├── AuthenticatedUser.java
│       │   │   │   ├── ChartSeriesData.java
│       │   │   │   ├── RoleStat.java
│       │   │   │   └── StudentDashboardData.java
│       │   │   ├── exception/
│       │   │   │   ├── AuthorizationException.java
│       │   │   │   ├── BusinessException.java
│       │   │   │   └── WorkflowException.java
│       │   │   ├── util/
│       │   │   │   └── PasswordUtils.java
│       │   │   ├── AbstractService.java
│       │   │   ├── AuthService.java
│       │   │   ├── DashboardService.java
│       │   │   ├── DemandeService.java
│       │   │   ├── TypeDemandeService.java
│       │   │   └── UtilisateurService.java
│       │   └── web/
│       │       ├── filter/
│       │       │   └── AuthFilter.java
│       │       ├── servlet/
│       │       │   ├── admin/        # Servlets Administrateur
│       │       │   │   ├── AdminDashboardServlet.java
│       │       │   │   ├── AdminDashboardTrendServlet.java
│       │       │   │   ├── AdminDemandeArchiveServlet.java
│       │       │   │   ├── AdminDemandeDetailServlet.java
│       │       │   │   ├── AdminDemandesServlet.java
│       │       │   │   ├── AdminTypeSaveServlet.java
│       │       │   │   ├── AdminTypesServlet.java
│       │       │   │   ├── AdminUserSaveServlet.java
│       │       │   │   └── AdminUsersServlet.java
│       │       │   ├── agent/        # Servlets Agent
│       │       │   │   ├── AgentDashboardActivityServlet.java
│       │       │   │   ├── AgentDashboardServlet.java
│       │       │   │   ├── AgentDemandeDetailServlet.java
│       │       │   │   ├── AgentDemandeRefuserServlet.java
│       │       │   │   ├── AgentDemandesServlet.java
│       │       │   │   ├── AgentDemandesTaiteesServlet.java
│       │       │   │   ├── AgentDemandeTakeServlet.java
│       │       │   │   └── AgentDemandeValiderServlet.java
│       │       │   ├── student/      # Servlets Étudiant
│       │       │   │   ├── StudentDashboardServlet.java
│       │       │   │   ├── StudentDemandeDeleteServlet.java
│       │       │   │   ├── StudentDemandeDetailServlet.java
│       │       │   │   ├── StudentDemandeFormServlet.java
│       │       │   │   ├── StudentDemandeSaveServlet.java
│       │       │   │   ├── StudentDemandesServlet.java
│       │       │   │   └── StudentDemandeSubmitServlet.java
│       │       │   ├── BaseServlet.java
│       │       │   ├── LoginServlet.java
│       │       │   └── LogoutServlet.java
│       │       └── util/
│       │           ├── JsonUtils.java
│       │           ├── ServletUtils.java
│       │           ├── SessionKeys.java
│       │           └── StoredFileInfo.java
│       ├── resources/META-INF/
│       │   └── persistence.xml       # Configuration JPA / EclipseLink
│       └── webapp/
│           ├── assets/
│           │   ├── css/app.css       # Feuille de style principale (mode clair + sombre)
│           │   └── js/
│           │       ├── app.js        # Interactions UI (sidebar, toasts, dark mode…)
│           │       └── water-animations.js
│           ├── WEB-INF/
│           │   ├── views/
│           │   │   ├── admin/        # Pages JSP Administrateur
│           │   │   │   ├── dashboard.jsp
│           │   │   │   ├── demandes.jsp
│           │   │   │   ├── types.jsp
│           │   │   │   └── users.jsp
│           │   │   ├── agent/        # Pages JSP Agent
│           │   │   │   ├── dashboard.jsp
│           │   │   │   ├── demandes.jsp
│           │   │   │   └── demandes-traitees.jsp
│           │   │   ├── auth/
│           │   │   │   └── login.jsp
│           │   │   ├── common/       # Composants partagés
│           │   │   │   ├── demande-detail.jsp
│           │   │   │   ├── error.jsp
│           │   │   │   ├── flash.jsp
│           │   │   │   ├── footer.jsp
│           │   │   │   └── header.jsp
│           │   │   └── student/      # Pages JSP Étudiant
│           │   │       ├── dashboard.jsp
│           │   │       ├── demande-form.jsp
│           │   │       └── demandes.jsp
│           │   ├── beans.xml         # Activation CDI
│           │   └── web.xml           # Configuration Servlet / Filtre
│           └── index.jsp             # Redirection vers /login
├── sgda.sql                          # Script SQL (structure + données initiales)
├── pom.xml                           # Configuration Maven
└── README.md
```

---

## 7. Entités JPA

Le modèle de données comprend **8 entités** bien normalisées.

### Diagramme des relations

```
Role ─────────────── Utilisateur ─────────────── Demande
                          │                          │
                     (agent/etudiant)         EtatDemande
                                                     │
                              ┌──────────────────────┤
                              │                      │
                         Commentaire           PieceJointe
                              │
                     HistoriqueTransition
                              │
                         TypeDemande
```

### Description des entités

| Entité | Table SQL | Description |
|--------|-----------|-------------|
| `Role` | `role` | Rôles du système (ADMIN, AGENT, ETUDIANT) |
| `Utilisateur` | `utilisateur` | Comptes utilisateurs avec mot de passe haché |
| `EtatDemande` | `etat_demande` | États du workflow (6 états) |
| `TypeDemande` | `type_demande` | Catégories de demandes (relevé, attestation…) |
| `Demande` | `demande` | Demande académique principale |
| `Commentaire` | `commentaire` | Commentaires sur une demande |
| `PieceJointe` | `piece_jointe` | Fichiers attachés à une demande |
| `HistoriqueTransition` | `historique_transition` | Journal de chaque changement d'état |

---

## 8. Workflow des demandes

Chaque demande suit un circuit d'états strict, contrôlé par `DemandeService`.

```
                    ┌─────────────┐
                    │  BROUILLON  │  ← Créée par l'étudiant
                    └──────┬──────┘
                           │ soumettre()
                    ┌──────▼──────┐
                    │   SOUMISE   │  ← Visible par les agents
                    └──────┬──────┘
                           │ prendreEnCharge()
                    ┌──────▼──────┐
                    │  EN ATTENTE │  ← Assignée à un agent
                    └──────┬──────┘
              ┌────────────┴────────────┐
              │ valider()               │ refuser()
       ┌──────▼──────┐          ┌──────▼──────┐
       │   VALIDEE   │          │   REFUSEE   │
       └──────┬──────┘          └──────┬──────┘
              └────────────┬────────────┘
                           │ archiver()  (Admin uniquement)
                    ┌──────▼──────┐
                    │   ARCHIVEE  │  ← État final
                    └─────────────┘
```

### Règles métier par transition

| Transition | Acteur autorisé | Condition |
|------------|-----------------|-----------|
| `BROUILLON → SOUMISE` | Étudiant propriétaire | L'objet est obligatoire |
| `SOUMISE → EN_ATTENTE` | Agent actif | La demande n'est pas déjà prise |
| `EN_ATTENTE → VALIDEE` | Agent assigné | La demande lui est assignée |
| `EN_ATTENTE → REFUSEE` | Agent assigné | Motif de refus obligatoire |
| `VALIDEE/REFUSEE → ARCHIVEE` | Administrateur | État terminal uniquement |

---

## 9. Rôles et permissions

```
ADMIN
 ├── Superviser toutes les demandes
 ├── Archiver les demandes validées ou refusées
 ├── Gérer les utilisateurs (CRUD)
 ├── Gérer les types de demandes (CRUD)
 └── Accéder aux statistiques globales

AGENT
 ├── Voir les demandes soumises (non assignées)
 ├── Prendre en charge une demande
 ├── Valider ou refuser une demande assignée
 ├── Commenter une demande
 └── Accéder à ses propres statistiques

ETUDIANT
 ├── Créer un brouillon de demande
 ├── Modifier / supprimer un brouillon
 ├── Ajouter / supprimer des pièces jointes (brouillon uniquement)
 ├── Soumettre une demande
 ├── Suivre l'état de ses demandes
 ├── Consulter l'historique des transitions
 └── Commenter ses propres demandes
```

---

## 10. Fonctionnalités par rôle

### Administrateur

- **Tableau de bord** : statistiques globales, graphique de répartition des utilisateurs par rôle (barres), graphique des demandes par état (doughnut), évolution temporelle dynamique (jour / semaine / mois / année)
- **Supervision** : liste complète des demandes avec filtrage instantané par statut (boutons-chips colorés), consultation du détail, archivage
- **Gestion des utilisateurs** : liste paginée, création / modification d'un utilisateur, activation / désactivation d'un compte
- **Types de demandes** : liste, création / modification / désactivation d'un type de demande

### Agent

- **Tableau de bord** : statistiques personnelles, demandes prioritaires urgentes (signalées en rouge si soumises depuis plus de 5 jours), graphique de répartition de son portefeuille (doughnut), graphique de ses demandes traitées par mois (dynamique)
- **Demandes à traiter** : liste des demandes soumises non assignées et des demandes en attente lui étant assignées, prise en charge, validation, refus avec motif
- **Demandes traitées** : historique complet des dossiers qu'il a traités

### Étudiant

- **Tableau de bord** : statistiques personnelles, graphique de l'état de ses demandes (doughnut), historique récent des 5 dernières demandes sous forme de timeline
- **Mes demandes** : liste complète avec statuts, boutons d'action contextuels selon l'état
- **Nouvelle demande** : formulaire de création (type, objet, description), ajout de pièces jointes, soumission

---

## 11. Services EJB

Tous les services sont des **EJB Session Beans Stateless** annotés `@Stateless` et héritent de `AbstractService` qui expose l'`EntityManager` injecté via CDI.

### AbstractService

Classe de base fournissant :
- `EntityManager` injecté par CDI
- Méthodes utilitaires partagées : `requireEntity`, `requireUtilisateurActif`, `requireEtat`, `requireRole`, `getSingleResultOrNull`, `normalize`, `requireText`
- Méthode `enregistrerTransition` pour journaliser chaque changement d'état

### AuthService

- `authenticate(login, password)` : recherche l'utilisateur par username ou email, vérifie le mot de passe (SHA-256 + sel), met à jour `dernierLoginLe`, retourne un `AuthenticatedUser` DTO

### DemandeService

- `createDraft` / `updateDraft` / `deleteDraft` : gestion des brouillons
- `soumettre` / `prendreEnCharge` / `valider` / `refuser` / `archiver` : transitions du workflow
- `ajouterCommentaire` : ajout de commentaire avec contrôle d'accès par rôle
- `ajouterPieceJointe` / `supprimerPieceJointe` : gestion des fichiers
- `listByEtudiant` / `listDemandesPourAgent` / `listAllDemandes` : requêtes JPQL optimisées avec `JOIN FETCH`

### UtilisateurService

- `findAll` / `findById` / `save` / `update` / `toggleActif` : CRUD complet des utilisateurs

### TypeDemandeService

- `findAll` / `findActifs` / `save` / `update` / `toggleActif` : gestion des types de demandes

### DashboardService

- `getAdminDashboard()` : agrège toutes les statistiques admin (compteurs par état, par rôle, évolution temporelle)
- `getAgentDashboard(agentId)` : statistiques personnelles de l'agent
- `getStudentDashboard(etudiantId)` : statistiques personnelles de l'étudiant
- `getTrendData(periode)` : données de tendance JSON pour les graphiques dynamiques

---

## 12. Sécurité

### Authentification

- Formulaire de connexion via `LoginServlet`
- Mot de passe stocké en **SHA-256 avec sel** (`PasswordUtils`)
- Session stockée dans `HttpSession` avec la clé `SessionKeys.AUTH_USER`
- Déconnexion via `LogoutServlet` qui invalide la session

### Autorisation

`AuthFilter` intercepte toutes les requêtes protégées :

```
/admin/*  → réservé au rôle ADMIN
/agent/*  → réservé au rôle AGENT
/student/*→ réservé au rôle ETUDIANT
```

Si la session est absente ou le rôle insuffisant, l'utilisateur est redirigé vers `/login`.

Les EJB appliquent une deuxième couche de contrôle avec des vérifications explicites de rôle (`requireRole`) et de propriété des ressources.

---

## 13. Interface utilisateur

### Design system

- **Palette principale** : Caramel doré `#C98A3E` + Vert forêt `#1A2E0F`
- **Fond de page** : Blanc crème `#FEFAE8` (mode clair) / `#0D1A07` (mode sombre)
- **Mode sombre** : activable via le bouton bascule dans la navbar, préférence sauvegardée en `localStorage`

### Couleurs des états

| État | Couleur | Code hex |
|------|---------|----------|
| Brouillon | Gris | `#888780` |
| Soumise | Caramel | `#C98A3E` |
| En attente | Orange | `#D84315` |
| Validée | Vert olive | `#4A5C2A` |
| Refusée | Rouge brique | `#BF360C` |
| Archivée | Brun | `#7A4010` |

### Composants clés

- **Sidebar** : fond vert forêt foncé, élément actif en fond caramel plein avec texte blanc et ombre — visible dans les deux modes
- **Toasts** : notifications avec barre de progression qui se vide en 30 secondes
- **Graphiques doughnut** : total affiché au centre, légende colorée à droite
- **Graphiques dynamiques** : rechargement asynchrone (`fetch`) sans rafraîchissement de page
- **Supervision** : filtrage instantané par statut via boutons-chips

---

## 14. API JSON internes

Deux servlets exposent des données JSON pour les graphiques dynamiques (Chart.js).

### GET `/admin/dashboard/trend`

Paramètre : `periode` = `jour` | `semaine` | `mois` | `annee`

Réponse :

```json
{
  "labels": ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"],
  "soumises": [12, 8, 15, 6, 20, 4, 9],
  "traitees": [10, 7, 12, 5, 18, 3, 8]
}
```

### GET `/agent/dashboard/activity`

Paramètre : `periode` = `3mois` | `6mois` | `annee`

Réponse :

```json
{
  "labels": ["Nov", "Déc", "Jan", "Fév", "Mar", "Avr"],
  "validees": [3, 5, 2, 8, 4, 6],
  "refusees": [1, 0, 2, 1, 3, 1]
}
```

---

## 15. Base de données

### Schéma principal

```sql
-- Rôles
CREATE TABLE role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(30) UNIQUE NOT NULL,   -- ADMIN | AGENT | ETUDIANT
    libelle VARCHAR(100) NOT NULL
);

-- Utilisateurs
CREATE TABLE utilisateur (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(60) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,  -- SHA-256 + sel
    nom VARCHAR(100),
    prenom VARCHAR(100),
    actif BOOLEAN DEFAULT TRUE,
    dernier_login_le DATETIME,
    role_id BIGINT NOT NULL REFERENCES role(id)
);

-- États des demandes
CREATE TABLE etat_demande (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(30) UNIQUE NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    ordre INT
);

-- Types de demandes
CREATE TABLE type_demande (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(60) UNIQUE NOT NULL,
    libelle VARCHAR(200) NOT NULL,
    description TEXT,
    actif BOOLEAN DEFAULT TRUE
);

-- Demandes
CREATE TABLE demande (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(30) UNIQUE,
    objet VARCHAR(300) NOT NULL,
    description TEXT,
    date_creation DATETIME NOT NULL,
    date_soumission DATETIME,
    date_prise_en_charge DATETIME,
    date_decision DATETIME,
    date_archivage DATETIME,
    motif_refus TEXT,
    version INT DEFAULT 0,
    etudiant_id BIGINT NOT NULL REFERENCES utilisateur(id),
    agent_id BIGINT REFERENCES utilisateur(id),
    etat_id BIGINT NOT NULL REFERENCES etat_demande(id),
    type_demande_id BIGINT NOT NULL REFERENCES type_demande(id)
);

-- Commentaires
CREATE TABLE commentaire (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    contenu TEXT NOT NULL,
    cree_le DATETIME NOT NULL,
    demande_id BIGINT NOT NULL REFERENCES demande(id) ON DELETE CASCADE,
    auteur_id BIGINT NOT NULL REFERENCES utilisateur(id)
);

-- Pièces jointes
CREATE TABLE piece_jointe (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nom_original VARCHAR(300) NOT NULL,
    mime_type VARCHAR(100),
    taille_octets BIGINT,
    chemin_stockage VARCHAR(500) NOT NULL,
    sha256 VARCHAR(64),
    cree_le DATETIME NOT NULL,
    demande_id BIGINT NOT NULL REFERENCES demande(id) ON DELETE CASCADE,
    uploade_par_id BIGINT NOT NULL REFERENCES utilisateur(id)
);

-- Historique des transitions
CREATE TABLE historique_transition (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    commentaire TEXT,
    cree_le DATETIME NOT NULL,
    demande_id BIGINT NOT NULL REFERENCES demande(id) ON DELETE CASCADE,
    acteur_id BIGINT NOT NULL REFERENCES utilisateur(id),
    de_etat_id BIGINT REFERENCES etat_demande(id),
    vers_etat_id BIGINT NOT NULL REFERENCES etat_demande(id)
);
```

### Données initiales (sgda.sql)

Le script `sgda.sql` inclut :
- Les 3 rôles (ADMIN, AGENT, ETUDIANT)
- Les 6 états de demande dans l'ordre du workflow
- Des types de demandes prédéfinis (Relevé de notes, Attestation de scolarité, Convention de stage…)
- Des comptes de test pour chaque rôle

---

## 16. Déploiement

### Tasks VS Code configurées

| Task | Commande équivalente |
|------|----------------------|
| `GlassFish: Start` | `asadmin start-domain` |
| `GlassFish: Stop` | `asadmin stop-domain` |
| `GlassFish: Deploy` | `asadmin deploy --force=true target/sgda.war` |
| `Maven: Build` | `mvn clean package -DskipTests` |
| `Build + Deploy` | Build puis Deploy en séquence |

### Déploiement manuel

```bash
# 1. Compiler
mvn clean package -DskipTests

# 2. Démarrer GlassFish
C:\GlassFish\glassfish7\bin\asadmin.bat start-domain

# 3. Déployer
C:\GlassFish\glassfish7\bin\asadmin.bat deploy --force=true target\sgda.war

# 4. Accéder
# http://localhost:8080/sgda
```

### Résolution des problèmes courants

| Problème | Solution |
|----------|----------|
| `JNDI lookup failed jdbc/SGDADS` | Vérifier que le pool SGDAPool est créé et que MySQL tourne |
| `No bootstrap jar exists` (Payara) | Utiliser Community Server Connectors ou les tasks VS Code |
| Erreur BOM `\ufeff` | Exécuter le script Python de nettoyage BOM fourni dans la documentation |
| `illegal character` à la compilation | Les fichiers ont un BOM UTF-8 — voir script de correction |
| Port 4848 déjà utilisé | GlassFish tourne déjà, passer directement au déploiement |

---

## 17. Gestion de versions Git

### Stratégie de branches (Git Flow simplifié)

```
main          ← production stable
  └── develop ← intégration continue
        ├── feature/domain           (entités JPA)
        ├── feature/authentification (login, filtre)
        ├── feature/admin            (servlets admin)
        ├── feature/agent            (servlets agent)
        ├── feature/student          (servlets étudiant)
        └── feature/css              (design et animations)
```

### Workflow de contribution

```bash
# 1. Partir de develop
git checkout develop
git pull origin develop

# 2. Créer une branche feature
git checkout -b feature/ma-fonctionnalite

# 3. Travailler et commiter
git add .
git commit -m "feature/ma-fonctionnalite: description claire"

# 4. Pusher et merger dans develop
git push -u origin feature/ma-fonctionnalite
git checkout develop
git merge feature/ma-fonctionnalite
git push origin develop

# 5. Merger develop dans main (livraison finale)
git checkout main
git merge develop
git push origin main
```

---

## 18. Équipe

| Membre | Rôle | Contributions principales |
|--------|------|--------------------------|
| **Chanciella** | Développeur principal | Architecture, EJB, JPA, Servlets, JSP, configuration GlassFish |
| **Muhimpundu Gloria** | Développeur frontend | Design CSS, animations, composants visuels, pages JSP |

**Année universitaire** : 2025 – 2026

---

## Licence

Projet académique — Université Polytechnique de Gitega  
Département Génie Logiciel / BAC4 
© 2026 SGDA — Tous droits réservés dans le cadre académique.
