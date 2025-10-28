package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.User;
import com.thirdgroup.cdms.exception.LoginException;
import com.thirdgroup.cdms.service.Interface.AuthService;
import com.thirdgroup.cdms.utils.Result;
import io.swagger.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Api(tags = "认证接口", description = "用于用户登录与登出操作")
@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    // TODO：状态码要对齐一下
    @ApiOperation(value = "用户登录", notes = "用户根据用户名与密码登录系统")
    @ApiResponses({
            @ApiResponse(code = 200, message = "登录成功，返回 'success'"),
            @ApiResponse(code = 400, message = "用户名或密码错误"),
            @ApiResponse(code = 500, message = "服务器内部错误")
    })
    @PostMapping("/login")
    @ResponseBody
    public String login(
            @ApiParam(value = "用户名", required = true, example = "admin")
            @RequestParam String username,

            @ApiParam(value = "密码", required = true, example = "123456")
            @RequestParam String password,

            HttpServletResponse response,
            HttpServletRequest request,
            Model model,
            HttpSession session) {
        System.out.println("start login!!!");
        try {
            String ip = getClientIp(request);
            System.out.println("ip:" + ip);
            User user = authService.login(username, password, ip);
            session.setAttribute("user", user);

            Cookie cookie = new Cookie("username", username);
            cookie.setPath("/");
            cookie.setMaxAge(7 * 24 * 3600);
            response.addCookie(cookie);

            return "success";
//            return "redirect:/home";
        } catch (LoginException e) {
            System.out.println("error:" + e.getMessage());

//            model.addAttribute("errorMsg", e.getMessage());

            model.addAttribute("errorMsg", Result.error(400, e.getMessage()));

            return "failure";
//            return "login"; // 回到登录页
        }
    }

    @ApiOperation(value = "用户登出", notes = "清除会话和登录状态")
    @ApiResponses({
            @ApiResponse(code = 200, message = "登出成功，跳转到登录页")
    })
    @PostMapping("/logout")
    public String logout(
            @ApiParam(value = "当前会话", hidden = true)
            HttpSession session,

            @ApiParam(value = "响应对象", hidden = true)
            HttpServletResponse response) {

        session.invalidate();

        Cookie cookie = new Cookie("username", "");
        cookie.setMaxAge(0); // 立即失效
        cookie.setPath("/");
        response.addCookie(cookie);

        return "redirect:/login"; // 浏览器 URL 改为 /login
    }

    /**
     * 获取请求 ip
     */
    public String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
            // 可能有多个代理，取第一个
            return ip.split(",")[0];
        }
        ip = request.getHeader("Proxy-Client-IP");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
