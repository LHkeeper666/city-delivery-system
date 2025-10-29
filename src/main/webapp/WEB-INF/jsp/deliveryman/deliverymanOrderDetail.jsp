<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>订单${order.orderId}详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .map-box {
            height: 350px;
            border: 1px solid #ddd;
            margin: 20px 0;
            padding: 15px;
            background-color: #f9f9f9;
        }
        .info-card {
            margin: 10px 0;
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 4px;
        }
        .status-tag {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            color: white;
            font-size: 12px;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 头部导航：返回工作台 -->
    <div class="row" style="margin: 20px 0;">
        <a href="${pageContext.request.contextPath}/deliveryman/workbench" class="btn btn-default">
            <span class="glyphicon glyphicon-arrow-left"></span> 返回工作台
        </a>
    </div>

    <!-- 订单状态 -->
    <div class="row">
        <h3>订单 ${order.orderId} 详情
            <c:choose>
                <c:when test="${order.status == 1}">
                    <span class="status-tag" style="background-color: #ffc107;">已接单待取货</span>
                </c:when>
                <c:when test="${order.status == 2}">
                    <span class="status-tag" style="background-color: #28a745;">配送中</span>
                </c:when>
                <c:when test="${order.status == 3}">
                    <span class="status-tag" style="background-color: #007bff;">已完成</span>
                </c:when>
                <c:when test="${order.status == 4}">
                    <span class="status-tag" style="background-color: #dc3545;">已取消</span>
                </c:when>
            </c:choose>
        </h3>
    </div>

    <!-- 地图区域（简化版，后续可集成高德/百度地图API） -->
    <!-- <p><strong>实时距离：公里（模拟数据）这个有点难我不写了</p>-->
    <div class="map-box">
        <h4>配送路线</h4>
        <p><strong>商家位置：</strong>${order.senderAddress}</p>
        <p><strong>收货位置：</strong>${order.consigneeAddress}</p>
        <p><strong>预计配送时效：</strong>${order.expectedMins} 分钟</p>
    </div>

    <!-- 配送信息 -->
    <div class="row">
        <!-- 商家信息 -->
        <div class="col-md-6 info-card">
            <h4>寄件人信息</h4>
            <p>名称：${order.senderName}</p>
            <p>电话：${order.senderPhone}</p>
            <p>地址：${order.senderAddress}</p>
        </div>
        <!-- 收货信息 -->
        <div class="col-md-6 info-card">
            <h4>收货人信息</h4>
            <p>姓名：${order.consigneeName}</p>
            <p>电话：${order.consigneePhone}</p>
            <p>地址：${order.consigneeAddress}</p>
        </div>
    </div>

    <!-- 订单其他信息 -->
    <div class="info-card">
        <div class="row">
            <div class="col-md-4">
                <p>货物类型：${order.goodsType == 'fragile' ? '易碎品' : '普通货物'}</p>
                <p>配送费：<fmt:formatNumber value="${order.deliveryFee}" pattern="0.00" /> 元</p>
            </div>
            <div class="col-md-4">
                <p>我的收益：<fmt:formatNumber value="${order.deliverymanIncome}" pattern="0.00" /> 元</p>
                <p>创建时间：${order.createTime}</p>
            </div>
            <div class="col-md-4">
                <p>预计时间：${order.expectedMins} 分钟</p>
                <p>备注：${order.remark == null ? '无' : order.remark}</p>
            </div>
        </div>
    </div>

    <!-- 操作按钮（根据订单状态显示不同按钮） -->
    <div class="text-center" style="margin: 30px 0;">
        <c:choose>
            <c:when test="${order.status == 1}">
                <!-- 已接单待取货：显示“确认取货” -->
                <button class="btn btn-primary" onclick="confirmTakeGoods('${order.orderId}')">
                    确认取货
                </button>
            </c:when>
            <c:when test="${order.status == 2}">
                <!-- 配送中：显示“确认送达” -->
                <button class="btn btn-success" onclick="confirmComplete('${order.orderId}')">
                    确认送达
                </button>
            </c:when>
        </c:choose>

        <!-- 未完成的订单显示“取消订单” -->
        <c:if test="${order.status != 3 && order.status != 4}">
            <button class="btn btn-danger" style="margin-left: 20px;" onclick="cancelOrder('${order.orderId}')">
                取消订单
            </button>
        </c:if>
    </div>
</div>

<script type="text/javascript">
    const contextPath = "${pageContext.request.contextPath}";

    // 确认取货（状态改为“配送中”）
    function confirmTakeGoods(orderId) {
        if (confirm("确定已从商家取货吗？取货后将开始配送计时~")) {
            updateOrderStatus(orderId, 2, "取货成功，开始配送！");
        }
    }

    // 确认送达（状态改为“已完成”）
    function confirmComplete(orderId) {
        if (confirm("确定已将订单送达收货人手中吗？")) {
            updateOrderStatus(orderId, 3, "送达成功，订单已完成！");
        }
    }

    // 取消订单（状态改为“已取消”）
    function cancelOrder(orderId) {
        if (confirm("确定要取消订单吗？取消可能影响您的接单评分~")) {
            updateOrderStatus(orderId, 4, "订单已取消");
        }
    }

    // 通用：更新订单状态
    function updateOrderStatus(orderId, statusCode, successMsg) {
        const xhr = new XMLHttpRequest();
        xhr.open("POST", contextPath + "/order/updateStatus", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                const result = JSON.parse(xhr.responseText);
                if (result.code === 200) {
                    alert("✅ " + successMsg);
                    // 跳转回工作台
                    window.location.href = contextPath + "/deliveryman/workbench";
                } else {
                    alert("❌ " + result.msg);
                }
            }
        };
        xhr.send(`orderId=${orderId}&statusCode=${statusCode}`);
    }
</script>
</body>
</html>