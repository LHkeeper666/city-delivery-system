package com.thirdgroup.cdms.model.enums;

/**
 * 账号状态枚举类
 */
public enum UserStatus {
    ENABLED(0),
    DISABLED(1),
    LOCKED(2);

    private int code;

    UserStatus(int code) { this.code = code; }

    public int getCode() { return code; }

}
