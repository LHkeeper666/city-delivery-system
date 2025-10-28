package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.Deliveryman;
import com.thirdgroup.cdms.model.enums.DeliverymanStatus;
import com.thirdgroup.cdms.service.Interface.DeliveryManService;
import com.thirdgroup.cdms.service.Interface.OrderService;
import com.thirdgroup.cdms.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
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
    private OrderService deliveryOrderService; // 订单Service（统一注入，避免重复声明）

    // 1. 跳转【外卖员登录页】
    @GetMapping("/toLogin")
    public String toLogin() {
        return "deliveryman/deliverymanLogin";
    }

    // 2. 跳转【忘记密码页】
    @GetMapping("/toForgotPassword")
    public String toForgotPassword() {
        return "deliveryman/deliverymanForgotPassword";
    }

    // 3. 登录接口（验证+Session存储）
    @PostMapping("/login")
    public void login(
            @RequestParam String phone,
            @RequestParam String password,
            HttpSession session,
            HttpServletResponse response) throws IOException {
        Deliveryman deliveryman = deliverymanService.login(phone, password);
        if (deliveryman != null) {
            // 登录成功：存储用户信息到Session，跳转工作台
            session.setAttribute("deliveryman", deliveryman);
            // 移除冗余的user存储（避免后续取值混淆，统一用deliveryman）
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/workbench");
        } else {
            // 登录失败：返回登录页带错误标识
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/toLogin?error=1");
        }
    }

    // 4. 跳转【外卖员工作台】（核心：传递订单数据+状态数据）
    @GetMapping("/workbench")
    public String toWorkbench(HttpSession session, Model model) {
        // 未登录拦截：跳转登录页
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return "redirect:/deliveryman/toLogin";
        }

        // 传递订单数据到JSP（待接订单+我的订单）
        List<DeliveryOrder> pendingOrders = deliveryOrderService.getPendingOrders(); // 待接单（状态=0）
        List<DeliveryOrder> myOrders = deliveryOrderService.getMyOrders(deliveryman.getUserId()); // 我的在途订单（状态=1）
        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("myOrders", myOrders);

        // 传递当前用户状态到JSP（可选，也可直接在JSP通过${deliveryman}获取）
        model.addAttribute("currentStatus", deliveryman.getWorkStatusEnum());

        return "deliveryman/deliverymanWorkbench";
    }

    // 5. 退出登录（销毁Session）
    @GetMapping("/logout")
    public void logout(HttpSession session, HttpServletResponse response) throws IOException {
        // 退出前可设置状态为离线（可选，优化用户体验）
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman != null) {
            deliverymanService.setWorkStatus(deliveryman.getUserId(), DeliverymanStatus.OFFLINE);
        }
        // 销毁Session，跳转登录页
        session.invalidate();
        response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/toLogin");
    }

    // 6. 检查手机号是否存在（注册/忘记密码用）
    @GetMapping("/checkPhone")
    @ResponseBody
    public Result<?> checkPhone(@RequestParam String phone) {
        boolean exists = deliverymanService.existsByPhone(phone);
        return exists ? Result.error(400, "该手机号已注册") : Result.success(null);
    }

    // 7. 重置密码接口（返回JSON结果）
    @PostMapping("/resetPassword")
    @ResponseBody
    public Result<?> resetPassword(
            @RequestParam String phone,
            @RequestParam String newPwd,
            @RequestParam String confirmPwd) {
        // 密码一致性校验
        if (!newPwd.equals(confirmPwd)) {
            return Result.error(400, "两次密码不一致");
        }
        // 调用Service重置密码（已加密）
        boolean success = deliverymanService.resetPassword(phone, newPwd);
        return success ? Result.success("密码重置成功") : Result.error(500, "重置失败，请检查手机号");
    }

    // 8. 获取当前登录用户信息（前端异步请求用）
    @GetMapping("/current")
    @ResponseBody
    public Result<Deliveryman> getCurrent(HttpSession session) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        return deliveryman != null ? Result.success(deliveryman) : Result.error(401, "未登录");
    }

    // 9. 跳转【外卖员注册页】
    @GetMapping("/toRegister")
    public String toRegister() {
        return "deliveryman/deliverymanRegister";
    }

    // 10. 处理【注册提交】（含用户名/手机号/密码校验）
    @PostMapping("/register")
    public void register(
            @RequestParam String username,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam String confirmPwd,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        String contextPath = request.getContextPath();

        // 1. 用户名校验（非空+长度3-20位）
        if (username == null || username.trim().length() < 3 || username.trim().length() > 20) {
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=3");
            return;
        }

        // 2. 用户名唯一性校验
        if (deliverymanService.checkUsernameExists(username.trim())) {
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=5");
            return;
        }

        // 3. 密码一致性校验
        if (!password.equals(confirmPwd)) {
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=1");
            return;
        }

        // 4. 手机号唯一性校验
        if (deliverymanService.existsByPhone(phone)) {
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=2");
            return;
        }

        // 5. 调用Service完成注册（密码已加密）
        boolean registerSuccess = deliverymanService.register(username.trim(), phone, password);
        if (registerSuccess) {
            // 注册成功：跳转登录页带成功标识
            response.sendRedirect(contextPath + "/deliveryman/toLogin?success=1");
        } else {
            // 注册失败：返回注册页带错误标识
            response.sendRedirect(contextPath + "/deliveryman/toRegister?error=4");
        }
    }

    // 11. 跳转【个人中心页】
    @GetMapping("/toProfile")
    public String toProfile(HttpSession session, Model model) {
        // 未登录拦截
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return "redirect:/deliveryman/toLogin";
        }
        // 传递用户信息到个人中心JSP
        model.addAttribute("deliveryman", deliveryman);
        return "deliveryman/deliverymanProfile";
    }

    // 12. 跳转【订单地图详情页】
    @GetMapping("/toOrderMap")
    public String toOrderMap(@RequestParam("orderId") Long orderId, Model model, HttpSession session) {
        // 未登录拦截
        if (session.getAttribute("deliveryman") == null) {
            return "redirect:/deliveryman/toLogin";
        }
        // 查订单详情（传递到地图JSP）
        DeliveryOrder order = deliveryOrderService.getOrderById(orderId);
        model.addAttribute("order", order);
        return "deliveryman/deliverymanMap";
    }

    // 13. 切换配送员状态（核心修改：补充跳转逻辑，适配前端POST）
    @PostMapping("/setStatus")
    public void setWorkStatus(
            @RequestParam Integer statusCode,
            HttpSession session,
            HttpServletResponse response) throws IOException { // 新增response用于跳转
        // 未登录校验（原有逻辑不变）
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            // 未登录：跳转登录页
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/toLogin?error=1");
            return;
        }

        // 转换状态码（原有逻辑不变）
        DeliverymanStatus status = DeliverymanStatus.getByCode(statusCode);
        boolean success = deliverymanService.setWorkStatus(deliveryman.getUserId(), status);

        if (success) {
            // 状态更新成功：刷新Session中的用户状态（避免页面显示旧状态）
            deliveryman.setWorkStatus(status.getCode());
            session.setAttribute("deliveryman", deliveryman);
            // 跳转回工作台（带成功提示，可选）
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/workbench?success=1");
        } else {
            // 失败：跳转回工作台（带错误提示）
            response.sendRedirect(session.getServletContext().getContextPath() + "/deliveryman/workbench?error=2");
        }
    }
}