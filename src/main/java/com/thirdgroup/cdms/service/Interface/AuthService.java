package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.User;
import com.thirdgroup.cdms.exception.LoginException;

/**
 * 登录验证模块Service
 *
 * @author Lu Huafei
 */
public interface AuthService {

    /**
     * 根据 username 和 password 验证用户信息,
     * 并更新登录信息
     *
     * @param username 用户名
     * @param password 密码
     * @return 相应的 user 实体
     */
    User login(String username, String password, String ip) throws LoginException;
}
