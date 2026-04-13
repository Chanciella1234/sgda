package com.sgda.service;

import com.sgda.domain.Role;
import com.sgda.domain.Utilisateur;
import com.sgda.service.exception.BusinessException;
import com.sgda.service.util.PasswordUtils;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.ejb.Stateless;
import jakarta.persistence.TypedQuery;

@Stateless
public class UtilisateurService extends AbstractService {

    public List<Utilisateur> listAllUsers() {
        return entityManager.createQuery(
                "SELECT u FROM Utilisateur u JOIN FETCH u.role ORDER BY u.nom ASC, u.prenom ASC",
                Utilisateur.class)
                .getResultList();
    }

    public List<Role> listRolesActifs() {
        return entityManager.createQuery(
                "SELECT r FROM Role r WHERE r.actif = true ORDER BY r.libelle ASC",
                Role.class)
                .getResultList();
    }

    public Utilisateur findUserForEdition(Long utilisateurId) {
        TypedQuery<Utilisateur> query = entityManager.createQuery(
                "SELECT u FROM Utilisateur u JOIN FETCH u.role WHERE u.id = :id", Utilisateur.class);
        query.setParameter("id", utilisateurId);
        Utilisateur utilisateur = getSingleResultOrNull(query);
        if (utilisateur == null) {
            throw new BusinessException("Utilisateur introuvable.");
        }
        return utilisateur;
    }

    public void createUser(Long adminId, Long roleId, String username, String email,
            String password, String nom, String prenom) {
        requireAdmin(adminId);
        requireText(username, "Le username est obligatoire.");
        requireText(email, "L email est obligatoire.");
        requireText(password, "Le mot de passe est obligatoire.");
        requireText(nom, "Le nom est obligatoire.");
        requireText(prenom, "Le prenom est obligatoire.");

        String normalizedUsername = normalize(username);
        String normalizedEmail = normalize(email).toLowerCase();
        ensureUserIdentityAvailable(normalizedUsername, normalizedEmail, null);

        Role role = requireEntity(Role.class, roleId, "Role introuvable.");

        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setRole(role);
        utilisateur.setUsername(normalizedUsername);
        utilisateur.setEmail(normalizedEmail);
        utilisateur.setMotDePasse(PasswordUtils.hashPassword(password));
        utilisateur.setNom(normalize(nom));
        utilisateur.setPrenom(normalize(prenom));
        utilisateur.setActif(true);
        utilisateur.setCreeLe(LocalDateTime.now());
        entityManager.persist(utilisateur);
    }

    public void updateUser(Long adminId, Long utilisateurId, Long roleId, String username, String email,
            String password, String nom, String prenom, boolean actif) {
        requireAdmin(adminId);
        requireText(username, "Le username est obligatoire.");
        requireText(email, "L email est obligatoire.");
        requireText(nom, "Le nom est obligatoire.");
        requireText(prenom, "Le prenom est obligatoire.");

        Utilisateur utilisateur = requireUtilisateur(utilisateurId);
        Role role = requireEntity(Role.class, roleId, "Role introuvable.");

        String normalizedUsername = normalize(username);
        String normalizedEmail = normalize(email).toLowerCase();
        ensureUserIdentityAvailable(normalizedUsername, normalizedEmail, utilisateurId);

        utilisateur.setRole(role);
        utilisateur.setUsername(normalizedUsername);
        utilisateur.setEmail(normalizedEmail);
        utilisateur.setNom(normalize(nom));
        utilisateur.setPrenom(normalize(prenom));
        utilisateur.setActif(actif);

        if (!isBlank(password)) {
            utilisateur.setMotDePasse(PasswordUtils.hashPassword(password));
        }
    }

    private void ensureUserIdentityAvailable(String username, String email, Long excludedId) {
        String usernameQuery = "SELECT COUNT(u) FROM Utilisateur u WHERE u.username = :value"
                + (excludedId == null ? "" : " AND u.id <> :excludedId");
        String emailQuery = "SELECT COUNT(u) FROM Utilisateur u WHERE u.email = :value"
                + (excludedId == null ? "" : " AND u.id <> :excludedId");

        TypedQuery<Long> usernameCount = entityManager.createQuery(usernameQuery, Long.class);
        usernameCount.setParameter("value", username);
        TypedQuery<Long> emailCount = entityManager.createQuery(emailQuery, Long.class);
        emailCount.setParameter("value", email);
        if (excludedId != null) {
            usernameCount.setParameter("excludedId", excludedId);
            emailCount.setParameter("excludedId", excludedId);
        }

        if (usernameCount.getSingleResult() > 0L) {
            throw new BusinessException("Ce username existe deja.");
        }
        if (emailCount.getSingleResult() > 0L) {
            throw new BusinessException("Cet email existe deja.");
        }
    }
}

