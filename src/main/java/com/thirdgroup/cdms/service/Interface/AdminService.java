package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.ApiKey;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.PageResult;

public interface AdminService {
    // 发布配送订单（管理员代用户创建订单）
    String publishOrder(DeliveryOrder order);
    // 分页查询所有订单（带多条件筛选）
    PageResult<DeliveryOrder> queryAllOrders(Integer status, String keyword, int page, int size, long id);
    // 强制取消订单（仅管理员有权限）
    void cancelOrder(String orderId, String reason);
    // 管理API密钥（创建/禁用第三方接口密钥）
    ApiKey createApiKey(String appName);
}