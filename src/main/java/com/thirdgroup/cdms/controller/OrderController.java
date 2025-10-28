package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.Deliveryman;
import com.thirdgroup.cdms.model.enums.OrderStatus;
import com.thirdgroup.cdms.service.Interface.OrderService;
import com.thirdgroup.cdms.utils.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 订单控制器：处理订单查询、状态更新等请求
 */
@RestController
@RequestMapping("/order")
public class OrderController {

    @Resource
    private OrderService orderService;

    // 从配置文件读取高德地图API密钥（推荐配置在application.properties中，暂不启用）
    // @Value("${amap.key}")
    // private String amapKey;

    // 1. 获取待接单订单列表（供外卖员工作台查看）
    @GetMapping("/pending")
    public Result<List<DeliveryOrder>> getPendingOrders() {
        List<DeliveryOrder> orders = orderService.getPendingOrders();
        return Result.success(orders);
    }

    // 2. 外卖员接单
    @PostMapping("/accept")
    public Result<?> acceptOrder(@RequestParam Long orderId, HttpSession session) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return Result.error(401, "未登录，请先登录");
        }
        boolean success = orderService.acceptOrder(orderId, deliveryman.getUserId());
        return success ? Result.success("接单成功") : Result.error(400, "接单失败，订单可能已被抢");
    }

    // 3. 更新订单状态（完成/取消订单）
    @PostMapping("/updateStatus")
    public Result<?> updateOrderStatus(
            @RequestParam Long orderId,
            @RequestParam Integer statusCode
            // 可选：更新状态时的经纬度（地图功能用，暂不启用）
            // @RequestParam(required = false) Double longitude,
            // @RequestParam(required = false) Double latitude
    ) {
        OrderStatus targetStatus = OrderStatus.getByCode(statusCode);
        if (targetStatus == null) {
            return Result.error(400, "无效的订单状态");
        }
        // 这里可以扩展：保存订单状态更新时的位置信息（需在Service和Mapper中添加对应字段，暂不启用）
        boolean success = orderService.updateOrderStatus(orderId, targetStatus);
        return success ? Result.success("状态更新成功") : Result.error(500, "状态更新失败");
    }

    // 4. 获取外卖员的配送中订单（调用Service的getMyOrders方法）
    @GetMapping("/myDelivering")
    public Result<List<DeliveryOrder>> getMyDeliveringOrders(HttpSession session) {
        Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
        if (deliveryman == null) {
            return Result.error(401, "未登录");
        }
        List<DeliveryOrder> orders = orderService.getMyOrders(deliveryman.getUserId());
        return Result.success(orders);
    }

    // 5. 根据ID查询订单详情（调用Service的getOrderById方法）
    @GetMapping("/detail")
    public Result<DeliveryOrder> getOrderDetail(@RequestParam Long orderId) {
        DeliveryOrder order = orderService.getOrderById(orderId);
        return order != null ? Result.success(order) : Result.error(404, "订单不存在");
    }

    // 6. 分页查询订单（管理员/统计功能用）
    @GetMapping("/page")
    public Result<List<DeliveryOrder>> getOrderPage(
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int start,
            @RequestParam(defaultValue = "10") int size) {
        List<DeliveryOrder> orders = orderService.selectPage(status, keyword, start, size);
        return Result.success(orders);
    }

    // 7. 高德地图api 还没实现（暂时注释，后续启用）
    // // 高德地图相关接口：获取地图初始化参数（密钥+订单位置）
    // @GetMapping("/map/init")
    // public Result<Map<String, Object>> initMap(@RequestParam Long orderId, HttpSession session) {
    //     // 1. 校验登录
    //     Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
    //     if (deliveryman == null) {
    //         return Result.error(401, "未登录");
    //     }
    //     // 2. 获取订单详情（包含发货地址和收货地址）
    //     DeliveryOrder order = orderService.getOrderById(orderId);
    //     if (order == null) {
    //         return Result.error(404, "订单不存在");
    //     }
    //     // 3. 构建地图初始化参数
    //     Map<String, Object> mapData = new HashMap<>();
    //     mapData.put("amapKey", amapKey);  // 高德地图密钥
    //     mapData.put("orderId", orderId);
    //     mapData.put("senderAddress", order.getSenderAddress());  // 发货地址
    //     mapData.put("consigneeAddress", order.getConsigneeAddress());  // 收货地址
    //     // 扩展：如果存储了经纬度，直接返回经纬度
    //     // mapData.put("senderLng", order.getSenderLongitude());
    //     // mapData.put("senderLat", order.getSenderLatitude());
    //     // mapData.put("consigneeLng", order.getConsigneeLongitude());
    //     // mapData.put("consigneeLat", order.getConsigneeLatitude());
    //     return Result.success(mapData);
    // }

    // // 8. 实时更新配送位置（供地图页定时调用，暂时注释）
    // @PostMapping("/map/updateLocation")
    // public Result<?> updateDeliveryLocation(
    //         @RequestParam Long orderId,
    //         @RequestParam Double longitude,
    //         @RequestParam Double latitude,
    //         HttpSession session) {
    //     Deliveryman deliveryman = (Deliveryman) session.getAttribute("deliveryman");
    //     if (deliveryman == null) {
    //         return Result.error(401, "未登录");
    //     }
    //     // 这里可以扩展：将位置信息更新到订单表或单独的位置表（暂时注释）
    //     // boolean success = orderService.updateDeliveryLocation(orderId, deliveryman.getUserId(), longitude, latitude);
    //     return Result.success("位置更新成功");
    // }
}