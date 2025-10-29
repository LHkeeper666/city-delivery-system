package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.DeliveryOrderMapper;
import com.thirdgroup.cdms.model.ApiKey;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.DeliveryTrace;
import com.thirdgroup.cdms.model.PageResult;
import com.thirdgroup.cdms.service.Interface.AdminService;
import com.thirdgroup.cdms.service.Interface.TraceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class AdminServiceImpl implements AdminService {
    @Autowired
    private DeliveryOrderMapper orderMapper;  // 订单Mapper接口

    @Autowired
    private TraceService traceService;

    @Override
    public String publishOrder(DeliveryOrder order) {
        return "";
    }

    @Override
    public PageResult<DeliveryOrder> queryAllOrders(
            Integer status, String keyword, int page, int size, Long id, Date startTime, Date endTime) {
        // 1. 计算分页起始位置（MySQL分页用LIMIT start, size）
        int start = (page - 1) * size;  // 第1页：start=0，第2页：start=10...

        // 2. 查询当前页数据（调用Mapper接口，带条件+分页）
        List<DeliveryOrder> orderList = orderMapper.selectPageAdmin(
                status, keyword, start, size, id, startTime, endTime
        );

        // 3. 查询总记录数（用于计算总页数）
        Long total = orderMapper.count(status, keyword, id, startTime, endTime);

        // 4. 封装到PageResult并返回
        PageResult<DeliveryOrder> result = new PageResult<>();
        result.setList(orderList);    // 当前页订单列表
        result.setTotal(total);       // 总条数
        result.setPage(page);         // 当前页码
        result.setSize(size);         // 每页条数
        return result;
    }

    @Override
    public void cancelOrder(String orderId, String reason) {

    }

    @Override
    public ApiKey createApiKey(String appName) {
        return null;
    }

    @Override
    public List<DeliveryTrace> trackOrder(String orderId) {
        List<DeliveryTrace> deliveryTraceList = traceService.getOrderTraces(orderId);
        return deliveryTraceList;
    }
}
// 先用ai生成一下，这个后面我自己改