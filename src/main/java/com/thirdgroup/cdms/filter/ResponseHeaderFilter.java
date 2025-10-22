package com.thirdgroup.cdms.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class ResponseHeaderFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("Filter init");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // 执行下一个过滤器或 Controller
        chain.doFilter(request, response);

        // 注意：下面的代码会在响应返回时执行
        resp.setHeader("X-App-Version", "1.0");
        System.out.println("[响应过滤器] 响应已生成，附加自定义响应头");

        // 计算耗时
        Long startTime = (Long) req.getAttribute("startTime");
        if (startTime != null) {
            long duration = System.currentTimeMillis() - startTime;
            System.out.println("[响应过滤器] " + req.getRequestURI() + " 耗时: " + duration + "ms");
        }
    }

    @Override
    public void destroy() {
        System.out.println("Filter destroyed");
    }
}
