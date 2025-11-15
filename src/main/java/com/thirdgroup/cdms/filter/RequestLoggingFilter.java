package com.thirdgroup.cdms.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Enumeration;

@WebFilter(urlPatterns = "/*") // 拦截所有请求
public class RequestLoggingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("Filter init");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // 统一编码
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // 请求日志
        System.out.println("[请求过滤器] " + LocalDateTime.now() + " " +
                req.getMethod() + " " + req.getRequestURI());

        // 打印请求参数
        Enumeration<String> params = req.getParameterNames();
        while (params.hasMoreElements()) {
            String name = params.nextElement();
            System.out.println("   参数: " + name + " = " + req.getParameter(name));
        }

        // 登录校验（排除登录）
        String path = req.getRequestURI();
        String contextPath = req.getContextPath();
        String relativePath = path.substring(contextPath.length());

        HttpSession session = req.getSession(false);

        if (relativePath.startsWith("/deliveryman") && !isLoginging(relativePath)) {
            if (session == null || session.getAttribute("deliveryman") == null) {
                resp.sendRedirect(req.getContextPath() + "/deliveryman/toLogin");
                return;
            }
        } else if (relativePath.startsWith("/admin")) {
            if (session == null || session.getAttribute("user") == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
        }

        if ((session == null ||
                (session.getAttribute("user") == null &&
                session.getAttribute("deliveryman") == null)) &&
                !isLoginging(relativePath)
        ) {
//            resp.sendRedirect(req.getContextPath() + "/deliveryman/toLogin");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 记录请求开始时间，方便响应过滤器统计耗时
        req.setAttribute("startTime", System.currentTimeMillis());

        // 继续执行
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("Filter destroyed");
    }

    public boolean isLoginging(String relativePath) {
        return relativePath.startsWith("/deliveryman/toLogin") ||
                relativePath.startsWith("/deliveryman/toRegister") ||
                relativePath.startsWith("/deliveryman/login") ||
                relativePath.startsWith("/deliveryman/register") ||
                relativePath.startsWith("/login") ||
                relativePath.startsWith("/deliveryman/toForgotPassword");
    }
}
