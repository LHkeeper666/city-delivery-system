<%--
  Created by IntelliJ IDEA.
  User: LHkeeper
  Date: 2025/11/1
  Time: 22:24
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>apiKey管理</title>
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
<jsp:include page="navbar.jsp"/>

<div class="container">
    <h1>apiKey管理</h1>
    <!-- 搜索表单 -->
    <div class="search-form">
        <form action="${pageContext.request.contextPath}/admin/api-key-list" method="get" class="form-inline">

            <div class="form-group">
                <label for="status">状态：</label>
                <select name="status" id="status" class="form-control">
                    <option value="">全部</option>
                    <option value="enabled" <c:if test="${status eq 'enabled'}">selected</c:if>>启用</option>
                    <option value="disabled" <c:if test="${status eq 'disabled'}">selected</c:if>>禁用</option>
                </select>
            </div>

            <div class="form-group">
                <label for="keyword">关键词：</label>
                <input type="text" name="keyword" id="keyword" class="form-control" value="${keyword}" placeholder="应用名称">
            </div>

            <button type="submit" class="btn btn-primary">搜索</button>
            <a href="${pageContext.request.contextPath}/admin/api-key-list" class="btn btn-default" style="margin-left: 10px;">重置</a>
        </form>
    </div>

      <!-- 错误提示 -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

      <!-- 订单列表 -->
    <table class="table table-striped table-hover">
        <thead>
        <tr>
            <th>keyID</th>
            <th>应用名称</th>
            <th>Api Key</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${apiKeys != null && apiKeys.list != null && not empty apiKeys.list}">
            <c:forEach var="apiKey" items="${apiKeys.list}">
            <tr>
                <td>${apiKey.keyId}</td>
                <td>${apiKey.appName}</td>
                <td>${apiKey.apiKey}</td>
                <td>${apiKey.status}</td>
                <td>
                    <fmt:formatDate value="${apiKey.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                </td>
                <td class="table-actions" style="min-width: 100px;">
                    <a href="${pageContext.request.contextPath}/admin/api-key-set-status?keyId=${apiKey.keyId}" class="btn btn-sm btn-info">
                        <c:choose>
                            <c:when test="${apiKey.status eq 'enabled'}">禁用</c:when>
                            <c:otherwise>启用</c:otherwise>
                        </c:choose>
                    </a>
                </td>
            </tr>
            </c:forEach>
        </c:if>
        </tbody>
    </table>

    <!-- 分页 -->
    <c:if test="${apiKeys != null && apiKeys.total > 0}">
        <nav aria-label="Page navigation" class="text-center">
            <ul class="pagination">
                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(1)" aria-label="First">
                        <span aria-hidden="true">首页</span>
                    </a>
                </li>
                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(${apiKeys.page > 1 ? apiKeys.page - 1 : 1})" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>

                <c:set var="startPage" value="${apiKeys.page - 2}" />
                <c:set var="endPage" value="${apiKeys.page + 2}" />
                <c:set var="totalPages" value="${(apiKeys.total + apiKeys.size - 1) / apiKeys.size}" />

                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1" />
                    <c:set var="endPage" value="${Math.min(5.0, totalPages)}" />
                </c:if>
                <c:if test="${endPage > totalPages}">
                    <c:set var="endPage" value="${totalPages}" />
                    <c:set var="startPage" value="${Math.max(1.0, totalPages - 4)}" />
                </c:if>

                <c:forEach begin="${startPage}" end="${endPage}" var="p">
                    <li class="${p == apiKeys.page ? 'active' : ''}">
                        <a href="javascript:void(0)" onclick="gotoPage(${p})"><c:out value="${p}"/></a>
                    </li>
                </c:forEach>

                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(${apiKeys.page < totalPages ? apiKeys.page + 1 : totalPages})" aria-label="Next">
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
</body>
</html>
