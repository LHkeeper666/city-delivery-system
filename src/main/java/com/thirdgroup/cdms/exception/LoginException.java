package com.thirdgroup.cdms.exception;

/**
 * 登录异常类
 * 当登录操作不成功时抛出
 */
public class LoginException extends Exception {

    static final long serialVersionUID = 1L;
    private String message;

    public LoginException(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }
}
