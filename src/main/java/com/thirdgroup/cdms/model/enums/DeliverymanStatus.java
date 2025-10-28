package com.thirdgroup.cdms.model.enums;

/**
 * 配送员工作状态枚举类
 * 状态说明：0=离线，1=在线，2=休息中
 */
public enum DeliverymanStatus {
    OFFLINE(0, "离线"),
    ONLINE(1, "在线"),
    RESTING(2, "休息中");

    private final int code; // 状态编码（基本类型int，避免equals问题）
    private final String desc; // 状态描述（页面显示用）

    // 枚举构造器（默认private，无需显式声明）
    DeliverymanStatus(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    // Getter方法（只暴露读取，不允许修改）
    public int getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    /**
     * 修复equals问题：根据状态编码获取枚举（支持Integer/int入参，避免空指针）
     * 核心：用==对比（int与Integer自动拆箱，无需equals）
     */
    public static DeliverymanStatus getByCode(Integer code) {
        // 入参为null时，默认返回离线
        if (code == null) {
            return OFFLINE;
        }
        // 遍历枚举匹配编码（int == Integer → 自动拆箱，安全对比）
        for (DeliverymanStatus status : values()) {
            if (status.code == code) {
                return status;
            }
        }
        // 无匹配编码时，默认返回离线
        return OFFLINE;
    }

    /**
     * 重载方法：支持直接传入int类型（避免调用时手动装箱）
     */
    public static DeliverymanStatus getByCode(int code) {
        return getByCode((Integer) code); // 复用上面的方法，减少重复代码
    }
}