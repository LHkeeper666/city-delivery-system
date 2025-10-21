
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface DeliveryOrderMapper {
    int insert(DeliveryOrder record);
    int deleteByPrimaryKey(String orderId);
    int updateByPrimaryKey(DeliveryOrder record);
    DeliveryOrder selectByPrimaryKey(String orderId);
    List<DeliveryOrder> selectAll();
}