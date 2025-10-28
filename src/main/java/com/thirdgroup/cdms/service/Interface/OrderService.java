package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import java.util.List;

public interface OrderService {
    // 1. 获取待接单订单
    List<DeliveryOrder> getPendingOrders();

    // 2. 外卖员接单
    boolean acceptOrder(Long orderId, Long userId);

    // 3. 更新订单状态
    boolean updateOrderStatus(Long orderId, OrderStatus targetStatus);

    // 4. 获取外卖员的配送中订单（替代原getDeliveringByCourierId）
    List<DeliveryOrder> getMyOrders(Long userId);

    // 5. 根据ID查订单详情
    DeliveryOrder getOrderById(Long orderId);

    // 6. 分页查询订单
    List<DeliveryOrder> selectPage(Integer status, String keyword, int start, int size);
}