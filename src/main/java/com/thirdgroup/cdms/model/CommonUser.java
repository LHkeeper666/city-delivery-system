package com.thirdgroup.cdms.model;

import lombok.Data;

/**
 * 通用用户类，作为User抽象类的通用实现
 * 用于处理不需要特定角色类型的通用用户查询场景
 */
@Data
public class CommonUser extends User {
    
    /**
     * 实现抽象类的getId方法，返回用户ID
     */
    @Override
    public Long getId() {
        return this.getUserId();
    }
}