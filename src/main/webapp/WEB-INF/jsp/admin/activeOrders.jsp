<%--
  订单管理页面 - 活跃订单
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>订单管理 - 同城配送系统</title>
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
            width: 100%;
            margin: 0 auto;
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
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            margin-bottom: 15px;
        }
        table {
            min-width: 100%;
            table-layout: fixed;
        }
        th, td {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .narrow-col {
            width: 80px;
        }
        .medium-col {
            width: 120px;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <jsp:include page="navbar.jsp"/>

    <main class="container">
        <h1>订单管理 - 活跃订单</h1>
        
        <!-- 搜索表单 -->
        <form id="searchForm" action="${pageContext.request.contextPath}/admin/orders/active" method="post" class="form-horizontal search-form">
            <div class="form-group">
                <label for="keyword" class="col-sm-2 control-label">关键词搜索</label>
                <div class="col-sm-4">
                    <input type="text" id="keyword" name="keyword" class="form-control" 
                           placeholder="订单号/收货人姓名/收货人电话" 
                           value="${searchKeyword != null ? searchKeyword : ''}">
                </div>
                <label for="status" class="col-sm-2 control-label">订单状态</label>
                <div class="col-sm-4">
                    <select id="status" name="status" class="form-control">
                        <option value="">全部</option>
                        <option value="0" ${searchStatus != null && searchStatus == 0 ? 'selected' : ''}>待接单</option>
                        <option value="1" ${searchStatus != null && searchStatus == 1 ? 'selected' : ''}>进行中</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-primary">查询</button>
                    <button type="button" class="btn btn-default" onclick="resetForm()" style="margin-left: 10px;">重置</button>
                </div>
            </div>
            <input type="hidden" id="page" name="page" value="${page != null ? page : 1}">
            <input type="hidden" id="size" name="size" value="10">
        </form>
        
        <!-- 消息提示 -->
        <c:if test="${not empty message}">
            <div class="alert alert-success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <!-- 订单列表 -->
        <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th class="medium-col">订单号</th>
                    <th class="narrow-col">货物类型</th>
                    <th class="narrow-col">配送费用</th>
                    <th class="narrow-col">接货人</th>
                    <th class="medium-col">接货电话</th>
                    <th class="narrow-col">收货人</th>
                    <th class="medium-col">收货电话</th>
                    <th class="narrow-col">状态</th>
                    <th class="medium-col">创建时间</th>
                    <th class="medium-col">操作</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${ActiveOrders != null && ActiveOrders.data.list != null && not empty ActiveOrders.data.list}">
                    <c:forEach var="order" items="${ActiveOrders.data.list}">
                        <tr>
                            <td>${order.orderId}</td>
                            <td>${order.goodsType}</td>
                            <td>¥${order.deliveryFee}</td>
                            <td>${order.senderName}</td>
                            <td>${order.senderPhone}</td>
                            <td>${order.consigneeName}</td>
                            <td>${order.consigneePhone}</td>
                            <td>
                                <span class="label 
                                    <c:choose>
                                        <c:when test="${order.status == 0}">label-warning">待接单</c:when>
                                        <c:when test="${order.status == 1}">label-info">进行中</c:when>
                                        <c:otherwise>label-default">未知状态</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                            <td class="table-actions">
                                <a href="${pageContext.request.contextPath}/admin/delivery-tracking/detail?orderId=${order.orderId}" class="btn btn-sm btn-info">查看详情</a>
                                <a href="javascript:void(0)" class="btn btn-sm btn-danger" 
                                   onclick="confirmCancel('${order.orderId}')">取消订单</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${ActiveOrders == null || ActiveOrders.data.list == null || empty ActiveOrders.data.list}">
                    <tr>
                        <td colspan="10" class="text-center">
                            <div class="alert alert-warning">
                                未查询到符合条件的订单，请调整查询条件
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
        </div>
        
        <!-- 分页 -->
        <div class="row">
            <div class="col-md-12 text-center">
                <nav>
                    <ul class="pagination">
                        <li <c:if test="${ActiveOrders.data.current == 1}">class="disabled"</c:if>>
                            <a href="${pageContext.request.contextPath}/admin/orders/active?page=${ActiveOrders.data.current-1}&size=${ActiveOrders.data.size}&keyword=${searchKeyword}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        
                        <c:forEach begin="1" end="${ActiveOrders.data.pages}" var="i">
                            <li <c:if test="${i eq ActiveOrders.data.current}">class="active"</c:if>>
                                <a href="${pageContext.request.contextPath}/admin/orders/active?page=${i}&size=${ActiveOrders.data.size}&keyword=${searchKeyword}">${i}</a>
                            </li>
                        </c:forEach>
                        
                        <li <c:if test="${ActiveOrders.data.current eq ActiveOrders.data.pages}">class="disabled"</c:if>>
                            <a href="${pageContext.request.contextPath}/admin/orders/active?page=${ActiveOrders.data.current+1}&size=${ActiveOrders.data.size}&keyword=${searchKeyword}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
                <p>共 ${ActiveOrders.data.total} 条记录，第 ${ActiveOrders.data.current} / ${ActiveOrders.data.pages} 页</p>
            </div>
        </div>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
    <script>
        // 重置表单
        function resetForm() {
            document.getElementById('keyword').value = '';
            document.getElementById('status').value = '';
            document.getElementById('page').value = '1';
            document.getElementById('searchForm').submit();
        }
        
        // 确认取消订单
        function confirmCancel(orderId) {
            if (confirm('确定要取消该订单吗？')) {
                // 这里可以实现取消订单的逻辑
                alert('取消订单功能待实现');
                // 实际实现时可以通过AJAX调用后端接口
                // fetch('${pageContext.request.contextPath}/admin/orders/cancel?orderId=' + orderId)
                //     .then(response => response.json())
                //     .then(data => {
                //         if (data.success) {
                //             alert('订单已成功取消');
                //             window.location.reload();
                //         } else {
                //             alert('取消订单失败: ' + data.message);
                //         }
                //     });
            }
        }
    </script>

    <jsp:include page="/WEB-INF/jsp/admin/footer.jsp"/>
</body>
</html>
