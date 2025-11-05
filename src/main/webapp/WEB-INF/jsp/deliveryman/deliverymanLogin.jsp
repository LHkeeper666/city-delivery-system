<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>外卖员登录 - 同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            background-color: #f7f7f7;
        }
        .navbar {
            border-radius: 0;
        }
        .login-box {
            width: 100%;
            max-width: 400px;
            padding: 40px;
            border-radius: 8px;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            margin: auto;
        }
        .error {
            color: red;
            margin: 10px 0;
        }
        .btn-primary {
            background-color: #34a853;
            border-color: #34a853;
        }
        .btn-primary:hover {
            background-color: #2a8b4f;
            border-color: #2a8b4f;
        }
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-inverse">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="<c:url value='/'/>">同城配送系统</a>
        </div>
        <ul class="nav navbar-nav">
            <li><a href="<c:url value='/'/>">首页</a></li>
            <li><a href="<c:url value='/deliveryman/toLogin'/>">外卖员登录</a></li>
            <li><a href="<c:url value='/admin/login'/>">管理员页面</a></li>
            <!-- Add other page links as needed -->
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="#">欢迎，用户</a></li>
            <li><a href="<c:url value='/deliveryman/logout'/>">退出登录</a></li>
        </ul>
    </div>
</nav>

<div class="login-box">
    <h2>外卖员登录</h2>

    <!-- 登录错误提示 -->
    <c:if test="${param.error == '1'}">
        <div class="error">手机号或密码错误，请重新输入</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/deliveryman/login">
        <div class="form-group">
            <label>手机号</label>
            <input type="tel" name="phone" class="form-control" placeholder="请输入登录手机号" required>
        </div>
        <div class="form-group">
            <label>密码</label>
            <input type="password" name="password" class="form-control" placeholder="请输入密码" required>
        </div>
        <button type="submit" class="btn btn-primary btn-block">登录</button>
        <div class="text-center mt-2">
            <a href="${pageContext.request.contextPath}/deliveryman/toForgotPassword">忘记密码？</a>
            <span style="margin: 0 10px;">|</span>
            <a href="${pageContext.request.contextPath}/deliveryman/toRegister">还没账号？去注册</a>
        </div>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
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