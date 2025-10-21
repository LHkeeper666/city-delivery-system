
package com.thirdgroup.cdms.entity;

import lombok.Data;
import java.util.Date;
import java.math.BigDecimal;

/**
 * DeliveryOrder entity
 */
@Data
public class DeliveryOrder {
    /**
     * order_id
     * @Primary Key
     */
    private String orderId;

    /**
     * sender_name
     */
    private String senderName;

    /**
     * sender_phone
     */
    private String senderPhone;

    /**
     * sender_address
     */
    private String senderAddress;

    /**
     * consignee_name
     */
    private String consigneeName;

    /**
     * consignee_phone
     */
    private String consigneePhone;

    /**
     * consignee_address
     */
    private String consigneeAddress;

    /**
     * goods_type
     */
    private String goodsType;

    /**
     * weight
     */
    private BigDecimal weight;

    /**
     * volume
     */
    private BigDecimal volume;

    /**
     * delivery_fee
     */
    private BigDecimal deliveryFee;

    /**
     * expected_mins
     */
    private Integer expectedMins;

    /**
     * remark
     */
    private String remark;

    /**
     * status
     */
    private Integer status;

    /**
     * create_time
     */
    private Date createTime;

    /**
     * creator_id
     */
    private Long creatorId;

    /**
     * deliveryman_id
     */
    private Long deliverymanId;

    /**
     * complete_time
     */
    private Date completeTime;

    /**
     * cancel_time
     */
    private Date cancelTime;

}
