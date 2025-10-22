package com.thirdgroup.cdms.service.Interface;

public interface NotificationService {
    // 发送新订单通知（给符合条件的配送员）
    void sendNewOrderNotify(String orderId);
    // 查询用户未读通知数（用于首页提醒）
    int getUnreadCount(Long userId);
    // 标记通知为已读
    void markAsRead(Long userId, String noticeId);
}