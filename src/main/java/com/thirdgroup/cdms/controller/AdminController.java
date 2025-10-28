package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.DeliveryOrder;
import com.thirdgroup.cdms.model.DeliveryTrace;
import com.thirdgroup.cdms.model.PageResult;
import com.thirdgroup.cdms.service.Interface.AdminService;
import com.thirdgroup.cdms.utils.Result;
import io.swagger.annotations.Api;
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
}
