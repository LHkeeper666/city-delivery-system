package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.Deliveryman;
import com.thirdgroup.cdms.model.OrderStatisticsDTO;
import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import com.thirdgroup.cdms.service.Interface.DeliveryManService;
import com.thirdgroup.cdms.service.Interface.OrderService;
import com.thirdgroup.cdms.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/deliveryman")
public class DeliverymanController {

    @Resource
    private DeliveryManService deliverymanService;

    @Autowired
    private OrderService deliveryOrderService;

    // 1. 跳转【外卖员登录页】（不变）
    @GetMapping("/toLogin")
    public String toLogin() {
        return "deliveryman/deliverymanLogin";
    }

    // 2. 跳转【游客忘记密码页】（不变）
    @GetMapping("/toForgotPassword")
    public String toForgotPassword() {
        return "deliveryman/deliverymanForgotPassword";
    }

    // 3. 跳转【登录后修改密码页】（不变）
    @GetMapping("/toResetPassword")
    public String toResetPassword(HttpSession session, Model model) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return "redirect:/deliveryman/toLogin";
        }
        model.addAttribute("deliveryman", deliveryman);
        return "deliveryman/deliverymanResetPassword";
    }

    // 4. 登录接口（不变）
    @PostMapping("/login")
    public void login(
            @RequestParam String phone,
            @RequestParam String password,
            HttpSession session,
            HttpServletResponse response) throws IOException {
        Deliveryman deliveryman = deliverymanService.login(phone, password);
        if (deliveryman != null) {
            session.setAttribute("deliveryman", deliveryman);
            // 保存手机号到cookie，实现记忆用户名功能
            Cookie cookie = new Cookie("deliverymanPhone", phone);
            cookie.setPath(session.getServletContext().getContextPath());
            cookie.setMaxAge(7 * 24 * 60 * 60); // 7天有效期
            response.addCookie(cookie);
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/workbench");
        } else {
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/toLogin?error=1");
        }
    }

    // 5. 跳转【外卖员工作台】
    @GetMapping("/workbench")
    public String toWorkbench(HttpSession session, Model model) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return "redirect:/deliveryman/toLogin";
        }

        List<DeliveryOrder> pendingOrders = deliveryOrderService.getPendingOrders();
        List<DeliveryOrder> myOrders = deliveryOrderService.getMyOrders(deliveryman.getUserId());
        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("myOrders", myOrders);
        model.addAttribute("currentStatus", deliveryman.getWorkStatusEnum());

        return "deliveryman/deliverymanWorkbench";
    }

    // 6. 退出登录（不变）
    @GetMapping("/logout")
    public void logout(HttpSession session, HttpServletResponse response) throws IOException {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman != null) {
            deliverymanService.setWorkStatus(deliveryman.getUserId(), DeliverymanStatus.OFFLINE);
        }
        session.invalidate();
        response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/toLogin");
    }

    // 7. 检查手机号是否存在（不变）
    @GetMapping("/checkPhone")
    @ResponseBody
    public Result<?> checkPhone(@RequestParam String phone) {
        boolean exists = deliverymanService.existsByPhone(phone);
        return exists ? Result.error(400, "该手机号已注册") : Result.success(null);
    }

    // 8. 重置密码接口（返回JSON）
    @PostMapping("/resetPassword")
    @ResponseBody
    public Result<?> resetPassword(
            @RequestParam String phone,
            @RequestParam String newPwd,
            @RequestParam String confirmPwd,
            HttpSession session) {
        if (!newPwd.equals(confirmPwd)) {
            return Result.error(400, "两次密码不一致");
        }
        Deliveryman loginUser = (Deliveryman) session.getAttribute("deliveryman");
        if (loginUser != null && !loginUser.getPhoneNo().equals(phone)) {
            return Result.error(400, "只能修改当前登录账号的密码");
        }
        boolean success = deliverymanService.resetPassword(phone, newPwd);
        if (success) {
            if (loginUser != null) {
                loginUser.setPassword(newPwd);
                session.setAttribute("deliveryman", loginUser);
            }
            return Result.success("密码重置成功");
        } else {
            return Result.error(400, "重置失败，请检查手机号");
        }
    }

    // 9. 获取当前登录用户信息（不变）
    @GetMapping("/current")
    @ResponseBody
    public Result<Deliveryman> getCurrent(HttpSession session) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        return deliveryman != null ? Result.success(deliveryman) : Result.error(401, "未登录");
    }

    // 10. 跳转【外卖员注册页】（不变）
    @GetMapping("/toRegister")
    public String toRegister() {
        return "deliveryman/deliverymanRegister";
    }

    // 11. 处理注册提交（不变）
    @PostMapping("/register")
    public void register(
            @RequestParam String username,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam String confirmPwd,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        String contextPath = request.getContextPath();

        if (username == null || username.trim().length() < 3 || username.trim().length() > 20) {
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=3");
            return;
        }
        if (deliverymanService.checkUsernameExists(username.trim())) {
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=5");
            return;
        }
        if (!password.equals(confirmPwd)) {
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=1");
            return;
        }
        if (deliverymanService.existsByPhone(phone)) {
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=2");
            return;
        }

        boolean registerSuccess = deliverymanService.register(username.trim(), phone, password);
        if (registerSuccess) {
            response.sendRedirect(contextPath + "/deliveryman/toLogin?success=1");
        } else {
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=4");
        }
    }

    // 12. 跳转【个人中心页】（不变）
    @GetMapping("/toProfile")
    public String toProfile(HttpSession session, Model model) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return "redirect:/deliveryman/toLogin";
        }
        model.addAttribute("deliveryman", deliveryman);
        return "deliveryman/deliverymanProfile";
    }

    // 13. 跳转【订单地图详情页】：Long → String（核心修改）
    @GetMapping("/toOrderMap")
    public String toOrderMap(
            @RequestParam("orderId") String orderId, // Long → String
            Model model,
            HttpSession session) {
        if (session.getAttribute("deliveryman") == null) {
            return "redirect:/deliveryman/toLogin";
        }
        DeliveryOrder order = deliveryOrderService.getOrderById(orderId); // 传String
        model.addAttribute("order", order);
        return "deliveryman/deliverymanMap";
    }

    // 14. 切换配送员工作状态（不变）
    @PostMapping("/setStatus")
    public void setWorkStatus(
            @RequestParam Integer statusCode,
            HttpSession session,
            HttpServletResponse response) throws IOException {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/toLogin?error=1");
            return;
        }

        DeliverymanStatus status = DeliverymanStatus.getByCode(statusCode);
        boolean success = deliverymanService.setWorkStatus(deliveryman.getUserId(), status);

        if (success) {
            deliveryman.setWorkStatus(status.getCode());
            session.setAttribute("deliveryman", deliveryman);
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/workbench?success=1");
        } else {
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/workbench?error=2");
        }
    }

    // 15. 跳转【历史订单页】（不变）
    @GetMapping("/toHistoryOrders")
    public String toHistoryOrders(HttpSession session, Model model) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return "redirect:/deliveryman/toLogin";
        }

        List<DeliveryOrder> historyOrders = deliveryOrderService.getHistoryOrders(
                deliveryman.getUserId(),
                OrderStatus.COMPLETED.getCode(),
                OrderStatus.CANCELLED.getCode()
        );
        model.addAttribute("historyOrders", historyOrders);
        return "deliveryman/deliverymanOrderHistory";
    }

    // 16. 跳转【订单详情页】：Long → String（核心修改）
    // 补充：历史订单查看详情接口（路径与JSP一致）
    @GetMapping("/toOrderDetail") // 关键：路径必须是/deliveryman/orderDetail
    public String toOrderDetail(
            @RequestParam String orderId, // 接收String类型orderId（匹配数据库VARCHAR）
            HttpSession session,
            Model model) {
        // 1. 登录校验：未登录跳登录页
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return "redirect:/deliveryman/toLogin";
        }

        // 2. 查询订单详情（调用OrderService，确保Service的getOrderById参数是String）
        DeliveryOrder order = deliveryOrderService.getOrderById(orderId);
        if (order == null) {
            model.addAttribute("errorMsg", "订单不存在或已被删除");
            return "deliveryman/deliverymanWorkbench"; // 订单不存在返回工作台
        }

        // 3. 权限校验：只能查看自己的订单
        if (!deliveryman.getUserId().equals(order.getDeliverymanId())) {
            model.addAttribute("errorMsg", "无权查看他人订单");
            return "deliveryman/deliverymanWorkbench";
        }

        // 4. 传递订单数据和配送员信息到详情页JSP
        model.addAttribute("order", order);
        model.addAttribute("deliveryman", deliveryman); // 将配送员信息添加到model中，用于工作状态验证
        return "deliveryman/deliverymanOrderDetail"; // 跳订单详情页（确保该JSP存在）
    }
    // 17. 修改手机号接口（不变）
    @PostMapping("/updatePhone")
    @ResponseBody
    public Result<?> updatePhone(
            @RequestParam String newPhone,
            @RequestParam String confirmPhone,
            HttpSession session) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return Result.error(401, "未登录，请先登录");
        }
        if (!newPhone.equals(confirmPhone)) {
            return Result.error(400, "两次输入的手机号不一致");
        }
        boolean success = deliverymanService.updatePhone(deliveryman.getUserId(), newPhone);
        if (success) {
            deliveryman.setPhoneNo(newPhone);
            session.setAttribute("deliveryman", deliveryman);
            return Result.success("手机号修改成功");
        } else {
            return Result.error(400, "手机号修改失败，可能已被占用或格式错误");
        }
    }
    // 18. 获取当前外卖员的订单统计信息（新增）
    @GetMapping("/stats")
    @ResponseBody
    public Result<OrderStatisticsDTO> getDeliverymanStats(HttpSession session) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return Result.error(401, "未登录，请先登录");
        }

        OrderStatisticsDTO stats = deliverymanService.getCurrentStats(deliveryman.getUserId());

        if (stats == null) {
            stats = new OrderStatisticsDTO();
        }

        return Result.success(stats);

    }

}