package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.OrderMapper;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import com.thirdgroup.cdms.service.Interface.OrderService;
import com.thirdgroup.cdms.utils.Result;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.Date;
import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

    @Resource
    private OrderMapper orderMapper;

    // 1. 获取待接单订单列表
    @Override
    public List<DeliveryOrder> getPendingOrders() {
        // 调用Mapper查询状态为"待接单（PENDING）"的订单
        return orderMapper.selectPendingOrders(OrderStatus.PENDING.getCode());
    }

    // 2. 外卖员接单（核心方法：绑定外卖员+更新状态为已接单待取货）
    @Override
    @Transactional  // 事务保证：防止并发抢单
    public Result acceptOrder(String orderId, Long deliverymanId) {
        int rows = orderMapper.acceptOrder(
                orderId,
                deliverymanId,
                OrderStatus.ACCEPTED.getCode(),  // 目标状态：已接单待取货
                OrderStatus.PENDING.getCode()    // 原状态：仅待接单可被接
        );
        return rows > 0 ?
                Result.success("接单成功，请尽快取货") :
                Result.error(500, "接单失败，订单可能已被接走或状态异常");
    }

    // 3. 更新订单状态（统一处理取餐/送达，根据目标状态区分逻辑）
    @Override
    @Transactional
    public Result updateOrderStatus(String orderId, OrderStatus targetStatus) {
        Date operateTime = new Date(); // 操作时间（取餐/完成时间）
        int rows;

        if (targetStatus == OrderStatus.IN_TRANSIT) {
            // 从"已接单待取货"→"配送中"（记录取餐时间）
            rows = orderMapper.updateStatus(
                    orderId,
                    targetStatus.getCode(),
                    operateTime,  // 取餐时间
                    null
            );
        } else if (targetStatus == OrderStatus.COMPLETED) {
            // 从"配送中"→"已完成"（记录完成时间）
            rows = orderMapper.updateStatus(
                    orderId,
                    targetStatus.getCode(),
                    null,
                    operateTime  // 完成时间
            );
        } else {
            // 其他状态（如取消）直接更新状态
            rows = orderMapper.updateStatus(
                    orderId,
                    targetStatus.getCode(),
                    null,
                    null
            );
        }

        return rows > 0 ?
                Result.success("状态更新成功") :
                Result.error(500, "更新失败，订单状态异常");
    }

    // 4. 获取外卖员的配送中订单
    @Override
    public List<DeliveryOrder> getDeliveringByCourierId(Long deliverymanId) {
        // 调用Mapper查询状态为"配送中（IN_TRANSIT）"且属于当前外卖员的订单
        return orderMapper.selectByCourierIdAndStatus(
                Math.toIntExact(deliverymanId),
                OrderStatus.IN_TRANSIT.getCode()
        );
    }

    // 5. 根据ID查询订单详情
    @Override
    public DeliveryOrder getById(String orderId) {
        return orderMapper.selectById(Integer.valueOf(orderId));
    }

    // 6. 分页查询订单
    @Override
    public List<DeliveryOrder> selectPage(Integer status, String keyword, int start, int size) {
        // 调用分页查询方法，参数与Mapper接口匹配
        return orderMapper.selectPage(status, keyword, start, size);
    }
}