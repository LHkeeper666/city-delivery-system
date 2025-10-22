package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.User;

public interface UserService {
    // 登录（验证账号密码，返回用户信息）
    User login(String username, String password);
    // 根据ID查询用户详情
    User getUserById(Long userId);
    // 新增用户（管理员创建配送员账号）
    Long createUser(User user);
    // 更新用户状态（启用/禁用账号）
    void updateStatus(Long userId, Integer status);
    // 修改密码（支持所有用户自我修改）
    boolean updatePassword(Long userId, String oldPwd, String newPwd);
}