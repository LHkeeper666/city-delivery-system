package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.model.User;
import com.thirdgroup.cdms.mapper.UserMapper;
import com.thirdgroup.cdms.service.Interface.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(String username, String password) {
        return null;
    }

    @Override
    public User getUserById(Long userId) {
        return null;
    }

    @Override
    public Long createUser(User user) {
        return 0L;
    }

    @Override
    public void updateStatus(Long userId, Integer status) {

    }

    @Override
    public boolean updatePassword(Long userId, String oldPwd, String newPwd) {
        return false;
    }

    @Override
    public User findByUsername(String username) {
        return userMapper.selectByUsername(username);
    }
}
