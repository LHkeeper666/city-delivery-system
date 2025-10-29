package com.thirdgroup.cdms.mapper;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.Deliveryman;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

/**
 * 外卖员Mapper：操作cdms_user表（外卖员角色）
 */
@Mapper
public interface DeliverymanMapper {
    // 1. 根据ID查外卖员（参数名：id→userId，类型：Integer→Long，匹配表中user_id（BIGINT））
    Deliveryman selectById(@Param("userId") Long userId);

    // 2. 根据手机号查外卖员（无修改，已匹配）
    Deliveryman selectByPhone(@Param("phone") String phone);

    // 3. 更新外卖员工作状态（参数名：id→userId，类型：Integer→Long）
    int updateStatus(@Param("userId") Long userId, @Param("status") Integer status);

    // 4. 更新外卖员信息（依赖实体类属性，需确保实体类有userId）
    int updateProfile(Deliveryman deliveryman);

    // 5. 更新余额（参数名：id→userId，类型：Integer→Long）
    int updateBalance(@Param("userId") Long userId, @Param("addProfit") BigDecimal addProfit);

    // 6. 根据手机号更新密码（无修改，已匹配）
    int updatePasswordByPhone(
            @Param("phone") String phone,
            @Param("newPassword") String newPassword
    );

    // 7. 新增外卖员（无修改，已匹配实体类userId）
    int insert(Deliveryman deliveryman);

    // 8. 检查用户名是否存在（无修改，已匹配）
    int countByUsername(@Param("username") String username);
    // 新增：根据外卖员ID查询我的订单（状态=1：配送中）
    List<DeliveryOrder> selectMyOrders(@Param("userId") Long userId);

    int updatePhone(
            @Param("userId") Long userId,
            @Param("newPhone") String newPhone,
            @Param("updateTime") java.util.Date updateTime
    );
}