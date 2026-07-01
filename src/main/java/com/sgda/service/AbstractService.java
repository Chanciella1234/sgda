package com.sgda.service;

import com.sgda.domain.Demande;
import com.sgda.domain.EtatDemande;
import com.sgda.domain.HistoriqueTransition;
import com.sgda.domain.Role;
import com.sgda.domain.TypeDemande;
import com.sgda.domain.Utilisateur;
import com.sgda.domain.enums.EtatDemandeCode;
import com.sgda.domain.enums.RoleCode;
import com.sgda.service.exception.AuthorizationException;
import com.sgda.service.exception.BusinessException;
import java.time.LocalDateTime;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

public abstract class AbstractService {

    @PersistenceContext(unitName = "sgdaPU")
    protected EntityManager entityManager;

    protected String normalize(String value) {
        return value == null ? null : value.trim();
    }

    protected String normalizeUpper(String value) {
        String normalized = normalize(value);
        return normalized == null ? null : normalized.toUpperCase();
    }

    protected boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    protected void requireText(String value, String message) {
        if (isBlank(value)) {
            throw new BusinessException(message);
        }
    }

    protected <T> T requireEntity(Class<T> entityType, Long id, String missingMessage) {
        if (id == null) {
            throw new BusinessException(missingMessage);
        }
        T entity = entityManager.find(entityType, id);
        if (entity == null) {
            throw new BusinessException(missingMessage);
        }
        return entity;
    }

    protected Utilisateur requireUtilisateur(Long utilisateurId) {
        return requireEntity(Utilisateur.class, utilisateurId, "Utilisateur introuvable.");
    }

    protected Utilisateur requireUtilisateurActif(Long utilisateurId) {
        Utilisateur utilisateur = requireUtilisateur(utilisateurId);
        if (!utilisateur.isActif()) {
            throw new AuthorizationException("Ce compte utilisateur est desactive.");
        }
        return utilisateur;
    }

    protected Role requireRole(RoleCode code) {
        TypedQuery<Role> query = entityManager.createQuery(
                "SELECT r FROM Role r WHERE r.code = :code", Role.class);
        query.setParameter("code", code.name());
        Role role = getSingleResultOrNull(query);
        if (role == null) {
            throw new BusinessException("Role introuvable : " + code.name());
        }
        return role;
    }

    protected EtatDemande requireEtat(EtatDemandeCode code) {
        TypedQuery<EtatDemande> query = entityManager.createQuery(
                "SELECT e FROM EtatDemande e WHERE e.code = :code", EtatDemande.class);
        query.setParameter("code", code.name());
        EtatDemande etat = getSingleResultOrNull(query);
        if (etat == null) {
            throw new BusinessException("Etat introuvable : " + code.name());
        }
        return etat;
    }

    protected TypeDemande requireTypeDemande(Long typeDemandeId) {
        return requireEntity(TypeDemande.class, typeDemandeId, "Type de demande introuvable.");
    }

    protected void requireAdmin(Long utilisateurId) {
        Utilisateur utilisateur = requireUtilisateurActif(utilisateurId);
        if (!utilisateur.hasRole(RoleCode.ADMIN)) {
            throw new AuthorizationException("Action reservee a l administrateur.");
        }
    }

    protected void requireRole(Utilisateur utilisateur, RoleCode roleCode, String message) {
        if (!utilisateur.hasRole(roleCode)) {
            throw new AuthorizationException(message);
        }
    }

    protected <T> T getSingleResultOrNull(TypedQuery<T> query) {
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    protected void enregistrerTransition(
            Demande demande,
            EtatDemande ancienEtat,
            EtatDemande nouvelEtat,
            Utilisateur acteur,
            String commentaire) {
        HistoriqueTransition historique = new HistoriqueTransition();
        historique.setDemande(demande);
        historique.setDeEtat(ancienEtat);
        historique.setVersEtat(nouvelEtat);
        historique.setActeur(acteur);
        historique.setCommentaire(commentaire);
        historique.setCreeLe(LocalDateTime.now());
        entityManager.persist(historique);
    }
}

