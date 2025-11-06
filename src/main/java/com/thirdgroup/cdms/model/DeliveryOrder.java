package com.thirdgroup.cdms.model;

import com.thirdgroup.cdms.model.enums.OrderStatus;
import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

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
    private BigDecimal platformIncome;
    private BigDecimal deliverymanIncome;
    private Integer expectedMins;
    private String remark;
    private Integer status;
    private Date createTime;  // 仅保留数据库存在的时间字段
    private Long creatorId;
    private Long deliverymanId;
    private Date completeTime;  // 仅保留数据库存在的时间字段
    private Date cancelTime;    // 仅保留数据库存在的时间字段
    private String abandonReason;    // 放弃原因
    private String abandonDescription; // 放弃说明

    // 辅助方法：转订单状态枚举
    public OrderStatus getStatusEnum() {
        return OrderStatus.fromCode(this.status);
    }
}