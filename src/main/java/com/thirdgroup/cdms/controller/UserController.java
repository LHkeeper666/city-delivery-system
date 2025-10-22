package com.thirdgroup.cdms.controller;

import com.thirdgroup.cdms.model.User;
import io.swagger.annotations.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.thirdgroup.cdms.service.Interface.UserService;
@RestController
@RequestMapping("/api")
@Api(tags = "用户管理")
public class UserController {
    @GetMapping("/users/{id}")
    @ApiOperation("获取用户详情")
    @ApiResponses({
            @ApiResponse(code = 200, message = "成功获取用户信息"),
            @ApiResponse(code = 404, message = "用户不存在")
    })
    public User getUser(@ApiParam("用户ID") @PathVariable Long id) {
        return UserService.findById(id);
    }
}