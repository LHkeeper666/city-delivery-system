<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>外卖员工作台</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style type="text/css">
        .container { width: 1200px; margin: 0 auto; padding: 20px; }
        .header { margin-bottom: 30px; padding-bottom: 10px; border-bottom: 1px solid #eee; }
        .status-online { color: #28a745; font-weight: bold; }
        .status-rest { color: #ffc107; font-weight: bold; }
        .status-offline { color: #6c757d; }
        .order-list { margin: 20px 0; }
        .order-item {
            padding: 15px;
            margin-bottom: 10px;
            border: 1px solid #eee;
            border-radius: 4px;
            cursor: pointer;
        }
        .order-item:hover { background-color: #f9f9f9; }
        .btn { padding: 6px 12px; margin-left: 10px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-accept { background-color: #28a745; color: white; }
        .btn-refresh { background-color: #007bff; color: white; }
        .message { padding: 10px; margin: 10px 0; border-radius: 4px; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        .nav-links { margin-top: 10px; }
        .nav-links a { margin-right: 15px; text-decoration: none; }
    </style>
</head>
<body>
<div class="container">
    <!-- 消息提示 -->
    <c:if test="${not empty successMsg}">
        <div class="message success">${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="message error">${errorMsg}</div>
    </c:if>

    <!-- 头部：用户信息+导航 -->
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
            <!-- 状态切换按钮 -->
            <button class="btn" onclick="switchWorkStatus(1)">切换在线</button>
            <button class="btn" onclick="switchWorkStatus(2)">切换休息</button>
            <button class="btn" onclick="switchWorkStatus(0)">切换离线</button>

            <!-- 导航链接（匹配Controller接口） -->
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/deliveryman/toProfile" class="btn btn-default">
                    个人中心
                </a>
                <a href="${pageContext.request.contextPath}/deliveryman/toHistoryOrders" class="btn btn-default">
                    历史订单
                </a>
                <a href="${pageContext.request.contextPath}/deliveryman/logout" class="btn btn-danger" onclick="return confirm('确定退出？')">
                    退出登录
                </a>
            </div>
        </div>
    </div>

    <!-- 待接单订单列表 -->
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
                        <div>货物类型：<c:choose>
                            <c:when test="${order.goodsType == 'fragile'}">易碎品</c:when>
                            <c:when test="${order.goodsType == 'normal'}">普通货物</c:when>
                            <c:otherwise>${order.goodsType}</c:otherwise>
                        </c:choose></div>
                        <div>配送费：<fmt:formatNumber value="${order.deliveryFee}" pattern="0.00" /> 元</div>
                        <div>预计时间：${order.expectedMins} 分钟</div>
                        <button class="btn btn-accept" onclick="acceptOrder('${order.orderId}')">接单</button>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="padding: 20px; color: #6c757d; border: 1px dashed #eee; text-align: center;">
                    暂无待接单订单，请稍后刷新
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 我的在途订单（点击跳转详情页） -->
    <div class="order-list">
        <h3>我的在途订单</h3>
        <c:choose>
            <c:when test="${not empty myOrders}">
                <c:forEach items="${myOrders}" var="order">
                    <div class="order-item" onclick="window.location.href='${pageContext.request.contextPath}/deliveryman/toOrderDetail?orderId=${order.orderId}'">
                        <div>订单号：${order.orderId}</div>
                        <div>订单状态：
                            <c:choose>
                                <c:when test="${order.status == 1}"><span class="label label-warning">已接单待取货</span></c:when>
                                <c:when test="${order.status == 2}"><span class="label label-success">配送中</span></c:when>
                                <c:otherwise><span class="label label-default">待处理</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div>收货地址：${order.consigneeAddress}</div>
                        <div>预计时间：${order.expectedMins} 分钟</div>
                        <div>我的收益：<fmt:formatNumber value="${order.deliverymanIncome}" pattern="0.00" /> 元</div>
                        <!-- 按钮阻止事件冒泡 -->
                        <c:choose>
                            <c:when test="${order.status == 1}">
                                <button class="btn btn-primary" onclick="event.stopPropagation(); confirmTakeGoods('${order.orderId}')">确认取货</button>
                            </c:when>
                            <c:when test="${order.status == 2}">
                                <button class="btn btn-success" onclick="event.stopPropagation(); confirmCompleteOrder('${order.orderId}')">确认送达</button>
                            </c:when>
                        </c:choose>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="padding: 20px; color: #6c757d; border: 1px dashed #eee; text-align: center;">
                    暂无在途订单，快去接新单吧！
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- 核心JS逻辑 -->
<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script type="text/javascript">
    const currentWorkStatus = ${deliveryman.workStatus};
    const contextPath = "${pageContext.request.contextPath}";

    // 1. 切换工作状态
    function switchWorkStatus(statusCode) {
        const statusText = statusCode === 1 ? "在线" : statusCode === 2 ? "休息中" : "离线";
        if (confirm("确定要切换到" + statusText + "状态吗？")) {
            const form = $("<form>").attr({
                method: "POST",
                action: contextPath + "/deliveryman/setStatus"
            }).append($("<input>").attr({
                type: "hidden",
                name: "statusCode",
                value: statusCode
            }));
            $("body").append(form);
            form.submit();
        }
    }

    // 2. 接单（AJAX提交）
    function acceptOrder(orderId) {
        if (currentWorkStatus !== 1) {
            alert("⚠️ 只有【在线】状态才能接单，请先切换到在线状态！");
            return;
        }
        if (confirm("确定要接订单【" + orderId + "】吗？")) {
            $.ajax({
                url: contextPath + "/order/accept",
                type: "POST",
                data: { orderId: orderId },
                dataType: "json",
                success: function(res) {
                    if (res.code === 200) {
                        alert("✅ " + res.msg);
                        window.location.reload();
                    } else {
                        alert("❌ " + res.msg);
                    }
                },
                // 重点：增加错误详情打印
                error: function(xhr, status, error) {
                    // 打印错误信息到浏览器控制台（按F12查看）
                    console.log("接单请求失败：");
                    console.log("状态码：", xhr.status); // 404=接口不存在，500=后端报错，0=跨域或网络不通
                    console.log("响应内容：", xhr.responseText); // 后端返回的错误详情
                    console.log("错误原因：", error);
                    // 提示具体错误
                    alert("❌ 接单失败，状态码：" + xhr.status + "，请查看控制台详情");
                }
            });
        }
    }

    // 3. 确认取货
    function confirmTakeGoods(orderId) {
        // 新增：打印orderId，确认是否为有效数值
        console.log("要接单的订单ID：", orderId); // 重点看这里！
        if (currentWorkStatus !== 1) {
            alert("⚠️ 只有【在线】状态才能操作订单，请先切换到在线状态！");
            return;
        }
        if (confirm("确定已从商家取货吗？")) {
            submitStatusUpdate(orderId, 2, "取货成功，开始配送！");
        }
    }

    // 4. 确认送达
    function confirmCompleteOrder(orderId) {
        if (currentWorkStatus !== 1) {
            alert("⚠️ 只有【在线】状态才能操作订单，请先切换到在线状态！");
            return;
        }
        if (confirm("确定已将订单【" + orderId + "】送达吗？")) {
            submitStatusUpdate(orderId, 3, "送达成功，订单已完成！");
        }
    }

    // 通用：提交订单状态更新
    function submitStatusUpdate(orderId, statusCode, successMsg) {
        $.ajax({
            url: contextPath + "/order/updateStatus",
            type: "POST",
            data: { orderId: orderId, statusCode: statusCode },
            dataType: "json",
            success: function(res) {
                if (res.code === 200) {
                    alert("✅ " + successMsg);
                    window.location.reload();
                } else {
                    alert("❌ " + res.msg);
                }
            },
            error: function() {
                alert("❌ 网络错误，请重试");
            }
        });
    }

    // 5. 刷新列表
    function refreshPendingOrders() {
        window.location.reload();
    }
</script>
</body>
</html>