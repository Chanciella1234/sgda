package com.sgda.service.dto;

import java.io.Serializable;

public class RoleStat implements Serializable {

    private String roleCode;
    private String roleLabel;
    private Long total;

    public RoleStat(String roleCode, String roleLabel, Long total) {
        this.roleCode = roleCode;
        this.roleLabel = roleLabel;
        this.total = total;
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

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }
}
