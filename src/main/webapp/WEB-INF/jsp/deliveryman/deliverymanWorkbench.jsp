<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>外卖员工作台</title>
    <style type="text/css">
        .container { width: 1200px; margin: 0 auto; padding: 20px; }
        .header { margin-bottom: 30px; padding-bottom: 10px; border-bottom: 1px solid #eee; }
        .status-online { color: #28a745; font-weight: bold; }
        .status-rest { color: #ffc107; font-weight: bold; }
        .status-offline { color: #6c757d; }
        .order-list { margin: 20px 0; }
        .order-item { padding: 15px; margin-bottom: 10px; border: 1px solid #eee; border-radius: 4px; }
        .btn { padding: 6px 12px; margin-left: 10px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-accept { background-color: #28a745; color: white; }
        .btn-refresh { background-color: #007bff; color: white; }
        .message { padding: 10px; margin: 10px 0; border-radius: 4px; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
<div class="container">
    <!-- 消息提示（保留原有） -->
    <c:if test="${not empty successMsg}">
        <div class="message success">${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="message error">${errorMsg}</div>
    </c:if>

    <!-- 头部：用户信息与状态（保留原有结构） -->
    <div class="header">
        <h2>外卖员工作台</h2>
        <div>
            欢迎，${deliveryman.username}（工号：${deliveryman.userId}）<br>
            工作状态：
            <c:choose>
                <c:when test="${deliveryman.workStatus == 1}"><span class="status-online">在线</span></c:when>
                <c:when test="${deliveryman.workStatus == 2}"><span class="status-rest">休息中</span></c:when>
                <c:otherwise><span class="status-offline">离线</span></c:otherwise>
            </c:choose>
            <!-- 状态切换按钮（保留原有） -->
            <button class="btn" onclick="switchWorkStatus(1)">切换在线</button>
            <button class="btn" onclick="switchWorkStatus(2)">切换休息</button>
            <button class="btn" onclick="switchWorkStatus(0)">切换离线</button>
        </div>
    </div>

    <!-- 待接单订单列表（完全保留） -->
    <div class="order-list">
        <h3>待接单订单
            <button class="btn btn-refresh" onclick="refreshPendingOrders()">刷新列表</button>
        </h3>
        <c:choose>
            <c:when test="${not empty pendingOrders}">
                <c:forEach items="${pendingOrders}" var="order">
                    <div class="order-item">
                        <div>订单号：${order.orderId}</div>
                        <div>商家信息：${order.senderName}（${order.senderPhone}）</div>
                        <div>商家地址：${order.senderAddress}</div>
                        <div>收货信息：${order.consigneeName}（${order.consigneePhone}）</div>
                        <div>收货地址：${order.consigneeAddress}</div>
                        <div>货物类型：${order.goodsType}</div>
                        <div>配送费：<fmt:formatNumber value="${order.deliveryFee}" pattern="0.00" /> 元</div>
                        <div>预计时效：${order.expectedMins} 分钟</div>
                        <button class="btn btn-accept" onclick="acceptOrder('${order.orderId}')">接单</button>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="padding: 20px; color: #6c757d; border: 1px dashed #eee;">
                    暂无待接单订单，请稍后刷新
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 我的在途订单（完全保留） -->
    <div class="order-list">
        <h3>我的在途订单</h3>
        <c:choose>
            <c:when test="${not empty myOrders}">
                <c:forEach items="${myOrders}" var="order">
                    <div class="order-item">
                        <div>订单号：${order.orderId}</div>
                        <div>订单状态：
                            <c:choose>
                                <c:when test="${order.status == 1}">已接单待取货</c:when>
                                <c:when test="${order.status == 2}">配送中</c:when>
                                <c:otherwise>待处理</c:otherwise>
                            </c:choose>
                        </div>
                        <div>收货地址：${order.consigneeAddress}</div>
                        <div>预计时效：${order.expectedMins} 分钟</div>
                        <div>我的收益：<fmt:formatNumber value="${order.deliverymanIncome}" pattern="0.00" /> 元</div>
                        <c:choose>
                            <c:when test="${order.status == 1}">
                                <button class="btn" onclick="confirmTakeGoods('${order.orderId}')">确认取货</button>
                            </c:when>
                            <c:when test="${order.status == 2}">
                                <button class="btn" onclick="confirmCompleteOrder('${order.orderId}')">确认送达</button>
                            </c:when>
                        </c:choose>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="padding: 20px; color: #6c757d; border: 1px dashed #eee;">
                    暂无在途订单，快去接新单吧！
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>


<script type="text/javascript">
    // 1. 切换工作状态（仅修改状态码与枚举的映射，保持POST表单逻辑）
    function switchWorkStatus(statusCode) {
        // 状态文本映射与后端DeliverymanStatus枚举保持一致
        const statusText = statusCode === 1 ? "在线" : statusCode === 2 ? "休息中" : "离线";
        if (confirm("确定要切换到" + statusText + "状态吗？")) {
            const form = document.createElement("form");
            form.method = "POST";
            // 接口路径与后端DeliverymanController的@RequestMapping完全匹配
            form.action = "${pageContext.request.contextPath}/deliveryman/setStatus";

            const input = document.createElement("input");
            input.type = "hidden";
            input.name = "statusCode"; // 与后端@RequestParam("statusCode")参数名一致
            input.value = statusCode;
            form.appendChild(input);

            document.body.appendChild(form);
            form.submit();
        }
    }

    // 2. 接单（保留原有POST逻辑，仅修正参数类型传递）
    function acceptOrder(orderId) {
        if (confirm("确定要接订单【" + orderId + "】吗？")) {
            const form = document.createElement("form");
            form.method = "POST";
            form.action = "${pageContext.request.contextPath}/order/accept";

            const input = document.createElement("input");
            input.type = "hidden";
            input.name = "orderId"; // 与OrderController的@RequestParam("orderId")匹配
            input.value = orderId;
            form.appendChild(input);

            document.body.appendChild(form);
            form.submit();
        }
    }

    // 3. 确认取货（保留原有）
    function confirmTakeGoods(orderId) {
        if (confirm("确定已从商家取货吗？")) {
            const form = document.createElement("form");
            form.method = "POST";
            form.action = "${pageContext.request.contextPath}/order/updateStatus";

            const orderInput = document.createElement("input");
            orderInput.type = "hidden";
            orderInput.name = "orderId";
            orderInput.value = orderId;
            form.appendChild(orderInput);

            const statusInput = document.createElement("input");
            statusInput.type = "hidden";
            statusInput.name = "statusCode";
            statusInput.value = 2; // 与OrderStatus.DELIVERING.getCode()一致
            form.appendChild(statusInput);

            document.body.appendChild(form);
            form.submit();
        }
    }

    // 4. 确认送达（保留原有）
    function confirmCompleteOrder(orderId) {
        if (confirm("确定已将订单【" + orderId + "】送达吗？")) {
            const form = document.createElement("form");
            form.method = "POST";
            form.action = "${pageContext.request.contextPath}/order/updateStatus";

            const orderInput = document.createElement("input");
            orderInput.type = "hidden";
            orderInput.name = "orderId";
            orderInput.value = orderId;
            form.appendChild(orderInput);

            const statusInput = document.createElement("input");
            statusInput.type = "hidden";
            statusInput.name = "statusCode";
            statusInput.value = 3; // 与OrderStatus.COMPLETED.getCode()一致
            form.appendChild(statusInput);

            document.body.appendChild(form);
            form.submit();
        }
    }

    // 5. 刷新页面（保留原有）
    function refreshPendingOrders() {
        window.location.reload();
    }
</script>
</body>
</html>