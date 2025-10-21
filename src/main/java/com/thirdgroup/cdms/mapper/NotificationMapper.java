
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.entity.Notification;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface NotificationMapper {
    int insert(Notification record);
    int deleteByPrimaryKey(String id);
    int updateByPrimaryKey(Notification record);
    Notification selectByPrimaryKey(String id);
    List<Notification> selectAll();
}