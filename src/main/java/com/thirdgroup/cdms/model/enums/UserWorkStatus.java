package com.thirdgroup.cdms.model.enums;

/**
 * 配送员工作状态枚举类
 */
public enum UserWorkStatus {
    OFFLINE(0, "离线"),
    ONLINE(1, "在线"),
    RESTING(2, "休息中");

    private int code;
    private String desc;

    UserWorkStatus(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public int getCode() { return code; }
    public String getDesc() { return desc; }

}
