package com.sgda.service;

import com.sgda.domain.TypeDemande;
import com.sgda.service.exception.BusinessException;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.ejb.Stateless;
import jakarta.persistence.TypedQuery;

@Stateless
public class TypeDemandeService extends AbstractService {

    public List<TypeDemande> listAllTypes() {
        return entityManager.createQuery(
                "SELECT t FROM TypeDemande t ORDER BY t.libelle ASC", TypeDemande.class)
                .getResultList();
    }

    public List<TypeDemande> listActiveTypes() {
        return entityManager.createQuery(
                "SELECT t FROM TypeDemande t WHERE t.actif = true ORDER BY t.libelle ASC",
                TypeDemande.class)
                .getResultList();
    }

    public TypeDemande findById(Long typeDemandeId) {
        return requireTypeDemande(typeDemandeId);
    }

    public void createType(Long adminId, String code, String libelle, String description) {
        requireAdmin(adminId);
        requireText(code, "Le code du type est obligatoire.");
        requireText(libelle, "Le libelle du type est obligatoire.");

        String normalizedCode = normalizeUpper(code);
        ensureCodeAvailable(normalizedCode, null);

        TypeDemande typeDemande = new TypeDemande();
        typeDemande.setCode(normalizedCode);
        typeDemande.setLibelle(normalize(libelle));
        typeDemande.setDescription(normalize(description));
        typeDemande.setActif(true);
        typeDemande.setCreeLe(LocalDateTime.now());
        entityManager.persist(typeDemande);
    }

    public void updateType(Long adminId, Long typeDemandeId, String code, String libelle, String description, boolean actif) {
        requireAdmin(adminId);
        requireText(code, "Le code du type est obligatoire.");
        requireText(libelle, "Le libelle du type est obligatoire.");

        TypeDemande typeDemande = requireTypeDemande(typeDemandeId);
        String normalizedCode = normalizeUpper(code);
        ensureCodeAvailable(normalizedCode, typeDemandeId);

        typeDemande.setCode(normalizedCode);
        typeDemande.setLibelle(normalize(libelle));
        typeDemande.setDescription(normalize(description));
        typeDemande.setActif(actif);
    }

    private void ensureCodeAvailable(String code, Long excludedId) {
        TypedQuery<Long> query = entityManager.createQuery(
                "SELECT COUNT(t) FROM TypeDemande t WHERE t.code = :code"
                + (excludedId == null ? "" : " AND t.id <> :excludedId"),
                Long.class);
        query.setParameter("code", code);
        if (excludedId != null) {
            query.setParameter("excludedId", excludedId);
        }

        if (query.getSingleResult() > 0L) {
            throw new BusinessException("Ce code de type de demande existe deja.");
        }
    }
}

