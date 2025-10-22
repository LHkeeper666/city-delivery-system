package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryOrder;

import java.time.LocalDateTime;

public interface OrderService {
    // 根据订单号查询订单详情（供管理员和配送员查看）
    DeliveryOrder getOrderByNo(String orderId);
    // 更新订单状态（通用方法，被接单、完成、取消等操作调用）
    int updateOrderStatus(String orderId, Integer status, LocalDateTime time);
    // 生成唯一订单号（规则：前缀+时间戳+随机数）
    String generateOrderNo();
}