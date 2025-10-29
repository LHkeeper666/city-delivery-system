package com.thirdgroup.cdms.service.impl;

import com.thirdgroup.cdms.mapper.DeliveryOrderMapper;
import com.thirdgroup.cdms.mapper.UserMapper;
import com.thirdgroup.cdms.model.*;
import com.thirdgroup.cdms.service.Interface.AdminService;
import com.thirdgroup.cdms.service.Interface.TraceService;
import com.thirdgroup.cdms.utils.DateUtils;
import com.thirdgroup.cdms.utils.PasswordUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.text.SimpleDateFormat;

import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.Map;
import java.util.stream.Collectors;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import java.math.BigDecimal;

@Service
public class AdminServiceImpl implements AdminService {
    @Autowired
    private DeliveryOrderMapper orderMapper;  // 订单Mapper接口

    @Autowired
    private TraceService traceService;
    
    @Autowired
    private UserMapper userMapper;  // 用户Mapper接口

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String publishOrder(DeliveryOrder order) {
        try {
            // 生成订单ID：DEL + 日期 + 3位流水号
            String orderId = generateOrderId();
            order.setOrderId(orderId);

            // 设置订单状态为待接单
            order.setStatus(OrderStatus.PENDING.getCode());

            // 设置创建时间
            order.setCreateTime(new Date());

            // 计算平台收入和配送员收入（假设平台抽取20%）
            if (order.getDeliveryFee() != null) {
                BigDecimal platformRate = new BigDecimal(0.2); // 20%平台抽成
                order.setPlatformIncome(order.getDeliveryFee().multiply(platformRate));
                order.setDeliverymanIncome(order.getDeliveryFee().subtract(order.getPlatformIncome()));
            }

            // 保存订单到数据库
            orderMapper.insert(order);

            // 返回生成的订单ID
            return order.getOrderId();
        } catch (Exception e) {
            throw new RuntimeException("发布订单失败: " + e.getMessage());
        }
    }

    /**
     * 生成订单ID
     * 规则：DEL + 日期（yyyyMMdd） + 3位流水号
     */
    private String generateOrderId() {
        // 获取当前日期
        String dateStr = new SimpleDateFormat("yyyyMMdd").format(new Date());

        // 查询当天最大的订单号
        String maxOrderId = orderMapper.getMaxOrderIdByDate(dateStr);

        String sequence;
        if (maxOrderId != null && maxOrderId.startsWith("DEL" + dateStr)) {
            // 提取序号部分并加1
            String seqStr = maxOrderId.substring(9); // DELyyyyMMdd后的3位
            int seq = Integer.parseInt(seqStr) + 1;
            sequence = String.format("%03d", seq);
        } else {
            // 如果没有找到，从001开始
            sequence = "001";
        }

        return "DEL" + dateStr + sequence;
    }

    @Override
    public PageResult<DeliveryOrder> queryAllOrders(
            Integer status, String keyword, int page, int size, Long deliverymanId, Date startTime, Date endTime) {
        if (endTime != null) {
            endTime = DateUtils.addDays(endTime, 1);
        }

        // 1. 计算分页起始位置（MySQL分页用LIMIT start, size）
        int start = (page - 1) * size;  // 第1页：start=0，第2页：start=10...

        // 2. 查询当前页数据（调用Mapper接口，带条件+分页）
        List<DeliveryOrder> orderList = orderMapper.selectPageAdmin(
                status, keyword, start, size, deliverymanId, startTime, endTime
        );

        // 3. 查询总记录数（用于计算总页数）
        Long total = orderMapper.count(status, keyword, deliverymanId, startTime, endTime);

        // 4. 封装到PageResult并返回
        PageResult<DeliveryOrder> result = new PageResult<>();
        result.setList(orderList);    // 当前页订单列表
        result.setTotal(total);       // 总条数
        result.setPage(page);         // 当前页码
        result.setSize(size);         // 每页条数
        return result;
    }

    public PageResult<DeliveryOrder> queryActiveOrders(
            String keyword, int page, int size) {
        int start = (page - 1) * size;
        List<DeliveryOrder> orderList = orderMapper.selectActiveOrdersByPage(keyword, start, size);
        Long totalCount = orderMapper.countActiveOrders(keyword);
        PageResult<DeliveryOrder> result = new PageResult<>();
        result.setList(orderList);
        result.setTotal(totalCount);
        result.setPage(page);
        result.setSize(size);
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
        // 检查用户名是否已存在
        User existingUser = userMapper.selectByUsername(user.getUsername());
        if (existingUser != null) {
            throw new RuntimeException("用户名已存在");
        }

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
            existingUser.setPassword(existingUser.getPassword()); // 保持密码不变
            existingUser.setUpdateTime(new Date());

            // 更新非空字段
            if (user.getPhoneNo() != null) {
                existingUser.setPhoneNo(user.getPhoneNo());
            }
            if (user.getStatus() != null) {
                existingUser.setStatus(user.getStatus());
            }
            if (user.getWorkStatus() != null) {
                existingUser.setWorkStatus(user.getWorkStatus());
            }

            // 更新用户信息
            userMapper.updateByPrimaryKey(existingUser);
        }
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteAccount(Long userId) {
        // 检查是否为最后一个管理员账号（避免删除所有管理员）
        List<User> adminUsers = userMapper.selectAll().stream()
            .filter(user -> user.getRole().equals(0)) // 0表示管理员角色
            .collect(Collectors.toList());
        
        User userToDelete = userMapper.selectByPrimaryKey(userId);
        if (userToDelete == null) {
            return false; // 用户不存在
        }

        // 不能删除最后一个管理员
        if (userToDelete.getRole().equals(0) && adminUsers.size() <= 1) {
            return false;
        }
        
        // 如果是配送员，先处理相关订单（避免外键约束冲突）
        if (userToDelete.getRole().equals(2)) { // 假设2表示配送员角色
            // 将相关订单的配送员ID设置为null
            orderMapper.updateDeliverymanIdToNull(userId);
        }
        // 执行删除操作
        int rows = userMapper.deleteByPrimaryKey(userId);
        return rows > 0;
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

    @Override
    public OrderStatisticsDTO getOrderStatistic(Date startTime, Date endTime) {
        endTime = DateUtils.addDays(endTime, 1);
        OrderStatisticsDTO orderStatistics =  orderMapper.countOrderStatistics(startTime, endTime);
        return orderStatistics;
    }

    @Override
    public List<OrderTrendDTO> getOrderTrend(Date startTime, Date endTime) {
        endTime = DateUtils.addDays(endTime, 1);
        List<OrderTrendDTO> orderTrendByDate = orderMapper.getOrderTrendByDate(startTime, endTime);
        return orderTrendByDate;
    }
}
// 先用ai生成一下，这个后面我自己改