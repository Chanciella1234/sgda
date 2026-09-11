<div align="center">

# SGDA

### Systeme de Gestion des Demandes Academiques

Plateforme web enterprise pour la digitalisation et le pilotage du cycle de vie
des demandes universitaires — de la soumission etudiant à l'archivage administratif.

<br>

![Java](https://img.shields.io/badge/Java-17-E76F00?style=for-the-badge&logo=openjdk&logoColor=white)
![Jakarta EE](https://img.shields.io/badge/Jakarta_EE-10-ED1B2F?style=for-the-badge)
![Maven](https://img.shields.io/badge/Maven-3.8+-C71A36?style=for-the-badge&logo=apache-maven&logoColor=white)
![GlassFish](https://img.shields.io/badge/GlassFish-7-025B8C?style=for-the-badge&logo=eclipseide&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8+-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Chart.js](https://img.shields.io/badge/Chart.js-4-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white)
![GSAP](https://img.shields.io/badge/GSAP-3.12-88CE02?style=for-the-badge)

<br>

**Version** `1.0.0-SNAPSHOT` · **Licence** MIT · **Etat** En developpement actif

</div>

---

## Sommaire

| No. | Section | Description |
|:---:|---------|-------------|
| 1 | [Apercu general](#1-apercu-general) | Objectifs, public cible, fonctionnalites |
| 2 | [Architecture technique](#2-architecture-technique) | Vue d'ensemble des couches applicatives |
| 3 | [Stack technologique](#3-stack-technologique) | Composants et versions utilises |
| 4 | [Modele de donnees](#4-modele-de-donnees) | Entites JPA, enums, relations |
| 5 | [Workflow](#5-workflow) | Automate a etats finis des demandes |
| 6 | [Roles et permissions](#6-roles-et-permissions) | Matrice d'acces par profil |
| 7 | [Diagrammes UML](#7-diagrammes-uml) | Documentation visuelle du systeme |
| 8 | [Installation](#8-installation) | Prerequis, configuration, demarrage |
| 9 | [Base de donnees](#9-base-de-donnees) | Scripts SQL et donnees initiales |
| 10 | [Build et deploiement](#10-build-et-deploiement) | Commandes Maven, configuration serveur |
| 11 | [Guide utilisateur](#11-guide-utilisateur) | Flux par role, utilisation quotidienne |
| 12 | [Design et UI](#12-design-et-ui) | Palette, composants, animations |
| 13 | [Securite](#13-securite) | Mesures de protection implementees |
| 14 | [Performance](#14-performance) | Optimisations et bonnes pratiques |
| 15 | [Accessibilite](#15-accessibilite) | Conformite et ergonomie |
| 16 | [Feuille de route](#16-feuille-de-route) | Phases du projet et avancement |
| 17 | [Contribuer](#17-contribuer) | Conventions et guidelines |
| 18 | [Licence et contact](#18-licence-et-contact) | Informations legales |

---

## 1. Apercu general

### Contexte

Les etablissements universitaires gerent quotidiennement un flux important de demandes academiques — certificats, inscriptions, recours, attestations. Ce processus, souvent manuel et papier, engendre des lenteurs, un manque de traabilite et des pertes d'information.

**SGDA** resout ce probleme en offrant une plateforme centralisee, securisee et stable pour le suivi numerique de ces demandes.

### Objectifs strategiques

| Objectif | Impact |
|----------|--------|
| **Dematerialisation** | Elimination du papier, reduction des delais |
| **Tracabilite** | Historique complet de chaque transition d'etat |
| **Automatisation** | Workflow de validation configurable par role |
| **Securite** | Controle d'acces granulaire et cryptage |
| **Pilotage** | Tableaux de bord en temps reel avec metriques |

### Public cible

| Profil | Role dans le systeme |
|--------|---------------------|
| **Etudiant** | Cree, soumet et suit ses demandes academiques |
| **Agent administratif** | Traite, valide ou refuse les demandes assignees |
| **Administrateur** | Supervise l'ensemble, gere les utilisateurs et parametres |
| **Visiteur** | Consulte la page d'accueil publique |

### Fonctionnalites principales

<details>
<summary><strong>Authentification et gestion des sessions</strong></summary>

- Connexion par nom d'utilisateur ou adresse email
- Hachage securise des mots de passe (bcrypt)
- Session HTTP avec timeout configurable (30 min)
- Redirection automatique adaptee au role
- Rehash automatique si algorithme obsolete

</details>

<details>
<summary><strong>Gestion des demandes (Etudiant)</strong></summary>

- Creation de demandes par type (brouillon ou soumission directe)
- Modification et suppression des brouillons uniquement
- Soumission en un clic
- Suivi de l'etat en temps reel
- Historique complet des transitions
- Detail de chaque demande avec pieces jointes

</details>

<details>
<summary><strong>Traitement des demandes (Agent)</strong></summary>

- Consultation des demandes en attente
- Prise en charge (assignation a un agent)
- Validation ou refus avec motif obligatoire
- Consultation des demandes deja traitees
- Detail avec historique et commentaires

</details>

<details>
<summary><strong>Administration</strong></summary>

- Tableau de bord avec statistiques et graphiques
- Gestion complete des utilisateurs (CRUD)
- Gestion des types de demande (CRUD)
- Supervision de toutes les demandes du systeme
- Archivage des demandes cloturees
- Tendances et metriques temporelles

</details>

---

## 2. Architecture technique

Le systeme est bati sur une **architecture en couches** strictement separee, conformement aux standards Jakarta EE.

```
 ┌──────────────────────────────────────────────────────────────────┐
 │                         CLIENT                                   │
 │               Navigateur Web · HTML/CSS/JS                       │
 └─────────────────────────────┬────────────────────────────────────┘
                               │  HTTP / HTTPS
 ┌─────────────────────────────▼────────────────────────────────────┐
 │                   COUCHE PRESENTATION                            │
 │              Servlet 6.0 · JSP · JSTL 3.0                        │
 │                                                                  │
 │   AuthFilter ─► BaseServlet ─► 24 Servlets ─► 18 Vues JSP       │
 │   (filtrage)    (base)         (3 par role)    (par role)        │
 └─────────────────────────────┬────────────────────────────────────┘
                               │  @Inject (CDI)
 ┌─────────────────────────────▼────────────────────────────────────┐
 │                    COUCHE METIER                                  │
 │               EJB 4.0 · @Stateless                               │
 │                                                                  │
 │   AuthService · DemandeService · UtilisateurService              │
 │   TypeDemandeService · DashboardService                          │
 │                                                                  │
 │   Exceptions : BusinessException · WorkflowException             │
 │                AuthorizationException                            │
 └─────────────────────────────┬────────────────────────────────────┘
                               │  @PersistenceContext
 ┌─────────────────────────────▼────────────────────────────────────┐
 │                   COUCHE PERSISTANCE                              │
 │              JPA 3.0 · EntityManager                             │
 │                                                                  │
 │   8 Entites · 2 Enums · Persistence Unit : sgdaPU               │
 └─────────────────────────────┬────────────────────────────────────┘
                               │  JDBC / JTA
 ┌─────────────────────────────▼────────────────────────────────────┐
 │                   BASE DE DONNEES                                 │
 │           MySQL 8+  ou  PostgreSQL 14+                           │
 │           DataSource JTA : jdbc/SGDADS                           │
 └──────────────────────────────────────────────────────────────────┘
```

### Composants par couche

| Couche | Composants | Technologie |
|--------|-----------|-------------|
| **Presentation** | 1 Filtre · 24 Servlets · 18 JSP | Servlet 6.0, JSP/JSTL |
| **Metier** | 5 Services · 6 DTO · 3 Exceptions | EJB 4.0 Stateless |
| **Persistance** | 8 Entites · 2 Enums · 1 PU | JPA 3.0 (Hibernate) |
| **Donnees** | 8 Tables · JTA DataSource | MySQL / PostgreSQL |

---

## 3. Stack technologique

| Domaine | Composant | Version |
|---------|-----------|:-------:|
| Langage | Java | 17 |
| Plateforme | Jakarta EE | 10 |
| Servlets | Jakarta Servlet | 6.0 |
| Pages dynamiques | JSP / JSTL | 3.0 |
| Bean de metier | Jakarta EJB | 4.0 |
| ORM | Jakarta Persistence (JPA) | 3.0 |
| Injection de dependances | CDI (beans.xml) | 4.0 |
| Build | Apache Maven | 3.8+ |
| Serveur d'application | GlassFish | 7.0+ |
| Base de donnees | MySQL / PostgreSQL | 8+ / 14+ |
| Frontend | HTML5 · CSS3 · JavaScript ES2022 | — |
| Graphiques | Chart.js | 4.x (UMD) |
| Animations | GSAP (GreenSock) | 3.12 |
| IDE recommande | NetBeans | 17+ |

---

## 4. Modele de donnees

### Entites et relations

```
  ┌───────────┐         ┌─────────────────┐         ┌───────────┐
  │   Role    │ 1     * │   Utilisateur   │ 1     * │  Demande  │
  │───────────│─────────│─────────────────│─────────│───────────│
  │ id        │         │ id              │         │ id        │
  │ code      │         │ role_id    (FK) │         │ code      │
  │ libelle   │         │ username        │         │ etudiant  │
  │ actif     │         │ email           │         │ agent     │
  └───────────┘         │ mot_de_passe    │         │ type      │
                        │ nom · prenom    │         │ etat      │
                        │ actif           │         │ objet     │
                        │ cree_le         │         │ desc.     │
                        │ dernier_login   │         │ 5 dates   │
                        └─────────────────┘         │ motif     │
                                                    │ version   │
                                                    └─────┬─────┘
                                                          │
                              ┌───────────────────────────┼────────────────────┐
                              │                           │                    │
                    ┌─────────▼────────┐    ┌─────────────▼────┐    ┌─────────▼─────────┐
                    │   Commentaire    │    │   PieceJointe    │    │ HistoriqueTrans.  │
                    │─────────────────│    │──────────────────│    │───────────────────│
                    │ demande (FK)    │    │ demande (FK)     │    │ demande (FK)      │
                    │ auteur (FK)     │    │ uploade_par (FK) │    │ de_etat (FK)      │
                    │ contenu         │    │ nom_original     │    │ vers_etat (FK)    │
                    │ cree_le         │    │ mime_type        │    │ acteur (FK)       │
                    └─────────────────┘    │ taille_octets    │    │ commentaire       │
                                           │ chemin_stockage  │    │ cree_le           │
                                           │ sha256           │    └───────────────────┘
                                           │ cree_le          │
                                           └──────────────────┘
```

### Enums systeme

| Enum | Identifiants |
|------|:------------|
| **RoleCode** | `ETUDIANT` · `AGENT` · `ADMIN` |
| **EtatDemandeCode** | `BROUILLON` · `SOUMISE` · `EN_ATTENTE` · `VALIDEE` · `REFUSEE` · `ARCHIVEE` |

### Correlation etats

| Code | Libelle | Description | Acteur |
|:----:|---------|-------------|:------:|
| `BROUILLON` | Brouillon | Demande creee, non soumise | Etudiant |
| `SOUMISE` | Soumise | Transmise pour traitement | Etudiant |
| `EN_ATTENTE` | En attente | Prise en charge par un agent | Agent |
| `VALIDEE` | Validee | Demande acceptee | Agent |
| `REFUSEE` | Refusee | Demande refusee (motif obligatoire) | Agent |
| `ARCHIVEE` | Archivee | Archivee apres traitement | Admin |

---

## 5. Workflow

Le cycle de vie de chaque demande suit un **automate a etats finis** dont chaque transition est journalisee dans la table `historique_transition`.

```
                            ETUDIANT
                    ┌────────────────────────┐
                    │                        │
  ┌──────┐ creer   ┌▼──────────┐ soumettre ┌▼──────────┐
  │(vide)│────────►│ BROUILLON │──────────►│  SOUMISE  │
  └──────┘         └─────┬─────┘           └─────┬─────┘
                         │                       │
                    modifier /                   │
                    supprimer                    │
                         │                       │
                         ▼                       ▼
                  (supprimee)              ┌──────────┐
                                          │EN_ATTENTE│
  ┌──────────────────────────────────────┐└────┬─────┘
  │               AGENT                  │     │
  │                                      │     │
  │  ┌──────────┐  refuser  ┌──────────┐│     │
  │  │ REFUSEE  │◄─────────│ VALIDEE  ││     │
  │  └────┬─────┘           └────┬─────┘│     │
  │       │                      │      │     │
  └───────┼──────────────────────┼──────┘     │
          │        ADMIN         │            │
          ▼                      ▼            │
     ┌──────────────────────────────────┐     │
     │           ARCHIVEE               │◄────┘
     └──────────────────────────────────┘
```

### Regles de transition

| Transition | Preconditions | Acteur autorise |
|------------|:-------------|:---------------:|
| `→ BROUILLON` | Creation d'une nouvelle demande | Etudiant |
| `BROUILLON → SOUMISE` | Objet non vide | Etudiant (proprietaire) |
| `BROUILLON → (supprimee)` | Aucune | Etudiant (proprietaire) |
| `SOUMISE → EN_ATTENTE` | Pas encore assignee | Agent |
| `EN_ATTENTE → VALIDEE` | Agent assigne | Agent (assigne) |
| `EN_ATTENTE → REFUSEE` | Motif de refus fourni | Agent (assigne) |
| `VALIDEE/REFUSEE → ARCHIVEE` | Demande cloturee | Admin |

---

## 6. Roles et permissions

### Matrice d'acces

| Capacite | Etudiant | Agent | Admin |
|----------|:--------:|:-----:|:-----:|
| Consulter son dashboard | ✅ | ✅ | ✅ |
| Creer une demande | ✅ | — | — |
| Modifier un brouillon | ✅ | — | — |
| Supprimer un brouillon | ✅ | — | — |
| Soumettre une demande | ✅ | — | — |
| Suivre ses propres demandes | ✅ | — | — |
| Voir les demandes en attente | — | ✅ | — |
| Prendre en charge | — | ✅ | — |
| Valider une demande | — | ✅ | — |
| Refuser une demande | — | ✅ | — |
| Voir les demandes traitees | — | ✅ | — |
| Superviser toutes les demandes | — | — | ✅ |
| Archiver une demande | — | — | ✅ |
| Gerer les utilisateurs (CRUD) | — | — | ✅ |
| Gerer les types de demande | — | — | ✅ |
| Consulter les tendances | — | — | ✅ |
| Gerer son profil | ✅ | ✅ | ✅ |

---

## 7. Diagrammes UML

Les diagrammes sont fournis au format **PlantUML** dans le repertoire `docs/`.

| Fichier | Type | Description |
|---------|------|-------------|
| `arch-layers.puml` | Composants | Architecture en couches de l'application |
| `class-diagram-entities.puml` | Classes | Diagramme de classes des entites JPA |
| `use-case-diagram.puml` | Cas d'utilisation | Cas d'utilisation par role |
| `seq-1-authentication.puml` | Sequence | Scenario d'authentification complet |
| `seq-2-student-submit.puml` | Sequence | Scenario de soumission etudiant |
| `seq-3-agent-process.puml` | Sequence | Scenario de traitement agent |

### Generation des images

```bash
# Via PlantUML JAR
java -jar plantuml.jar -tpng docs/*.puml

# Ou via l'extension VS Code / NetBeans
```

---

## 8. Installation

### Prerequis

| Outil | Version minimale | Verification |
|-------|:----------------:|:------------:|
| JDK | 17 | `java -version` |
| Maven | 3.8 | `mvn -version` |
| GlassFish | 7.0 | `asadmin version` |
| MySQL ou PostgreSQL | 8+ / 14+ | `mysql --version` / `psql --version` |
| Git | 2.x | `git --version` |

### Etape 1 — Cloner le depot

```bash
git clone https://github.com/votre-org/sgda.git
cd sgda
```

### Etape 2 — Configurer la base de donnees

**MySQL :**

```bash
asadmin create-jdbc-connection-pool \
  --datasourceclassname com.mysql.cj.jdbc.MysqlXADataSource \
  --restype javax.sql.XADataSource \
  --property User=sgda_user:Password=sgda_pass:ServerName=localhost:Port=3306:DatabaseName=sgda_db \
  SGDAPool

asadmin create-jdbc-resource --poolname SGDAPool jdbc/SGDADS
```

**PostgreSQL :**

```bash
asadmin create-jdbc-connection-pool \
  --datasourceclassname org.postgresql.xa.PGXADataSource \
  --restype javax.sql.XADataSource \
  --property User=sgda_user:Password=sgda_pass:ServerName=localhost:Port=5432:DatabaseName=sgda_db \
  SGDAPool

asadmin create-jdbc-resource --poolname SGDAPool jdbc/SGDADS
```

### Etape 3 — Compiler et deployer

```bash
mvn clean install
asadmin deploy target/sgda.war
```

### Etape 4 — Acceder

```
http://localhost:8080/sgda
```

---

## 9. Base de donnees

### Unite de persistance

| Parametre | Valeur |
|-----------|--------|
| Nom | `sgdaPU` |
| Transaction | JTA |
| DataSource | `jdbc/SGDADS` |
| Validation | Desactivee |
| Schema generation | None (manuel) |

### Scripts de creation

```sql
CREATE TABLE role (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    code        VARCHAR(30)  NOT NULL UNIQUE,
    libelle     VARCHAR(100) NOT NULL,
    actif       BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE utilisateur (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id          BIGINT       NOT NULL,
    username         VARCHAR(60)  NOT NULL UNIQUE,
    email            VARCHAR(120) NOT NULL UNIQUE,
    mot_de_passe     VARCHAR(255) NOT NULL,
    nom              VARCHAR(80)  NOT NULL,
    prenom           VARCHAR(80)  NOT NULL,
    actif            BOOLEAN      NOT NULL DEFAULT TRUE,
    cree_le          DATETIME     NOT NULL,
    dernier_login_le DATETIME,
    FOREIGN KEY (role_id) REFERENCES role(id)
);

CREATE TABLE type_demande (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    code        VARCHAR(30)  NOT NULL UNIQUE,
    libelle     VARCHAR(120) NOT NULL,
    description TEXT,
    actif       BOOLEAN      NOT NULL DEFAULT TRUE,
    cree_le     DATETIME     NOT NULL
);

CREATE TABLE etat_demande (
    id      BIGINT AUTO_INCREMENT PRIMARY KEY,
    code    VARCHAR(30)  NOT NULL UNIQUE,
    libelle VARCHAR(100) NOT NULL,
    ordre   INTEGER      NOT NULL,
    actif   BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE demande (
    id                     BIGINT AUTO_INCREMENT PRIMARY KEY,
    code                   VARCHAR(40) NOT NULL UNIQUE,
    etudiant_id            BIGINT      NOT NULL,
    agent_id               BIGINT,
    type_demande_id        BIGINT      NOT NULL,
    etat_id                BIGINT      NOT NULL,
    objet                  VARCHAR(200) NOT NULL,
    description            TEXT,
    date_creation          DATETIME    NOT NULL,
    date_soumission        DATETIME,
    date_prise_en_charge   DATETIME,
    date_decision          DATETIME,
    date_archivage         DATETIME,
    motif_refus            TEXT,
    version                INTEGER     NOT NULL DEFAULT 0,
    FOREIGN KEY (etudiant_id)     REFERENCES utilisateur(id),
    FOREIGN KEY (agent_id)        REFERENCES utilisateur(id),
    FOREIGN KEY (type_demande_id) REFERENCES type_demande(id),
    FOREIGN KEY (etat_id)         REFERENCES etat_demande(id)
);

CREATE TABLE commentaire (
    id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    demande_id BIGINT NOT NULL,
    auteur_id  BIGINT NOT NULL,
    contenu    TEXT   NOT NULL,
    cree_le   DATETIME NOT NULL,
    FOREIGN KEY (demande_id) REFERENCES demande(id),
    FOREIGN KEY (auteur_id)  REFERENCES utilisateur(id)
);

CREATE TABLE piece_jointe (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    demande_id       BIGINT       NOT NULL,
    uploade_par_id   BIGINT       NOT NULL,
    nom_original     VARCHAR(255) NOT NULL,
    mime_type        VARCHAR(120) NOT NULL,
    taille_octets    BIGINT       NOT NULL,
    chemin_stockage  VARCHAR(500) NOT NULL,
    sha256           VARCHAR(64),
    cree_le          DATETIME     NOT NULL,
    FOREIGN KEY (demande_id)     REFERENCES demande(id),
    FOREIGN KEY (uploade_par_id) REFERENCES utilisateur(id)
);

CREATE TABLE historique_transition (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    demande_id     BIGINT  NOT NULL,
    de_etat_id     BIGINT,
    vers_etat_id   BIGINT  NOT NULL,
    acteur_id      BIGINT  NOT NULL,
    commentaire    TEXT,
    cree_le        DATETIME NOT NULL,
    FOREIGN KEY (demande_id)   REFERENCES demande(id),
    FOREIGN KEY (de_etat_id)   REFERENCES etat_demande(id),
    FOREIGN KEY (vers_etat_id) REFERENCES etat_demande(id),
    FOREIGN KEY (acteur_id)    REFERENCES utilisateur(id)
);
```

### Donnees initiales

```sql
INSERT INTO role (code, libelle) VALUES
    ('ETUDIANT', 'Etudiant'),
    ('AGENT',    'Agent administratif'),
    ('ADMIN',    'Administrateur');

INSERT INTO etat_demande (code, libelle, ordre) VALUES
    ('BROUILLON',   'Brouillon',   1),
    ('SOUMISE',     'Soumise',      2),
    ('EN_ATTENTE',  'En attente',   3),
    ('VALIDEE',     'Validee',      4),
    ('REFUSEE',     'Refusee',      5),
    ('ARCHIVEE',    'Archivee',     6);
```

---

## 10. Build et deploiement

### Commandes Maven

```bash
mvn clean install              # Compiler et generer le WAR
mvn clean install -DskipTests  # Compiler sans tests
mvn glassfish:deploy           # Deployer sur GlassFish (plugin)
mvn clean                      # Nettoyer
```

### Sortie

```
target/sgda.war    # Fichier WAR genere (finalName = sgda)
```

### Parametres du serveur

| Parametre | Valeur |
|-----------|--------|
| Context path | `/sgda` |
| Session timeout | 30 minutes |
| Welcome file | `index.jsp` |
| Error page | `/WEB-INF/views/common/error.jsp` |

---

## 11. Guide utilisateur

### Connexion

1. Acceder a `http://localhost:8080/sgda`
2. Cliquer sur **Se connecter**
3. Saisir le nom d'utilisateur ou l'email
4. Saisir le mot de passe
5. Redirection automatique vers le dashboard du role

### Parcours Etudiant

| Action | Chemin |
|--------|--------|
| Creer une demande | Menu « Nouvelle demande » → Formulaire → Sauvegarder |
| Soumettre | Liste → Cliquer « Soumettre » sur un brouillon |
| Suivre | Liste des demandes → Badge d'etat |
| Detail | Cliquer sur une demande → Historique complet |

### Parcours Agent

| Action | Chemin |
|--------|--------|
| Consulter | Dashboard → Demandes en attente |
| Prendre en charge | Liste → Cliquer « Prendre en charge » |
| Traiter | Detail → Valider ou Refuser (motif obligatoire) |
| Historique | Onglet « Demandes traitees » |

### Parcours Admin

| Action | Chemin |
|--------|--------|
| Superviser | Dashboard → Statistiques et graphiques |
| Archiver | Detail d'une demande → Bouton « Archiver » |
| Gerer utilisateurs | Menu « Utilisateurs » → CRUD |
| Gerer types | Menu « Types de demande » → CRUD |
| Tendances | Dashboard → Graphiques temporels |

---

## 12. Design et UI

### Palette de couleurs

<details>
<summary><strong>Mode clair</strong></summary>

| Role | Couleur | Hex |
|------|---------|:---:|
| Primaire | Caramel dore | `#C98A3E` |
| Hover | Caramel fonce | `#A86E28` |
| Succes | Vert olive | `#4A5C2A` |
| Sidebar | Vert foret (degrade) | `#1A2E0F → #111F08` |
| Danger | Orange fonce | `#BF360C` |
| Warning | Orange moyen | `#D84315` |
| Fond | Blanc creme | `#FEFAE8` |
| Cartes | Blanc pur | `#FFFFFF` |
| Champs | Creme fonce | `#F5EDD0` |
| Bordures | — | `#D4C49A` |
| Texte principal | — | `#1A2E0F` |
| Texte secondaire | — | `#4A5C2A` |

</details>

<details>
<summary><strong>Mode sombre</strong></summary>

| Role | Hex |
|------|:---:|
| Fond | `#0D1A07` |
| Cartes | `#162210` |
| Sidebar | `#0A1205` |
| Navbar | `#0D1A07` |
| Texte principal | `#F5EDD0` |
| Texte secondaire | `#A8C080` |
| Bordures | `#2A4015` |
| Champs | `#1A2E0F` |

</details>

### Typographie

| Element | Taille | Police |
|---------|:------:|--------|
| Titres de page | 26px | system-ui, Segoe UI |
| Titres de section | 20px | system-ui, Segoe UI |
| Titres de cartes | 17px | system-ui, Segoe UI |
| Tableaux | 15px | system-ui, Segoe UI |
| Statistiques | 32px gras | system-ui, Segoe UI |
| Boutons | 14px | system-ui, Segoe UI |
| Sidebar | 15px | system-ui, Segoe UI |

### Composants UI

| Composant | Description |
|-----------|-------------|
| **Sidebar** | Navigation laterale avec degrade vert, indicateur actif |
| **Navbar** | Barre superieure — hamburger, notifications, avatar, toggle sombre |
| **Cartes stats** | 4 cartes colorees avec compteurs animes |
| **Graphiques** | Doughnut (repartition), Ligne (tendances), Barres (comparaison) |
| **Tableaux** | Entetes, badges de statut pilule, lignes alternees |
| **Boutons** | Primaire, secondaire, danger, contour — effet ripple |
| **Badges** | Forme pilule avec couleurs par statut |
| **Toasts** | Notifications entrantes avec barre de progression |
| **Formulaires** | Champs stylises, labels, messages d'erreur |
| **Footer** | Style universitaire premium |

### Animations

| Effet | Technologie |
|-------|-------------|
| Effet ripple sur boutons | CSS + JS |
| Entrees en cascade (stagger) | GSAP ScrollTrigger |
| Hover states | CSS transitions (0.2s ease) |
| Lift des cartes au survol | CSS box-shadow |
| Scroll fade-in | GSAP + Intersection Observer |
| Float / flottement | GSAP Tween |

---

## 13. Securite

| Couche | Mesure | Implementation |
|--------|--------|----------------|
| **Authentification** | Filtre HTTP | `AuthFilter` sur `/student/*`, `/agent/*`, `/admin/*` |
| **Identifiants** | Hachage bcrypt | `PasswordUtils.hashPassword()` / `verifyPassword()` |
| **Evolution hash** | Rehash automatique | `PasswordUtils.needsRehash()` → mise a jour |
| **Autorisation** | Verification par role | Verification du `roleCode` vs chemin d'acces |
| **Session** | Timeout + cle unique | 30 min, cle `AUTH_USER` |
| **Concurrence** | Optimistic Locking | `@Version` sur l'entite `Demande` |
| **Fichiers** | Integrite SHA-256 | Hash verifie sur `PieceJointe` |
| **Validation** | Cote service | `requireText()`, `requireEntity()`, `requireRole()` |
| **Erreurs** | Page dediee | `/WEB-INF/views/common/error.jsp` |

---

## 14. Performance

| Optimisation | Details |
|--------------|---------|
| **Lazy Loading** | Toutes les associations JPA en `FetchType.LAZY` |
| **CDI** | Injection declarative, pas d'instanciation manuelle |
| **Optimistic Locking** | `@Version` → pas de verrouillage pessimiste |
| **JTA** | Transactions gerees par le conteneur EJB |
| **GSAP** | Animations via `requestAnimationFrame` |
| **CSS Variables** | Themes reutilisables, pas de recalcul |
| **Chart.js UMD** | Graphiques légers, pas de framework |
| **Gzip** | Compresion HTTP geree par GlassFish |

---

## 15. Accessibilite

- Support de `prefers-reduced-motion` — desactivation des animations si requis
- Attributs ARIA maintenus sur les elements interactifs
- Fallback sans JavaScript pour les etats de base
- Contraste de couleurs valide pour la lisibilite
- Navigation clavier accessible sur tous les elements interactifs

---

## 16. Feuille de route

### Phase 1 — Core ✅ Terminee

- [x] Entites JPA et modele de donnees
- [x] Services EJB (Auth, Demande, Utilisateur, Type, Dashboard)
- [x] Servlets et filtrage par role
- [x] Vues JSP par role
- [x] Workflow complet BROUILLON → ARCHIVEE
- [x] Authentification et gestion de session

### Phase 2 — UI/UX 🔄 En cours

- [x] Variables CSS et theme clair/sombre
- [x] Composants de base (sidebar, navbar, cartes)
- [ ] Design pixel perfect — composants restants
- [ ] Responsive design (tablette, mobile)
- [ ] Mode sombre complet
- [ ] Animations GSAP avancees

### Phase 3 — Avancee 📋 Planifiee

- [ ] Recherche et filtrage avance des demandes
- [ ] Notifications en temps reel
- [ ] Export PDF des demandes
- [ ] Tableau de bord avec metriques avancees
- [ ] API REST pour integrations tierces

---

## 17. Contribuer

### Branches

```
main          Production stable
├── develop   Integration
├── feature/* Nouvelles fonctionnalites
├── bugfix/*  Corrections de bugs
└── release/* Preparation de release
```

### Conventions de commit

```
feat(scope):     ajout d'une fonctionnalite
fix(scope):      correction de bug
refactor(scope): refactoring sans changement fonctionnel
docs(scope):     mise a jour de la documentation
style(scope):    formatage, espaces, indentation
test(scope):     ajout ou modification de tests
```

### Regles

1. Valider le build avant de pousser (`mvn clean install`)
2. Respecter l'architecture en couches
3. Documenter les nouveaux endpoints et services
4. Mettre a jour le README si necessaire
5. Une branche = une fonctionnalite = une PR

---

## 18. Licence et contact

### Licence

Ce projet est distribue sous licence **MIT**. Consultez le fichier `LICENSE` pour les details.

### Contact

| Service | Email |
|---------|-------|
| Equipe de developpement | dev@sgda.ac.ke |
| Support technique | support@sgda.ac.ke |

---

<div align="center">

**SGDA** — Systeme de Gestion des Demandes Academiques

*Concu avec Jakarta EE 10 · Architecture en couches · Design universitaire premium*

</div>
