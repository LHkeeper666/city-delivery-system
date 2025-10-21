
package com.thirdgroup.cdms.model;

import lombok.Data;
import java.util.Date;

/**
 * Notification entity
 */
@Data
public class Notification {
    /**
     * id
     * @Primary Key
     */
    private String id;

    /**
     * deliveryman_id
     */
    private Long deliverymanId;

    /**
     * content
     */
    private String content;

    /**
     * type
     */
    private Integer type;

    /**
     * is_read
     */
    private Integer isRead;

    /**
     * create_time
     */
    private Date createTime;

    /**
     * sms_sent
     */
    private Integer smsSent;

}
