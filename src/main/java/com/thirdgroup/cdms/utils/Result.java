package com.thirdgroup.cdms.utils;

public class Result<T> {
    // 状态码：200=成功，400=参数错误，500=服务器错误等
    private int code;
    // 提示消息（如“登录成功”“用户名不存在”）
    private String msg;
    // 业务数据（如登录成功后的用户信息、订单列表等）
    private T data;

    // 构造方法和getter/setter
    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.code = 200;
        result.msg = "操作成功";
        result.data = data;
        return result;
    }

    public static <T> Result<T> error(int code, String msg) {
        Result<T> result = new Result<>();
        result.code = code;
        result.msg = msg;
        return result;
    }
}