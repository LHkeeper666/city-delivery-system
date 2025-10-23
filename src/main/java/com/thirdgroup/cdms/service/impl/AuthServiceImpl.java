package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.model.User;
import com.thirdgroup.cdms.exception.LoginException;
import com.thirdgroup.cdms.service.Interface.AuthService;
import com.thirdgroup.cdms.service.Interface.UserService;
import com.thirdgroup.cdms.utils.DateUtils;
import com.thirdgroup.cdms.utils.PasswordUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private UserService userService;

    @Override
    public User login(String username, String password, String ip) throws LoginException {
        User user = userService.findByUsername(username);

        if (user == null) {
            throw new LoginException("用户不存在");
        }

        // 如果尝试次数超过指定次数且与最后一次登录时间相差不超过5分钟
        if (user.getFailCount() >= 3) {
            Date untilDate = Date.from(DateUtils.addMinutes(user.getLastLoginTime(), 5).toInstant());
//            Date untilDate = Date.from(DateUtils.addSeconds(user.getLastLoginTime(), 10).toInstant());
            if (new Date().before(untilDate)) {
                System.out.println("failcount too much");
                throw new LoginException("登录次数过多，请稍后重试！");
            }
        }

        if (!PasswordUtils.matches(password, user.getPassword())) {
            userService.updateLoginInfo(user.getUserId(), user.getFailCount() + 1, ip, false, "密码错误");
            System.out.println("wrong password");
            throw new LoginException("密码错误");
        }

        userService.updateLoginInfo(user.getUserId(), 0, ip, true, "");

        return user;
    }
}
