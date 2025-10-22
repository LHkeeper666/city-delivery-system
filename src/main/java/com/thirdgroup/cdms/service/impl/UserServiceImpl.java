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
    public User findByUsername(String username) {
        return userMapper.selectByUsername(username);
    }
}
