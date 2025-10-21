
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.entity.OperationLog;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface OperationLogMapper {
    int insert(OperationLog record);
    int deleteByPrimaryKey(Long logId);
    int updateByPrimaryKey(OperationLog record);
    OperationLog selectByPrimaryKey(Long logId);
    List<OperationLog> selectAll();
}