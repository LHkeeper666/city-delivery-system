
package com.thirdgroup.cdms.entity;

import lombok.Data;
import java.util.Date;

/**
 * OperationLog entity
 */
@Data
public class OperationLog {
    /**
     * log_id
     * @Primary Key
     */
    private Long logId;

    /**
     * operator_id
     */
    private Long operatorId;

    /**
     * operation_type
     */
    private String operationType;

    /**
     * operation_obj
     */
    private String operationObj;

    /**
     * operation_time
     */
    private Date operationTime;

    /**
     * result
     */
    private String result;

}
