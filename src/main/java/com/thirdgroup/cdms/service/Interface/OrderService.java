package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.enums.OrderStatus;

import java.util.List;

/**
 * 订单Service接口：定义订单相关业务
 */
public interface OrderService {
    // 1. 获取待接单订单列表
    List<DeliveryOrder> getPendingOrders();

    // 2. 接单：给订单分配外卖员，更新订单状态
    boolean acceptOrder(Integer orderId, Integer courierId);

    // 3. 更新订单状态（确认取餐/送达）
    boolean updateOrderStatus(Integer orderId, OrderStatus targetStatus);

    // 4. 获取外卖员的配送中订单
    List<DeliveryOrder> getDeliveringByCourierId(Integer courierId);

    // 5. 根据ID查订单
    DeliveryOrder getById(Integer orderId);

    // 6. 补充分页查询方法（与控制器对齐）
    List<DeliveryOrder> selectPage(Integer status, String keyword, int start, int size);
}