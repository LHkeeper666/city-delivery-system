package com.thirdgroup.cdms.model;

import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import lombok.Data; // 如果你用Lombok，没有就写getter/setter

import java.util.Date;

/**
 * 外卖员实体类，对应courier表,需要思考一下status和role的区别
 */
@Data
public class Deliveryman extends User {
    private Long userId; // 对应表中user_id，作为外卖员工号
    private String username;
    private String password;
    private Integer role; // 1=外卖员，0=管理员（继承User后可考虑删除，统一用父类属性）
    private String phoneNo;
    private Integer status; // 账号状态：0=启用，1=禁用
    private Integer workStatus; // 工作状态：0=离线，1=在线
    private Integer failCount; // 登录失败次数
    private Date lastLoginTime;
    private String lastLoginIp;
    private Integer lastLoginSuccess; // 1=成功，0=失败
    private String lastLoginRemark;
    private Date createTime;
    private Long creatorId; // 创建人ID（如管理员ID）
    private Date updateTime;

    // 辅助方法：把workStatus转成枚举（页面显示状态用，原statusEnum可能对应错字段）
    public DeliverymanStatus getWorkStatusEnum() {
        return DeliverymanStatus.getByCode(this.workStatus);
    }

    // 关键修改：删除原有的固定返回0的getId()，改为返回userId（工号）
    // 原因：父类User可能已有getId()，重写后返回正确的工号，避免页面显示0

    public Long getId() {
        return this.userId; // 工号就是userId，页面${deliveryman.userId}也能直接取
    }
}