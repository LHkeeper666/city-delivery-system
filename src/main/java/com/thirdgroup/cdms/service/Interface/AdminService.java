package com.thirdgroup.cdms.service.Interface;

import com.thirdgroup.cdms.model.ApiKey;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.DeliveryTrace;
import com.thirdgroup.cdms.model.PageResult;
import com.thirdgroup.cdms.model.User;

import java.util.List;

public interface AdminService {
    // 发布配送订单（管理员代用户创建订单）
    String publishOrder(DeliveryOrder order);

    /**
     * 分页查询所有订单，
     * 支持收发件人信息、订单号、配送员姓名的模糊搜索
     */
    PageResult<DeliveryOrder> queryAllOrders(Integer status, String keyword, int page, int size, Long id);
    // 强制取消订单（仅管理员有权限）
    void cancelOrder(String orderId, String reason);
    // 管理API密钥（创建/禁用第三方接口密钥）
    ApiKey createApiKey(String appName);

    /**
     * 根据 orderId 查找对应的订单的 trace 列表
     */
    List<DeliveryTrace> trackOrder(String orderId);
    
    /**
     * 分页查询所有用户账号
     */
    PageResult<User> queryAllUsers(Integer role, Integer status, String keyword, int page, int size);
    
    /**
     * 创建新账号（管理员或配送员）
     */
    Long createAccount(User user);
    
    /**
     * 更新账号信息
     */
    void updateAccount(User user);
    
    /**
     * 删除账号
     */
    boolean deleteAccount(Long userId);
    
    /**
     * 重置账号密码
     */
    void resetPassword(Long userId, String newPassword);
    
    /**
     * 查询单个账号详情
     */
    User getUserById(Long userId);
}