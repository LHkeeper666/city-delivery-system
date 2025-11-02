package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.ApiKeyMapper;
import com.thirdgroup.cdms.model.ApiKey;
import com.thirdgroup.cdms.model.PageResult;
import com.thirdgroup.cdms.service.Interface.ApiKeyService;
import com.thirdgroup.cdms.utils.ApiKeyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class ApiKeyServiceImpl implements ApiKeyService {

    @Autowired
    private ApiKeyMapper apiKeyMapper;

    @Override
    public boolean isValid(String apiKey) {
        ApiKey apiKeyEntity = apiKeyMapper.selectByApiKey(apiKey);
        return apiKeyEntity != null;
    }

    @Override
    public String createNewApiKey(String appName) throws Exception {
        if (apiKeyMapper.selectByAppName(appName) != null) {
            System.out.println("app name is exist");
            throw new Exception("应用名称已存在！");
        }
        String newKey = ApiKeyUtil.generateApiKey();
//        ApiKey newApiKey = new ApiKey(null, appName, newKey, "enabled", null);
        ApiKey newApiKey = new ApiKey();
        newApiKey.setAppName(appName);
        newApiKey.setApiKey(newKey);
        newApiKey.setCreateTime(new Date());
        newApiKey.setStatus("enabled");
        apiKeyMapper.insert(newApiKey);

        return newKey;
    }

    @Override
    public PageResult<ApiKey> queryByPage(String keyword, String status, Integer page, Integer size) {
        int start = (page - 1) * size;
        List<ApiKey> apiKeys = apiKeyMapper.selectByPageAndAppName(keyword, status, start, size);

        Long total = apiKeyMapper.countByAppName(keyword, status);

        PageResult<ApiKey> result = new PageResult<>();
        result.setList(apiKeys);
        result.setTotal(total);
        result.setPage(page);
        result.setSize(size);

        return result;
    }

    @Override
    public void turnStatus(Long keyId) {
        apiKeyMapper.turnStatus(keyId);
    }
}
