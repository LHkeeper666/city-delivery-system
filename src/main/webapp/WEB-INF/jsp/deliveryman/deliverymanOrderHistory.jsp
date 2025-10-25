<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>订单历史查询</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-datetimepicker@4.17.47/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
    <style>
        .filter-area { margin-bottom: 20px; padding: 15px; border: 1px solid #eee; border-radius: 8px; }
        .status-label { display: inline-block; padding: 3px 8px; border-radius: 4px; font-size: 12px; }
        .status-completed { background-color: #d4edda; color: #155724; }
        .status-canceled { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
<div class="container">
    <h3 class="mt-3">订单历史查询</h3>

    <!-- 筛选条件 -->
    <div class="filter-area">
        <form action="${pageContext.request.contextPath}/courier/orderHistory" method="get" class="form-inline">
            <div class="form-group">
                <label for="startDate">开始日期：</label>
                <div class="input-group date" id="startDatePicker">
                    <input type="text" id="startDate" name="startDate" class="form-control" value="${startDate}" required>
                    <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                </div>
            </div>
            <div class="form-group" style="margin-left: 15px;">
                <label for="endDate">结束日期：</label>
                <div class="input-group date" id="endDatePicker">
                    <input type="text" id="endDate" name="endDate" class="form-control" value="${endDate}" required>
                    <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                </div>
            </div>
            <div class="form-group" style="margin-left: 15px;">
                <label for="orderStatus">订单状态：</label>
                <select id="orderStatus" name="orderStatus" class="form-control">
                    <option value="-1" ${orderStatus == -1 ? 'selected' : ''}>全部</option>
                    <option value="3" ${orderStatus == 3 ? 'selected' : ''}>已完成</option>
                    <option value="4" ${orderStatus == 4 ? 'selected' : ''}>已取消</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary" style="margin-left: 15px;">查询</button>
        </form>
    </div>

    <!-- 订单列表 -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead>
            <tr class="bg-info text-white">
                <th>订单编号</th>
                <th>配送时间</th>
                <th>取餐商家</th>
                <th>送餐地址</th>
                <th>收益（元）</th>
                <th>订单状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty orderList}">
                    <tr>
                        <td colspan="7" class="text-center text-muted">暂无符合条件的订单</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${orderList}" var="order">
                        <tr>
                            <td>${order.id}</td>
                            <td><fmt:formatDate value="${order.deliveryTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td>${order.shopName}</td>
                            <td>${order.userAddress}</td>
                            <td>${order.profit}</td>
                            <td>
                                    <span class="status-label ${order.status == 3 ? 'status-completed' : 'status-canceled'}">
                                            ${order.status == 3 ? '已完成' : '已取消'}
                                    </span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-info" onclick="viewDetail(${order.id})">查看详情</button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 分页控件 -->
    <div class="text-center">
        <nav>
            <ul class="pagination">
                <li ${currentPage == 1 ? 'class="disabled"' : ''}>
                    <a href="?startDate=${startDate}&endDate=${endDate}&orderStatus=${orderStatus}&page=${currentPage - 1}" aria-label="上一页">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="page">
                    <li ${page == currentPage ? 'class="active"' : ''}>
                        <a href="?startDate=${startDate}&endDate=${endDate}&orderStatus=${orderStatus}&page=${page}">${page}</a>
                    </li>
                </c:forEach>
                <li ${currentPage == totalPages ? 'class="disabled"' : ''}>
                    <a href="?startDate=${startDate}&endDate=${endDate}&orderStatus=${orderStatus}&page=${currentPage + 1}" aria-label="下一页">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
        <p class="text-muted">共 ${totalOrders} 条订单，当前第 ${currentPage}/${totalPages} 页</p>
    </div>

    <!-- 订单详情弹窗（默认隐藏） -->
    <div class="modal fade" id="orderDetailModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">订单详情</h4>
                </div>
                <div class="modal-body" id="orderDetailContent">
                    <!-- 详情内容通过JS动态填充 -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 引入日期选择器和弹窗JS -->
<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/moment@2.29.4/moment.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap-datetimepicker@4.17.47/js/bootstrap-datetimepicker.min.js"></script>
<script>
    // 初始化日期选择器
    $('#startDatePicker').datetimepicker({
        format: 'yyyy-mm-dd',
        minView: 2, // 只显示到日期（不显示时分秒）
        autoclose: true
    });
    $('#endDatePicker').datetimepicker({
        format: 'yyyy-mm-dd',
        minView: 2,
        autoclose: true
    });

    // 查看订单详情（AJAX获取详情内容）
    function viewDetail(orderId) {
        $.get("${pageContext.request.contextPath}/courier/getOrderDetail",
            {orderId: orderId},
            function(data) {
                $("#orderDetailContent").html(data); // 填充详情内容
                $("#orderDetailModal").modal('show'); // 显示弹窗
            });
    }
</script>
</body>
</html>