package com.thirdgroup.cdms.mapper;
import com.thirdgroup.cdms.model.Deliveryman;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;

/**
 * 外卖员Mapper：操作courier表
 */
@Mapper // 标记为MyBatis Mapper接口（或在config里配置扫描）
public interface DeliverymanMapper {
    // 根据ID查外卖员（登录后获取详情用）
    Deliveryman selectById(@Param("id") Integer id);

    // 根据手机号查外卖员（登录验证用）
    Deliveryman selectByPhone(@Param("phone") String phone);

    // 更新外卖员状态（接单时设为在线，退出时设为离线）
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    // 更新外卖员信息（个人中心修改姓名、头像等）
    int updateProfile(Deliveryman courier);

    // 更新余额（完成订单后加收益）
    int updateBalance(@Param("id") Integer id, @Param("addProfit") BigDecimal addProfit);
}