<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>外卖员工作台</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .info-bar { background-color: #2e6da4; color: white; padding: 10px 0; margin-bottom: 20px; }
        .order-card { border: 1px solid #eee; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
        .tag { display: inline-block; padding: 3px 8px; border-radius: 4px; font-size: 12px; margin-right: 5px; }
        .tag-distance { background-color: #d4edda; color: #155724; }
        .tag-money { background-color: #fff3cd; color: #856404; }
    </style>
</head>
<body>
<div class="container">
    <!-- 顶部信息栏 -->
    <div class="info-bar">
        <div class="container">
            <div class="row">
                <div class="col-xs-4">欢迎您，${courier.name}（ID：${courier.id}）</div>
                <div class="col-xs-4 text-center">今日完成：${todayCompleted} 单 | 累计收益：<fmt:formatNumber value="${todayIncome}" pattern="0.00"/> 元</div>
                <div class="col-xs-4 text-right">
                    <a href="${pageContext.request.contextPath}/courier/profile.jsp" style="color:white; margin-right:15px;">个人中心</a>
                    <a href="${pageContext.request.contextPath}/courier/logout" style="color:white;">退出登录</a>
                </div>
            </div>
        </div>
    </div>

    <!-- 待接单列表 -->
    <div class="row">
        <div class="col-xs-8">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-xs-6">待接单列表</div>
                        <div class="col-xs-6 text-right">
                            <select id="sortType" class="form-control input-sm" style="width: 150px; display: inline-block;">
                                <option value="distance">距离最近</option>
                                <option value="money">金额最高</option>
                            </select>
                            <button id="refreshOrder" class="btn btn-sm btn-primary">刷新订单</button>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <c:choose>
                        <c:when test="${empty pendingOrders}">
                            <div class="text-center text-muted">暂无待接订单，可稍候刷新</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${pendingOrders}" var="order">
                                <div class="order-card">
                                    <div class="row">
                                        <div class="col-xs-8">
                                            <h5>订单编号：${order.id}</h5>
                                            <p>取餐点：${order.shopName}（${order.shopAddress}）</p>
                                            <p>送餐点：${order.userAddress}</p>
                                        </div>
                                        <div class="col-xs-4 text-right">
                                            <span class="tag tag-distance">距离：${order.distance} km</span><br>
                                            <span class="tag tag-money">收益：${order.profit} 元</span><br>
                                            <button class="btn btn-sm btn-success mt-2"
                                                    onclick="acceptOrder(${order.id})">接单</button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- 配送中订单 -->
        <div class="col-xs-4">
            <div class="panel panel-warning">
                <div class="panel-heading">配送中订单</div>
                <div class="panel-body">
                    <c:choose>
                        <c:when test="${empty deliveringOrders}">
                            <div class="text-center text-muted">暂无配送中订单</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${deliveringOrders}" var="order">
                                <div class="order-card">
                                    <h5>订单 ${order.id}</h5>
                                    <p>状态：${order.status == 1 ? '待取餐' : '待送餐'}</p>
                                    <p>剩余时间：<span style="color: #d9534f;">${order.remainingTime} 分钟</span></p>
                                    <button class="btn btn-sm btn-info btn-block"
                                            onclick="viewRoute(${order.id})">查看路线</button>
                                    <button class="btn btn-sm btn-primary btn-block mt-1"
                                            onclick="updateStatus(${order.id})">
                                            ${order.status == 1 ? '确认取餐' : '确认送达'}
                                    </button>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script>
    // 接单确认
    function acceptOrder(orderId) {
        if (confirm("确认接此订单？接单后需在30分钟内取餐")) {
            window.location.href = "${pageContext.request.contextPath}/courier/acceptOrder?orderId=" + orderId;
        }
    }
    // 刷新订单（AJAX异步刷新，避免页面重载）
    $("#refreshOrder").click(function() {
        var sortType = $("#sortType").val();
        $.get("${pageContext.request.contextPath}/courier/getPendingOrders",
            {sortType: sortType},
            function(data) {
                $(".panel-body").html(data); // 替换待接单列表内容
            });
    });
    // 查看配送路线（跳转至地图页）
    function viewRoute(orderId) {
        window.location.href = "${pageContext.request.contextPath}/courier/map?orderId=" + orderId;
    }
</script>
</body>
</html>