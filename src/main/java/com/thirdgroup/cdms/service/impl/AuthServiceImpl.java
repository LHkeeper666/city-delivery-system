package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.model.User;
import com.thirdgroup.cdms.exception.LoginException;
import com.thirdgroup.cdms.service.AuthService;
import com.thirdgroup.cdms.service.UserService;
import com.thirdgroup.cdms.utils.PasswordUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private UserService userService;

    @Override
    public User login(String username, String password) throws LoginException {
        User user = userService.findByUsername(username);
        if (user == null) {
            throw new LoginException("用户不存在");
        }

        if (!PasswordUtils.matches(password, user.getPassword())) {
            System.out.println("password = " + password);
            System.out.println("user.getPassword() = " + user.getPassword());
            throw new LoginException("密码错误");
        }

        return user;
    }
}
