<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .navbar-inverse {
    background-color: #333;
    border-color: #333;
  }
  .navbar-inverse .navbar-nav > li > a,
  .navbar-inverse .navbar-brand {
    color: #fff;
    font-size: 12px;
  }
  .navbar-inverse .navbar-brand {
    font-size: 14px;
  }
  .navbar-inverse .navbar-nav > li > a {
    color: #ffffff;
  }

  /* 移动端适配 */
  @media (max-width: 768px) {
    body {
      padding-top: 50px;
      font-size: 13px;
    }
    .header h2 {
      font-size: 18px;
      margin-bottom: 10px;
    }
    .order-item div {
      margin-bottom: 3px;
      font-size: 12px;
    }
    .btn {
      font-size: 11px;
      padding: 4px 8px;
      margin: 1px;
    }
    .navbar-brand {
      font-size: 15px !important;
    }
    .navbar-nav > li > a {
      font-size: 11px !important;
      padding: 8px 5px !important;
    }
  }

  /* 超小屏幕适配 */
  @media (max-width: 480px) {
    .navbar-brand {
      font-size: 15px !important;
    }
    .navbar-nav > li > a {
      font-size: 10px !important;
      padding: 6px 3px !important;
    }
  }
</style>
<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="<c:url value='/'/>">同城配送系统</a>
      <a class="navbar-brand" href="#">欢迎，${deliveryman.username}</a>
    </div>

    <div class="collapse navbar-collapse" id="navbar-collapse">
      <ul class="nav navbar-nav">
        <li class="${pageContext.request.requestURI.contains('/deliveryman/deliverymanProfile') ? 'active' : ''}">
          <a href="<c:url value='/deliveryman/toProfile'/>">&emsp;&emsp;个人中心</a>
        </li>
        <li class="${pageContext.request.requestURI.contains('/deliveryman/deliverymanWorkbench') ? 'active' : ''}">
          <a href="<c:url value='/deliveryman/workbench'/>">&emsp;&emsp;工作台</a>
        </li>
        <li class="${pageContext.request.requestURI.contains('/deliveryman/deliverymanOrderHistory') ? 'active' : ''}">
          <a href="<c:url value='/deliveryman/toHistoryOrders'/>">&emsp;&emsp;历史订单</a>
        </li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <%--                <li><a href="#">欢迎，${deliveryman.username}</a></li>--%>
        <li><a href="<c:url value='/deliveryman/logout'/>" onclick="return confirm('确定退出？')">&emsp;&emsp;退出</a></li>
      </ul>
    </div>
  </div>
</nav>
