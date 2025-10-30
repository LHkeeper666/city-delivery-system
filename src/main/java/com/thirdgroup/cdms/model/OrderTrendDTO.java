package com.thirdgroup.cdms.model;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class OrderTrendDTO {
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date date;              // 日期
    private Integer orderCount;     // 当日订单数
    private BigDecimal totalIncome; // 当日收入
    private Double avgDeliveryTime; // 当日平均配送时长
}
