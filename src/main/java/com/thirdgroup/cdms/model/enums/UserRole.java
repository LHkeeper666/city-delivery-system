package com.thirdgroup.cdms.model.enums;

/**
 * 用户身份枚举类
 */
public enum UserRole {
    ADMIN(0, "管理员"),
    DELIVERYMABN(1, "配送员");


    private int code;
    private String desc;

    UserRole(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public int getCode() { return code; }
    public String getDesc() { return desc; }
}
