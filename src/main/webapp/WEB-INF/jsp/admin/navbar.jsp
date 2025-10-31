<%--
  Created by IntelliJ IDEA.
  User: LHkeeper
  Date: 2025/10/30
  Time: 17:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/accounts">
        同城配送系统 - 管理员后台
      </a>
    </div>
    <div id="navbar" class="navbar-collapse collapse">
      <ul class="nav navbar-nav">
        <li class="${pageContext.request.requestURI.contains('/admin/accountList') ? 'active' : ''}">
          <a href="${pageContext.request.contextPath}/admin/accounts">账号管理</a>
        </li>
        <li class="${pageContext.request.requestURI.contains('/admin/ordersHistory') ? 'active' : ''}">
          <a href="${pageContext.request.contextPath}/admin/orders">订单管理</a>
        </li>
        <li class="${pageContext.request.requestURI.contains('/admin/publishOrder') ? 'active' : ''}">
          <a href="${pageContext.request.contextPath}/admin/publish-order">发布配送</a>
        </li>
        <li class="${pageContext.request.requestURI.contains('/admin/orderStatistic') ? 'active' : ''}">
          <a href="${pageContext.request.contextPath}/admin/order/statistic">数据统计</a>
        </li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#">欢迎，${sessionScope.user.username}</a></li>
        <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>
      </ul>
    </div>
  </div>
</nav>
