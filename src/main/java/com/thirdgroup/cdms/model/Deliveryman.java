package com.thirdgroup.cdms.model;

import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import lombok.Data; // 如果你用Lombok，没有就写getter/setter

import java.util.Date;

/**
 * 外卖员实体类，对应courier表,需要思考一下status和role的区别
 */
@Data // Lombok注解：自动生成getter、setter、toString
public class Deliveryman extends User {
    private Long userId;
    private String username;
    private String password;
    private Integer role;
    private String phoneNo;
    private Integer status;
    private Integer workStatus;
    private Integer failCount;
    private Date lastLoginTime;
    private String lastLoginIp;
    private Integer lastLoginSuccess;
    private String lastLoginRemark;
    private Date createTime;
    private Long creatorId;
    private Date updateTime;


    // 辅助方法：把status（int）转成CourierStatus枚举（给页面显示用）
    public DeliverymanStatus getStatusEnum() {
        return DeliverymanStatus.getByCode(this.status);
    }

    public Integer getId() {
        return 0;
        /**
         * 还没实现
         */
    }
}