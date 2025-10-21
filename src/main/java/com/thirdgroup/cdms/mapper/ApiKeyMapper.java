
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.ApiKey;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface ApiKeyMapper {
    int insert(ApiKey record);
    int deleteByPrimaryKey(Long keyId);
    int updateByPrimaryKey(ApiKey record);
    ApiKey selectByPrimaryKey(Long keyId);
    List<ApiKey> selectAll();
}