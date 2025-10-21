
package com.thirdgroup.cdms.entity;

import lombok.Data;
import java.util.Date;

/**
 * User entity
 */
@Data
public class User {
    /**
     * user_id
     * @Primary Key
     */
    private Long userId;

    /**
     * username
     */
    private String username;

    /**
     * password
     */
    private String password;

    /**
     * role
     */
    private Integer role;

    /**
     * phone_no
     */
    private String phoneNo;

    /**
     * status
     */
    private Integer status;

    /**
     * work_status
     */
    private Integer workStatus;

    /**
     * fail_count
     */
    private Integer failCount;

    /**
     * last_login_time
     */
    private Date lastLoginTime;

    /**
     * last_login_ip
     */
    private String lastLoginIp;

    /**
     * last_login_success
     */
    private Integer lastLoginSuccess;

    /**
     * last_login_remark
     */
    private String lastLoginRemark;

    /**
     * create_time
     */
    private Date createTime;

    /**
     * creator_id
     */
    private Long creatorId;

    /**
     * update_time
     */
    private Date updateTime;

}
