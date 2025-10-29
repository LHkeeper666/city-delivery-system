package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import java.util.List;

public interface OrderService {
    List<DeliveryOrder> getPendingOrders();

    // 接单方法：orderId从Long改为String
    boolean acceptOrder(String orderId, Long userId); // Long → String

    // 更新状态方法：orderId从Long改为String
    boolean updateOrderStatus(String orderId, OrderStatus targetStatus, Long userId); // Long → String

    List<DeliveryOrder> getMyOrders(Long userId);

    // 查订单详情：orderId从Long改为String
    DeliveryOrder getOrderById(String orderId); // Long → String

    List<DeliveryOrder> selectPage(Integer status, String keyword, int start, int size);

    List<DeliveryOrder> getHistoryOrders(Long userId, Integer... statusCodes);
}