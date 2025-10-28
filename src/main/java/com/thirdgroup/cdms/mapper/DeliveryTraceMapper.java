
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryTrace;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface DeliveryTraceMapper {
    int insert(DeliveryTrace record);
    int deleteByPrimaryKey(Long traceId);
    int updateByPrimaryKey(DeliveryTrace record);
    DeliveryTrace selectByPrimaryKey(Long traceId);
    List<DeliveryTrace> selectAll();

    List<DeliveryTrace> selectByOrderId(String orderId);
}