package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.DeliverymanMapper;
import com.thirdgroup.cdms.mapper.OrderMapper;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.Deliveryman;
import com.thirdgroup.cdms.model.OrderStatisticsDTO;
import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import com.thirdgroup.cdms.service.Interface.DeliveryManService;
import com.thirdgroup.cdms.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Date;
import java.util.List;

@Service
public class DeliverymanServiceImpl implements DeliveryManService {

    @Autowired
    private DeliverymanMapper deliverymanMapper;

    @Autowired
    private OrderMapper orderMapper;

    // 登录
    @Override
    public Deliveryman login(String phone, String password) {
        Deliveryman deliveryman = deliverymanMapper.selectByPhone(phone);
        if (deliveryman == null) return null;
        if (!BCrypt.checkpw(password, deliveryman.getPassword())) return null;
        updateStatus(deliveryman.getUserId(), DeliverymanStatus.ONLINE);
        return deliveryman;
    }

    @Override
    public Deliveryman getById(Long userId) {
        return deliverymanMapper.selectById(userId);
    }

    @Override
    public boolean existsByPhone(String phone) {
        return deliverymanMapper.selectByPhone(phone) != null;
    }

    @Override
    public boolean resetPassword(String phone, String newPassword) {
        if (!existsByPhone(phone)) return false;
        String encodedPwd = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return deliverymanMapper.updatePasswordByPhone(phone, encodedPwd) > 0;
    }

    @Override
    public boolean register(String username, String phone, String password) {
        String encodedPwd = BCrypt.hashpw(password, BCrypt.gensalt());
        Deliveryman deliveryman = new Deliveryman();
        deliveryman.setUsername(username);
        deliveryman.setPhoneNo(phone);
        deliveryman.setPassword(encodedPwd);
        deliveryman.setRole(1);
        deliveryman.setStatus(0);
        deliveryman.setWorkStatus(DeliverymanStatus.OFFLINE.getCode());
        deliveryman.setCreateTime(new Date());
        deliveryman.setUpdateTime(new Date());
        return deliverymanMapper.insert(deliveryman) > 0;
    }

    @Override
    public boolean updateStatus(Long userId, DeliverymanStatus status) {
        return deliverymanMapper.updateStatus(userId, status.getCode()) > 0;
    }

    @Override
    public boolean updateProfile(Deliveryman deliveryman) {
        deliveryman.setUpdateTime(new Date());
        return deliverymanMapper.updateProfile(deliveryman) > 0;
    }

    @Override
    public boolean addBalance(Long userId, BigDecimal profit) {
        return deliverymanMapper.updateBalance(userId, profit) > 0;
    }

    @Override
    public List<DeliveryOrder> getPendingOrders() {
        return Collections.emptyList();
    }

    @Override
    public Result takeOrder(Long userId, String orderId) {
        return Result.error(500, "暂未实现");
    }

    @Override
    public Result completeOrder(Long userId, String orderId) {
        return Result.error(500, "暂未实现");
    }

    @Override
    public List<DeliveryOrder> getMyOrders(Long userId, Integer status) {
        return Collections.emptyList();
    }

    @Override
    public boolean updatePhone(Long userId, String newPhone) {
        if (userId == null || newPhone == null || newPhone.trim().isEmpty()) return false;
        if (!newPhone.matches("^1[3-9]\\d{9}$")) return false;
        Deliveryman existing = deliverymanMapper.selectByPhone(newPhone);
        if (existing != null && !existing.getUserId().equals(userId)) return false;
        int rows = deliverymanMapper.updatePhone(userId, newPhone, new Date());
        return rows > 0;
    }

    @Override
    public boolean checkUsernameExists(String username) {
        return deliverymanMapper.countByUsername(username) > 0;
    }

    @Override
    public boolean setWorkStatus(Long userId, DeliverymanStatus status) {
        return updateStatus(userId, status);
    }

    // ✅ 实现统计逻辑
    @Override
    public OrderStatisticsDTO getCurrentStats(Long deliverymanId) {
        OrderStatisticsDTO stats = new OrderStatisticsDTO();
        stats.setCompletedOrders(orderMapper.countCompletedByDeliverymanId(deliverymanId)); // 完成订单统计

        // 没有专门的待处理统计方法，用 selectByStatusAndDeliveryman 替代
        stats.setPendingOrders(orderMapper.selectByStatusAndDeliveryman(deliverymanId, 0).size());
        return stats;
    }
}