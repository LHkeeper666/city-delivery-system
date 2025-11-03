package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.*;
import com.thirdgroup.cdms.model.enums.UserRole;
import com.thirdgroup.cdms.model.enums.UserStatus;
import com.thirdgroup.cdms.service.Interface.AdminService;
import com.thirdgroup.cdms.service.Interface.ApiKeyService;
import com.thirdgroup.cdms.service.Interface.OrderService;
import com.thirdgroup.cdms.utils.ApiKeyUtil;
import com.thirdgroup.cdms.utils.DateUtils;
import com.thirdgroup.cdms.utils.Result;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.Date;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Api(tags = "管理接口")
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;
    
    @Autowired
    private OrderService orderService;

    @Autowired
    private ApiKeyService apiKeyService;

    /**
     * 查询所有订单
     * TODO: 页面大小暂时定为10，后续考虑在配置文件中配置
     */
    @RequestMapping("/orders")
    public String queryOrders(
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long deliverymanId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startTime,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endTime,
            Model model
    ) {
        PageResult<DeliveryOrder> deliveryOrderPageResult = adminService.queryAllOrders(status, keyword, page, size, deliverymanId, startTime, endTime);

        model.addAttribute("historyOrders", Result.success(deliveryOrderPageResult));

        return "admin/ordersHistory";
    }

    /**
     * 查询所有未完成订单
     */
    @PostMapping("/orders/active")
    public String queryActiveOrders(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model
    ) {
        PageResult<DeliveryOrder> deliveryOrderPageResult = adminService.queryActiveOrders(keyword, status, page, size);
        model.addAttribute("ActiveOrders", Result.success(deliveryOrderPageResult));
        model.addAttribute("searchKeyword", keyword);
        model.addAttribute("searchStatus", status);
        model.addAttribute("page", page);
        return "admin/activeOrders";
    }

    /**
     * 显示发布配送信息页面
     */
    @GetMapping("/publish-order")
    public String publishOrderPage(Model model) {
        model.addAttribute("deliveryOrder", new DeliveryOrder());
        return "admin/publishOrder";
    }

    /**
     * 处理发布配送信息表单提交
     */
    @PostMapping("/publish-order")
    public String publishOrder(@ModelAttribute DeliveryOrder order, HttpSession session, Model model) {
        try {
            // 表单验证
            if (order.getSenderAddress() == null || order.getSenderAddress().trim().isEmpty()) {
                model.addAttribute("error", "接货地址不能为空");
                model.addAttribute("deliveryOrder", order);
                return "admin/publishOrder";
            }
            if (order.getSenderName() == null || order.getSenderName().trim().isEmpty()) {
                model.addAttribute("error", "接货人姓名不能为空");
                model.addAttribute("deliveryOrder", order);
                return "admin/publishOrder";
            }
            if (order.getSenderPhone() == null || order.getSenderPhone().trim().isEmpty() ||
                !order.getSenderPhone().matches("1[3-9]\\d{9}")) {
                model.addAttribute("error", "接货人电话格式不正确，请输入11位手机号码");
                model.addAttribute("deliveryOrder", order);
                return "admin/publishOrder";
            }
            if (order.getConsigneeAddress() == null || order.getConsigneeAddress().trim().isEmpty()) {
                model.addAttribute("error", "配送地址不能为空");
                model.addAttribute("deliveryOrder", order);
                return "admin/publishOrder";
            }
            if (order.getConsigneeName() == null || order.getConsigneeName().trim().isEmpty()) {
                model.addAttribute("error", "收货人姓名不能为空");
                model.addAttribute("deliveryOrder", order);
                return "admin/publishOrder";
            }
            if (order.getConsigneePhone() == null || order.getConsigneePhone().trim().isEmpty() ||
                !order.getConsigneePhone().matches("1[3-9]\\d{9}")) {
                model.addAttribute("error", "收货人电话格式不正确，请输入11位手机号码");
                model.addAttribute("deliveryOrder", order);
                return "admin/publishOrder";
            }
            if (order.getDeliveryFee() == null || order.getDeliveryFee().compareTo(BigDecimal.ZERO) <= 0) {
                model.addAttribute("error", "配送费用必须大于0");
                model.addAttribute("deliveryOrder", order);
                return "admin/publishOrder";
            }
            if (order.getGoodsType() == null || order.getGoodsType().trim().isEmpty()) {
                model.addAttribute("error", "货物类型不能为空");
                model.addAttribute("deliveryOrder", order);
                return "admin/publishOrder";
            }
            if (order.getExpectedMins() != null && order.getExpectedMins() <= 0) {
                model.addAttribute("error", "预计送达时间必须大于0小时");
                model.addAttribute("deliveryOrder", order);
                return "admin/publishOrder";
            }

            // 设置创建者ID（从session中获取当前管理员）
            User currentUser = (User) session.getAttribute("user");
            if (currentUser != null) {
                order.setCreatorId(currentUser.getUserId());
            } else {
                // 如果session中没有用户信息，设置默认的管理员ID
                // 这里假设默认管理员ID为1（系统中第一个创建的管理员）
                order.setCreatorId(1L);
            }

            // 调用服务层发布订单
            String orderId = adminService.publishOrder(order);

            // 保存订单ID到模型中，用于前端显示
            model.addAttribute("orderId", orderId);
            model.addAttribute("success", true);

            return "admin/publishOrder";
        } catch (Exception e) {
            model.addAttribute("error", "发布订单失败：" + e.getMessage());
            model.addAttribute("deliveryOrder", order);
            return "admin/publishOrder";
        }
    }

    /**
     * 获取订单详情（支持查询参数形式）
     */
    @GetMapping("/delivery-tracking/detail")
    public String trackOrderByParam(
            @RequestParam String orderId,
            Model model
    ) {
        // 添加订单ID到model中
        model.addAttribute("orderId", orderId);
        
        // 获取订单详情
        DeliveryOrder order = orderService.getOrderById(orderId);
        if (order != null) {
            model.addAttribute("order", order);
        } else {
            model.addAttribute("error", "未找到该配送单信息");
        }
        
        // 获取配送跟踪信息
        List<DeliveryTrace> deliveryTraceList = adminService.trackOrder(orderId);
        if (deliveryTraceList != null && !deliveryTraceList.isEmpty()) {
            model.addAttribute("deliveryTraceList", Result.success(deliveryTraceList));
        } else {
            model.addAttribute("errorDeliveryTrace", "未找到配送轨迹信息");
        }
        return "admin/orderTraces";
    }

    /**
     * 获取 orderId 对应订单的历史动态
     */
    @GetMapping("/track/{orderId}")
    public String trackOrder(
            @PathVariable String orderId,
            Model model
    ) {
        // 添加订单ID到model中
        model.addAttribute("orderId", orderId);
        
        // 获取订单详情
        DeliveryOrder order = orderService.getOrderById(orderId);
        if (order != null) {
            model.addAttribute("order", order);
        } else {
            model.addAttribute("error", "未找到该配送单信息");
        }
        
        // 获取配送跟踪信息
        List<DeliveryTrace> deliveryTraceList = adminService.trackOrder(orderId);
        if (deliveryTraceList != null && !deliveryTraceList.isEmpty()) {
            model.addAttribute("deliveryTraceList", Result.success(deliveryTraceList));
        } else {
            model.addAttribute("errorDeliveryTrace", "未找到配送轨迹信息");
        }
        return "admin/orderTraces";
    }

    @RequestMapping("/order/statistic")
    public String getOrderStatistic (
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startTime,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endTime,
            @RequestParam(required = false) Integer timeRange,
            Model model
    ) {
        if (startTime == null && endTime == null) {
            endTime = new Date();
            startTime = DateUtils.addDays(endTime, -7);
            timeRange = 7;
        }
        System.out.println("startTime:" + startTime);
        System.out.println("endTime:" + endTime);

        OrderStatisticsDTO orderStatistic = adminService.getOrderStatistic(startTime, endTime);
        List<OrderTrendDTO> orderTrendList = adminService.getOrderTrend(startTime, endTime);
        List<Map<String, Object>> heatmapData = adminService.getOrderAddressMap(startTime, endTime);

        System.out.println("orderStatistic: " + orderStatistic);
        System.out.println("orderTrendList: " + orderTrendList);
        System.out.println("heatmapData: " + heatmapData);

        model.addAttribute("orderStatistic", orderStatistic);
        model.addAttribute("trendList", orderTrendList);
        model.addAttribute("timeRange", timeRange);
        model.addAttribute("heatmapData", heatmapData);

        return "admin/orderStatistic";
    }

    /**
     * 账号管理首页 - 展示账号列表
     */
    @GetMapping("/accounts")
    public String accountList(
            @RequestParam(required = false) Integer role,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpServletRequest request,
            Model model
    ) {
        PageResult<User> userPageResult = adminService.queryAllUsers(role, status, keyword, page, size);
        model.addAttribute("users", userPageResult.getList());
        model.addAttribute("total", userPageResult.getTotal());
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("roles", UserRole.values());
        model.addAttribute("statuses", UserStatus.values());
        model.addAttribute("searchRole", role);
        model.addAttribute("searchStatus", status);
        model.addAttribute("keyword", keyword);
        // 使用HttpServletRequest获取success参数，避免参数解析问题
        String successParam = request.getParameter("success");
        if (successParam != null && "true".equalsIgnoreCase(successParam)) {
            model.addAttribute("success", true);
        }
        return "admin/accountList";
    }
    
    /**
     * 新增账号页面
     */
    @GetMapping("/accounts/add")
    public String addAccountPage(
            @RequestParam(required = false) Boolean success,
            @RequestParam(required = false) String message,
            Model model) {
        model.addAttribute("roles", UserRole.values());
        model.addAttribute("statuses", UserStatus.values());
        // 传递success和message参数给前端页面
        if (success != null) {
            model.addAttribute("success", success);
        }
        if (message != null) {
            model.addAttribute("message", message);
        }
        return "admin/addAccount";
    }
    
    /**
     * 保存新增账号
     */
    @PostMapping("/accounts/add")
    public String addAccount(@ModelAttribute CommonUser user, Model model) {
        try {
            // 先进行基础验证
            if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
                model.addAttribute("error", "用户名不能为空");
                model.addAttribute("roles", UserRole.values());
                model.addAttribute("statuses", UserStatus.values());
                model.addAttribute("user", user); // 保留用户输入的值
                return "admin/addAccount";
            }

            // 调用服务层创建账号
            adminService.createAccount(user);
            // 创建成功后重定向回账号管理界面，带上success参数以触发弹窗
            return "redirect:/admin/accounts?success=true";
        } catch (Exception e) {
            // 处理异常，提供友好的错误提示
            String errorMsg = "用户名已存在，请重新输入用户名";

            // 检查是否为其他类型的异常
            if (!e.getMessage().contains("用户名已存在") && !e.getMessage().contains("UNIQUE INDEX") && !e.getMessage().contains("unique constraint")) {
                errorMsg = "账号创建失败，请稍后重试";
            }

            model.addAttribute("error", errorMsg);
            model.addAttribute("roles", UserRole.values());
            model.addAttribute("statuses", UserStatus.values());
            model.addAttribute("user", user); // 保留用户输入的值
            return "admin/addAccount";
        }
    }
    
    /**
     * 编辑账号页面
     */
    @GetMapping("/accounts/edit/{id}")
    public String editAccountPage(@PathVariable Long id, Model model) {
        User user = adminService.getUserById(id);
        if (user == null) {
            model.addAttribute("error", "账号不存在");
            return "redirect:/admin/accounts";
        }
        model.addAttribute("user", user);
        model.addAttribute("roles", UserRole.values());
        model.addAttribute("statuses", UserStatus.values());
        return "admin/editAccount";
    }
    
    /**
     * 更新账号信息
     */
    @PostMapping("/accounts/edit")
    public String editAccount(CommonUser user, Model model) {
        try {
            adminService.updateAccount(user);
            model.addAttribute("message", "账号更新成功");
            return "redirect:/admin/accounts";
        } catch (Exception e) {
            model.addAttribute("error", "账号更新失败：" + e.getMessage());
            model.addAttribute("user", user);
            model.addAttribute("roles", UserRole.values());
            model.addAttribute("statuses", UserStatus.values());
            return "admin/editAccount";
        }
    }
    
    /**
     * 删除账号
     */
    @GetMapping("/accounts/delete/{id}")
    public String deleteAccount(@PathVariable Long id, RedirectAttributes redirectAttributes, HttpSession session) {
        try {
            // 获取当前登录用户
            User currentUser = (User) session.getAttribute("user");
            
            // 检查是否要删除当前登录用户
            if (currentUser != null && currentUser.getUserId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "不能删除当前登录的账号");
                return "redirect:/admin/accounts";
            }
            
            boolean success = adminService.deleteAccount(id);
            if (success) {
                redirectAttributes.addFlashAttribute("message", "账号删除成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "不能删除最后一个管理员账号或用户不存在");
            }
        } catch (Exception e) {
            // 捕获可能的数据库异常，提供友好的错误消息
            redirectAttributes.addFlashAttribute("error", "删除账号失败：" + e.getMessage());
        }
        return "redirect:/admin/accounts";
    }
    
    /**
     * 重置密码页面
     */
    @GetMapping("/accounts/resetPassword/{id}")
    public String resetPasswordPage(@PathVariable Long id, Model model) {
        model.addAttribute("userId", id);
        return "admin/resetPassword";
    }
    
    /**
     * 执行密码重置
     */
    @PostMapping("/accounts/resetPassword")
    public String resetPassword(@RequestParam Long userId, @RequestParam String newPassword, Model model) {
        try {
            adminService.resetPassword(userId, newPassword);
            model.addAttribute("message", "密码重置成功");
            return "redirect:/admin/accounts";
        } catch (Exception e) {
            model.addAttribute("error", "密码重置失败：" + e.getMessage());
            model.addAttribute("userId", userId);
            return "admin/resetPassword";
        }
    }

    @GetMapping("/api-key-list")
    public String apiKeyList(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size,
            @RequestParam(required = false) String status,
            Model model) {
        PageResult<ApiKey> apiKeys = apiKeyService.queryByPage(keyword, status, page, size);
        model.addAttribute("apiKeys", apiKeys);
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        return "admin/apiKeyList";
    }

    @PostMapping("/new-api-key")
    public String newApiKey(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "10") Integer size,
            @RequestParam(required = false) String status,
            @RequestParam String appName,
            RedirectAttributes redirectAttributes) {
        try {
            String newApiKey = apiKeyService.createNewApiKey(appName);
            redirectAttributes.addFlashAttribute("newKey", newApiKey);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", e.getMessage());
        }
        StringBuilder redirectUrl = new StringBuilder("redirect:api-key-list");
        redirectUrl.append("?page=").append(page)
                .append("&size=").append(size);
        if (keyword != null && !keyword.isEmpty()) {
            redirectUrl.append("&keyword=").append(keyword);
        }
        if (status != null && !status.isEmpty()) {
            redirectUrl.append("&status=").append(status);
        }

        return redirectUrl.toString();
//        return "admin/apiKeyList";
    }

    // TODO: 页面逻辑待优化
    @GetMapping("api-key-set-status")
    public String apiKeySetStatus(@RequestParam Long keyId, Model model) {
        apiKeyService.turnStatus(keyId);
        return "redirect:api-key-list";
    }
}
