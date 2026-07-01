package com.sgda.service;

import com.sgda.domain.Demande;
import com.sgda.domain.Utilisateur;
import com.sgda.domain.enums.RoleCode;
import com.sgda.service.dto.AdminDashboardData;
import com.sgda.service.dto.AgentDashboardData;
import com.sgda.service.dto.ChartSeriesData;
import com.sgda.service.dto.RoleStat;
import com.sgda.service.dto.StudentDashboardData;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.time.Year;
import java.time.format.DateTimeFormatter;
import java.time.temporal.IsoFields;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import jakarta.ejb.Stateless;
import jakarta.persistence.TypedQuery;

@Stateless
public class DashboardService extends AbstractService {

    public AdminDashboardData getAdminDashboard(Long adminId) {
        requireAdmin(adminId);

        AdminDashboardData data = new AdminDashboardData();
        data.setTotalDemandes(countDemandes(null));
        data.setDemandesBrouillon(countDemandesByEtat("BROUILLON"));
        data.setDemandesSoumises(countDemandesByEtat("SOUMISE"));
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
        data.setDemandesATraiter(countDemandesByEtat("SOUMISE"));
        data.setTotalDemandesTraitees(countProcessedByAgent(agentId));
        data.setDemandesValideesParAgent(countValidatedByAgent(agentId));
        data.setDemandesRefuseesParAgent(countRejectedByAgent(agentId));
        data.setDemandesEnCours(countAssignedInProgress(agentId));
        data.setDernieresDemandes(loadRecentDemandes(agentId));
        data.setDemandesPrioritaires(loadPriorityDemandes());
        return data;
    }

    public StudentDashboardData getStudentDashboard(Long etudiantId) {
        Utilisateur etudiant = requireUtilisateurActif(etudiantId);
        requireRole(etudiant, RoleCode.ETUDIANT, "Action reservee a un etudiant.");

        StudentDashboardData data = new StudentDashboardData();
        data.setTotalDemandes(countDemandesByEtudiant(etudiantId));
        data.setDemandesBrouillons(countDemandesByEtudiantAndEtat(etudiantId, "BROUILLON"));
        data.setDemandesValidees(countValidatedByStudent(etudiantId));
        data.setDemandesRefusees(countRejectedByStudent(etudiantId));
        data.setDemandesEnCours(countOpenByStudent(etudiantId));
        data.setDernieresDemandes(loadRecentDemandesForStudent(etudiantId));
        return data;
    }

    public ChartSeriesData getAdminTrendData(Long adminId, String range) {
        requireAdmin(adminId);

        String normalizedRange = normalizeAdminRange(range);
        ChartSeriesData data = new ChartSeriesData();
        data.setPrimaryLabel("Demandes soumises");
        data.setSecondaryLabel("Demandes traitees");

        switch (normalizedRange) {
            case "semaine":
                fillWeeklyTrend(data);
                break;
            case "mois":
                fillMonthlyTrend(data, 6);
                break;
            case "annee":
                fillYearlyTrend(data, 5);
                break;
            default:
                fillDailyTrend(data, 7);
                break;
        }

        return data;
    }

    public ChartSeriesData getAgentActivityData(Long agentId, String range) {
        Utilisateur agent = requireUtilisateurActif(agentId);
        requireRole(agent, RoleCode.AGENT, "Action reservee a un agent.");

        String normalizedRange = normalizeAgentRange(range);
        ChartSeriesData data = new ChartSeriesData();
        data.setPrimaryLabel("Validees");
        data.setSecondaryLabel("Refusees");

        switch (normalizedRange) {
            case "3m":
                fillAgentMonthlyActivity(data, agentId, 3, false);
                break;
            case "year":
                fillAgentMonthlyActivity(data, agentId, Month.values().length, true);
                break;
            default:
                fillAgentMonthlyActivity(data, agentId, 6, false);
                break;
        }

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

    private Long countDemandesByEtudiantAndEtat(Long etudiantId, String etatCode) {
        return entityManager.createQuery(
                "SELECT COUNT(d) FROM Demande d "
                + "WHERE d.etudiant.id = :etudiantId AND d.etat.code = :etatCode",
                Long.class)
                .setParameter("etudiantId", etudiantId)
                .setParameter("etatCode", etatCode)
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
                .setParameter("codes", Arrays.asList("SOUMISE", "EN_ATTENTE"))
                .getSingleResult();
    }

    private List<Demande> loadPriorityDemandes() {
        return entityManager.createQuery(
                "SELECT d FROM Demande d "
                + "JOIN FETCH d.typeDemande "
                + "JOIN FETCH d.etat "
                + "JOIN FETCH d.etudiant "
                + "LEFT JOIN FETCH d.agent "
                + "WHERE d.etat.code = 'SOUMISE' AND d.dateSoumission IS NOT NULL "
                + "AND d.dateSoumission <= :threshold "
                + "ORDER BY d.dateSoumission ASC",
                Demande.class)
                .setParameter("threshold", LocalDateTime.now().minusDays(2))
                .setMaxResults(8)
                .getResultList();
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

    private String normalizeAdminRange(String range) {
        if ("semaine".equalsIgnoreCase(range) || "mois".equalsIgnoreCase(range) || "annee".equalsIgnoreCase(range)) {
            return range.toLowerCase(Locale.ROOT);
        }
        return "jour";
    }

    private String normalizeAgentRange(String range) {
        if ("3m".equalsIgnoreCase(range) || "year".equalsIgnoreCase(range)) {
            return range.toLowerCase(Locale.ROOT);
        }
        return "6m";
    }

    private void fillDailyTrend(ChartSeriesData data, int days) {
        LocalDate startDate = LocalDate.now().minusDays(days - 1L);
        LinkedHashMap<LocalDate, long[]> buckets = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEE", Locale.FRENCH);

        for (int index = 0; index < days; index += 1) {
            LocalDate currentDate = startDate.plusDays(index);
            buckets.put(currentDate, new long[]{0L, 0L});
            data.getLabels().add(capitalize(formatter.format(currentDate).replace(".", "")));
        }

        LocalDateTime threshold = startDate.atStartOfDay();
        List<Demande> demandes = loadDemandesForTrend(threshold);
        for (Demande demande : demandes) {
            if (demande.getDateSoumission() != null) {
                incrementBucket(buckets, demande.getDateSoumission().toLocalDate(), 0);
            }
            if (demande.getDateDecision() != null) {
                incrementBucket(buckets, demande.getDateDecision().toLocalDate(), 1);
            }
        }

        fillSeriesValues(data, new ArrayList<>(buckets.values()));
    }

    private void fillWeeklyTrend(ChartSeriesData data) {
        LocalDate currentWeekStart = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate firstWeekStart = currentWeekStart.minusWeeks(5);
        LinkedHashMap<String, long[]> buckets = new LinkedHashMap<>();

        for (int index = 0; index < 6; index += 1) {
            LocalDate weekStart = firstWeekStart.plusWeeks(index);
            String key = weekStart.getYear() + "-" + weekStart.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
            buckets.put(key, new long[]{0L, 0L});
            data.getLabels().add("S" + weekStart.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR));
        }

        LocalDateTime threshold = firstWeekStart.atStartOfDay();
        List<Demande> demandes = loadDemandesForTrend(threshold);
        for (Demande demande : demandes) {
            if (demande.getDateSoumission() != null) {
                LocalDate date = demande.getDateSoumission().toLocalDate();
                String key = date.getYear() + "-" + date.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
                incrementBucket(buckets, key, 0);
            }
            if (demande.getDateDecision() != null) {
                LocalDate date = demande.getDateDecision().toLocalDate();
                String key = date.getYear() + "-" + date.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
                incrementBucket(buckets, key, 1);
            }
        }

        fillSeriesValues(data, new ArrayList<>(buckets.values()));
    }

    private void fillMonthlyTrend(ChartSeriesData data, int months) {
        LocalDate monthStart = LocalDate.now().withDayOfMonth(1);
        LocalDate firstMonth = monthStart.minusMonths(months - 1L);
        LinkedHashMap<String, long[]> buckets = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM", Locale.FRENCH);

        for (int index = 0; index < months; index += 1) {
            LocalDate currentMonth = firstMonth.plusMonths(index);
            String key = currentMonth.getYear() + "-" + currentMonth.getMonthValue();
            buckets.put(key, new long[]{0L, 0L});
            data.getLabels().add(capitalize(formatter.format(currentMonth).replace(".", "")));
        }

        LocalDateTime threshold = firstMonth.atStartOfDay();
        List<Demande> demandes = loadDemandesForTrend(threshold);
        for (Demande demande : demandes) {
            if (demande.getDateSoumission() != null) {
                LocalDate date = demande.getDateSoumission().toLocalDate().withDayOfMonth(1);
                String key = date.getYear() + "-" + date.getMonthValue();
                incrementBucket(buckets, key, 0);
            }
            if (demande.getDateDecision() != null) {
                LocalDate date = demande.getDateDecision().toLocalDate().withDayOfMonth(1);
                String key = date.getYear() + "-" + date.getMonthValue();
                incrementBucket(buckets, key, 1);
            }
        }

        fillSeriesValues(data, new ArrayList<>(buckets.values()));
    }

    private void fillYearlyTrend(ChartSeriesData data, int years) {
        int currentYear = Year.now().getValue();
        int startYear = currentYear - (years - 1);
        LinkedHashMap<Integer, long[]> buckets = new LinkedHashMap<>();

        for (int year = startYear; year <= currentYear; year += 1) {
            buckets.put(year, new long[]{0L, 0L});
            data.getLabels().add(String.valueOf(year));
        }

        LocalDateTime threshold = LocalDate.of(startYear, 1, 1).atStartOfDay();
        List<Demande> demandes = loadDemandesForTrend(threshold);
        for (Demande demande : demandes) {
            if (demande.getDateSoumission() != null) {
                incrementBucket(buckets, demande.getDateSoumission().getYear(), 0);
            }
            if (demande.getDateDecision() != null) {
                incrementBucket(buckets, demande.getDateDecision().getYear(), 1);
            }
        }

        fillSeriesValues(data, new ArrayList<>(buckets.values()));
    }

    private void fillAgentMonthlyActivity(ChartSeriesData data, Long agentId, int months, boolean currentYearOnly) {
        LocalDate firstMonth = currentYearOnly
                ? LocalDate.now().withMonth(1).withDayOfMonth(1)
                : LocalDate.now().withDayOfMonth(1).minusMonths(months - 1L);
        LocalDate lastMonth = LocalDate.now().withDayOfMonth(1);
        LinkedHashMap<String, long[]> buckets = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM", Locale.FRENCH);

        LocalDate pointer = firstMonth;
        while (!pointer.isAfter(lastMonth)) {
            String key = pointer.getYear() + "-" + pointer.getMonthValue();
            buckets.put(key, new long[]{0L, 0L});
            data.getLabels().add(capitalize(formatter.format(pointer).replace(".", "")));
            pointer = pointer.plusMonths(1);
        }

        LocalDateTime threshold = firstMonth.atStartOfDay();
        List<Demande> demandes = loadAgentDecidedDemandes(agentId, threshold);
        for (Demande demande : demandes) {
            if (demande.getDateDecision() == null) {
                continue;
            }

            LocalDate decisionMonth = demande.getDateDecision().toLocalDate().withDayOfMonth(1);
            String key = decisionMonth.getYear() + "-" + decisionMonth.getMonthValue();

            if (isAcceptedOutcome(demande)) {
                incrementBucket(buckets, key, 0);
            } else if (isRejectedOutcome(demande)) {
                incrementBucket(buckets, key, 1);
            }
        }

        fillSeriesValues(data, new ArrayList<>(buckets.values()));
    }

    private List<Demande> loadDemandesForTrend(LocalDateTime threshold) {
        return entityManager.createQuery(
                "SELECT d FROM Demande d "
                + "WHERE (d.dateSoumission IS NOT NULL AND d.dateSoumission >= :threshold) "
                + "OR (d.dateDecision IS NOT NULL AND d.dateDecision >= :threshold)",
                Demande.class)
                .setParameter("threshold", threshold)
                .getResultList();
    }

    private List<Demande> loadAgentDecidedDemandes(Long agentId, LocalDateTime threshold) {
        return entityManager.createQuery(
                "SELECT d FROM Demande d "
                + "JOIN FETCH d.etat "
                + "WHERE d.agent.id = :agentId AND d.dateDecision IS NOT NULL AND d.dateDecision >= :threshold",
                Demande.class)
                .setParameter("agentId", agentId)
                .setParameter("threshold", threshold)
                .getResultList();
    }

    private boolean isAcceptedOutcome(Demande demande) {
        return "VALIDEE".equals(demande.getEtat().getCode())
                || ("ARCHIVEE".equals(demande.getEtat().getCode()) && demande.getMotifRefus() == null);
    }

    private boolean isRejectedOutcome(Demande demande) {
        return "REFUSEE".equals(demande.getEtat().getCode())
                || ("ARCHIVEE".equals(demande.getEtat().getCode()) && demande.getMotifRefus() != null);
    }

    private <K> void incrementBucket(Map<K, long[]> buckets, K key, int valueIndex) {
        long[] values = buckets.get(key);
        if (values != null) {
            values[valueIndex] += 1L;
        }
    }

    private void fillSeriesValues(ChartSeriesData data, List<long[]> values) {
        for (long[] pair : values) {
            data.getPrimaryValues().add(pair[0]);
            data.getSecondaryValues().add(pair[1]);
        }
    }

    private String capitalize(String value) {
        if (value == null || value.isEmpty()) {
            return value;
        }
        return value.substring(0, 1).toUpperCase(Locale.FRENCH) + value.substring(1);
    }
}
