package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.DeliveryOrderMapper;
import com.thirdgroup.cdms.mapper.OrderMapper;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.Deliveryman;
import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import com.thirdgroup.cdms.service.Interface.DeliveryManService;
import com.thirdgroup.cdms.service.Interface.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private DeliveryOrderMapper deliveryOrderMapper;
    @Autowired
    private DeliveryManService deliveryManService;

    @Override
    public List<DeliveryOrder> getPendingOrders() {
        return orderMapper.selectPendingOrders(OrderStatus.PENDING.getCode());
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean acceptOrder(String orderId, Long userId) {
        DeliveryOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在，可能已被删除");
        }
        if (order.getStatus() != OrderStatus.PENDING.getCode()) {
            throw new RuntimeException("订单状态异常，当前状态：" + OrderStatus.fromCode(order.getStatus()).getDesc());
        }
        if (order.getDeliverymanId() != null) {
            throw new RuntimeException("订单已被其他骑手抢走，请刷新列表");
        }

        Deliveryman deliveryman = deliveryManService.getById(userId);
        if (deliveryman == null) {
            throw new RuntimeException("骑手信息不存在");
        }
        if (deliveryman.getWorkStatus() != DeliverymanStatus.ONLINE.getCode()) {
            throw new RuntimeException("只有在线状态才能接单，请先切换状态");
        }

        int orderRows = orderMapper.acceptOrder(
                orderId,
                userId,
                OrderStatus.ACCEPTED.getCode()
        );
        if (orderRows <= 0) {
            throw new RuntimeException("订单更新失败，可能同时被其他骑手接单");
        }

        return deliveryManService.updateStatus(userId, DeliverymanStatus.ONLINE);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean updateOrderStatus(String orderId, OrderStatus targetStatus, Long userId) {
        DeliveryOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (!userId.equals(order.getDeliverymanId())) {
            throw new RuntimeException("无权操作他人订单");
        }

        if (!isStatusTransitionValid(order.getStatus(), targetStatus.getCode())) {
            throw new RuntimeException("状态流转不合法，当前状态：" + OrderStatus.fromCode(order.getStatus()).getDesc());
        }

        if (targetStatus == OrderStatus.COMPLETED) {
            BigDecimal platformCommission = new BigDecimal("2.00");
            BigDecimal deliverymanIncome = order.getDeliveryFee().subtract(platformCommission);

            int updateRows = orderMapper.updateDeliverymanIncomeAndCompleteTime(
                    orderId,
                    deliverymanIncome,
                    new Date()
            );
            if (updateRows <= 0) {
                throw new RuntimeException("收益更新失败");
            }

            if (!deliveryManService.addBalance(userId, deliverymanIncome)) {
                throw new RuntimeException("骑手总收益更新失败");
            }

            order.setDeliverymanIncome(deliverymanIncome);
        }

        int rows = orderMapper.updateStatus(
                orderId,
                targetStatus.getCode(),
                new Date()
        );
        if (rows <= 0) {
            throw new RuntimeException("状态更新失败");
        }
        return true;
    }

    @Override
    public List<DeliveryOrder> getMyOrders(Long userId) {
        if (deliveryManService.getById(userId) == null) {
            return Collections.emptyList();
        }

        List<DeliveryOrder> acceptedOrders = orderMapper.selectByStatusAndDeliveryman(
                userId, OrderStatus.ACCEPTED.getCode()
        );
        List<DeliveryOrder> deliveringOrders = orderMapper.selectByStatusAndDeliveryman(
                userId, OrderStatus.DELIVERING.getCode()
        );

        acceptedOrders.addAll(deliveringOrders);
        return acceptedOrders;
    }

    @Override
    public DeliveryOrder getOrderById(String orderId) {
        return orderMapper.selectById(orderId);
    }

    @Override
    public List<DeliveryOrder> selectPage(Integer status, String keyword, int start, int size) {
        keyword = keyword == null ? "" : "%" + keyword + "%";
        return orderMapper.selectPage(status, keyword, start, size);
    }

    @Override
    public List<DeliveryOrder> getHistoryOrders(Long userId, Integer... statusCodes) {
        if (userId == null || statusCodes == null || statusCodes.length == 0) {
            return Collections.emptyList();
        }
        return deliveryOrderMapper.selectHistoryOrders(
                userId,
                Arrays.asList(statusCodes)
        );
    }

    private boolean isStatusTransitionValid(int currentStatus, int targetStatus) {
        if (targetStatus == OrderStatus.CANCELLED.getCode()) {
            return true;
        }
        return (currentStatus == OrderStatus.PENDING.getCode() && targetStatus == OrderStatus.ACCEPTED.getCode())
                || (currentStatus == OrderStatus.ACCEPTED.getCode() && targetStatus == OrderStatus.DELIVERING.getCode())
                || (currentStatus == OrderStatus.DELIVERING.getCode() && targetStatus == OrderStatus.COMPLETED.getCode());
    }
}