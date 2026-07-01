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
@Table(name = "piece_jointe")
public class PieceJointe implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "demande_id", nullable = false)
    private Demande demande;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "uploade_par_id", nullable = false)
    private Utilisateur uploadePar;

    @Column(name = "nom_original", nullable = false, length = 255)
    private String nomOriginal;

    @Column(name = "mime_type", nullable = false, length = 120)
    private String mimeType;

    @Column(name = "taille_octets", nullable = false)
    private Long tailleOctets;

    @Column(name = "chemin_stockage", nullable = false, length = 500)
    private String cheminStockage;

    @Column(length = 64)
    private String sha256;

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

    public Utilisateur getUploadePar() {
        return uploadePar;
    }

    public void setUploadePar(Utilisateur uploadePar) {
        this.uploadePar = uploadePar;
    }

    public String getNomOriginal() {
        return nomOriginal;
    }

    public void setNomOriginal(String nomOriginal) {
        this.nomOriginal = nomOriginal;
    }

    public String getMimeType() {
        return mimeType;
    }

    public void setMimeType(String mimeType) {
        this.mimeType = mimeType;
    }

    public Long getTailleOctets() {
        return tailleOctets;
    }

    public void setTailleOctets(Long tailleOctets) {
        this.tailleOctets = tailleOctets;
    }

    public String getCheminStockage() {
        return cheminStockage;
    }

    public void setCheminStockage(String cheminStockage) {
        this.cheminStockage = cheminStockage;
    }

    public String getSha256() {
        return sha256;
    }

    public void setSha256(String sha256) {
        this.sha256 = sha256;
    }

    public LocalDateTime getCreeLe() {
        return creeLe;
    }

    public void setCreeLe(LocalDateTime creeLe) {
        this.creeLe = creeLe;
    }
}

