
package com.thirdgroup.cdms.model;

import com.thirdgroup.cdms.model.enums.OrderStatus;
import lombok.Data;
import java.util.Date;
import java.math.BigDecimal;

/**
 * DeliveryOrder entity
 */
@Data
public class DeliveryOrder {

    private String orderId;
    private String senderName;
    private String senderPhone;
    private String senderAddress;
    private String consigneeName;
    private String consigneePhone;
    private String consigneeAddress;
    private String goodsType;
    private BigDecimal weight;
    private BigDecimal volume;
    private BigDecimal deliveryFee;
    private Integer expectedMins;
    private String remark;
    private Integer status;
    private Date createTime;
    private Long creatorId;
    private Long deliverymanId;
    private Date completeTime;
    private Date cancelTime;
    // 辅助方法：转订单状态枚举
    public OrderStatus getStatusEnum() {
        return OrderStatus.fromCode(this.status);
    }
}
