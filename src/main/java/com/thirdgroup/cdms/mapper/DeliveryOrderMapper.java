package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.OrderStatisticsDTO;
import com.thirdgroup.cdms.model.OrderTrendDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;
import java.util.Map;

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
            @Param("deliverymanId") Long deliverymanId,
            @Param("startTime") Date startTime,
            @Param("endTime") Date endTime
    );

    // 5. 查询订单总数
    Long count(
            @Param("status") Integer status,
            @Param("keyword") String keyword,
            @Param("deliverymanId") Long deliverymanId,
            @Param("startTime") Date startTime,
            @Param("endTime") Date endTime
    );

    /**
     * 查询骑手在途订单数
     */
    Long countByDeliveryman(
            @Param("deliverymanId") Long deliverymanId,
            @Param("status") Integer status,
            @Param("start") Integer start,
            @Param("end") Integer end
    );

    /**
     * 分页查询未完成订单，支持关键词和状态模糊搜索
     */
    List<DeliveryOrder> selectActiveOrdersByPage(
            @Param("keyword") String keyword,
            @Param("status") Integer status,
            @Param("start") int start,
            @Param("size") int size
    );

    /**
     * 统计未完成订单数目，支持关键词和状态模糊搜索
     */
    Long countActiveOrders(@Param("keyword") String keyword, @Param("status") Integer status);

    /**
     * 统计时间范围内的订单数据
     */
    OrderStatisticsDTO countOrderStatistics(
            @Param("startTime") Date startTime,
            @Param("endTime") Date endTime
    );

    /**
     * 统计时间范围内每天的完成订单数、平台收入和平均订单完成时间
     */
    List<OrderTrendDTO> getOrderTrendByDate(
            @Param("startTime") Date startTime,
            @Param("endTime") Date endTime
    );

    /**
     * 根据日期查询当天最大的订单号
     */
    String getMaxOrderIdByDate(@Param("dateStr") String dateStr);

    /**
     * 将配送员的所有订单的配送员ID设置为null
     * 用于删除配送员账号时处理外键约束
     */
    int updateDeliverymanIdToNull(@Param("deliverymanId") Long deliverymanId);
    
    /**
     * 根据多条件组合查询配送单（用于配送跟踪功能）
     * @param orderId 配送单编号
     * @param senderPhone 接货人电话
     * @param consigneePhone 收货人电话
     * @param deliverymanId 配送员ID
     * @param deliverymanName 配送员姓名
     * @param status 配送状态
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @param start 分页起始位置
     * @param size 每页大小
     * @return 配送单列表
     */
    List<DeliveryOrder> selectByTrackingConditions(
            @Param("orderId") String orderId,
            @Param("senderPhone") String senderPhone,
            @Param("consigneePhone") String consigneePhone,
            @Param("deliverymanId") Long deliverymanId,
            @Param("deliverymanName") String deliverymanName,
            @Param("status") Integer status,
            @Param("startTime") Date startTime,
            @Param("endTime") Date endTime,
            @Param("start") int start,
            @Param("size") int size
    );
    
    /**
     * 统计符合跟踪条件的配送单数量
     * @param orderId 配送单编号
     * @param senderPhone 接货人电话
     * @param consigneePhone 收货人电话
     * @param deliverymanId 配送员ID
     * @param deliverymanName 配送员姓名
     * @param status 配送状态
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 配送单数量
     */
    Long countByTrackingConditions(
            @Param("orderId") String orderId,
            @Param("senderPhone") String senderPhone,
            @Param("consigneePhone") String consigneePhone,
            @Param("deliverymanId") Long deliverymanId,
            @Param("deliverymanName") String deliverymanName,
            @Param("status") Integer status,
            @Param("startTime") Date startTime,
            @Param("endTime") Date endTime
    );

    List<Map<String, Object>> countOrdersByAddress(
            @Param("startTime") Date startTime,
            @Param("endTime") Date endTime
    );

    /**
     * 查询状态为5（放弃待审核）的订单列表
     */
    List<DeliveryOrder> getAbandonOrdersByPage(
            @Param("start") Integer start,
            @Param("size") Integer size
    );

    /**
     * 统计状态为5（放弃待审核）的订单数量
     */
    long countAbandonOrder();

    /**
     * 根据订单id获取订单信息
     */
    DeliveryOrder getByPrimaryKey(String requestId);

    /**
     * 更新orderId对应订单的状态为status
     */
    int updateStatusByPrimaryKey(
            @Param("orderId") String orderId,
            @Param("status") int status
    );
}