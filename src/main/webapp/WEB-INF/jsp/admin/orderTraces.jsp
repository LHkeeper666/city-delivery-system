<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>配送单详情 - 同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /*body {*/
        /*    padding-top: 60px;*/
        /*    padding-bottom: 40px;*/
        /*}*/
        html, body {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        main {
            flex: 1;
        }
        .container {
            max-width: 1200px;
        }
        .info-card {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .status-tag {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 14px;
            color: white;
        }
        .timeline {
            position: relative;
            padding: 20px 0;
        }
        .timeline::before {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            left: 20px;
            width: 2px;
            background-color: #e9ecef;
        }
        .timeline-item {
            position: relative;
            padding-left: 60px;
            margin-bottom: 20px;
        }
        .timeline-dot {
            position: absolute;
            left: 12px;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background-color: #007bff;
            border: 3px solid #ffffff;
            box-shadow: 0 0 0 2px #e9ecef;
        }
        .timeline-time {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 5px;
        }
        .timeline-content {
            background-color: white;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #007bff;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .timeline-content .operator {
            color: #007bff;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <jsp:include page="navbar.jsp"/>

    <main class="container">
        <h2>配送单详情</h2>
        
        <!-- 消息提示 -->
        <c:if test="${not empty message}">
            <div class="alert alert-success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <!-- 返回按钮 -->
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-default">
                <span class="glyphicon glyphicon-arrow-left"></span> 返回列表
            </a>
        </div>
        
        <c:if test="${not empty order}">
            <!-- 订单基本信息 -->
            <div class="row">
                <div class="col-md-12">
                    <div class="info-card">
                        <div class="row">
                            <div class="col-md-6">
                                <h3>配送单编号：<span style="color: #007bff;">${order.orderId}</span></h3>
                            </div>
                            <div class="col-md-6 text-right">
                                <h3>
                                    <c:choose>
                                        <c:when test="${order.status == 0}">
                                            <span class="status-tag" style="background-color: #6c757d;">待接单</span>
                                        </c:when>
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
                                        <c:otherwise>
                                            <span class="status-tag" style="background-color: #999;">未知状态</span>
                                        </c:otherwise>
                                    </c:choose>
                                </h3>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <p><strong>创建时间：</strong><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                            </div>
                            <div class="col-md-4">
                                <p><strong>配送费用：</strong>¥${order.deliveryFee}</p>
                            </div>
                            <div class="col-md-4">
                                <p><strong>预计时效：</strong>${order.expectedMins} 分钟</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 地址信息 -->
            <div class="row">
                <!-- 寄件人信息 -->
                <div class="col-md-6">
                    <div class="info-card">
                        <h4>寄件人信息</h4>
                        <p><strong>姓名：</strong>${order.senderName}</p>
                        <p><strong>电话：</strong>${order.senderPhone}</p>
                        <p><strong>地址：</strong>${order.senderAddress}</p>
                    </div>
                </div>
                
                <!-- 收货人信息 -->
                <div class="col-md-6">
                    <div class="info-card">
                        <h4>收货人信息</h4>
                        <p><strong>姓名：</strong>${order.consigneeName}</p>
                        <p><strong>电话：</strong>${order.consigneePhone}</p>
                        <p><strong>地址：</strong>${order.consigneeAddress}</p>
                    </div>
                </div>
            </div>
            
            <!-- 货物信息 -->
            <div class="row">
                <div class="col-md-12">
                    <div class="info-card">
                        <h4>货物信息</h4>
                        <div class="row">
                            <div class="col-md-3">
                                <p><strong>货物类型：</strong>
                                    <c:choose>
                                        <c:when test="${order.goodsType == 'ordinary'}">普通物品</c:when>
                                        <c:when test="${order.goodsType == 'fragile'}">易碎物品</c:when>
                                        <c:when test="${order.goodsType == 'fresh'}">生鲜冷链</c:when>
                                        <c:otherwise>${order.goodsType}</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="col-md-3">
                                <p><strong>重量：</strong>${order.weight} kg</p>
                            </div>
                            <div class="col-md-3">
                                <p><strong>体积：</strong>${order.volume} m³</p>
                            </div>
                            <div class="col-md-3">
                                <p><strong>备注：</strong>${order.remark}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 配送员信息 -->
            <c:if test="${not empty errorDeliveryTrace}">
                <div class="alert alert-warning text-center">
                    ${errorDeliveryTrace}
                </div>
            </c:if>
            
            <!-- 配送跟踪节点 -->
            <div class="row">
                <div class="col-md-12">
                    <div class="info-card">
                        <h4>配送跟踪节点</h4>
                        <div class="timeline">
                            <c:forEach items="${deliveryTraceList.data}" var="trace">
                                <div class="timeline-item">
                                    <div class="timeline-dot"></div>
                                    <div class="timeline-time">
                                        <fmt:formatDate value="${trace.operateTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </div>
                                    <div class="timeline-content">
                                        <p>
                                            <c:choose>
                                                <c:when test="${trace.status == 0}">配送单创建，待接单</c:when>
                                                <c:when test="${trace.status == 1}">配送员 <span class="operator">${trace.operatorName}</span> 接单，状态变更为已接单待取货</c:when>
                                                <c:when test="${trace.status == 2}">配送员 <span class="operator">${trace.operatorName}</span> 开始配送，状态变更为配送中</c:when>
                                                <c:when test="${trace.status == 3}">配送员 <span class="operator">${trace.operatorName}</span> 配送完成，状态变更为已完成</c:when>
                                                <c:when test="${trace.status == 4}">配送单已取消</c:when>
                                                <c:otherwise>状态变更为 ${trace.status}</c:otherwise>
                                            </c:choose>
                                        </p>
                                        <c:if test="${not empty trace.remark}">
                                            <p><strong>备注：</strong>${trace.remark}</p>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <c:if test="${empty deliveryTraceList.data}">
                                <div class="text-center text-muted">暂无配送跟踪记录</div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <c:if test="${empty order}">
            <div class="alert alert-danger text-center">
                未找到该配送单信息
            </div>
        </c:if>
    </main>

    <jsp:include page="/WEB-INF/jsp/admin/footer.jsp"/>
    
    <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>
