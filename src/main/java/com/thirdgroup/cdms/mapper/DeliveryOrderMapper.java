
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

    /**
     * 分页查询配送员的订单列表。
     * <p>
     * 该方法用于配送员端查看自己的订单信息。
     * 支持根据订单状态筛选，并可通过关键词对订单号、收件人姓名进行模糊搜索。
     * </p>
     *
     * @param status  订单状态
     * @param keyword 搜索关键词（可选，用于匹配订单号、收件人姓名）
     * @param start   分页起始下标（从0开始）
     * @param size    每页显示的记录数
     * @param userId  配送员用户ID（用于筛选当前配送员的订单）
     * @return        当前配送员符合条件的订单列表
     */
    List<DeliveryOrder> selectPageByDeliveryman(
            @Param("status") Integer status,
            @Param("keyword") String keyword,  // 搜索关键词（如订单号、收件人）
            @Param("start") int start,
            @Param("size") int size,
            @Param("id") long userId
            //这里具体去看一下外卖员实体的属性对齐一下
    );

    /**
     * 分页查询订单列表（管理员端）。
     * <p>
     * 该方法供管理员使用，用于查看系统中所有订单信息。
     * 支持根据订单状态筛选，并可通过关键词对订单号、寄件人、收件人、
     * 电话及配送员姓名等信息进行模糊搜索。
     * </p>
     *
     * @param status   订单状态
     * @param keyword  搜索关键词（可选，用于匹配订单号、寄件人、收件人、电话或配送员姓名）
     * @param start    分页起始下标（从0开始）
     * @param size     每页显示的记录数
     * @return         符合条件的订单列表（包含配送员姓名等扩展信息）
     */
    List<DeliveryOrder> selectPageAdmin(
            @Param("status") Integer status,
            @Param("keyword") String keyword,  // 搜索关键词（如订单号、收件人）
            @Param("start") int start,
            @Param("size") int size,
            @Param("Id") long usersId
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