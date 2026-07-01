package com.sgda.service.exception;

import jakarta.ejb.ApplicationException;

@ApplicationException(rollback = false)
public class BusinessException extends RuntimeException {

    public BusinessException(String message) {
        super(message);
    }
}
