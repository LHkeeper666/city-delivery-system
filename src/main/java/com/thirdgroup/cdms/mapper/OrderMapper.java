package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Mapper
public interface OrderMapper {
    // 1. 查待接单订单（不变，内部SQL用String匹配）
    List<DeliveryOrder> selectPendingOrders(@Param("status") int status);

    // 2. 根据骑手ID和状态查订单（不变）
    List<DeliveryOrder> selectByStatusAndDeliveryman(
            @Param("deliverymanId") Long deliverymanId,
            @Param("status") int status
    );

    // 3. 接单：orderId从Long改为String
    int acceptOrder(
            @Param("orderId") String orderId, // Long → String
            @Param("deliverymanId") Long deliverymanId,
            @Param("targetStatus") int targetStatus
    );

    // 4. 更新订单状态：orderId从Long改为String
    int updateStatus(
            @Param("orderId") String orderId, // Long → String
            @Param("targetStatus") int targetStatus,
            @Param("updateTime") Date updateTime
    );

    // 5. 根据ID查订单：orderId从Long改为String
    DeliveryOrder selectById(@Param("orderId") String orderId); // Long → String

    // 6. 分页查询订单（不变）
    List<DeliveryOrder> selectPage(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("size") int size
    );

    // 7. 兼容历史方法（不变）
    List<DeliveryOrder> selectDeliveringByCourierId(
            @Param("deliverymanId") Long deliverymanId,
            @Param("status") int status
    );

    // 8. 新增：更新订单的配送员收益和完成时间（核心补充）
    int updateDeliverymanIncomeAndCompleteTime(
            @Param("orderId") String orderId,          // 订单ID（String类型）
            @Param("deliverymanIncome") BigDecimal deliverymanIncome, // 配送员收益
            @Param("completeTime") Date completeTime   // 订单完成时间
    );
}