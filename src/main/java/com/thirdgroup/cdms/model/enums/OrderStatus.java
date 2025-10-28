package com.thirdgroup.cdms.model.enums;

/**
 * 订单状态枚举类
 */
public enum OrderStatus {
    PENDING(0, "待接单"),
    ACCEPTED(1, "已接单待取货"),
    DELIVERING(2, "配送中"),
    COMPLETED(3, "已完成"),
    CANCELLED(4, "已取消"),
    ABANDONED_PENDING(5, "放弃待审核");



    private final int code;
    private final String desc;

    OrderStatus(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public int getCode() { return code; }
    public String getDesc() { return desc; }

    // 根据数据库存的 code 返回枚举对象
    public static OrderStatus fromCode(int code) {
        for (OrderStatus status : values()) {
            if (status.code == code) return status;
        }
        throw new IllegalArgumentException("未知订单状态: " + code);
        /**
         * 这个比return null好一些
         */
    }
}
