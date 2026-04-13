package com.sgda.service.dto;

import com.sgda.domain.Demande;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class AdminDashboardData implements Serializable {

    private Long totalDemandes;
    private Long demandesEnAttente;
    private Long demandesValidees;
    private Long demandesRefusees;
    private Long demandesArchivees;
    private Long totalUtilisateurs;
    private List<RoleStat> utilisateursParRole = new ArrayList<>();
    private List<Demande> dernieresDemandes = new ArrayList<>();

    public Long getTotalDemandes() {
        return totalDemandes;
    }

    public void setTotalDemandes(Long totalDemandes) {
        this.totalDemandes = totalDemandes;
    }

    public Long getDemandesEnAttente() {
        return demandesEnAttente;
    }

    public void setDemandesEnAttente(Long demandesEnAttente) {
        this.demandesEnAttente = demandesEnAttente;
    }

    public Long getDemandesValidees() {
        return demandesValidees;
    }

    public void setDemandesValidees(Long demandesValidees) {
        this.demandesValidees = demandesValidees;
    }

    public Long getDemandesRefusees() {
        return demandesRefusees;
    }

    public void setDemandesRefusees(Long demandesRefusees) {
        this.demandesRefusees = demandesRefusees;
    }

    public Long getDemandesArchivees() {
        return demandesArchivees;
    }

    public void setDemandesArchivees(Long demandesArchivees) {
        this.demandesArchivees = demandesArchivees;
    }

    public Long getTotalUtilisateurs() {
        return totalUtilisateurs;
    }

    public void setTotalUtilisateurs(Long totalUtilisateurs) {
        this.totalUtilisateurs = totalUtilisateurs;
    }

    public List<RoleStat> getUtilisateursParRole() {
        return utilisateursParRole;
    }

    public void setUtilisateursParRole(List<RoleStat> utilisateursParRole) {
        this.utilisateursParRole = utilisateursParRole;
    }

    public List<Demande> getDernieresDemandes() {
        return dernieresDemandes;
    }

    public void setDernieresDemandes(List<Demande> dernieresDemandes) {
        this.dernieresDemandes = dernieresDemandes;
    }
}
