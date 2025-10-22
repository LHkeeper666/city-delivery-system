package com.thirdgroup.cdms.model;

import lombok.Data;
import java.util.List;

@Data  // Lombok注解，自动生成getter/setter
public class PageResult<T> {
    // 1. 分页元数据
    private Long total;       // 总记录数（如所有订单共128条）
    private Integer page;     // 当前页码（如第3页）
    private Integer size;     // 每页条数（如每页10条）

    // 2. 业务数据（当前页的列表）
    private List<T> list;     // 泛型列表，此处为订单列表：List<DeliveryOrder>
}