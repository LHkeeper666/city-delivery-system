package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.utils.Result;
import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import com.thirdgroup.cdms.model.Deliveryman;
import java.math.BigDecimal;
import java.util.List;

public interface DeliveryManService {
    // 登录：根据手机号+密码验证，返回外卖员（null表示失败）
    Deliveryman login(String phone, String password);//这个接口定义完了，后面导入一下rest依赖，可以尝试一下用apipost测试一下接口
    // 根据ID查外卖员
    Deliveryman getById(Integer id);
    // 更新外卖员状态（在线/离线）
    boolean updateStatus(Integer courierId, DeliverymanStatus status);
    // 更新外卖员信息（个人中心）
    boolean updateProfile(Deliveryman courier);
    // 完成订单后加收益
    boolean addBalance(Integer courierId, BigDecimal profit);
    // 获取待接单列表（状态=0的订单）
    List<DeliveryOrder> getPendingOrders();
    // 接单（含业务校验：无在途订单、订单状态正常）
    Result takeOrder(Long deliveryManId, String orderId);
    // 完成订单（更新状态+记录轨迹）
    Result completeOrder(Long deliveryManId, String orderId);
    // 查询我的配送（按状态筛选：在途/已完成）
    List<DeliveryOrder> getMyOrders(Long deliveryManId, Integer status);
    // 修改配送员联系方式
    boolean updatePhone(Long deliveryManId, String newPhone);
}