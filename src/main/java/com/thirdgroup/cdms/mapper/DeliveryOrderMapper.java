
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DeliveryOrderMapper {
    int insert(DeliveryOrder record);
    int deleteByPrimaryKey(String orderId);
    int updateByPrimaryKey(DeliveryOrder record);
    DeliveryOrder selectByPrimaryKey(String orderId);
    List<DeliveryOrder> selectAll();
    // 查询当前页数据
    List<DeliveryOrder> selectPage(
            @Param("status") Integer status,
            @Param("keyword") String keyword,  // 搜索关键词（如订单号、收件人）
            @Param("start") int start,
            @Param("size") int size
    );
    // 查询总条数
    Long count(
            @Param("status") Integer status,
            @Param("keyword") String keyword
    );
}