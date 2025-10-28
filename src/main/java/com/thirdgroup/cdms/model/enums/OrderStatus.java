package com.thirdgroup.cdms.model.enums;

/**
 * 订单状态枚举类
 * 状态说明：0=待接单，1=已接单待取货，2=配送中，3=已完成，4=已取消，5=放弃待审核
 */
public enum OrderStatus {
    PENDING(0, "待接单"),
    ACCEPTED(1, "已接单待取货"),
    DELIVERING(2, "配送中"),
    COMPLETED(3, "已完成"),
    CANCELLED(4, "已取消"),
    ABANDONED_PENDING(5, "放弃待审核");

    private final int code;       // 状态编码（数据库存储用）
    private final String desc;    // 状态描述（页面显示用）

    // 枚举构造器（默认private，无需显式声明）
    OrderStatus(int code, String desc) {
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
     * 完整实现：根据状态编码获取枚举（支持Integer入参，处理空值，避免抛出异常）
     * 用于Controller接收前端参数（可能为null），与Service/Mapper逻辑对齐
     */
    public static OrderStatus getByCode(Integer statusCode) {
        // 1. 处理入参为null的情况（默认返回待接单，避免空指针）
        if (statusCode == null) {
            return PENDING;
        }
        // 2. 遍历枚举匹配编码（int与Integer自动拆箱，用==对比更高效）
        for (OrderStatus status : values()) {
            if (status.code == statusCode) {
                return status;
            }
        }
        // 3. 无匹配编码时（返回待接单，而非抛出异常，避免前端因非法参数崩溃）
        return PENDING;
    }

    /**
     * 整合fromCode方法：支持int入参（避免调用时手动装箱），非法编码抛出异常
     * 用于已知编码合法的场景（如从数据库查询后转换，确保数据有效性）
     */
    public static OrderStatus fromCode(int code) {
        for (OrderStatus status : values()) {
            if (status.code == code) {
                return status;
            }
        }
        // 数据库存非法编码时抛出异常，提醒数据问题（比return null更易排查）
        throw new IllegalArgumentException("未知订单状态编码: " + code + "，请检查数据库数据");
    }
}