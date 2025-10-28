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

    @Override
    public Deliveryman login(String phone, String password) {
        Deliveryman deliveryman = deliverymanMapper.selectByPhone(phone);
        if (deliveryman == null) {
            return null;
        }
        // 注意：这里要改加密对比！之前存的是BCrypt加密后的密码，不能用equals直接比
        if (!BCrypt.checkpw(password, deliveryman.getPassword())) {
            return null;
        }
        // 调用updateStatus，参数用Long类型的userId（从实体类获取）
        updateStatus(deliveryman.getUserId(), DeliverymanStatus.ONLINE);
        return deliveryman;
    }

    // 只保留1个getById：参数类型Long，匹配Service接口和Mapper
    @Override
    public Deliveryman getById(Long userId) {
        return deliverymanMapper.selectById(userId);
    }

    // 只保留1个updateStatus：参数类型Long，匹配Mapper
    @Override
    public boolean updateStatus(Long userId, DeliverymanStatus status) {
        int rows = deliverymanMapper.updateStatus(userId, status.getCode());
        return rows > 0;
    }

    @Override
    public boolean updateProfile(Deliveryman deliveryman) {
        int rows = deliverymanMapper.updateProfile(deliveryman);
        return rows > 0;
    }

    // 只保留1个addBalance：参数类型Long，匹配Service接口和Mapper
    @Override
    public boolean addBalance(Long userId, BigDecimal profit) {
        int rows = deliverymanMapper.updateBalance(userId, profit);
        return rows > 0;
    }

    @Override
    public List<DeliveryOrder> getPendingOrders() {
        return Collections.emptyList(); // 后续实现
    }

    @Override
    public Result takeOrder(Long userId, String orderId) {
        return null; // 后续实现（参数名改为userId，与统一命名一致）
    }

    @Override
    public Result completeOrder(Long userId, String orderId) {
        return null; // 后续实现（参数名改为userId）
    }

    @Override
    public List<DeliveryOrder> getMyOrders(Long userId, Integer status) {
        return Collections.emptyList(); // 后续实现（参数名改为userId）
    }

    @Override
    public boolean updatePhone(Long userId, String newPhone) {
        // 后续实现：需在Mapper中添加updatePhone方法，参数用userId
        return false;
    }

    @Override
    public boolean existsByPhone(String phone) {
        Deliveryman deliveryman = deliverymanMapper.selectByPhone(phone);
        return deliveryman != null;
    }

    @Override
    public boolean resetPassword(String phone, String newPassword) {
        if (!existsByPhone(phone)) {
            return false;
        }
        // 重置密码也要加密，和注册逻辑保持一致
        String encryptedPwd = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        int rows = deliverymanMapper.updatePasswordByPhone(phone, encryptedPwd);
        return rows > 0;
    }

    @Override
    public boolean register(String username, String phone, String password) {
        // 1. 密码加密（BCrypt）
        String encryptedPwd = BCrypt.hashpw(password, BCrypt.gensalt());

        // 2. 构建Deliveryman实体（确保属性与表字段对应）
        Deliveryman deliveryman = new Deliveryman();
        deliveryman.setUsername(username);  // 用户名
        deliveryman.setPhoneNo(phone);     // 手机号（对应表中phone_no）
        deliveryman.setPassword(encryptedPwd); // 加密后密码
        deliveryman.setRole(1);            // 1=外卖员角色
        deliveryman.setStatus(0);          // 0=账号启用状态
        deliveryman.setWorkStatus(0);      // 0=初始离线状态
        deliveryman.setCreateTime(new Date());
        deliveryman.setUpdateTime(new Date());

        // 3. 插入数据库
        int insertRows = deliverymanMapper.insert(deliveryman);
        return insertRows > 0;
    }

    @Override
    public boolean checkUsernameExists(String username) {
        int count = deliverymanMapper.countByUsername(username);
        return count > 0; //  count>0表示用户名已存在
    }

    @Override
    public boolean setWorkStatus(Long userId, DeliverymanStatus status) {
        // 调用 Mapper 更新 work_status 字段（传入枚举的 code）
        int rows = deliverymanMapper.updateStatus(userId, status.getCode());
        return rows > 0;
    }
}