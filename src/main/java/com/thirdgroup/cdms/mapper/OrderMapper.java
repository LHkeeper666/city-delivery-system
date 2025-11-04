package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Mapper
public interface OrderMapper {
    // 1. 查待接单订单
    List<DeliveryOrder> selectPendingOrders(@Param("status") int status);

    // 2. 根据骑手ID和状态查订单
    List<DeliveryOrder> selectByStatusAndDeliveryman(
            @Param("deliverymanId") Long deliverymanId,
            @Param("status") int status
    );

    // 3. 接单
    int acceptOrder(
            @Param("orderId") String orderId,
            @Param("deliverymanId") Long deliverymanId,
            @Param("targetStatus") int targetStatus
    );

    // 4. 更新订单状态
    int updateStatus(
            @Param("orderId") String orderId,
            @Param("targetStatus") int targetStatus,
            @Param("updateTime") Date updateTime
    );

    // 5. 根据ID查订单
    DeliveryOrder selectById(@Param("orderId") String orderId);

    // 6. 分页查询订单
    List<DeliveryOrder> selectPage(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("size") int size
    );

    // 7. 兼容历史方法：查询配送中订单
    List<DeliveryOrder> selectDeliveringByCourierId(
            @Param("deliverymanId") Long deliverymanId,
            @Param("status") int status
    );

    // 8. 更新配送员收益和完成时间
    int updateDeliverymanIncomeAndCompleteTime(
            @Param("orderId") String orderId,
            @Param("deliverymanIncome") BigDecimal deliverymanIncome,
            @Param("completeTime") Date completeTime
    );

    // 9. 统计骑手完成的订单数
    int countCompletedByDeliverymanId(@Param("deliverymanId") Long deliverymanId);
}