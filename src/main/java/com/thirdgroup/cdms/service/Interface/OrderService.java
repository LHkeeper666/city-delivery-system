package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import com.thirdgroup.cdms.utils.Result;

import java.util.List;

/**
 * 订单Service接口：定义订单相关业务
 */
public interface OrderService {

    // 1. 获取待接单订单列表（状态为PENDING）
    List<DeliveryOrder> getPendingOrders();

    // 2. 外卖员接单（重载优化：统一参数类型为String和Long，与实体类匹配）
    Result acceptOrder(String orderId, Long deliverymanId);

    // 3. 更新订单状态（确认取餐/送达，支持多状态流转）
    Result updateOrderStatus(String orderId, OrderStatus targetStatus);

    // 4. 获取外卖员的配送中订单（状态为IN_TRANSIT）
    List<DeliveryOrder> getDeliveringByCourierId(Long deliverymanId);

    // 5. 根据ID查询订单详情
    DeliveryOrder getById(String orderId);

    // 6. 分页查询订单（支持多条件筛选）
    List<DeliveryOrder> selectPage(Integer status, String keyword, int start, int size);
}