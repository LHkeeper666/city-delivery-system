package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryTrace;

import java.util.List;

public interface TraceService {
    // 新增轨迹记录（状态变更时自动调用）
    void addTrace(String orderId, Integer status, Long operatorId, String remark);
    // 查询订单完整轨迹（供管理员和用户查看）
    List<DeliveryTrace> getOrderTraces(String orderId);
}