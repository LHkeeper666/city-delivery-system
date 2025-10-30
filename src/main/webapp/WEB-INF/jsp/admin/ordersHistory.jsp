<%--
  订单管理页面 - 历史订单
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>订单管理 - 同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 60px;
            padding-bottom: 40px;
        }
        .container {
            max-width: 1200px;
        }
        .search-form {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        .table-actions {
            white-space: nowrap;
        }
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/accounts">同城配送系统 - 管理员后台</a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/admin/accounts">账号管理</a></li>
                    <li class="active"><a href="${pageContext.request.contextPath}/admin/orders">订单管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/publish-order">发布配送</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="#">欢迎，${sessionScope.user.username}</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h2>订单管理 - 历史订单</h2>
        
        <!-- 搜索表单 -->
        <form id="searchForm" action="${pageContext.request.contextPath}/admin/orders" method="post" class="form-horizontal">
            <div class="search-form">
                <div class="form-group">
                    <label for="keyword" class="col-sm-2 control-label">关键词搜索</label>
                    <div class="col-sm-4">
                        <input type="text" id="keyword" name="keyword" placeholder="订单号/收货人姓名/收货人电话" 
                               value="${searchKeyword != null ? searchKeyword : ''}" class="form-control">
                    </div>
                    <label for="status" class="col-sm-2 control-label">订单状态</label>
                    <div class="col-sm-4">
                        <select id="status" name="status" class="form-control">
                            <option value="">全部</option>
                            <option value="0" ${searchStatus != null && searchStatus == 0 ? 'selected' : ''}>待接单</option>
                            <option value="1" ${searchStatus != null && searchStatus == 1 ? 'selected' : ''}>进行中</option>
                            <option value="2" ${searchStatus != null && searchStatus == 2 ? 'selected' : ''}>已完成</option>
                            <option value="3" ${searchStatus != null && searchStatus == 3 ? 'selected' : ''}>已取消</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="startTime" class="col-sm-2 control-label">开始日期</label>
                    <div class="col-sm-4">
                        <input type="date" id="startTime" name="startTime" 
                               value="${searchStartTime != null ? searchStartTime : ''}" class="form-control">
                    </div>
                    <label for="endTime" class="col-sm-2 control-label">结束日期</label>
                    <div class="col-sm-4">
                        <input type="date" id="endTime" name="endTime" 
                               value="${searchEndTime != null ? searchEndTime : ''}" class="form-control">
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <button type="submit" class="btn btn-primary">查询</button>
                        <button type="button" class="btn btn-default" onclick="resetForm()">重置</button>
                    </div>
                </div>
            </div>
            <input type="hidden" id="page" name="page" value="1">
            <input type="hidden" id="size" name="size" value="10">
        </form>
        
        <!-- 错误提示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <!-- 订单列表 -->
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>订单号</th>
                    <th>货物类型</th>
                    <th>配送费用</th>
                    <th>接货人</th>
                    <th>接货电话</th>
                    <th>收货人</th>
                    <th>收货电话</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${historyOrders != null && historyOrders.data.list != null && not empty historyOrders.data.list}">
                    <c:forEach var="order" items="${historyOrders.data.list}">
                        <tr>
                            <td>${order.orderId}</td>
                            <td>${order.goodsType}</td>
                            <td>¥${order.deliveryFee}</td>
                            <td>${order.senderName}</td>
                            <td>${order.senderPhone}</td>
                            <td>${order.consigneeName}</td>
                            <td>${order.consigneePhone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status == 0}">
                                        <span class="label label-warning">待接单</span>
                                    </c:when>
                                    <c:when test="${order.status == 1}">
                                        <span class="label label-info">进行中</span>
                                    </c:when>
                                    <c:when test="${order.status == 2}">
                                        <span class="label label-success">已完成</span>
                                    </c:when>
                                    <c:when test="${order.status == 3}">
                                        <span class="label label-danger">已取消</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="label label-default">未知状态</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                            <td class="table-actions" style="min-width: 100px;">
                                <a href="${pageContext.request.contextPath}/admin/delivery-tracking/detail?orderId=${order.orderId}" class="btn btn-sm btn-info">查看详情</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${historyOrders == null || historyOrders.data.list == null || empty historyOrders.data.list}">
                    <tr>
                        <td colspan="10" class="text-center">暂无订单数据</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
        
        <!-- 分页 -->
        <c:if test="${historyOrders != null && historyOrders.data != null && historyOrders.data.total > 0}">
            <nav aria-label="Page navigation" class="text-center">
                <ul class="pagination">
                    <li>
                        <a href="javascript:void(0)" onclick="gotoPage(1)" aria-label="First">
                            <span aria-hidden="true">首页</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="gotoPage(${historyOrders.data.page > 1 ? historyOrders.data.page - 1 : 1})" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    
                    <c:set var="startPage" value="${historyOrders.data.page - 2}" />
                    <c:set var="endPage" value="${historyOrders.data.page + 2}" />
                    <c:set var="totalPages" value="${Math.ceil(historyOrders.data.total / historyOrders.data.size)}" />
                    
                    <c:if test="${startPage < 1}">
                        <c:set var="startPage" value="1" />
                        <c:set var="endPage" value="${Math.min(5.0, totalPages)}" />
                    </c:if>
                    <c:if test="${endPage > totalPages}">
                        <c:set var="endPage" value="${totalPages}" />
                        <c:set var="startPage" value="${Math.max(1.0, totalPages - 4)}" />
                    </c:if>
                    
                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                        <li class="${p == historyOrders.data.page ? 'active' : ''}">
                            <a href="javascript:void(0)" onclick="gotoPage(${p})"><c:out value="${p}"/></a>
                        </li>
                    </c:forEach>
                    
                    <li>
                        <a href="javascript:void(0)" onclick="gotoPage(${historyOrders.data.page < totalPages ? historyOrders.data.page + 1 : totalPages})" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="gotoPage(${totalPages})" aria-label="Last">
                            <span aria-hidden="true">末页</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
    <script>
        // 重置表单
        function resetForm() {
            document.getElementById('searchForm').reset();
            document.getElementById('page').value = 1;
        }
        
        // 跳转到指定页码
        function gotoPage(pageNum) {
            document.getElementById('page').value = pageNum;
            document.getElementById('searchForm').submit();
        }
        
        // 表单提交验证
        document.getElementById('searchForm').onsubmit = function() {
            const startTime = document.getElementById('startTime').value;
            const endTime = document.getElementById('endTime').value;
            
            // 验证日期范围
            if (startTime && endTime) {
                const startDate = new Date(startTime);
                const endDate = new Date(endTime);
                if (startDate > endDate) {
                    alert('开始日期不能晚于结束日期');
                    return false;
                }
            }
            
            return true;
        };
    </script>
</body>
</html>
