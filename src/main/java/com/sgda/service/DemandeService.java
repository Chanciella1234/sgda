package com.sgda.service;

import com.sgda.domain.Commentaire;
import com.sgda.domain.Demande;
import com.sgda.domain.EtatDemande;
import com.sgda.domain.HistoriqueTransition;
import com.sgda.domain.PieceJointe;
import com.sgda.domain.TypeDemande;
import com.sgda.domain.Utilisateur;
import com.sgda.domain.enums.EtatDemandeCode;
import com.sgda.domain.enums.RoleCode;
import com.sgda.service.exception.AuthorizationException;
import com.sgda.service.exception.BusinessException;
import com.sgda.service.exception.WorkflowException;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import jakarta.ejb.Stateless;
import jakarta.persistence.TypedQuery;

@Stateless
public class DemandeService extends AbstractService {

    public List<Demande> listByEtudiant(Long etudiantId) {
        return entityManager.createQuery(
                "SELECT d FROM Demande d "
                + "JOIN FETCH d.typeDemande "
                + "JOIN FETCH d.etat "
                + "LEFT JOIN FETCH d.agent "
                + "WHERE d.etudiant.id = :etudiantId "
                + "ORDER BY d.dateCreation DESC",
                Demande.class)
                .setParameter("etudiantId", etudiantId)
                .getResultList();
    }

    public Demande findDraftOwnedByStudent(Long demandeId, Long etudiantId) {
        TypedQuery<Demande> query = entityManager.createQuery(
                "SELECT d FROM Demande d "
                + "JOIN FETCH d.typeDemande "
                + "JOIN FETCH d.etat "
                + "WHERE d.id = :demandeId AND d.etudiant.id = :etudiantId AND d.etat.code = :etat",
                Demande.class);
        query.setParameter("demandeId", demandeId);
        query.setParameter("etudiantId", etudiantId);
        query.setParameter("etat", EtatDemandeCode.BROUILLON.name());

        Demande demande = getSingleResultOrNull(query);
        if (demande == null) {
            throw new BusinessException("Brouillon introuvable ou non modifiable.");
        }
        return demande;
    }

    public List<Demande> listDemandesPourAgent() {
        return entityManager.createQuery(
                "SELECT d FROM Demande d "
                + "JOIN FETCH d.typeDemande "
                + "JOIN FETCH d.etat "
                + "JOIN FETCH d.etudiant "
                + "LEFT JOIN FETCH d.agent "
                + "WHERE d.etat.code IN :codes "
                + "ORDER BY d.dateCreation ASC",
                Demande.class)
                .setParameter("codes", Arrays.asList(
                        EtatDemandeCode.SOUMISE.name(),
                        EtatDemandeCode.EN_ATTENTE.name()))
                .getResultList();
    }

    public List<Demande> listAllDemandes() {
        return entityManager.createQuery(
                "SELECT d FROM Demande d "
                + "JOIN FETCH d.typeDemande "
                + "JOIN FETCH d.etat "
                + "JOIN FETCH d.etudiant "
                + "LEFT JOIN FETCH d.agent "
                + "ORDER BY d.dateCreation DESC",
                Demande.class)
                .getResultList();
    }

    public Demande findDetailForUser(Long demandeId, Long utilisateurId) {
        Utilisateur utilisateur = requireUtilisateurActif(utilisateurId);

        TypedQuery<Demande> query = entityManager.createQuery(
                "SELECT d FROM Demande d "
                + "JOIN FETCH d.typeDemande "
                + "JOIN FETCH d.etat "
                + "JOIN FETCH d.etudiant "
                + "LEFT JOIN FETCH d.agent "
                + "WHERE d.id = :demandeId",
                Demande.class);
        query.setParameter("demandeId", demandeId);

        Demande demande = getSingleResultOrNull(query);
        if (demande == null) {
            throw new BusinessException("Demande introuvable.");
        }

        ensureDemandeVisible(demande, utilisateur);
        List<Commentaire> commentaires = loadCommentaires(demandeId);
        List<PieceJointe> piecesJointes = loadPiecesJointes(demandeId);
        List<HistoriqueTransition> historique = loadHistorique(demandeId);
        entityManager.detach(demande);
        demande.setCommentaires(commentaires);
        demande.setPiecesJointes(piecesJointes);
        demande.setHistoriqueTransitions(historique);
        return demande;
    }

    public Demande createDraft(Long etudiantId, Long typeDemandeId, String objet, String description) {
        Utilisateur etudiant = requireUtilisateurActif(etudiantId);
        requireRole(etudiant, RoleCode.ETUDIANT, "Seul un etudiant peut creer une demande.");
        requireText(objet, "L objet de la demande est obligatoire.");

        TypeDemande typeDemande = requireTypeDemande(typeDemandeId);
        if (!typeDemande.isActif()) {
            throw new BusinessException("Le type de demande selectionne est inactif.");
        }

        EtatDemande brouillon = requireEtat(EtatDemandeCode.BROUILLON);
        Demande demande = new Demande();
        demande.setCode("TMP");
        demande.setEtudiant(etudiant);
        demande.setTypeDemande(typeDemande);
        demande.setEtat(brouillon);
        demande.setObjet(normalize(objet));
        demande.setDescription(normalize(description));
        demande.setDateCreation(LocalDateTime.now());
        demande.setVersion(0);
        entityManager.persist(demande);
        entityManager.flush();

        demande.setCode(genererCodeDemande(demande.getId()));
        enregistrerTransition(demande, null, brouillon, etudiant, "Creation du brouillon.");
        return demande;
    }

    public void updateDraft(Long demandeId, Long etudiantId, Long typeDemandeId, String objet, String description) {
        requireText(objet, "L objet de la demande est obligatoire.");

        Utilisateur etudiant = requireUtilisateurActif(etudiantId);
        requireRole(etudiant, RoleCode.ETUDIANT, "Seul un etudiant peut modifier un brouillon.");
        Demande demande = requireEntity(Demande.class, demandeId, "Demande introuvable.");
        TypeDemande typeDemande = requireTypeDemande(typeDemandeId);

        ensureEtudiantOwner(demande, etudiantId);
        ensureState(demande, EtatDemandeCode.BROUILLON, "Seul un brouillon peut etre modifie.");
        if (!typeDemande.isActif()) {
            throw new BusinessException("Le type de demande selectionne est inactif.");
        }

        demande.setTypeDemande(typeDemande);
        demande.setObjet(normalize(objet));
        demande.setDescription(normalize(description));
    }

    public void deleteDraft(Long demandeId, Long etudiantId) {
        Utilisateur etudiant = requireUtilisateurActif(etudiantId);
        requireRole(etudiant, RoleCode.ETUDIANT, "Seul un etudiant peut supprimer un brouillon.");

        Demande demande = requireEntity(Demande.class, demandeId, "Demande introuvable.");
        ensureEtudiantOwner(demande, etudiantId);
        ensureState(demande, EtatDemandeCode.BROUILLON, "Seul un brouillon peut etre supprime.");
        entityManager.remove(demande);
    }

    public void soumettre(Long demandeId, Long etudiantId) {
        Utilisateur etudiant = requireUtilisateurActif(etudiantId);
        requireRole(etudiant, RoleCode.ETUDIANT, "Seul un etudiant peut soumettre une demande.");

        Demande demande = requireEntity(Demande.class, demandeId, "Demande introuvable.");
        ensureEtudiantOwner(demande, etudiantId);
        ensureState(demande, EtatDemandeCode.BROUILLON, "Seul un brouillon peut etre soumis.");

        EtatDemande ancienEtat = demande.getEtat();
        EtatDemande nouvelEtat = requireEtat(EtatDemandeCode.SOUMISE);
        demande.setEtat(nouvelEtat);
        demande.setDateSoumission(LocalDateTime.now());
        enregistrerTransition(demande, ancienEtat, nouvelEtat, etudiant, "Soumission de la demande.");
    }

    public void prendreEnCharge(Long demandeId, Long agentId) {
        Utilisateur agent = requireUtilisateurActif(agentId);
        requireRole(agent, RoleCode.AGENT, "Seul un agent peut prendre une demande en charge.");

        Demande demande = requireEntity(Demande.class, demandeId, "Demande introuvable.");
        ensureState(demande, EtatDemandeCode.SOUMISE, "Seule une demande soumise peut etre prise en charge.");

        EtatDemande ancienEtat = demande.getEtat();
        EtatDemande nouvelEtat = requireEtat(EtatDemandeCode.EN_ATTENTE);
        demande.setEtat(nouvelEtat);
        demande.setAgent(agent);
        demande.setDatePriseEnCharge(LocalDateTime.now());
        enregistrerTransition(demande, ancienEtat, nouvelEtat, agent, "Prise en charge par l agent.");
    }

    public void valider(Long demandeId, Long agentId) {
        Utilisateur agent = requireUtilisateurActif(agentId);
        requireRole(agent, RoleCode.AGENT, "Seul un agent peut valider une demande.");

        Demande demande = requireEntity(Demande.class, demandeId, "Demande introuvable.");
        ensureState(demande, EtatDemandeCode.EN_ATTENTE, "La demande doit etre en attente.");
        ensureAssignedAgent(demande, agentId);

        EtatDemande ancienEtat = demande.getEtat();
        EtatDemande nouvelEtat = requireEtat(EtatDemandeCode.VALIDEE);
        demande.setEtat(nouvelEtat);
        demande.setDateDecision(LocalDateTime.now());
        demande.setMotifRefus(null);
        enregistrerTransition(demande, ancienEtat, nouvelEtat, agent, "Validation de la demande.");
    }

    public void refuser(Long demandeId, Long agentId, String motifRefus) {
        requireText(motifRefus, "Le motif de refus est obligatoire.");

        Utilisateur agent = requireUtilisateurActif(agentId);
        requireRole(agent, RoleCode.AGENT, "Seul un agent peut refuser une demande.");

        Demande demande = requireEntity(Demande.class, demandeId, "Demande introuvable.");
        ensureState(demande, EtatDemandeCode.EN_ATTENTE, "La demande doit etre en attente.");
        ensureAssignedAgent(demande, agentId);

        EtatDemande ancienEtat = demande.getEtat();
        EtatDemande nouvelEtat = requireEtat(EtatDemandeCode.REFUSEE);
        demande.setEtat(nouvelEtat);
        demande.setDateDecision(LocalDateTime.now());
        demande.setMotifRefus(normalize(motifRefus));
        enregistrerTransition(demande, ancienEtat, nouvelEtat, agent, normalize(motifRefus));
    }

    public void archiver(Long demandeId, Long adminId) {
        Utilisateur administrateur = requireUtilisateurActif(adminId);
        requireRole(administrateur, RoleCode.ADMIN, "Seul un administrateur peut archiver une demande.");

        Demande demande = requireEntity(Demande.class, demandeId, "Demande introuvable.");
        if (!(demande.isInState(EtatDemandeCode.VALIDEE) || demande.isInState(EtatDemandeCode.REFUSEE))) {
            throw new WorkflowException("Seules les demandes validees ou refusees peuvent etre archivees.");
        }

        EtatDemande ancienEtat = demande.getEtat();
        EtatDemande nouvelEtat = requireEtat(EtatDemandeCode.ARCHIVEE);
        demande.setEtat(nouvelEtat);
        demande.setDateArchivage(LocalDateTime.now());
        enregistrerTransition(demande, ancienEtat, nouvelEtat, administrateur, "Archivage administratif.");
    }

    public void ajouterCommentaire(Long demandeId, Long auteurId, String contenu) {
        requireText(contenu, "Le commentaire est obligatoire.");

        Utilisateur auteur = requireUtilisateurActif(auteurId);
        Demande demande = requireEntity(Demande.class, demandeId, "Demande introuvable.");
        ensureCommentAccess(demande, auteur);

        Commentaire commentaire = new Commentaire();
        commentaire.setDemande(demande);
        commentaire.setAuteur(auteur);
        commentaire.setContenu(normalize(contenu));
        commentaire.setCreeLe(LocalDateTime.now());
        entityManager.persist(commentaire);
    }

    public PieceJointe ajouterPieceJointe(Long demandeId, Long auteurId, String nomOriginal, String mimeType,
            long tailleOctets, String cheminStockage, String sha256) {
        requireText(nomOriginal, "Le nom du fichier est obligatoire.");
        requireText(cheminStockage, "Le chemin de stockage est obligatoire.");

        Utilisateur auteur = requireUtilisateurActif(auteurId);
        requireRole(auteur, RoleCode.ETUDIANT, "Seul un etudiant peut ajouter une piece jointe.");

        Demande demande = requireEntity(Demande.class, demandeId, "Demande introuvable.");
        ensureEtudiantOwner(demande, auteurId);
        ensureState(demande, EtatDemandeCode.BROUILLON, "Les pieces jointes ne sont modifiables qu en brouillon.");

        PieceJointe pieceJointe = new PieceJointe();
        pieceJointe.setDemande(demande);
        pieceJointe.setUploadePar(auteur);
        pieceJointe.setNomOriginal(normalize(nomOriginal));
        pieceJointe.setMimeType(isBlank(mimeType) ? "application/octet-stream" : normalize(mimeType));
        pieceJointe.setTailleOctets(tailleOctets);
        pieceJointe.setCheminStockage(cheminStockage);
        pieceJointe.setSha256(sha256);
        pieceJointe.setCreeLe(LocalDateTime.now());
        entityManager.persist(pieceJointe);
        return pieceJointe;
    }

    public String supprimerPieceJointe(Long pieceJointeId, Long etudiantId) {
        Utilisateur etudiant = requireUtilisateurActif(etudiantId);
        requireRole(etudiant, RoleCode.ETUDIANT, "Seul un etudiant peut supprimer une piece jointe.");

        TypedQuery<PieceJointe> query = entityManager.createQuery(
                "SELECT p FROM PieceJointe p "
                + "JOIN FETCH p.demande d "
                + "JOIN FETCH d.etudiant "
                + "WHERE p.id = :pieceJointeId",
                PieceJointe.class);
        query.setParameter("pieceJointeId", pieceJointeId);
        PieceJointe pieceJointe = getSingleResultOrNull(query);
        if (pieceJointe == null) {
            throw new BusinessException("Piece jointe introuvable.");
        }

        ensureEtudiantOwner(pieceJointe.getDemande(), etudiantId);
        ensureState(pieceJointe.getDemande(), EtatDemandeCode.BROUILLON, "Les pieces jointes ne sont supprimables qu en brouillon.");

        String cheminStockage = pieceJointe.getCheminStockage();
        entityManager.remove(pieceJointe);
        return cheminStockage;
    }

    public PieceJointe findPieceJointeForUser(Long pieceJointeId, Long utilisateurId) {
        Utilisateur utilisateur = requireUtilisateurActif(utilisateurId);

        TypedQuery<PieceJointe> query = entityManager.createQuery(
                "SELECT p FROM PieceJointe p "
                + "JOIN FETCH p.demande d "
                + "JOIN FETCH d.etudiant "
                + "LEFT JOIN FETCH d.agent "
                + "JOIN FETCH p.uploadePar "
                + "WHERE p.id = :pieceJointeId",
                PieceJointe.class);
        query.setParameter("pieceJointeId", pieceJointeId);

        PieceJointe pieceJointe = getSingleResultOrNull(query);
        if (pieceJointe == null) {
            throw new BusinessException("Piece jointe introuvable.");
        }

        ensureDemandeVisible(pieceJointe.getDemande(), utilisateur);
        return pieceJointe;
    }

    private void ensureEtudiantOwner(Demande demande, Long etudiantId) {
        if (!demande.getEtudiant().getId().equals(etudiantId)) {
            throw new AuthorizationException("Vous ne pouvez pas acceder a cette demande.");
        }
    }

    private void ensureAssignedAgent(Demande demande, Long agentId) {
        if (demande.getAgent() == null || !demande.getAgent().getId().equals(agentId)) {
            throw new AuthorizationException("Cette demande est affectee a un autre agent.");
        }
    }

    private void ensureState(Demande demande, EtatDemandeCode expectedState, String message) {
        if (!demande.isInState(expectedState)) {
            throw new WorkflowException(message);
        }
    }

    private void ensureCommentAccess(Demande demande, Utilisateur auteur) {
        if (!auteur.hasRole(RoleCode.ADMIN)
                && !demande.getEtudiant().getId().equals(auteur.getId())
                && (demande.getAgent() == null || !demande.getAgent().getId().equals(auteur.getId()))) {
            throw new AuthorizationException("Vous ne pouvez pas commenter cette demande.");
        }
    }

    private void ensureDemandeVisible(Demande demande, Utilisateur utilisateur) {
        if (utilisateur.hasRole(RoleCode.ADMIN)) {
            return;
        }
        if (utilisateur.hasRole(RoleCode.ETUDIANT)) {
            ensureEtudiantOwner(demande, utilisateur.getId());
            return;
        }
        if (utilisateur.hasRole(RoleCode.AGENT)) {
            boolean accessible = (demande.getAgent() != null && demande.getAgent().getId().equals(utilisateur.getId()))
                    || demande.isInState(EtatDemandeCode.SOUMISE)
                    || demande.isInState(EtatDemandeCode.EN_ATTENTE);
            if (!accessible) {
                throw new AuthorizationException("Vous ne pouvez pas consulter cette demande.");
            }
            return;
        }
        throw new AuthorizationException("Role non autorise.");
    }

    private List<Commentaire> loadCommentaires(Long demandeId) {
        return entityManager.createQuery(
                "SELECT c FROM Commentaire c "
                + "JOIN FETCH c.auteur "
                + "WHERE c.demande.id = :demandeId "
                + "ORDER BY c.creeLe DESC",
                Commentaire.class)
                .setParameter("demandeId", demandeId)
                .getResultList();
    }

    private List<PieceJointe> loadPiecesJointes(Long demandeId) {
        return entityManager.createQuery(
                "SELECT p FROM PieceJointe p "
                + "JOIN FETCH p.uploadePar "
                + "WHERE p.demande.id = :demandeId "
                + "ORDER BY p.creeLe DESC",
                PieceJointe.class)
                .setParameter("demandeId", demandeId)
                .getResultList();
    }

    private List<HistoriqueTransition> loadHistorique(Long demandeId) {
        return entityManager.createQuery(
                "SELECT h FROM HistoriqueTransition h "
                + "LEFT JOIN FETCH h.deEtat "
                + "JOIN FETCH h.versEtat "
                + "JOIN FETCH h.acteur "
                + "WHERE h.demande.id = :demandeId "
                + "ORDER BY h.creeLe ASC",
                HistoriqueTransition.class)
                .setParameter("demandeId", demandeId)
                .getResultList();
    }

    private String genererCodeDemande(Long demandeId) {
        return String.format("SGDA-%d-%06d", LocalDateTime.now().getYear(), demandeId);
    }
}

