<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>配送地图 - 订单${order.id}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        #mapContainer { width: 100%; height: 600px; margin-bottom: 20px; }
        .order-info { padding: 15px; border: 1px solid #eee; border-radius: 8px; margin-bottom: 20px; }
    </style>
    <!-- 引入百度地图API（需替换为自己的AK） -->
    <script type="text/javascript" src="https://api.map.baidu.com/api?v=3.0&ak=你的百度地图AK"></script>
</head>
<body>
<div class="container">
    <!-- 订单信息 -->
    <div class="order-info">
        <div class="row">
            <div class="col-xs-4">
                <h4>订单 ${order.id}</h4>
                <p>状态：<span style="color: ${order.status == 1 ? '#f0ad4e' : '#5cb85c'}">
                    ${order.status == 1 ? '待取餐' : '待送餐'}
                </span></p>
            </div>
            <div class="col-xs-4">
                <p>商家：${order.shopName}</p>
                <p>电话：<a href="tel:${order.shopPhone}">${order.shopPhone}</a></p>
            </div>
            <div class="col-xs-4">
                <p>用户：${order.userName}</p>
                <p>电话：<a href="tel:${order.userPhone}">${order.userPhone}</a></p>
            </div>
        </div>
    </div>

    <!-- 地图容器 -->
    <div id="mapContainer"></div>

    <!-- 操作按钮 -->
    <div class="text-center">
        <button class="btn btn-info" onclick="callShop()">联系商家</button>
        <button class="btn btn-info" onclick="callUser()" style="margin: 0 20px;">联系用户</button>
        <button class="btn btn-${order.status == 1 ? 'warning' : 'success'}" onclick="updateStatus()">
            ${order.status == 1 ? '确认取餐' : '确认送达'}
        </button>
        <button class="btn btn-default" style="margin-left: 20px;" onclick="backToWorkbench()">返回工作台</button>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script>
    // 初始化地图
    var map = new BMapGL.Map("mapContainer");
    // 外卖员当前位置（假设从后端获取经纬度）
    var courierPoint = new BMapGL.Point(${courier.lng}, ${courier.lat});
    // 商家位置
    var shopPoint = new BMapGL.Point(${order.shopLng}, ${order.shopLat});
    // 用户位置
    var userPoint = new BMapGL.Point(${order.userLng}, ${order.userLat});

    // 设置地图中心点为外卖员位置，缩放级别15
    map.centerAndZoom(courierPoint, 15);
    // 开启鼠标滚轮缩放
    map.enableScrollWheelZoom(true);

    // 添加标注：外卖员（蓝色）、商家（红色）、用户（绿色）
    var courierMarker = new BMapGL.Marker(courierPoint, {icon: new BMapGL.Icon("${pageContext.request.contextPath}/img/courier.png", new BMapGL.Size(32, 32))});
    var shopMarker = new BMapGL.Marker(shopPoint, {icon: new BMapGL.Icon("${pageContext.request.contextPath}/img/shop.png", new BMapGL.Size(32, 32))});
    var userMarker = new BMapGL.Marker(userPoint, {icon: new BMapGL.Icon("${pageContext.request.contextPath}/img/user.png", new BMapGL.Size(32, 32))});
    map.addOverlay(courierMarker);
    map.addOverlay(shopMarker);
    map.addOverlay(userMarker);

    // 添加信息窗口（点击标注显示地址）
    var shopInfo = new BMapGL.InfoWindow("取餐点：${order.shopName}<br>${order.shopAddress}");
    var userInfo = new BMapGL.InfoWindow("送餐点：${order.userName}<br>${order.userAddress}");
    shopMarker.addEventListener("click", function() { this.openInfoWindow(shopInfo); });
    userMarker.addEventListener("click", function() { this.openInfoWindow(userInfo); });

    // 绘制路线：外卖员→商家→用户（根据当前状态）
    var driving = new BMapGL.DrivingRoute(map, {renderOptions: {map: map, autoViewport: true}});
    if (${order.status == 1}) {
        // 待取餐：路线为 外卖员→商家
        driving.search(courierPoint, shopPoint);
    } else {
        // 待送餐：路线为 外卖员→用户
        driving.search(courierPoint, userPoint);
    }

    // 联系商家（唤起电话拨号）
    function callShop() {
        window.location.href = "tel:${order.shopPhone}";
    }
    // 联系用户
    function callUser() {
        window.location.href = "tel:${order.userPhone}";
    }
    // 更新配送状态（确认取餐/送达）
    function updateStatus() {
        var confirmMsg = ${order.status == 1 ? "'确认已到达商家并取餐？'" : "'确认已将餐品送达用户？'"};
        if (confirm(confirmMsg)) {
            window.location.href = "${pageContext.request.contextPath}/courier/updateOrderStatus?orderId=${order.id}&status=${order.status == 1 ? 2 : 3}";
        }
    }
    // 返回工作台
    function backToWorkbench() {
        window.location.href = "${pageContext.request.contextPath}/courier/workbench";
    }
</script>
</body>
</html>