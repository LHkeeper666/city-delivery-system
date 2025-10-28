package com.thirdgroup.cdms.config;

import com.alibaba.druid.pool.DruidDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.init.DataSourceInitializer;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

/**
 * 数据库配置类
 * 开发阶段用 h2 数据库
 */
@Configuration
@ComponentScan(basePackages = {
        "com.thirdgroup.cdms.service"
//        ,"com.thirdgroup.cdms.mapper"
})
@MapperScan("com.thirdgroup.cdms.mapper")
@EnableTransactionManagement
public class DataSourceConfig {

//    @Bean
//    public DataSource dataSource() {
//        DruidDataSource ds = new DruidDataSource();
//        ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
//        ds.setUrl("jdbc:mysql://localhost:3306/cdms?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai");
//        ds.setUsername("root");
//        ds.setPassword("new_password");
//
//        // ========== 连接池配置 ==========
//        ds.setInitialSize(5);    // 初始连接数
//        ds.setMinIdle(5);        // 最小空闲连接
//        ds.setMaxActive(20);     // 最大活动连接
//        ds.setMaxWait(10000);    // 获取连接最大等待时间（ms）
//        ds.setValidationQuery("SELECT 1"); // 检测连接是否有效
//        ds.setTestOnBorrow(true);          // 取连接时检测
//        ds.setTestWhileIdle(true);         // 空闲时检测
//        ds.setTimeBetweenEvictionRunsMillis(60000); // 空闲检测周期
//
//        return ds;
//    }

    @Bean
    public DataSource dataSource() {
        DruidDataSource ds = new DruidDataSource();
        ds.setDriverClassName("org.h2.Driver");
        ds.setUrl("jdbc:h2:mem:cdms;DB_CLOSE_DELAY=-1;MODE=MySQL;DATABASE_TO_UPPER=false");
        ds.setUsername("sa");
        ds.setPassword("");

        ds.setInitialSize(1);
        ds.setMinIdle(1);
        ds.setMaxActive(10);
        ds.setValidationQuery("SELECT 1");
        ds.setTestOnBorrow(true);
        return ds;
    }

    @Bean
    public DataSourceInitializer dataSourceInitializer(DataSource dataSource) {
        ResourceDatabasePopulator populator = new ResourceDatabasePopulator();

        populator.addScript(new ClassPathResource("schema.sql"));

        populator.addScript(new ClassPathResource("data.sql"));

        DataSourceInitializer initializer = new DataSourceInitializer();
        initializer.setDataSource(dataSource);
        initializer.setDatabasePopulator(populator);
        return initializer;
    }


    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
        SqlSessionFactoryBean factory = new SqlSessionFactoryBean();
        factory.setDataSource(dataSource);

        factory.setMapperLocations(
                new PathMatchingResourcePatternResolver()
                        .getResources("classpath*:mapper/*.xml")
        );
        factory.setTypeAliasesPackage("com.thirdgroup.cdms.entity"); // 实体类包

        // 用 MyBatis 的 Configuration 对象替代 mybatis-config.xml
        org.apache.ibatis.session.Configuration configuration =
                new org.apache.ibatis.session.Configuration();
        configuration.setMapUnderscoreToCamelCase(true);
        configuration.setLogImpl(org.apache.ibatis.logging.stdout.StdOutImpl.class);

        factory.setConfiguration(configuration);

        return factory.getObject();
    }

    @Bean
    public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }

    @Bean
    public DataSourceTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }
}
