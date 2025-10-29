package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DeliveryOrderMapper {
    // 1. 插入订单（基础方法）
    int insert(DeliveryOrder record);

    // 2. 根据骑手ID和多状态查历史订单（核心方法）
    List<DeliveryOrder> selectHistoryOrders(
            @Param("userId") Long userId, // 骑手ID（与Service参数一致）
            @Param("statusCodes") List<Integer> statusCodes // 多状态列表
    );

    // 3. 分页查询骑手订单（个人中心用）
    List<DeliveryOrder> selectPageByDeliveryman(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("size") int size,
            @Param("id") Long userId
    );

    // 4. 分页查询管理员订单
    List<DeliveryOrder> selectPageAdmin(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("size") int size,
            @Param("deliverymanId") Long deliverymanId
    );

    // 5. 查询订单总数
    Long count(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("deliverymanId") Long deliverymanId
    );

    Long countByDeliveryman(
            @Param("deliverymanId") Long deliverymanId,
            @Param("status") Integer status,
            @Param("keyword") String keyword
    );
}