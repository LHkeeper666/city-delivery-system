<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>工作台</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .header { background: #337ab7; color: white; padding: 15px; margin-bottom: 20px; }
        .order-item { border: 1px solid #eee; padding: 15px; margin: 10px 0; }
    </style>
</head>
<body>
<div class="header">
    <div class="container">
        <div class="row">
            <div class="col-xs-6">欢迎：${user.name}（工号：${user.id}）</div>
            <div class="col-xs-6 text-right">
                <a href="${pageContext.request.contextPath}/deliverymanProfile.jsp" class="btn btn-default">个人中心</a>
                <a href="${pageContext.request.contextPath}/deliveryman/logout" class="btn btn-danger">退出</a>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <!-- 待接订单（查） -->
    <h4>待接订单</h4>
    <c:forEach items="${pendingOrders}" var="order">
        <div class="order-item">
            <div class="row">
                <div class="col-xs-4">订单号：${order.id}</div>
                <div class="col-xs-4">商家：${order.shopName}</div>
                <div class="col-xs-4">
                    <button class="btn btn-primary" onclick="accept(${order.id})">接单</button>
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- 我的订单（查） -->
    <h4 style="margin-top:30px;">我的订单</h4>
    <c:forEach items="${myOrders}" var="order">
        <div class="order-item">
            <div class="row">
                <div class="col-xs-4">订单号：${order.id}</div>
                <div class="col-xs-4">用户：${order.userName}</div>
                <div class="col-xs-4">
                    <a href="${pageContext.request.contextPath}/deliverymanMap.jsp?orderId=${order.id}" class="btn btn-info">详情</a>
                    <button class="btn btn-success" onclick="finish(${order.id})">完成</button>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script>
    // 接单（改：更新订单状态）
    function accept(orderId) {
        $.post("${pageContext.request.contextPath}/order/accept", {id: orderId}, function() {
            alert("接单成功");
            location.reload();
        });
    }
    // 完成订单（改：更新状态）
    function finish(orderId) {
        $.post("${pageContext.request.contextPath}/order/finish", {id: orderId}, function() {
            alert("订单完成");
            location.reload();
        });
    }
</script>
</body>
</html>