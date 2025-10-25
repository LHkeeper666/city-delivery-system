<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>外卖员登录 - 城市配送系统</title>
    <!-- 引入Bootstrap样式，优化移动端适配 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .login-container { max-width: 400px; margin: 80px auto; padding: 20px; border: 1px solid #eee; border-radius: 8px; }
        .error提示 { color: #d9534f; margin-top: 10px; display: <c:if test="${not empty errorMsg}">block</c:if><c:if test="${empty errorMsg}">none</c:if>; }
    </style>
</head>
<body>
<div class="container login-container">
    <h3 class="text-center">外卖员登录</h3>
    <!-- 登录表单：提交到CourierLoginServlet处理 -->
    <form action="${pageContext.request.contextPath}/courier/login" method="post" class="mt-3">
        <!-- 账号输入框 -->
        <div class="form-group">
            <label for="courierId">外卖员ID</label>
            <input type="text" id="courierId" name="courierId" class="form-control"
                   value="${cookie.courierId.value}" required placeholder="请输入您的工号">
        </div>
        <!-- 密码输入框 -->
        <div class="form-group">
            <label for="password">密码</label>
            <input type="password" id="password" name="password" class="form-control" required placeholder="请输入密码">
        </div>
        <!-- 验证码 -->
        <div class="form-group">
            <div class="row">
                <div class="col-xs-7">
                    <input type="text" name="verifyCode" class="form-control" required placeholder="请输入验证码">
                </div>
                <div class="col-xs-5">
                    <!-- 验证码图片：点击刷新 -->
                    <img src="${pageContext.request.contextPath}/verifyCode"
                         alt="验证码" style="cursor: pointer;" onclick="this.src='${pageContext.request.contextPath}/verifyCode?'+Math.random()">
                </div>
            </div>
        </div>
        <!-- 错误提示 -->
        <div class="error提示 text-center">${errorMsg}</div>
        <!-- 登录按钮 -->
        <button type="submit" class="btn btn-primary btn-block">登录</button>
        <!-- 忘记密码链接 -->
        <div class="text-center mt-2">
            <a href="${pageContext.request.contextPath}/courier/forgotPassword.jsp">忘记密码？</a>
        </div>
    </form>
</div>

<!-- 引入BootstrapJS，支持表单验证等交互 -->
<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>