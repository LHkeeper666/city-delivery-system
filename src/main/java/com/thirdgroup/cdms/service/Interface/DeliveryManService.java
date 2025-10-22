package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.util.Result;

import java.util.List;

public interface DeliveryManService {
    // 获取待接单列表（状态=0的订单）
    List<DeliveryOrder> getPendingOrders();
    // 接单（含业务校验：无在途订单、订单状态正常）
    Result takeOrder(Long deliveryManId, String orderId);
    // 完成订单（更新状态+记录轨迹）
    Result completeOrder(Long deliveryManId, String orderId);
    // 查询我的配送（按状态筛选：在途/已完成）
    List<DeliveryOrder> getMyOrders(Long deliveryManId, Integer status);
    // 修改配送员联系方式
    boolean updatePhone(Long deliveryManId, String newPhone);
}