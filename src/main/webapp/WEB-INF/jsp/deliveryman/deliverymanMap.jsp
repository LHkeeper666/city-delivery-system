<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>订单详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .map-box { height: 300px; border: 1px solid #ddd; margin: 20px 0; padding: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h3>订单 ${order.id} 详情</h3>
    <div class="map-box">
        <p><strong>简化地图展示</strong></p>
        <p>商家位置：${order.shopAddress}</p>
        <p>用户位置：${order.userAddress}</p>
    </div>
    <div class="row">
        <div class="col-xs-6">
            <p>商家：${order.shopName}</p>
            <p>电话：${order.shopPhone}</p>
        </div>
        <div class="col-xs-6">
            <p>用户：${order.userName}</p>
            <p>电话：${order.userPhone}</p>
        </div>
    </div>
    <div class="text-center mt-3">
        <button class="btn btn-success" onclick="finish(${order.id})">确认送达</button>
        <a href="${pageContext.request.contextPath}/deliveryman/deliverymanWorkbench.jsp" class="btn btn-default">返回</a>
    </div>
</div>

<script>
    function finish(orderId) {
        if (confirm("确认送达？")) {
            location.href = "${pageContext.request.contextPath}/order/finish?id=" + orderId;
        }
    }
</script>
</body>
</html>