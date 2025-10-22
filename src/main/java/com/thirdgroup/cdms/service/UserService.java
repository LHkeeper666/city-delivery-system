package com.thirdgroup.cdms.service;

import com.thirdgroup.cdms.model.User;

/**
 * user 表的 Service
 * 统一封装对 user 表的操作
 */
public interface UserService {

    /**
     * 根据用户名查找用户信息
     */
    User findByUsername(String username);



}
