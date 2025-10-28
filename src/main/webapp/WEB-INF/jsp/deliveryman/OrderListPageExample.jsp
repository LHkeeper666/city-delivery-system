<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>订单列表示例</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <h3>所有订单（示例）</h3>
    <table class="table table-striped">
        <tr>
            <th>ID</th>
            <th>商家</th>
            <th>用户</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        <c:forEach items="${allOrders}" var="order">
            <tr>
                <td>${order.id}</td>
                <td>${order.shopName}</td>
                <td>${order.userName}</td>
                <td>
                    <c:choose>
                        <c:when test="${order.status == 0}">待接单</c:when>
                        <c:when test="${order.status == 1}">配送中</c:when>
                        <c:otherwise>已完成</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <button class="btn btn-sm btn-info">查看</button>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>
</body>
</html>