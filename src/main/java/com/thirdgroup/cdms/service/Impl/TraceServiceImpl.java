package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.DeliveryTraceMapper;
import com.thirdgroup.cdms.model.DeliveryTrace;
import com.thirdgroup.cdms.model.PageResult;
import com.thirdgroup.cdms.service.Interface.TraceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TraceServiceImpl implements TraceService {

    @Autowired
    private DeliveryTraceMapper deliveryTraceMapper;

    @Override
    public void addTrace(String orderId, Integer status, Long operatorId, String remark) {

    }

    @Override
    public List<DeliveryTrace> getOrderTraces(String orderId) {
        List<DeliveryTrace> deliveryTraces = deliveryTraceMapper.selectByOrderId(orderId);
        return deliveryTraces;
    }
}
