<%--
  Created by IntelliJ IDEA.
  User: LHkeeper
  Date: 2025/11/7
  Time: 18:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Title</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /*body {*/
        /*  padding-top: 60px;*/
        /*  padding-bottom: 40px;*/
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
<jsp:include page="navbar.jsp" />

<main class="container">
    <h1>订单审核</h1>

    <!-- 错误提示 -->
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger">${errorMsg}</div>
    </c:if>

    <!-- 订单列表 -->
    <table class="table table-striped table-hover">
        <thead>
        <tr>
            <th>orderID</th>
            <th>货物类型</th>
            <th>配送费用</th>
            <th>放弃原因</th>
            <th>创建时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${abandonRequests != null && abandonRequests.list != null && not empty abandonRequests.list}">
            <c:forEach var="order" items="${abandonRequests.list}">
                <tr>
                    <td>${order.orderId}</td>
                    <td>${order.goodsType}</td>
                    <td>${order.deliveryFee}</td>
                    <td>${order.abandonReason}</td>
                    <td>
                        <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </td>
                    <td class="table-actions" style="min-width: 100px;">
<%--                        TODO--%>
                        <a href="${pageContext.request.contextPath}/admin/abandon/${order.orderId}" class="btn btn-sm btn-info">
                            查看详情
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </c:if>
        </tbody>
    </table>

    <!-- 分页 -->
    <c:if test="${abandonRequests != null && abandonRequests.total > 0}">
        <nav aria-label="Page navigation" class="text-center">
            <ul class="pagination">
                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(1)" aria-label="First">
                        <span aria-hidden="true">首页</span>
                    </a>
                </li>
                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(${abandonRequests.page > 1 ? abandonRequests.page - 1 : 1})" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>

                <c:set var="startPage" value="${abandonRequests.page - 2}" />
                <c:set var="endPage" value="${abandonRequests.page + 2}" />
                <c:set var="totalPages" value="${(abandonRequests.total + abandonRequests.size - 1) / abandonRequests.size}" />

                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1" />
                    <c:set var="endPage" value="${Math.min(5.0, totalPages)}" />
                </c:if>
                <c:if test="${endPage > totalPages}">
                    <c:set var="endPage" value="${totalPages}" />
                    <c:set var="startPage" value="${Math.max(1.0, totalPages - 4)}" />
                </c:if>

                <c:forEach begin="${startPage}" end="${endPage}" var="p">
                    <li class="${p == abandonRequests.page ? 'active' : ''}">
                        <a href="javascript:void(0)" onclick="gotoPage(${p})"><c:out value="${p}"/></a>
                    </li>
                </c:forEach>

                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(${abandonRequests.page < totalPages ? abandonRequests.page + 1 : totalPages})" aria-label="Next">
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
</main>

<jsp:include page="footer.jsp" />
</body>
</html>
