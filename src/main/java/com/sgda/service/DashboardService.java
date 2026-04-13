package com.sgda.service;

import com.sgda.domain.Demande;
import com.sgda.domain.Utilisateur;
import com.sgda.domain.enums.RoleCode;
import com.sgda.service.dto.AdminDashboardData;
import com.sgda.service.dto.AgentDashboardData;
import com.sgda.service.dto.RoleStat;
import com.sgda.service.dto.StudentDashboardData;
import java.util.Arrays;
import java.util.List;
import jakarta.ejb.Stateless;
import jakarta.persistence.TypedQuery;

@Stateless
public class DashboardService extends AbstractService {

    public AdminDashboardData getAdminDashboard(Long adminId) {
        requireAdmin(adminId);

        AdminDashboardData data = new AdminDashboardData();
        data.setTotalDemandes(countDemandes(null));
        data.setDemandesEnAttente(countDemandesByEtat("EN_ATTENTE"));
        data.setDemandesValidees(countDemandesByEtat("VALIDEE"));
        data.setDemandesRefusees(countDemandesByEtat("REFUSEE"));
        data.setDemandesArchivees(countDemandesByEtat("ARCHIVEE"));
        data.setTotalUtilisateurs(countUtilisateurs());
        data.setUtilisateursParRole(loadUserStatsByRole());
        data.setDernieresDemandes(loadRecentDemandes(null));
        return data;
    }

    public AgentDashboardData getAgentDashboard(Long agentId) {
        Utilisateur agent = requireUtilisateurActif(agentId);
        requireRole(agent, RoleCode.AGENT, "Action reservee a un agent.");

        AgentDashboardData data = new AgentDashboardData();
        data.setTotalDemandesTraitees(countProcessedByAgent(agentId));
        data.setDemandesValideesParAgent(countValidatedByAgent(agentId));
        data.setDemandesRefuseesParAgent(countRejectedByAgent(agentId));
        data.setDemandesEnCours(countAssignedInProgress(agentId));
        data.setDernieresDemandes(loadRecentDemandes(agentId));
        return data;
    }

    public StudentDashboardData getStudentDashboard(Long etudiantId) {
        Utilisateur etudiant = requireUtilisateurActif(etudiantId);
        requireRole(etudiant, RoleCode.ETUDIANT, "Action reservee a un etudiant.");

        StudentDashboardData data = new StudentDashboardData();
        data.setTotalDemandes(countDemandesByEtudiant(etudiantId));
        data.setDemandesValidees(countValidatedByStudent(etudiantId));
        data.setDemandesRefusees(countRejectedByStudent(etudiantId));
        data.setDemandesEnCours(countOpenByStudent(etudiantId));
        data.setDernieresDemandes(loadRecentDemandesForStudent(etudiantId));
        return data;
    }

    private Long countDemandes(String jpqlSuffix) {
        String jpql = "SELECT COUNT(d) FROM Demande d";
        if (jpqlSuffix != null) {
            jpql += " " + jpqlSuffix;
        }
        return entityManager.createQuery(jpql, Long.class).getSingleResult();
    }

    private Long countDemandesByEtat(String etatCode) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d WHERE d.etat.code = :etatCode",
                Long.class)
                .setParameter("etatCode", etatCode)
                .getSingleResult();
    }

    private Long countUtilisateurs() {
        return entityManager.createQuery(
                "SELECT COUNT(u) FROM Utilisateur u",
                Long.class)
                .getSingleResult();
    }

    private List<RoleStat> loadUserStatsByRole() {
        return entityManager.createQuery(
                "SELECT new com.sgda.service.dto.RoleStat(r.code, r.libelle, COUNT(u)) "
                + "FROM Role r LEFT JOIN r.utilisateurs u "
                + "GROUP BY r.code, r.libelle "
                + "ORDER BY r.libelle ASC",
                RoleStat.class)
                .getResultList();
    }

    private List<Demande> loadRecentDemandes(Long agentId) {
        String jpql = "SELECT d FROM Demande d "
                + "JOIN FETCH d.typeDemande "
                + "JOIN FETCH d.etat "
                + "JOIN FETCH d.etudiant "
                + "LEFT JOIN FETCH d.agent ";
        if (agentId != null) {
            jpql += "WHERE d.agent.id = :agentId ";
        }
        jpql += "ORDER BY COALESCE(d.dateDecision, d.datePriseEnCharge, d.dateCreation) DESC";

        TypedQuery<Demande> query = entityManager.createQuery(jpql, Demande.class)
                .setMaxResults(5);
        if (agentId != null) {
            query.setParameter("agentId", agentId);
        }
        return query.getResultList();
    }

    private Long countProcessedByAgent(Long agentId) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d "
                + "WHERE d.agent.id = :agentId AND d.dateDecision IS NOT NULL",
                Long.class)
                .setParameter("agentId", agentId)
                .getSingleResult();
    }

    private Long countValidatedByAgent(Long agentId) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d "
                + "WHERE d.agent.id = :agentId AND d.dateDecision IS NOT NULL "
                + "AND (d.etat.code = 'VALIDEE' OR (d.etat.code = 'ARCHIVEE' AND d.motifRefus IS NULL))",
                Long.class)
                .setParameter("agentId", agentId)
                .getSingleResult();
    }

    private Long countRejectedByAgent(Long agentId) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d "
                + "WHERE d.agent.id = :agentId AND d.dateDecision IS NOT NULL "
                + "AND (d.etat.code = 'REFUSEE' OR (d.etat.code = 'ARCHIVEE' AND d.motifRefus IS NOT NULL))",
                Long.class)
                .setParameter("agentId", agentId)
                .getSingleResult();
    }

    private Long countAssignedInProgress(Long agentId) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d "
                + "WHERE d.agent.id = :agentId AND d.etat.code = 'EN_ATTENTE'",
                Long.class)
                .setParameter("agentId", agentId)
                .getSingleResult();
    }

    private Long countDemandesByEtudiant(Long etudiantId) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d WHERE d.etudiant.id = :etudiantId",
                Long.class)
                .setParameter("etudiantId", etudiantId)
                .getSingleResult();
    }

    private Long countValidatedByStudent(Long etudiantId) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d "
                + "WHERE d.etudiant.id = :etudiantId "
                + "AND (d.etat.code = 'VALIDEE' OR (d.etat.code = 'ARCHIVEE' AND d.motifRefus IS NULL AND d.dateDecision IS NOT NULL))",
                Long.class)
                .setParameter("etudiantId", etudiantId)
                .getSingleResult();
    }

    private Long countRejectedByStudent(Long etudiantId) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d "
                + "WHERE d.etudiant.id = :etudiantId "
                + "AND (d.etat.code = 'REFUSEE' OR (d.etat.code = 'ARCHIVEE' AND d.motifRefus IS NOT NULL AND d.dateDecision IS NOT NULL))",
                Long.class)
                .setParameter("etudiantId", etudiantId)
                .getSingleResult();
    }

    private Long countOpenByStudent(Long etudiantId) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d "
                + "WHERE d.etudiant.id = :etudiantId AND d.etat.code IN :codes",
                Long.class)
                .setParameter("etudiantId", etudiantId)
                .setParameter("codes", Arrays.asList("BROUILLON", "SOUMISE", "EN_ATTENTE"))
                .getSingleResult();
    }

    private List<Demande> loadRecentDemandesForStudent(Long etudiantId) {
        return entityManager.createQuery(
                "SELECT d FROM Demande d "
                + "JOIN FETCH d.typeDemande "
                + "JOIN FETCH d.etat "
                + "LEFT JOIN FETCH d.agent "
                + "WHERE d.etudiant.id = :etudiantId "
                + "ORDER BY d.dateCreation DESC",
                Demande.class)
                .setParameter("etudiantId", etudiantId)
                .setMaxResults(5)
                .getResultList();
    }
}
