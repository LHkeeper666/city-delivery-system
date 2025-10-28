package com.thirdgroup.cdms.service.impl;

/**
 * 实现Orderservice接口
 */
import com.thirdgroup.cdms.mapper.OrderMapper;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import com.thirdgroup.cdms.service.Interface.DeliveryManService;
import com.thirdgroup.cdms.service.Interface.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 订单Service实现：核心业务（接单、更新状态）
 */
@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private DeliveryManService courierService; // 注入外卖员Service，完成订单时加收益

    // 1. 获取待接单订单（status=0）
    @Override
    public List<DeliveryOrder> getPendingOrders() {
        return orderMapper.selectPendingOrders(OrderStatus.PENDING.getCode());
    }

    // 2. 接单：加事务（防止订单更新成功但外卖员状态更新失败）
    @Transactional // 标记为事务方法，出错自动回滚
    @Override
    public boolean acceptOrder(Integer orderId, Integer courierId) {
        // 1. 查订单是否存在且是待接单状态
        DeliveryOrder order = orderMapper.selectById(orderId);
        if (order == null || order.getStatus() != OrderStatus.PENDING.getCode()) {
            return false; // 订单不存在或已被接单
        }

        // TODO: 未解决bug，临时注释
        return true;
//        // 2. 更新订单：分配外卖员+设为配送中
//        int orderRows = orderMapper.acceptOrder(
//                orderId,
//                courierId,
//                OrderStatus.DELIVERING.getCode(),
//                OrderStatus.PENDING.getCode() // 只更新待接单的订单
//        );
//        // 3. 更新外卖员状态为在线（双重保险）DeliverymanStatus status
//        boolean courierRows = courierService.updateStatus(courierId, OrderStatus.DELIVERING.getCode());
//        // 4. 两个操作都成功才算接单成功
//        return orderRows > 0 && courierRows;
    }

    // 3. 更新订单状态（确认取餐：还是配送中，不用改；确认送达：设为已完成+加收益）
    @Transactional
    @Override
    public boolean updateOrderStatus(Integer orderId, OrderStatus targetStatus) {
        // 1. 查订单
        DeliveryOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            return false;
        }
        // 2. 确认送达：加收益给外卖员
        // TODO
        // 临时注释
//        if (targetStatus == OrderStatus.COMPLETED) {
//            courierService.addBalance(order.getCourierId(), order.getProfit());
//        }
        // 3. 更新订单状态和时间
        int rows = orderMapper.updateStatus(
                orderId,
                targetStatus.getCode(),
                new Date() // 完成时间
        );
        return rows > 0;
    }

    // 4. 获取外卖员的配送中订单
    @Override
    public List<DeliveryOrder> getDeliveringByCourierId(Integer courierId) {
        return null;
        // TODO
        // 临时注释
//        return orderMapper.selectDeliveringByCourierId(
//                courierId,
//                OrderStatus.DELIVERING.getCode()
//        );
    }

    // 5. 根据ID查订单
    @Override
    public DeliveryOrder getById(Integer orderId) {
        return orderMapper.selectById(orderId);
    }
}
