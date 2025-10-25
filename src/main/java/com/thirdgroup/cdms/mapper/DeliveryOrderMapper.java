
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.DeliveryOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

@Mapper
public interface DeliveryOrderMapper {
    int insert(DeliveryOrder record);
    int deleteByPrimaryKey(String orderId);
    int updateByPrimaryKey(DeliveryOrder record);
    DeliveryOrder selectByPrimaryKey(String orderId);

    /**
     * 这个应该默认按照距离来selectALL
     * @return
     */
    List<DeliveryOrder> selectAll();
    // 查询当前页数据
    List<DeliveryOrder> selectPage(
            @Param("status") Integer status,
            @Param("keyword") String keyword,  // 搜索关键词（如订单号、收件人）
            @Param("start") int start,
            @Param("size") int size,
            @Param("Id") Integer usersId
            //这里具体去看一下外卖员实体的属性对齐一下
    );

    // 3. 接单：更新订单的courier_id、status、accept_time
    int acceptOrder(@Param("orderId") Integer orderId, @Param("courierId") Integer courierId, @Param("status") Integer status);

    // 4. 更新订单状态（确认取餐/送达/取消）
    int updateStatus(@Param("orderId") Integer orderId, @Param("status") Integer status, @Param("time") Date time);

    // 5. 根据ID查订单（地图页显示订单详情用）
    DeliveryOrder selectById(@Param("orderId") Integer orderId);


    // 查询总条数
    Long count(
            @Param("status") Integer status,
            @Param("keyword") String keyword
    );
}