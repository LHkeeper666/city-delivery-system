package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.DeliverymanMapper;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.Deliveryman;
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

    // 1. 登录（密码加密校验+状态更新）
    @Override
    public Deliveryman login(String phone, String password) {
        Deliveryman deliveryman = deliverymanMapper.selectByPhone(phone);
        if (deliveryman == null) {
            return null;
        }
        // BCrypt密码校验（正确逻辑）
        if (!BCrypt.checkpw(password, deliveryman.getPassword())) {
            return null;
        }
        // 登录后自动设为在线
        updateStatus(deliveryman.getUserId(), DeliverymanStatus.ONLINE);
        return deliveryman;
    }

    // 2. 根据ID查骑手（Long类型统一）
    @Override
    public Deliveryman getById(Long userId) {
        return deliverymanMapper.selectById(userId);
    }

    // 3. 检查手机号是否存在
    @Override
    public boolean existsByPhone(String phone) {
        return deliverymanMapper.selectByPhone(phone) != null;
    }

    // 4. 重置密码（加密存储）
    @Override
    public boolean resetPassword(String phone, String newPassword) {
        if (!existsByPhone(phone)) {
            return false;
        }
        // BCrypt加密
        String encryptedPwd = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return deliverymanMapper.updatePasswordByPhone(phone, encryptedPwd) > 0;
    }

    // 5. 骑手注册（加密+字段完整）
    @Override
    public boolean register(String username, String phone, String password) {
        // 1. 密码加密
        String encryptedPwd = BCrypt.hashpw(password, BCrypt.gensalt());

        // 2. 构建实体（字段与表匹配）
        Deliveryman deliveryman = new Deliveryman();
        deliveryman.setUsername(username);
        deliveryman.setPhoneNo(phone);
        deliveryman.setPassword(encryptedPwd);
        deliveryman.setRole(1); // 1=骑手角色
        deliveryman.setStatus(0); // 0=启用
        deliveryman.setWorkStatus(DeliverymanStatus.OFFLINE.getCode()); // 初始离线
        deliveryman.setCreateTime(new Date());
        deliveryman.setUpdateTime(new Date());

        // 3. 插入数据库
        return deliverymanMapper.insert(deliveryman) > 0;
    }

    // 6. 更新骑手状态（work_status字段）
    @Override
    public boolean updateStatus(Long userId, DeliverymanStatus status) {
        return deliverymanMapper.updateStatus(userId, status.getCode()) > 0;
    }

    // 7. 更新骑手信息
    @Override
    public boolean updateProfile(Deliveryman deliveryman) {
        deliveryman.setUpdateTime(new Date());
        return deliverymanMapper.updateProfile(deliveryman) > 0;
    }

    // 8. 完成订单加收益
    @Override
    public boolean addBalance(Long userId, BigDecimal profit) {
        return deliverymanMapper.updateBalance(userId, profit) > 0;
    }

    // 9. 待实现方法（返回空列表避免空指针）
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

    // 10. 修改手机号（待实现）
    // 实现修改手机号方法
    @Override
    public boolean updatePhone(Long userId, String newPhone) {
        // 1. 参数校验
        if (userId == null || newPhone == null || newPhone.trim().isEmpty()) {
            return false;
        }

        // 2. 手机号格式简单校验（11位数字）
        if (!newPhone.matches("^1[3-9]\\d{9}$")) {
            return false;
        }

        // 3. 检查新手机号是否已被其他骑手使用
        Deliveryman existing = deliverymanMapper.selectByPhone(newPhone);
        if (existing != null && !existing.getUserId().equals(userId)) {
            return false; // 手机号已被占用
        }

        // 4. 调用Mapper更新（带时间戳）
        int rows = deliverymanMapper.updatePhone(
                userId,
                newPhone,
                new Date() // 更新时间
        );
        return rows > 0;
    }

    // 11. 检查用户名是否存在
    @Override
    public boolean checkUsernameExists(String username) {
        return deliverymanMapper.countByUsername(username) > 0;
    }

    // 12. 设置工作状态（与updateStatus逻辑统一，避免冗余）
    @Override
    public boolean setWorkStatus(Long userId, DeliverymanStatus status) {
        return updateStatus(userId, status);
    }
}