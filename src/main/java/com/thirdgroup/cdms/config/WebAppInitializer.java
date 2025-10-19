package com.thirdgroup.cdms.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    // 加载 Spring 根容器配置（通常用于Service/Dao层）
    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class<?>[]{RootConfig.class};
    }

    // 加载 Spring MVC 配置（Controller 层）
    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[]{WebConfig.class};
    }

    // 映射路径
    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }
}

