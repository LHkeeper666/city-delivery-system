package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 订单Mapper：操作cdms_delivery_order表
 */
@Mapper
public interface OrderMapper {
    // 查待接单订单（状态=0+未分配外卖员）
    List<DeliveryOrder> selectPendingOrders(@Param("status") int status);

    // 根据外卖员ID和状态查询订单
    List<DeliveryOrder> selectByStatusAndDeliveryman(
            @Param("deliverymanId") Long deliverymanId,
            @Param("status") int status
    );

    // 查外卖员的配送中订单（兼容历史方法）
    List<DeliveryOrder> selectDeliveringByCourierId(
            @Param("deliverymanId") Long deliverymanId,
            @Param("status") int status
    );

    // 接单：更新订单（不涉及不存在的字段）
    int acceptOrder(
            @Param("orderId") Long orderId,
            @Param("deliverymanId") Long deliverymanId,
            @Param("targetStatus") int targetStatus,
            @Param("oldStatus") int oldStatus
    );

    // 更新订单状态
    int updateStatus(
            @Param("orderId") Long orderId,
            @Param("targetStatus") int targetStatus,
            @Param("updateTime") java.util.Date updateTime
    );

    // 根据ID查订单
    DeliveryOrder selectById(@Param("orderId") Long orderId);

    // 分页查询订单
    List<DeliveryOrder> selectPage(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("size") int size
    );
}