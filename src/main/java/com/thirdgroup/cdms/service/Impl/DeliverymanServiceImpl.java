package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.DeliverymanMapper;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.Deliveryman;
import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import com.thirdgroup.cdms.service.Interface.DeliveryManService;
import com.thirdgroup.cdms.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

/**
 * 外卖员Service实现：封装业务逻辑
 */
@Service // 标记为Spring服务类，让Spring管理
public class DeliverymanServiceImpl implements DeliveryManService {

    // 注入DeliverymanMapper（MyBatis自动生成代理对象）
    @Autowired
    private DeliverymanMapper deliverymanMapper;

    // 登录：验证手机号和密码（测试时暂用明文，后续改加密）
    @Override
    public Deliveryman login(String phone, String password) {
        // 1. 根据手机号查外卖员
        Deliveryman deliveryman = deliverymanMapper.selectByPhone(phone);
        if (deliveryman == null) {
            return null; // 手机号不存在
        }
        // 2. 验证密码（后续优化：用BCrypt加密对比，现在暂用明文）
        if (!password.equals(deliveryman.getPassword())) {
            return null; // 密码错误
        }
        // 3. 登录成功：把外卖员状态设为在线
        updateStatus(deliveryman.getId(), DeliverymanStatus.ONLINE);
        return deliveryman;
    }

    // 根据ID查外卖员
    @Override
    public Deliveryman getById(Integer id) {
        return deliverymanMapper.selectById(id);
    }

    // 更新外卖员状态
    @Override
    public boolean updateStatus(Integer deliverymanId, DeliverymanStatus status) {
        int rows = deliverymanMapper.updateStatus(deliverymanId, status.getCode());
        return rows > 0; // 影响行数>0表示成功
    }

    // 更新外卖员信息
    @Override
    public boolean updateProfile(Deliveryman deliveryman) {
        int rows = deliverymanMapper.updateProfile(deliveryman);
        return rows > 0;
    }

    // 完成订单后加收益
    @Override
    public boolean addBalance(Integer deliverymanId, BigDecimal profit) {
        int rows = deliverymanMapper.updateBalance(deliverymanId, profit);
        return rows > 0;
    }


    /**
     * 这几个接口实现后面实现
     * @return
     */
    @Override
    public List<DeliveryOrder> getPendingOrders() {
        return Collections.emptyList();
    }

    @Override
    public Result takeOrder(Long deliveryManId, String orderId) {
        return null;
    }

    @Override
    public Result completeOrder(Long deliveryManId, String orderId) {
        return null;
    }

    @Override
    public List<DeliveryOrder> getMyOrders(Long deliveryManId, Integer status) {
        return Collections.emptyList();
    }

    @Override
    public boolean updatePhone(Long deliveryManId, String newPhone) {
        return false;
    }
}