package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

@Mapper
public interface DeliveryOrderMapper {
    int insert(DeliveryOrder record);
    int deleteByPrimaryKey(String orderId);
    int updateByPrimaryKey(DeliveryOrder record);
    DeliveryOrder selectByPrimaryKey(String orderId);

    /**
     * 按创建时间倒序查询所有订单
     */
    List<DeliveryOrder> selectAll();

    /**
     * 分页查询配送员的订单列表
     */
    List<DeliveryOrder> selectPageByDeliveryman(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("size") int size,
            @Param("id") long userId
    );

    /**
     * 分页查询订单列表（管理员端）
     */
    List<DeliveryOrder> selectPageAdmin(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("size") int size,
            @Param("deliverymanId") Long usersId
    );

    // 接单：更新订单
    int acceptOrder(
            @Param("orderId") Integer orderId,
            @Param("courierId") Integer courierId,
            @Param("status") Integer status
    );

    // 更新订单状态
    int updateStatus(
            @Param("orderId") Integer orderId,
            @Param("status") Integer status,
            @Param("time") Date time
    );

    // 根据ID查订单
    DeliveryOrder selectById(@Param("orderId") Integer orderId);

    // 查询总条数
    Long count(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("deliverymanId") Long userId
    );

    Long countByDeliveryman(@Param("deliverymanId") Long deliverymanId, @Param("status") Integer status, @Param("keyword") String keyword);
}