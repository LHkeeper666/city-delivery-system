package com.thirdgroup.cdms.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.Import;
import org.springframework.core.type.filter.RegexPatternTypeFilter;

import java.util.regex.Pattern;

/**
 *
 * 配置类，用于管理ContextLoadListener创建的上下文的bean
 *
 */
// 定义为配置类
@Configuration
// 引入数据库配置类
@Import(DataSourceConfig.class)
public class RootConfig {

}
