package com.thirdgroup.cdms.utils;

// 响应结果工具类：仅负责封装接口返回数据，不包含业务逻辑
public class Result<T> {
    private int code;       // 状态码：200=成功，400=参数错误，500=服务器错误等
    private String msg;     // 提示消息
    private T data;         // 业务数据

    // 成功响应（带数据）
    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.code = 200;
        result.msg = "操作成功";
        result.data = data;
        return result;
    }

    // 错误响应
    public static <T> Result<T> error(int code, String msg) {
        Result<T> result = new Result<>();
        result.code = code;
        result.msg = msg;
        return result;
    }

    // Getter和Setter（必须添加，否则JSON序列化失败）
    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}