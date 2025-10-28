package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.utils.Result;
import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import com.thirdgroup.cdms.model.Deliveryman;
import java.math.BigDecimal;
import java.util.List;

public interface DeliveryManService {
    // 1. 登录（无修改，已匹配）
    Deliveryman login(String phone, String password);

    // 2. 根据ID查外卖员（参数名：id→userId，类型：Integer→Long）
    Deliveryman getById(Long userId);

    // 3. 检查手机号是否存在（无修改，已匹配）
    boolean existsByPhone(String phone);

    // 4. 重置密码（无修改，已匹配）
    boolean resetPassword(String phone, String newPassword);

    // 5. 外卖员注册（无修改，已匹配）
    boolean register(String username, String phone, String password);

    // 6. 更新外卖员状态（参数名：courierId→userId，类型：Integer→Long）
    boolean updateStatus(Long userId, DeliverymanStatus status);

    // 7. 更新外卖员信息（无修改，依赖实体类userId）
    boolean updateProfile(Deliveryman deliveryman);

    // 8. 完成订单后加收益（参数名：courierId→userId，类型：Integer→Long）
    boolean addBalance(Long userId, BigDecimal profit);

    // 9. 获取待接单列表（无修改）
    List<DeliveryOrder> getPendingOrders();

    // 10. 接单（参数名：deliveryManId→userId，更清晰）
    Result takeOrder(Long userId, String orderId);

    // 11. 完成订单（参数名：deliveryManId→userId，更清晰）
    Result completeOrder(Long userId, String orderId);

    // 12. 查询我的配送（参数名：deliveryManId→userId，更清晰）
    List<DeliveryOrder> getMyOrders(Long userId, Integer status);

    // 13. 修改配送员联系方式（参数名：deliveryManId→userId，类型：Integer→Long）
    boolean updatePhone(Long userId, String newPhone);

    // 14. 检查用户名是否存在（无修改，已匹配）
    boolean checkUsernameExists(String username);
    // 15. 设置外卖员状态（支持在线/离线/休息中）
    boolean setWorkStatus(Long userId, DeliverymanStatus status);
}