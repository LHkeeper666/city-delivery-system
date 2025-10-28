<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>订单历史</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <h3>订单历史查询</h3>
    <table class="table table-bordered">
        <tr>
            <th>订单号</th>
            <th>商家</th>
            <th>用户</th>
            <th>状态</th>
            <th>完成时间</th>
        </tr>
        <c:forEach items="${historyOrders}" var="order">
            <tr>
                <td>${order.id}</td>
                <td>${order.shopName}</td>
                <td>${order.userName}</td>
                <td>已完成</td>
                <td>${order.finishTime}</td>
            </tr>
        </c:forEach>
    </table>
    <a href="${pageContext.request.contextPath}/deliveryman/deliverymanWorkbench.jsp" class="btn btn-default">返回工作台</a>
</div>
</body>
</html>