
package com.thirdgroup.cdms.model;

import lombok.Data;
import java.util.Date;

/**
 * DeliveryTrace entity
 */
@Data
public class DeliveryTrace {
    /**
     * trace_id
     * @Primary Key
     */
    private Long traceId;

    /**
     * order_id
     */
    private String orderId;

    /**
     * status
     */
    private Integer status;

    /**
     * operator_id
     */
    private Long operatorId;

    /**
     * operate_time
     */
    private Date operateTime;

    /**
     * remark
     */
    private String remark;

    /**
     * 用于前端显示
     */
    private String operatorName;
}
