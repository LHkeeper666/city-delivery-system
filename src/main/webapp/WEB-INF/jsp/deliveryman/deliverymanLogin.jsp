<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>外卖员登录</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .login-box { width: 300px; margin: 100px auto; padding: 20px; border: 1px solid #ddd; }
        .error { color: red; margin: 10px 0; }
    </style>
</head>
<body>
<div class="login-box">
    <h2 class="text-center">外卖员登录</h2>

    <!-- 登录错误提示 -->
    <c:if test="${param.error == '1'}">
        <div class="error text-center">手机号或密码错误，请重新输入</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/deliveryman/login">
        <div class="form-group">
            <label>手机号</label>
            <input type="tel" name="phone" class="form-control"
                   placeholder="请输入登录手机号" required>
        </div>
        <div class="form-group">
            <label>密码</label>
            <input type="password" name="password" class="form-control"
                   placeholder="请输入密码" required>
        </div>
        <button type="submit" class="btn btn-primary btn-block">登录</button>
        <div class="text-center mt-2">
            <a href="${pageContext.request.contextPath}/deliveryman/toForgotPassword">忘记密码？</a>
            <span style="margin: 0 10px;">|</span>
            <a href="${pageContext.request.contextPath}/deliveryman/toRegister">还没账号？去注册</a>
        </div>
    </form>
</div>

<script>
    // 自动填充上次登录的手机号（可选功能）
    window.onload = function() {
        const cookies = document.cookie.split(';');
        for (let cookie of cookies) {
            const [name, value] = cookie.trim().split('=');
            if (name === 'deliverymanPhone') {
                document.querySelector('input[name="phone"]').value = decodeURIComponent(value);
                break;
            }
        }
    };
</script>
</body>
</html>