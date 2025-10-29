package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.DeliveryOrderMapper;
import com.thirdgroup.cdms.mapper.UserMapper;
import com.thirdgroup.cdms.model.ApiKey;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.DeliveryTrace;
import com.thirdgroup.cdms.model.PageResult;
import com.thirdgroup.cdms.model.User;
import com.thirdgroup.cdms.service.Interface.AdminService;
import com.thirdgroup.cdms.service.Interface.TraceService;
import com.thirdgroup.cdms.utils.PasswordUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminServiceImpl implements AdminService {
    @Autowired
    private DeliveryOrderMapper orderMapper;  // 订单Mapper接口

    @Autowired
    private TraceService traceService;
    
    @Autowired
    private UserMapper userMapper;  // 用户Mapper接口

    @Override
    public String publishOrder(DeliveryOrder order) {
        return "";
    }

    @Override
    public PageResult<DeliveryOrder> queryAllOrders(
            Integer status, String keyword, int page, int size, Long id, Date startTime, Date endTime) {
        // 1. 计算分页起始位置（MySQL分页用LIMIT start, size）
        int start = (page - 1) * size;  // 第1页：start=0，第2页：start=10...

        // 2. 查询当前页数据（调用Mapper接口，带条件+分页）
        List<DeliveryOrder> orderList = orderMapper.selectPageAdmin(
                status, keyword, start, size, id, startTime, endTime
        );

        // 3. 查询总记录数（用于计算总页数）
        Long total = orderMapper.count(status, keyword, id, startTime, endTime);

        // 4. 封装到PageResult并返回
        PageResult<DeliveryOrder> result = new PageResult<>();
        result.setList(orderList);    // 当前页订单列表
        result.setTotal(total);       // 总条数
        result.setPage(page);         // 当前页码
        result.setSize(size);         // 每页条数
        return result;
    }

    @Override
    public void cancelOrder(String orderId, String reason) {

    }

    @Override
    public ApiKey createApiKey(String appName) {
        return null;
    }

    @Override
    public List<DeliveryTrace> trackOrder(String orderId) {
        List<DeliveryTrace> deliveryTraceList = traceService.getOrderTraces(orderId);
        return deliveryTraceList;
    }
    
    @Override
    public PageResult<User> queryAllUsers(Integer role, Integer status, String keyword, int page, int size) {
        int start = (page - 1) * size;
        
        // 这里假设UserMapper有相应的方法，后续可能需要扩展
        List<User> userList = userMapper.selectAll();
        // 简单过滤（实际应该在数据库层面实现）
        if (role != null || status != null || keyword != null) {
            userList = userList.stream()
                // 先按ID升序排序
                .sorted((u1, u2) -> u1.getUserId().compareTo(u2.getUserId()))
                .filter(user -> (role == null || user.getRole().equals(role)))
                .filter(user -> (status == null || user.getStatus().equals(status)))
                .filter(user -> (keyword == null || user.getUsername().contains(keyword) || 
                               (user.getPhoneNo() != null && user.getPhoneNo().contains(keyword))))
                .skip(start)
                .limit(size)
                .collect(Collectors.toList());
        } else {
            // 如果没有过滤条件，也要按ID升序排序并进行分页
            userList = userList.stream()
                .sorted((u1, u2) -> u1.getUserId().compareTo(u2.getUserId()))
                .skip(start)
                .limit(size)
                .collect(Collectors.toList());
        }
        
        PageResult<User> result = new PageResult<>();
        result.setList(userList);
        result.setTotal((long) userMapper.selectAll().size());
        result.setPage(page);
        result.setSize(size);
        return result;
    }
    
    @Override
    public Long createAccount(User user) {
        // 密码加密
        user.setPassword(PasswordUtils.encode(user.getPassword()));
        user.setCreateTime(new Date());
        user.setStatus(0); // 默认为启用状态
        user.setFailCount(0);
        
        userMapper.insert(user);
        return user.getUserId();
    }
    
    @Override
    public void updateAccount(User user) {
        // 更新非密码字段
        User existingUser = userMapper.selectByPrimaryKey(user.getUserId());
        if (existingUser != null) {
            user.setPassword(existingUser.getPassword()); // 保持密码不变
            user.setUpdateTime(new Date());
            userMapper.updateByPrimaryKey(user);
        }
    }
    
    @Override
    public boolean deleteAccount(Long userId) {
        // 检查是否为最后一个管理员账号（避免删除所有管理员）
        List<User> adminUsers = userMapper.selectAll().stream()
            .filter(user -> user.getRole().equals(0)) // 0表示管理员角色
            .collect(Collectors.toList());
        
        User userToDelete = userMapper.selectByPrimaryKey(userId);
        if (userToDelete != null && userToDelete.getRole().equals(0) && adminUsers.size() <= 1) {
            return false; // 不能删除最后一个管理员
        }
        
        userMapper.deleteByPrimaryKey(userId);
        return true;
    }
    
    @Override
    public void resetPassword(Long userId, String newPassword) {
        User user = userMapper.selectByPrimaryKey(userId);
        if (user != null) {
            user.setPassword(PasswordUtils.encode(newPassword));
            userMapper.updateByPrimaryKey(user);
        }
    }
    
    @Override
    public User getUserById(Long userId) {
        return userMapper.selectByPrimaryKey(userId);
    }
}
// 先用ai生成一下，这个后面我自己改