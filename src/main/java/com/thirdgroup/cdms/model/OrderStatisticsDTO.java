package com.thirdgroup.cdms.model;

import lombok.Data;

@Data
public class OrderStatisticsDTO {

    private Long totalCount;        // 总订单数
    private Double totalAmount;     // 总金额
    private Long completedCount;    // 已完成订单数
    private Long canceledCount;     // 已取消订单数
    private Long deliveringCount;   // 配送中订单数
    private Double avgDeliveryTime;
    private int completedOrders;  // 已完成订单数
    private int pendingOrders;    // 待处理订单数// 平均配送时长（分钟）
}
