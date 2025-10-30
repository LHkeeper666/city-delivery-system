<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>账号管理 - 同城配送系统</title>
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
                    <li class="active"><a href="${pageContext.request.contextPath}/admin/accounts">账号管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders">订单管理</a></li>
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
        <h2>账号管理</h2>
        
        <!-- 成功消息弹窗 -->
        <c:if test="${not empty success and success}">
            <script type="text/javascript">
                // 使用setTimeout确保在DOM加载完成后显示弹窗
                window.onload = function() {
                    setTimeout(function() {
                        alert('账号新增成功');
                    }, 100);
                };
            </script>
        </c:if>
        
        <!-- 错误消息提示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <!-- 搜索表单 -->
        <div class="search-form">
            <form action="${pageContext.request.contextPath}/admin/accounts" method="get" class="form-inline">
                <div class="form-group">
                    <label for="role">角色：</label>
                    <select name="role" id="role" class="form-control">
                        <option value="">全部</option>
                        <c:forEach items="${roles}" var="role">
                            <option value="${role.code}" <c:if test="${role.code eq searchRole}">selected</c:if>>${role.desc}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="status">状态：</label>
                    <select name="status" id="status" class="form-control">
                        <option value="">全部</option>
                        <c:forEach items="${statuses}" var="status">
                            <option value="${status.code}" <c:if test="${status.code eq searchStatus}">selected</c:if>>
                                <c:choose>
                                    <c:when test="${status.code eq 0}">启用</c:when>
                                    <c:when test="${status.code eq 1}">禁用</c:when>
                                    <c:when test="${status.code eq 2}">锁定</c:when>
                                    <c:otherwise>未知</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="keyword">关键词：</label>
                    <input type="text" name="keyword" id="keyword" class="form-control" value="${keyword}" placeholder="用户名或手机号">
                </div>
                
                <button type="submit" class="btn btn-primary">搜索</button>
            </form>
        </div>
        
        <!-- 操作按钮 -->
        <div class="row" style="margin-bottom: 20px;">
            <div class="col-md-12">
                <a href="${pageContext.request.contextPath}/admin/accounts/add" class="btn btn-success">新增账号</a>
            </div>
        </div>
        
        <!-- 账号列表 -->
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>角色</th>
                    <th>手机号</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${users}" var="user">
                    <tr>
                        <td>${user.userId}</td>
                        <td>${user.username}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.role eq 0}">管理员</c:when>
                                <c:when test="${user.role eq 1}">配送员</c:when>
                                <c:otherwise>未知</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${user.phoneNo}</td>
                        <td>
                            <span class="label 
                                <c:choose>
                                    <c:when test="${user.status eq 0}">label-success">启用</c:when>
                                    <c:when test="${user.status eq 1}">label-warning">禁用</c:when>
                                    <c:when test="${user.status eq 2}">label-danger">锁定</c:when>
                                    <c:otherwise>label-default">未知</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>
                            <fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                        <td class="table-actions">
                            <a href="${pageContext.request.contextPath}/admin/accounts/edit/${user.userId}" class="btn btn-sm btn-primary">编辑</a>
                            <a href="${pageContext.request.contextPath}/admin/accounts/resetPassword/${user.userId}" class="btn btn-sm btn-info">重置密码</a>
                            <a href="${pageContext.request.contextPath}/admin/accounts/delete/${user.userId}" class="btn btn-sm btn-danger" 
                               onclick="return confirm('确定要删除该账号吗？');">删除</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <!-- 分页 -->
        <div class="row">
            <div class="col-md-12 text-center">
                <nav>
                    <ul class="pagination">
                        <li <c:if test="${page eq 1}">class="disabled"</c:if>>
                            <a href="${pageContext.request.contextPath}/admin/accounts?page=${page-1}&size=${size}&role=${searchRole}&status=${searchStatus}&keyword=${keyword}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        
                        <c:forEach begin="1" end="${(total + size - 1) / size}" var="i">
                            <li <c:if test="${i eq page}">class="active"</c:if>>
                                <a href="${pageContext.request.contextPath}/admin/accounts?page=${i}&size=${size}&role=${searchRole}&status=${searchStatus}&keyword=${keyword}">${i}</a>
                            </li>
                        </c:forEach>
                        
                        <li <c:if test="${page eq (total + size - 1) / size}">class="disabled"</c:if>>
                            <a href="${pageContext.request.contextPath}/admin/accounts?page=${page+1}&size=${size}&role=${searchRole}&status=${searchStatus}&keyword=${keyword}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
                <p>共 ${total} 条记录，第 ${page} / ${(total + size - 1) / size} 页</p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>