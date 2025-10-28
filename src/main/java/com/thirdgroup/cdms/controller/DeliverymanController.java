package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.Deliveryman; // 需补充外卖员实体类
import com.thirdgroup.cdms.service.Interface.DeliveryManService; // 需补充外卖员Service
import com.thirdgroup.cdms.utils.Result;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * 外卖员控制器：处理登录、个人信息等请求
 */
@RestController
@RequestMapping("/deliveryman")
public class DeliverymanController {

    @Resource
    private DeliveryManService deliverymanService;

    // 1. 外卖员登录
    @PostMapping("/login")
    public Result login(
            @RequestParam String username,
            @RequestParam String password,
            HttpSession session) {
        Deliveryman deliveryman = deliverymanService.login(username, password);
        if (deliveryman != null) {
            // 登录成功，将用户信息存入Session
            session.setAttribute("deliveryman", deliveryman);
            return Result.success("登录成功");
        } else {
            return Result.error(401, "用户名或密码错误");
        }
    }

    // 2. 获取当前登录外卖员信息
    @GetMapping("/current")
    public Result getCurrentDeliveryman(HttpSession session) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        return deliveryman != null ? Result.success(deliveryman) : Result.error(401, "未登录");
    }

    // 3. 退出登录
    @PostMapping("/logout")
    public Result logout(HttpSession session) {
        session.invalidate(); // 清除Session
        return Result.success("退出成功");
    }

    // 其他接口：如修改密码、查看个人配送记录等
}