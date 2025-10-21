
package com.thirdgroup.cdms.entity;

import lombok.Data;
import java.util.Date;

/**
 * ApiKey entity
 */
@Data
public class ApiKey {
    /**
     * key_id
     * @Primary Key
     */
    private Long keyId;

    /**
     * app_name
     */
    private String appName;

    /**
     * api_key
     */
    private String apiKey;

    /**
     * status
     */
    private String status;

    /**
     * create_time
     */
    private Date createTime;

}
