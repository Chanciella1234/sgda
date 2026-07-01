package com.sgda.domain;

import com.sgda.domain.enums.RoleCode;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "utilisateur")
public class Utilisateur implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    @Column(nullable = false, unique = true, length = 60)
    private String username;

    @Column(nullable = false, unique = true, length = 120)
    private String email;

    @Column(name = "mot_de_passe", nullable = false, length = 255)
    private String motDePasse;

    @Column(nullable = false, length = 80)
    private String nom;

    @Column(nullable = false, length = 80)
    private String prenom;

    @Column(nullable = false)
    private boolean actif = true;

    @Column(name = "cree_le", nullable = false)
    private LocalDateTime creeLe;

    @Column(name = "dernier_login_le")
    private LocalDateTime dernierLoginLe;

    @OneToMany(mappedBy = "etudiant", fetch = FetchType.LAZY)
    private List<Demande> demandesEtudiant = new ArrayList<>();

    @OneToMany(mappedBy = "agent", fetch = FetchType.LAZY)
    private List<Demande> demandesAssignees = new ArrayList<>();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
        this.actif = actif;
    }

    public LocalDateTime getCreeLe() {
        return creeLe;
    }

    public void setCreeLe(LocalDateTime creeLe) {
        this.creeLe = creeLe;
    }

    public LocalDateTime getDernierLoginLe() {
        return dernierLoginLe;
    }

    public void setDernierLoginLe(LocalDateTime dernierLoginLe) {
        this.dernierLoginLe = dernierLoginLe;
    }

    public List<Demande> getDemandesEtudiant() {
        return demandesEtudiant;
    }

    public void setDemandesEtudiant(List<Demande> demandesEtudiant) {
        this.demandesEtudiant = demandesEtudiant;
    }

    public List<Demande> getDemandesAssignees() {
        return demandesAssignees;
    }

    public void setDemandesAssignees(List<Demande> demandesAssignees) {
        this.demandesAssignees = demandesAssignees;
    }

    public String getNomComplet() {
        return prenom + " " + nom;
    }

    public boolean hasRole(RoleCode roleCode) {
        return role != null && roleCode.name().equals(role.getCode());
    }
}

