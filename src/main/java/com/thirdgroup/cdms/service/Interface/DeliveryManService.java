package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.OrderStatisticsDTO;
import com.thirdgroup.cdms.utils.Result;
import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import com.thirdgroup.cdms.model.Deliveryman;
import java.math.BigDecimal;
import java.util.List;

public interface DeliveryManService {

    // 1. 登录
    Deliveryman login(String phone, String password);

    // 2. 根据ID查外卖员
    Deliveryman getById(Long userId);

    // 3. 检查手机号是否存在
    boolean existsByPhone(String phone);

    // 4. 重置密码
    boolean resetPassword(String phone, String newPassword);

    // 5. 外卖员注册
    boolean register(String username, String phone, String password);

    // 6. 更新外卖员状态
    boolean updateStatus(Long userId, DeliverymanStatus status);

    // 7. 更新外卖员信息
    boolean updateProfile(Deliveryman deliveryman);

    // 8. 完成订单后加收益
    boolean addBalance(Long userId, BigDecimal profit);

    // 9. 获取待接单列表
    List<DeliveryOrder> getPendingOrders();

    // 10. 接单
    Result takeOrder(Long userId, String orderId);

    // 11. 完成订单
    Result completeOrder(Long userId, String orderId);

    // 12. 我的配送
    List<DeliveryOrder> getMyOrders(Long userId, Integer status);

    // 13. 修改手机号
    boolean updatePhone(Long userId, String newPhone);

    // 14. 检查用户名是否存在
    boolean checkUsernameExists(String username);

    // 15. 设置外卖员工作状态
    boolean setWorkStatus(Long userId, DeliverymanStatus status);

    // 16. 获取当前骑手统计数据（✅ 参数与实现保持一致）
    OrderStatisticsDTO getCurrentStats(Long deliverymanId);
}