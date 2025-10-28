<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>忘记密码</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .box { width: 400px; margin: 80px auto; padding: 20px; border: 1px solid #ddd; }
    </style>
</head>
<body>
<div class="box">
    <h3>重置密码</h3>
    <form action="${pageContext.request.contextPath}/deliveryman/resetPassword" method="post">
        <div class="form-group">
            <label>注册手机号</label>
            <input type="tel" name="phone" class="form-control" required placeholder="输入手机号">
        </div>
        <div class="form-group">
            <label>新密码</label>
            <input type="password" name="newPwd" class="form-control" required placeholder="6-16位">
        </div>
        <div class="form-group">
            <label>确认密码</label>
            <input type="password" name="confirmPwd" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-success btn-block">重置</button>
        <div class="text-center mt-2">
            <a href="${pageContext.request.contextPath}/deliverymanLogin.jsp">返回登录</a>
        </div>
    </form>
</body>
</html>