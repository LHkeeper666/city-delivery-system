<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>外卖员登录</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .login-box { width: 350px; margin: 100px auto; padding: 20px; border: 1px solid #ddd; }
        .error { color: red; text-align: center; margin: 10px 0; }
    </style>
</head>
<body>
<div class="login-box">
    <h3 class="text-center">外卖员登录</h3>
    <form action="${pageContext.request.contextPath}/deliveryman/login" method="post">
        <div class="form-group">
            <label>工号</label>
            <input type="text" name="id" class="form-control" required placeholder="输入工号（如：1001）">
        </div>
        <div class="form-group">
            <label>密码</label>
            <input type="password" name="password" class="form-control" required placeholder="输入密码（如：123456）">
        </div>
        <c:if test="${not empty errorMsg}">
            <div class="error">${errorMsg}</div>
        </c:if>
        <button type="submit" class="btn btn-primary btn-block">登录</button>
        <div class="text-center mt-2">
            <a href="${pageContext.request.contextPath}/deliverymanForgotPassword.jsp">忘记密码？</a>
        </div>
    </form>
</div>
</body>
</html>