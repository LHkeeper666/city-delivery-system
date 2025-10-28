<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>个人中心</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container" style="margin-top:30px;">
    <h3>个人信息</h3>
    <table class="table table-bordered" style="width: 500px;">
        <tr><td>工号</td><td>${user.id}</td></tr>
        <tr><td>姓名</td><td>${user.name}</td></tr>
        <tr><td>手机号</td><td>${user.phone}</td></tr>
        <tr><td>总完成订单</td><td>${user.totalOrders}</td></tr>
    </table>
    <a href="${pageContext.request.contextPath}/deliverymanWorkbench.jsp" class="btn btn-default">返回工作台</a>
    <a href="${pageContext.request.contextPath}/deliveryman/updatePwd.jsp" class="btn btn-warning">修改密码</a>
</div>
</body>
</html>