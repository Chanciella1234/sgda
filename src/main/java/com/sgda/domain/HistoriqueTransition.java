package com.sgda.domain;

import java.io.Serializable;
import java.time.LocalDateTime;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "historique_transition")
public class HistoriqueTransition implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "demande_id", nullable = false)
    private Demande demande;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "de_etat_id")
    private EtatDemande deEtat;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vers_etat_id", nullable = false)
    private EtatDemande versEtat;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "acteur_id", nullable = false)
    private Utilisateur acteur;

    @Column(columnDefinition = "TEXT")
    private String commentaire;

    @Column(name = "cree_le", nullable = false)
    private LocalDateTime creeLe;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Demande getDemande() {
        return demande;
    }

    public void setDemande(Demande demande) {
        this.demande = demande;
    }

    public EtatDemande getDeEtat() {
        return deEtat;
    }

    public void setDeEtat(EtatDemande deEtat) {
        this.deEtat = deEtat;
    }

    public EtatDemande getVersEtat() {
        return versEtat;
    }

    public void setVersEtat(EtatDemande versEtat) {
        this.versEtat = versEtat;
    }

    public Utilisateur getActeur() {
        return acteur;
    }

    public void setActeur(Utilisateur acteur) {
        this.acteur = acteur;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    public LocalDateTime getCreeLe() {
        return creeLe;
    }

    public void setCreeLe(LocalDateTime creeLe) {
        this.creeLe = creeLe;
    }
}

