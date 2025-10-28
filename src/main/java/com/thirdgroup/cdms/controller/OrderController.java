package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import com.thirdgroup.cdms.service.Interface.OrderService;
import com.thirdgroup.cdms.utils.Result;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 订单控制器：处理订单查询、状态更新等请求
 */
@RestController
@RequestMapping("/order")
public class OrderController {

    @Resource
    private OrderService orderService;

    // 1. 获取待接单订单列表（供外卖员工作台查看）
    @GetMapping("/pending")
    public Result getPendingOrders() {
        List<DeliveryOrder> orders = orderService.getPendingOrders();
        return Result.success(orders);
    }

    // 2. 外卖员接单
    @PostMapping("/accept")
    public Result acceptOrder(
            @RequestParam String orderId,
            @RequestParam Long deliverymanId) {
        return orderService.acceptOrder(orderId, deliverymanId);
    }

    // 3. 更新订单状态（取餐/送达）
    @PostMapping("/updateStatus")
    public Result updateOrderStatus(
            @RequestParam String orderId,
            @RequestParam Integer statusCode) {
        // 将状态码转换为枚举（避免前端直接传递枚举名称）
        OrderStatus targetStatus = OrderStatus.fromCode(statusCode);
        return orderService.updateOrderStatus(orderId, targetStatus);
    }

    // 4. 获取外卖员的配送中订单
    @GetMapping("/delivering")
    public Result getDeliveringOrders(@RequestParam Long deliverymanId) {
        List<DeliveryOrder> orders = orderService.getDeliveringByCourierId(deliverymanId);
        return Result.success(orders);
    }

    // 5. 根据ID查询订单详情
    @GetMapping("/detail")
    public Result getOrderDetail(@RequestParam String orderId) {
        DeliveryOrder order = orderService.getById(orderId);
        return order != null ? Result.success(order) : Result.error(404, "订单不存在");
    }

    // 6. 分页查询订单（支持多条件筛选）
    @GetMapping("/page")
    public Result getOrderPage(
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int start,
            @RequestParam(defaultValue = "10") int size) {
        List<DeliveryOrder> orders = orderService.selectPage(status, keyword, start, size);
        return Result.success(orders);
    }

    /**
     * 高德地图api功能暂留
     * @param orderId
     * @param model
     * @return
     */
//    @RequestMapping("/toMap")
//    public String toMap(@RequestParam("orderId") Integer orderId, Model model) {
//        // 查订单详情传给页面
//        DeliveryOrder order = orderService.getById(orderId);
//        model.addAttribute("order", order);
//        return "courier/map.jsp";
//    }

}