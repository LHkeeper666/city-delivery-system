<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>订单历史 - 同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
    <style>
        body {
            margin-left: 3%;
            margin-right: 3%;
            padding-top: 50px;
            background-color: #f4f5f7;
            font-size: 14px;
        }
        .container {
            width: 95%;
            max-width: 800px;
            margin: 20px auto;
            padding: 10px;
        }
        .navbar-inverse {
            background-color: #333;
            border-color: #333;
        }
        .navbar-inverse .navbar-nav > li > a {
            color: #fff;
            font-size: 12px;
        }
        .navbar-inverse .navbar-brand {
            color: #fff;
            font-size: 14px;
        }
        table {
            margin-top: 15px;
            font-size: 12px;
        }
        .text-center {
            text-align: center;
        }
        .info-card {
            background: #fff;
            padding: 12px;
            margin-bottom: 10px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        
        /* 移动端适配 */
        @media (max-width: 768px) {
            body {
                padding-top: 50px;
                font-size: 13px;
            }
            .container {
                width: 98%;
                margin-top: 10px;
                padding: 5px;
            }
            .navbar-brand {
                font-size: 12px !important;
            }
            .navbar-nav > li > a {
                font-size: 11px !important;
                padding: 8px 5px !important;
            }
            table {
                font-size: 11px;
                margin-top: 10px;
            }
            table th, table td {
                padding: 5px 3px;
            }
            .btn-sm {
                font-size: 10px;
                padding: 3px 6px;
            }
            h3 {
                font-size: 16px;
                margin: 10px 0;
            }
        }
        
        /* 超小屏幕适配 */
        @media (max-width: 480px) {
            .container {
                width: 100%;
                padding: 2px;
            }
            table {
                font-size: 10px;
            }
            table th, table td {
                padding: 3px 1px;
                font-size: 9px;
            }
            .btn-sm {
                font-size: 9px;
                padding: 2px 4px;
            }
            h3 {
                font-size: 14px;
                margin: 5px 0;
            }
            .row {
                margin: 10px 0;
            }
            .navbar-brand {
                font-size: 15px !important;
            }
        }
    </style>
</head>
<body>
<%@include file="banner.jsp"%>

<div class="container">
    <!-- 返回按钮 -->
    <div class="row" style="margin: 20px 0;">
<%--        <a href="${pageContext.request.contextPath}/deliveryman/workbench" class="btn btn-default">--%>
<%--            <span class="glyphicon glyphicon-arrow-left"></span> 返回工作台--%>
<%--        </a>--%>
<%--        <h2 style="display: inline-block; margin-left: 20px;">我的历史订单</h2>--%>
        <div style="text-align: center; margin: 20px 0;">
            <h2>我的历史订单</h2>
        </div>
    </div>

    <!-- 历史订单列表 -->
    <c:choose>
        <c:when test="${not empty historyOrders}">
            <c:forEach items="${historyOrders}" var="order">
                <div class="info-card" style="margin-bottom: 15px;">
                    <p><strong>订单号：</strong>${order.orderId}</p>
                    <p><strong>商家名称：</strong>${order.senderName}</p>
                    <p><strong>收货人：</strong>${order.consigneeName}</p>
                    <p><strong>订单状态：</strong>
                        <c:choose>
                            <c:when test="${order.status == 3}">已完成</c:when>
                            <c:when test="${order.status == 4}">已取消</c:when>
                            <c:when test="${order.status == 5}">配送员放弃</c:when>
                        </c:choose>
                    </p>
                    <p><strong>完成时间：</strong>
                        <c:choose>
                            <c:when test="${order.status == 3}">${order.completeTime}</c:when>
                            <c:when test="${order.status == 4}">${order.cancelTime}</c:when>
                            <c:when test="${order.status == 5}">${order.cancelTime}</c:when>
                        </c:choose>
                    </p>
                    <p><strong>我的收益：</strong><fmt:formatNumber value="${order.deliverymanIncome == null ? 0 : order.deliverymanIncome}" pattern="0.00" /> 元</p>
                    <a href="<c:url value='/deliveryman/toOrderDetail?orderId=${order.orderId}'/>"
                       class="btn btn-info btn-block">查看详情</a>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="text-center" style="padding: 30px;">暂无历史订单记录</div>
        </c:otherwise>
    </c:choose>
</div>

<%--<div class="container">--%>
<%--    <!-- 导航栏：返回工作台 -->--%>
<%--    <div class="row" style="margin: 20px 0;">--%>
<%--        <a href="${pageContext.request.contextPath}/deliveryman/workbench" class="btn btn-default">--%>
<%--            <span class="glyphicon glyphicon-arrow-left"></span> 返回工作台--%>
<%--        </a>--%>
<%--        <h3 style="display: inline-block; margin-left: 20px;">我的历史订单</h3>--%>
<%--    </div>--%>

<%--    <!-- 历史订单列表 -->--%>
<%--    <table class="table table-bordered table-striped">--%>
<%--        <thead>--%>
<%--        <tr>--%>
<%--            <th>订单号</th>--%>
<%--            <th>商家名称</th>--%>
<%--            <th>收货人</th>--%>
<%--            <th>订单状态</th>--%>
<%--            <th>完成时间</th>--%>
<%--            <th>我的收益</th>--%>
<%--            <th>操作</th>--%>
<%--        </tr>--%>
<%--        </thead>--%>
<%--        <tbody>--%>
<%--        <c:choose>--%>
<%--            <c:when test="${not empty historyOrders}">--%>
<%--                <c:forEach items="${historyOrders}" var="order">--%>
<%--                    <tr>--%>
<%--                        <td>${order.orderId}</td>--%>
<%--                        <td>${order.senderName}</td>--%>
<%--                        <td>${order.consigneeName}</td>--%>
<%--                        <td>--%>
<%--                            <c:choose>--%>
<%--                                <c:when test="${order.status == 3}">已完成</c:when>--%>
<%--                                <c:when test="${order.status == 4}">已取消</c:when>--%>
<%--                                <c:when test="${order.status == 5}">配送员放弃</c:when>--%>
<%--                            </c:choose>--%>
<%--                        </td>--%>
<%--                        <td>--%>
<%--                            <c:choose>--%>
<%--                                <c:when test="${order.status == 3}">${order.completeTime}</c:when>--%>
<%--                                <c:when test="${order.status == 4}">${order.cancelTime}</c:when>--%>
<%--                                <c:when test="${order.status == 5}">${order.cancelTime}</c:when>--%>
<%--                            </c:choose>--%>
<%--                        </td>--%>
<%--                        <td><fmt:formatNumber value="${order.deliverymanIncome == null ? 0 : order.deliverymanIncome}" pattern="0.00" /> 元</td>--%>
<%--                        <td>--%>
<%--                            <a href="<c:url value='/deliveryman/toOrderDetail?orderId=${order.orderId}'/>"--%>
<%--                               class="btn btn-sm btn-info">查看详情</a>--%>
<%--                        </td>--%>
<%--                    </tr>--%>
<%--                </c:forEach>--%>
<%--            </c:when>--%>
<%--            <c:otherwise>--%>
<%--                <tr>--%>
<%--                    <td colspan="7" class="text-center" style="padding: 30px;">--%>
<%--                        暂无历史订单记录--%>
<%--                    </td>--%>
<%--                </tr>--%>
<%--            </c:otherwise>--%>
<%--        </c:choose>--%>
<%--        </tbody>--%>
<%--    </table>--%>
<%--</div>--%>
</body>
</html>