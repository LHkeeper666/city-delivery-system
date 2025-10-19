package com.thirdgroup.cdms.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@Configuration
@EnableWebMvc
@ComponentScan("com.thirdgroup.cdms.controller")
public class WebConfig {
    // 注册拦截器、视图解析器、静态资源映射等
}
