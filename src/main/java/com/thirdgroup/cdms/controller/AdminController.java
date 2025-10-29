package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.DeliveryTrace;
import com.thirdgroup.cdms.model.PageResult;
import com.thirdgroup.cdms.model.User;
import com.thirdgroup.cdms.model.CommonUser;
import com.thirdgroup.cdms.model.enums.UserRole;
import com.thirdgroup.cdms.model.enums.UserStatus;
import com.thirdgroup.cdms.service.Interface.AdminService;
import com.thirdgroup.cdms.utils.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Api(tags = "管理接口")
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    /**
     * 查询所有订单
     * TODO: 页面大小暂时定为10，后续考虑在配置文件中配置
     */
    @PostMapping("/orders")
//    @ResponseBody // 测试用
    public String queryOrders(
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long id,
            Model model
    ) {
        PageResult<DeliveryOrder> deliveryOrderPageResult = adminService.queryAllOrders(status, keyword, page, size, id);

        model.addAttribute("deliveryOrders", Result.success(deliveryOrderPageResult));

        // TODO: jsp名称不确定
//        return deliveryOrderPageResult.getList().get(0).getConsigneeAddress();
        return null;
    }

    /**
     * 获取 orderId 对应订单的历史动态
     */
    @GetMapping("/track/{orderId}")
//    @ResponseBody // 测试用
    public String trackOrder(
            @PathVariable String orderId,
            Model model
    ) {
        List<DeliveryTrace> deliveryTraceList = adminService.trackOrder(orderId);
        if (deliveryTraceList != null && !deliveryTraceList.isEmpty()) {
//            System.out.println("traceList: " + deliveryTraceList);
            model.addAttribute("deliveryTraceList", Result.success(deliveryTraceList));
        } else {
            // TODO: 不确定
//            model.addAttribute("errorMsg", Result.error());
        }


        // TODO: jsp名称不确定
        return null;
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
        return "admin/accountList";
    }
    
    /**
     * 新增账号页面
     */
    @GetMapping("/accounts/add")
    public String addAccountPage(Model model) {
        model.addAttribute("roles", UserRole.values());
        model.addAttribute("statuses", UserStatus.values());
        return "admin/addAccount";
    }
    
    /**
     * 保存新增账号
     */
    @PostMapping("/accounts/add")
    public String addAccount(CommonUser user, Model model) {
        try {
            adminService.createAccount(user);
            model.addAttribute("message", "账号创建成功");
            return "redirect:/admin/accounts";
        } catch (Exception e) {
            model.addAttribute("error", "账号创建失败：" + e.getMessage());
            model.addAttribute("roles", UserRole.values());
            model.addAttribute("statuses", UserStatus.values());
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
    public String deleteAccount(@PathVariable Long id, Model model) {
        boolean success = adminService.deleteAccount(id);
        if (success) {
            model.addAttribute("message", "账号删除成功");
        } else {
            model.addAttribute("error", "不能删除最后一个管理员账号");
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
}
