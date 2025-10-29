<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>订单历史</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <!-- 导航栏：返回工作台 -->
    <div class="row" style="margin: 20px 0;">
        <a href="${pageContext.request.contextPath}/deliveryman/workbench" class="btn btn-default">
            <span class="glyphicon glyphicon-arrow-left"></span> 返回工作台
        </a>
        <h3 style="display: inline-block; margin-left: 20px;">我的历史订单</h3>
    </div>

    <!-- 历史订单列表 -->
    <table class="table table-bordered table-striped">
        <thead>
        <tr>
            <th>订单号</th>
            <th>商家名称</th>
            <th>收货人</th>
            <th>订单状态</th>
            <th>完成时间</th>
            <th>我的收益</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty historyOrders}">
                <c:forEach items="${historyOrders}" var="order">
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.senderName}</td>
                        <td>${order.consigneeName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 3}">已完成</c:when>
                                <c:when test="${order.status == 4}">已取消</c:when>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 3}">${order.completeTime}</c:when>
                                <c:when test="${order.status == 4}">${order.cancelTime}</c:when>
                            </c:choose>
                        </td>
                        <td><fmt:formatNumber value="${order.deliverymanIncome == null ? 0 : order.deliverymanIncome}" pattern="0.00" /> 元</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/deliveryman/orderDetail?orderId=${order.orderId}"
                               class="btn btn-sm btn-info">查看详情</a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="7" class="text-center" style="padding: 30px;">
                        暂无历史订单记录
                    </td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
</body>
</html>