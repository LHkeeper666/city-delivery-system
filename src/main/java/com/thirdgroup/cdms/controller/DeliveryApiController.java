package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.ApiKey;
import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.service.Interface.AdminService;
import com.thirdgroup.cdms.service.Interface.ApiKeyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@RestController   // 等价于 @Controller + 所有方法默认 @ResponseBody
@RequestMapping("/api/admin")
public class DeliveryApiController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private ApiKeyService apiKeyService;

    @PostMapping("/publish-order")
    public ResponseEntity<?> publishOrderApi(
            @RequestBody DeliveryOrder order,
            ServletRequest servletRequest,
            ServletResponse servletResponse
    ) throws IOException {
        Map<String, Object> result = new HashMap<>();

        HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
        HttpServletResponse httpResponse = (HttpServletResponse) servletResponse;

        String apiKey = httpRequest.getHeader("X-API-KEY");
        System.out.println("X-API-KEY: " + apiKey);
        if (apiKey == null || !apiKeyService.isValid(apiKey)) {
            result.put("code", 403);
            result.put("message", "非法访问或API Key无效");
            return ResponseEntity.internalServerError().body(result);
        }

        if (order.getSenderAddress() == null || order.getSenderAddress().trim().isEmpty()) {
            result.put("code", 400);
            result.put("message", "接货地址不能为空");
            return ResponseEntity.badRequest().body(result);
        }

        if (order.getSenderPhone() == null || !order.getSenderPhone().matches("1[3-9]\\d{9}")) {
            result.put("code", 400);
            result.put("message", "接货人电话格式不正确");
            return ResponseEntity.badRequest().body(result);
        }

        if (order.getConsigneeAddress() == null || order.getConsigneeAddress().trim().isEmpty()) {
            result.put("code", 400);
            result.put("message", "配送地址不能为空");
            return ResponseEntity.badRequest().body(result);
        }

        if (order.getDeliveryFee() == null || order.getDeliveryFee().compareTo(BigDecimal.ZERO) <= 0) {
            result.put("code", 400);
            result.put("message", "配送费用必须大于0");
            return ResponseEntity.badRequest().body(result);
        }

        try {
            order.setCreatorId(1L); // 默认管理员ID
            String orderId = adminService.publishOrder(order);
            result.put("code", 200);
            result.put("message", "订单发布成功");
            result.put("orderId", orderId);
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误：" + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }
}
