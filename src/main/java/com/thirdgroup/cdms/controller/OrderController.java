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

    // 1. 获取获取待接单订单列表（供外卖员工作台查看）
    @GetMapping("/pending")
    public Result getPendingOrders() {
        List<DeliveryOrder> orders = orderService.getPendingOrders();
        return Result.success(orders);
    }

    // 2. 外卖员接单（参数转为Integer，与Service对齐）
    @PostMapping("/accept")
    public Result acceptOrder(
            @RequestParam Integer orderId,  // 接收Integer类型
            @RequestParam Integer courierId) {  // 与Service的courierId类型一致
        boolean success = orderService.acceptOrder(orderId, courierId);
        return success ? Result.success("接单成功") : Result.error(500, "接单失败");
    }

    // 3. 更新订单状态（orderId转为Integer，与Service对齐）
    @PostMapping("/updateStatus")
    public Result updateOrderStatus(
            @RequestParam Integer orderId,  // 接收Integer类型
            @RequestParam Integer statusCode) {
        OrderStatus targetStatus = OrderStatus.fromCode(statusCode);
        boolean success = orderService.updateOrderStatus(orderId, targetStatus);
        return success ? Result.success("状态更新成功") : Result.error(500, "状态更新失败");
    }

    // 4. 获取外卖员的配送中订单（参数转为Integer，与Service对齐）
    @GetMapping("/delivering")
    public Result getDeliveringOrders(@RequestParam Integer courierId) {  // 与Service参数类型一致
        List<DeliveryOrder> orders = orderService.getDeliveringByCourierId(courierId);
        return Result.success(orders);
    }

    // 5. 根据ID查询订单详情（orderId转为Integer，与Service对齐）
    @GetMapping("/detail")
    public Result getOrderDetail(@RequestParam Integer orderId) {  // 接收Integer类型
        DeliveryOrder order = orderService.getById(orderId);
        return order != null ? Result.success(order) : Result.error(404, "订单不存在");
    }

    // 6. 分页查询订单（补充方法，与Service扩展对齐）
    @GetMapping("/page")
    public Result getOrderPage(
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int start,
            @RequestParam(defaultValue = "10") int size) {
        // 若Service中添加了selectPage方法，需确保参数为Integer/int
        List<DeliveryOrder> orders = orderService.selectPage(status, keyword, start, size);
        return Result.success(orders);
    }

    /**
     * 高德地图api功能暂留
     */
//    @RequestMapping("/toMap")
//    public String toMap(@RequestParam("orderId") Integer orderId, Model model) {  // 参数为Integer
//        DeliveryOrder order = orderService.getById(orderId);
//        model.addAttribute("order", order);
//        return "courier/map.jsp";
//    }

}