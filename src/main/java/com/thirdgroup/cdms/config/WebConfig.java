package com.thirdgroup.cdms.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {
        "com.thirdgroup.cdms.controller"
})
public class WebConfig implements WebMvcConfigurer {
    // 注册拦截器、视图解析器、静态资源映射等
}
