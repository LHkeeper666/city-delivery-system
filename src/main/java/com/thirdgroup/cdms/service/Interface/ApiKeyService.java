package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.ApiKey;
import com.thirdgroup.cdms.model.PageResult;

public interface ApiKeyService {

    /**
     * 验证 apiKey 是否有效
     */
    boolean isValid(String apiKey);

    /**
     * 创建新的 apiKey 并插入到表中
     */
    String createNewApiKey(String appName);

    /**
     * 分页查询 apikey，支持appname模糊搜索
     */
    PageResult<ApiKey> queryByPage(String keyword, String status, Integer page, Integer size);

    /**
     * 反转状态
     */
    void turnStatus(Long keyId);
}
