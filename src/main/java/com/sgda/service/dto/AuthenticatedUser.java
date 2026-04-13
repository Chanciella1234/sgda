package com.sgda.service.dto;

import com.sgda.domain.Utilisateur;
import java.io.Serializable;

public class AuthenticatedUser implements Serializable {

    private Long id;
    private String username;
    private String fullName;
    private String roleCode;
    private String roleLabel;

    public static AuthenticatedUser from(Utilisateur utilisateur) {
        AuthenticatedUser user = new AuthenticatedUser();
        user.setId(utilisateur.getId());
        user.setUsername(utilisateur.getUsername());
        user.setFullName(utilisateur.getNomComplet());
        user.setRoleCode(utilisateur.getRole().getCode());
        user.setRoleLabel(utilisateur.getRole().getLibelle());
        return user;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRoleCode() {
        return roleCode;
    }

    public void setRoleCode(String roleCode) {
        this.roleCode = roleCode;
    }

    public String getRoleLabel() {
        return roleLabel;
    }

    public void setRoleLabel(String roleLabel) {
        this.roleLabel = roleLabel;
    }
}
