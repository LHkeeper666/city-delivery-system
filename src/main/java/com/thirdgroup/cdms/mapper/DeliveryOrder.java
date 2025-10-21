
package com.thirdgroup.cdms.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface DeliveryOrder {
    int insert(com.thirdgroup.cdms.entity.DeliveryOrder record);
    int deleteByPrimaryKey(String orderId);
    int updateByPrimaryKey(com.thirdgroup.cdms.entity.DeliveryOrder record);
    com.thirdgroup.cdms.entity.DeliveryOrder selectByPrimaryKey(String orderId);
    List<com.thirdgroup.cdms.entity.DeliveryOrder> selectAll();
}