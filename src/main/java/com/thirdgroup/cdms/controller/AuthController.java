package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.User;
import com.thirdgroup.cdms.exception.LoginException;
import com.thirdgroup.cdms.service.Interface.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    @ResponseBody
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpServletResponse response,
                        Model model,
                        HttpSession session) {
        System.out.println("start login!!!");
        try {
            User user = authService.login(username, password);
            session.setAttribute("user", user);

            Cookie cookie = new Cookie("username", username);
            cookie.setPath("/");
            cookie.setMaxAge(7 * 24 * 3600);
            response.addCookie(cookie);

            return "success";
//            return "redirect:/home";
        } catch (LoginException e) {
            model.addAttribute("errorMsg", e.getMessage());

            return "failure";
//            return "login"; // 回到登录页
        }
    }

    @PostMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response) {
        session.invalidate();

        Cookie cookie = new Cookie("username", "");
        cookie.setMaxAge(0); // 立即失效
        cookie.setPath("/");
        response.addCookie(cookie);

        return "redirect:/login"; // 浏览器 URL 改为 /login
    }
}
