
package com.thirdgroup.cdms.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface DeliveryOrder {
    int insert(com.thirdgroup.cdms.model.DeliveryOrder record);
    int deleteByPrimaryKey(String orderId);
    int updateByPrimaryKey(com.thirdgroup.cdms.model.DeliveryOrder record);
    com.thirdgroup.cdms.model.DeliveryOrder selectByPrimaryKey(String orderId);
    List<com.thirdgroup.cdms.model.DeliveryOrder> selectAll();
}