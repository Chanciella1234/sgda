package com.sgda.service;

import com.sgda.domain.Utilisateur;
import com.sgda.service.dto.AuthenticatedUser;
import com.sgda.service.exception.BusinessException;
import com.sgda.service.util.PasswordUtils;
import java.time.LocalDateTime;
import jakarta.ejb.Stateless;
import jakarta.persistence.TypedQuery;

@Stateless
public class AuthService extends AbstractService {

    public AuthenticatedUser authenticate(String login, String password) {
        requireText(login, "Le nom d utilisateur ou l email est obligatoire.");
        requireText(password, "Le mot de passe est obligatoire.");

        String normalizedLogin = normalize(login);
        String normalizedEmail = normalizedLogin.toLowerCase();

        TypedQuery<Utilisateur> query = entityManager.createQuery(
                "SELECT u FROM Utilisateur u JOIN FETCH u.role "
                + "WHERE u.username = :login OR LOWER(u.email) = :email",
                Utilisateur.class);
        query.setParameter("login", normalizedLogin);
        query.setParameter("email", normalizedEmail);

        Utilisateur utilisateur = getSingleResultOrNull(query);
        if (utilisateur == null) {
            throw new BusinessException(
                    "Aucun utilisateur n a ete trouve pour ce login. "
                    + "La base utilisee par l application ne contient probablement pas ce compte.");
        }
        if (!PasswordUtils.verifyPassword(password, utilisateur.getMotDePasse())) {
            throw new BusinessException("Mot de passe incorrect pour l utilisateur " + normalizedLogin + ".");
        }
        if (!utilisateur.isActif()) {
            throw new BusinessException("Votre compte est desactive.");
        }

        if (PasswordUtils.needsRehash(utilisateur.getMotDePasse())) {
            utilisateur.setMotDePasse(PasswordUtils.hashPassword(password));
        }

        utilisateur.setDernierLoginLe(LocalDateTime.now());
        return AuthenticatedUser.from(utilisateur);
    }
}

