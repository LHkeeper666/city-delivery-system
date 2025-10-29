package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.Deliveryman;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import com.thirdgroup.cdms.service.Interface.OrderService;
import com.thirdgroup.cdms.utils.Result;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.List;

@RestController
@RequestMapping("/order")
public class OrderController {

    @Resource
    private OrderService orderService;

    // 1. 接单接口：orderId从Long改为String（核心修改）
    @PostMapping("/accept")
    public Result<?> acceptOrder(@RequestParam String orderId, HttpSession session) { // Long → String
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return Result.error(401, "未登录，请先登录");
        }
        try {
            boolean success = orderService.acceptOrder(orderId, deliveryman.getUserId()); // 同步传String
            return success ? Result.success("接单成功") : Result.error(400, "接单失败");
        } catch (RuntimeException e) {
            return Result.error(400, e.getMessage());
        }
    }

    // 2. 更新订单状态：orderId从Long改为String（核心修改）
    @PostMapping("/updateStatus")
    public Result<?> updateOrderStatus(
            @RequestParam String orderId, // Long → String
            @RequestParam Integer statusCode,
            HttpSession session
    ) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return Result.error(401, "未登录");
        }

        OrderStatus targetStatus = OrderStatus.getByCode(statusCode);
        if (targetStatus == null) {
            return Result.error(400, "无效的订单状态");
        }

        try {
            boolean success = orderService.updateOrderStatus(
                    orderId, // 传String
                    targetStatus,
                    deliveryman.getUserId()
            );
            return success ? Result.success("状态更新成功") : Result.error(500, "更新失败");
        } catch (RuntimeException e) {
            return Result.error(400, e.getMessage());
        }
    }

    // 3. 其他方法保持不变（确保参数类型统一为Long）
    @GetMapping("/pending")
    public Result<List<DeliveryOrder>> getPendingOrders() {
        return Result.success(orderService.getPendingOrders());
    }

    @GetMapping("/myDelivering")
    public Result<List<DeliveryOrder>> getMyDeliveringOrders(HttpSession session) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return Result.error(401, "未登录");
        }
        return Result.success(orderService.getMyOrders(deliveryman.getUserId()));
    }

    // 4. 获取订单详情：orderId从Long改为String
    @GetMapping("/detail")
    public Result<DeliveryOrder> getOrderDetail(@RequestParam String orderId) { // Long → String
        DeliveryOrder order = orderService.getOrderById(orderId); // 传String
        return order != null ? Result.success(order) : Result.error(404, "订单不存在");
    }
}