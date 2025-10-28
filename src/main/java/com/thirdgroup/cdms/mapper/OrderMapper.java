package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Param;
import java.util.Date;
import java.util.List;

public interface OrderMapper {
    // 1. 接单（orderId改为String类型，与实体类一致）
    int acceptOrder(
            @Param("orderId") String orderId,  // 原Integer改为String
            @Param("courierId") Long courierId,  // 与deliverymanId类型一致（Long）
            @Param("targetStatus") int targetStatus,
            @Param("pendingStatus") int pendingStatus
    );

    // 2. 更新状态（兼容取餐和完成时间）
    int updateStatus(
            @Param("orderId") String orderId,  // String类型
            @Param("status") int status,
            @Param("acceptTime") Date acceptTime,  // 取餐时间（startDelivery时用）
            @Param("completeTime") Date completeTime  // 完成时间（complete时用）
    );

    // 3. 分页查询（根据你的需求定义）
    List<DeliveryOrder> selectPage(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("size") int size
    );
    // 4. 查待接单订单（按距离排序，给工作台用）
    // 补充参数说明：status=0（PENDING）
    List<DeliveryOrder> selectPendingOrders(@Param("status") int status);

    // 5. 按外卖员ID查配送中订单（给工作台用）
    // 补充参数：status=2（IN_TRANSIT），同时兼容已接单待取货（status=1）的查询
    List<DeliveryOrder> selectByCourierIdAndStatus(
            @Param("courierId") Integer courierId,
            @Param("status") int status
    );


    // 6. 更新订单状态（确认取餐/送达/取消）
    // 细化时间字段：取餐时间/完成时间
    int updateStatus(
            @Param("orderId") Integer orderId,
            @Param("status") Integer status,
            @Param("acceptTime") Date acceptTime,  // 取餐时间（status=2时用）
            @Param("completeTime") Date completeTime  // 完成时间（status=3时用）
    );

    // 7. 根据ID查订单（地图页显示订单详情用）
    DeliveryOrder selectById(@Param("orderId") Integer orderId);

    // 新增：查询外卖员的所有历史订单（已完成）
    List<DeliveryOrder> selectCompletedByCourierId(
            @Param("courierId") Integer courierId,
            @Param("status") int status  // status=3（COMPLETED）
    );
}