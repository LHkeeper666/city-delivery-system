package com.thirdgroup.cdms.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * ApiKey entity
 */
@Data
//@AllArgsConstructor
//@NoArgsConstructor
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
