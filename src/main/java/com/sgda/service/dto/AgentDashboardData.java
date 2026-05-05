package com.sgda.service.dto;

import com.sgda.domain.Demande;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class AgentDashboardData implements Serializable {

    private Long demandesATraiter;
    private Long totalDemandesTraitees;
    private Long demandesValideesParAgent;
    private Long demandesRefuseesParAgent;
    private Long demandesEnCours;
    private List<Demande> dernieresDemandes = new ArrayList<>();
    private List<Demande> demandesPrioritaires = new ArrayList<>();

    public Long getDemandesATraiter() {
        return demandesATraiter;
    }

    public void setDemandesATraiter(Long demandesATraiter) {
        this.demandesATraiter = demandesATraiter;
    }

    public Long getTotalDemandesTraitees() {
        return totalDemandesTraitees;
    }

    public void setTotalDemandesTraitees(Long totalDemandesTraitees) {
        this.totalDemandesTraitees = totalDemandesTraitees;
    }

    public Long getDemandesValideesParAgent() {
        return demandesValideesParAgent;
    }

    public void setDemandesValideesParAgent(Long demandesValideesParAgent) {
        this.demandesValideesParAgent = demandesValideesParAgent;
    }

    public Long getDemandesRefuseesParAgent() {
        return demandesRefuseesParAgent;
    }

    public void setDemandesRefuseesParAgent(Long demandesRefuseesParAgent) {
        this.demandesRefuseesParAgent = demandesRefuseesParAgent;
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

    public List<Demande> getDemandesPrioritaires() {
        return demandesPrioritaires;
    }

    public void setDemandesPrioritaires(List<Demande> demandesPrioritaires) {
        this.demandesPrioritaires = demandesPrioritaires;
    }
}
