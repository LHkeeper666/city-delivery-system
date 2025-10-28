package com.thirdgroup.cdms.service.impl;

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
import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * 订单Service实现：核心业务（接单、更新状态、订单查询）
 */
@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private DeliveryManService deliveryManService;

    // 1. 获取待接单订单（状态=待接单+未分配外卖员）
    @Override
    public List<DeliveryOrder> getPendingOrders() {
        return orderMapper.selectPendingOrders(OrderStatus.PENDING.getCode());
    }

    // 接单方法（核心修改）
    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean acceptOrder(Long orderId, Long userId) {
        DeliveryOrder order = orderMapper.selectById(orderId);
        if (order == null || order.getStatus() != OrderStatus.PENDING.getCode() || order.getDeliverymanId() != null) {
            return false;
        }

        Deliveryman deliveryman = deliveryManService.getById(userId);
        if (deliveryman == null
                || (deliveryman.getWorkStatus() != DeliverymanStatus.ONLINE.getCode()
                && deliveryman.getWorkStatus() != DeliverymanStatus.RESTING.getCode())) {
            return false;
        }

        // 关键修改：删除最后一个参数（new Date()），与接口参数保持一致
        int orderRows = orderMapper.acceptOrder(
                orderId,
                userId,
                OrderStatus.ACCEPTED.getCode(),
                OrderStatus.PENDING.getCode()
                // 已删除：new Date() 这一行
        );
        if (orderRows <= 0) {
            throw new RuntimeException("订单更新失败");
        }

        boolean statusSuccess = deliveryManService.updateStatus(userId, DeliverymanStatus.ONLINE);
        if (!statusSuccess) {
            throw new RuntimeException("外卖员状态更新失败");
        }

        return true;
    }

    // 3. 更新订单状态（支持取货→配送中→完成的完整流程）
    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean updateOrderStatus(Long orderId, OrderStatus targetStatus) {
        DeliveryOrder order = orderMapper.selectById(orderId);
        if (order == null || !isStatusTransitionValid(order.getStatus(), targetStatus.getCode())) {
            return false;
        }
        // 完成订单时添加收益
        if (targetStatus == OrderStatus.COMPLETED) {
            if (order.getDeliverymanId() == null) {
                return false;
            }
            BigDecimal profit = order.getDeliverymanIncome() != null ? order.getDeliverymanIncome() : new BigDecimal("10.00");
            boolean profitSuccess = deliveryManService.addBalance(order.getDeliverymanId(), profit);
            if (!profitSuccess) {
                throw new RuntimeException("收益添加失败");
            }
        }
        // 更新订单状态和时间
        int rows = orderMapper.updateStatus(orderId, targetStatus.getCode(), new Date());
        return rows > 0;
    }

    // 4. 获取外卖员的所有在途订单（无需修改代码，排序依赖XML的update_time）
    @Override
    public List<DeliveryOrder> getMyOrders(Long userId) {
        if (deliveryManService.getById(userId) == null) {
            return Collections.emptyList();
        }
        // 调用Mapper时，排序逻辑已在XML中改为按update_time（接单时会更新）
        List<DeliveryOrder> acceptedOrders = orderMapper.selectByStatusAndDeliveryman(
                userId, OrderStatus.ACCEPTED.getCode());
        List<DeliveryOrder> deliveringOrders = orderMapper.selectByStatusAndDeliveryman(
                userId, OrderStatus.DELIVERING.getCode());
        acceptedOrders.addAll(deliveringOrders);
        return acceptedOrders;
    }

    // 5. 根据ID查订单
    @Override
    public DeliveryOrder getOrderById(Long orderId) {
        return orderMapper.selectById(orderId);
    }

    // 6. 分页查询订单
    @Override
    public List<DeliveryOrder> selectPage(Integer status, String keyword, int start, int size) {
        keyword = keyword == null ? "" : "%" + keyword + "%";
        return orderMapper.selectPage(status, keyword, start, size);
    }

    // 辅助：完善状态流转校验（支持待接单→待取货→配送中→完成）
    private boolean isStatusTransitionValid(int currentStatus, int targetStatus) {
        // 任何状态都可以取消
        if (targetStatus == OrderStatus.CANCELLED.getCode()) {
            return true;
        }
        // 合法流转路径：待接单→待取货→配送中→完成
        return (currentStatus == OrderStatus.PENDING.getCode() && targetStatus == OrderStatus.ACCEPTED.getCode())
                || (currentStatus == OrderStatus.ACCEPTED.getCode() && targetStatus == OrderStatus.DELIVERING.getCode())
                || (currentStatus == OrderStatus.DELIVERING.getCode() && targetStatus == OrderStatus.COMPLETED.getCode());
    }

    // 扩展：更新配送位置（供地图功能调用，暂时注释，后续启用）
    // public boolean updateDeliveryLocation(Long orderId, Long userId, Double longitude, Double latitude) {
    //     // 校验订单属于当前外卖员
    //     DeliveryOrder order = orderMapper.selectById(orderId);
    //     if (order == null || !order.getDeliverymanId().equals(userId)) {
    //         return false;
    //     }
    //     // 更新订单中的经纬度信息（需在Mapper中实现，暂时注释）
    //     // return orderMapper.updateLocation(orderId, longitude, latitude, new Date()) > 0;
    //     return true;
    // }
}