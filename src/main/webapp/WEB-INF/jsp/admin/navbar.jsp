<%--
  Created by IntelliJ IDEA.
  User: LHkeeper
  Date: 2025/10/30
  Time: 17:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--<nav class="navbar navbar-inverse navbar-fixed-top">--%>
<%--    <div class="container-fluid">--%>
<%--        <div class="navbar-header">--%>
<%--            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/accounts">--%>
<%--                同城配送系统 - 管理员后台--%>
<%--            </a>--%>
<%--        </div>--%>
<%--        <div id="navbar" class="navbar-collapse collapse">--%>
<%--            <ul class="nav navbar-nav">--%>
<%--                <li class="${pageContext.request.requestURI.contains('/admin/accountList') ? 'active' : ''}">--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/accounts">账号管理</a>--%>
<%--                </li>--%>
<%--                <li class="${pageContext.request.requestURI.contains('/admin/ordersHistory') ? 'active' : ''}">--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/orders">订单管理</a>--%>
<%--                </li>--%>
<%--                <li class="${pageContext.request.requestURI.contains('/admin/publishOrder') ? 'active' : ''}">--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/publish-order">发布配送</a>--%>
<%--                </li>--%>
<%--                <li class="${pageContext.request.requestURI.contains('/admin/orderStatistic') ? 'active' : ''}">--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/order/statistic">数据统计</a>--%>
<%--                </li>--%>
<%--                <li class="${pageContext.request.requestURI.contains('/admin/api-key-list') ? 'active' : ''}">--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/api-key-list">密钥管理</a>--%>
<%--                </li>--%>
<%--            </ul>--%>
<%--            <ul class="nav navbar-nav navbar-right">--%>
<%--                <li><a href="#">欢迎，${sessionScope.user.username}</a></li>--%>
<%--                <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>--%>
<%--            </ul>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</nav>--%>

<nav class="navbar navbar-inverse navbar-fixed-top" style="background: linear-gradient(90deg, #1c1f26, #2a2f3a); border: none; box-shadow: 0 2px 8px rgba(0,0,0,0.3);">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/accounts" style="color: #f5f6f6; font-weight: bold; font-size: 18px;">
                🚚 同城配送系统 <span style="color: #bbb; font-size: 14px;">管理员后台</span>
            </a>
        </div>

        <div id="navbar" class="navbar-collapse collapse">
            <!-- 左侧菜单 -->
            <ul class="nav navbar-nav">
                <li class="${pageContext.request.requestURI.contains('/admin/accountList') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/accounts">👥 账号管理</a>
                </li>
                <li class="${pageContext.request.requestURI.contains('/admin/ordersHistory') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/orders">📦 订单管理</a>
                </li>
                <li class="${pageContext.request.requestURI.contains('/admin/publishOrder') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/publish-order">📝 发布配送</a>
                </li>
                <li class="${pageContext.request.requestURI.contains('/admin/orderStatistic') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/order/statistic">📊 数据统计</a>
                </li>
                <li class="${pageContext.request.requestURI.contains('/admin/api-key-list') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/api-key-list">🔑 密钥管理</a>
                </li>
                <li class="${pageContext.request.requestURI.contains('/admin/list-abandon-requests') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/list-abandon-requests">订单审核</a>
                </li>
            </ul>

            <!-- 右侧用户信息 -->
            <ul class="nav navbar-nav navbar-right">
                <li class="navbar-text" style="color: #ccc;">欢迎，<strong>${sessionScope.user.username}</strong></li>
                <li><a href="${pageContext.request.contextPath}/logout" style="color: #ff5252;">退出登录</a></li>
            </ul>
        </div>
    </div>
</nav>

<style>
    .navbar-nav > li > a {
        color: #ddd !important;
        font-size: 15px;
        transition: all 0.2s ease;
    }

    .navbar-nav > li > a:hover {
        color: #00bcd4 !important;
        background-color: transparent !important;
        transform: translateY(-1px);
    }

    .navbar-nav > .active > a,
    .navbar-nav > .active > a:focus,
    .navbar-nav > .active > a:hover {
        color: #fff !important;
        background-color: #00bcd4 !important;
        font-weight: bold;
        border-radius: 4px;
    }

    .navbar-brand:hover {
        color: #26d7f7 !important;
    }

    body {
        padding-top: 60px;
    }
</style>
