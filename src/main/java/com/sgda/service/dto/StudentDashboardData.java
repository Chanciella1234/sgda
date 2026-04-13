package com.sgda.service.dto;

import com.sgda.domain.Demande;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class StudentDashboardData implements Serializable {

    private Long totalDemandes;
    private Long demandesValidees;
    private Long demandesRefusees;
    private Long demandesEnCours;
    private List<Demande> dernieresDemandes = new ArrayList<>();

    public Long getTotalDemandes() {
        return totalDemandes;
    }

    public void setTotalDemandes(Long totalDemandes) {
        this.totalDemandes = totalDemandes;
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

    public Long getDemandesEnCours() {
        return demandesEnCours;
    }

    public void setDemandesEnCours(Long demandesEnCours) {
        this.demandesEnCours = demandesEnCours;
    }

    public List<Demande> getDernieresDemandes() {
        return dernieresDemandes;
    }

    public void setDernieresDemandes(List<Demande> dernieresDemandes) {
        this.dernieresDemandes = dernieresDemandes;
    }
}
