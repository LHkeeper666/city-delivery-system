
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.ApiKey;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ApiKeyMapper {
    int insert(ApiKey record);
    int deleteByPrimaryKey(Long keyId);
    int updateByPrimaryKey(ApiKey record);
    ApiKey selectByPrimaryKey(Long keyId);
    List<ApiKey> selectAll();

    /**
     * 根据 apiKey 的值查询相应的 ApiKey 对象
     */
    ApiKey selectByApiKey(String apiKey);

    /**
     * 根据keyword模糊匹配app_name，分页查询apikey list
     */
    List<ApiKey> selectByPageAndAppName(
            @Param("keyword") String keyword,
            @Param("status") String status,
            @Param("start") Integer start,
            @Param("size") Integer size
    );

    /**
     * 统计app_name包含keyword的记录数
     */
    Long countByAppName(
            @Param("keyword") String keyword,
            @Param("status") String status
    );

    /**
     * 反转状态
     */
    void turnStatus(Long keyId);
}