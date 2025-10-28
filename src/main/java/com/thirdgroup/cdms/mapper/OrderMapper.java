package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * 订单Mapper：操作delivery_order表
 */
@Mapper
public interface OrderMapper {
    // 1. 查待接单订单（按距离排序，给工作台用）
    List<DeliveryOrder> selectPendingOrders(int code);

    // 2. 按外卖员ID查配送中订单（给工作台用）
    List<DeliveryOrder> selectDeliveringByCourierId(@Param("courierId") Integer courierId);

    // 3. 接单：更新订单的courier_id、status、accept_time
    int acceptOrder(@Param("orderId") Integer orderId, @Param("courierId") Integer courierId, @Param("status") Integer status);

    // 4. 更新订单状态（确认取餐/送达/取消）
    int updateStatus(@Param("orderId") Integer orderId, @Param("status") Integer status, @Param("time") Date time);

    // 5. 根据ID查订单（地图页显示订单详情用）
    DeliveryOrder selectById(@Param("orderId") Integer orderId);
}