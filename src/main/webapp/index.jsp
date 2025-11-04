<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f7f7f7;
            font-family: Arial, sans-serif;
        }
        .navbar {
            margin-bottom: 20px;
            border-radius: 0;
        }
        .container {
            max-width: 1000px;
        }
        .content {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-inverse">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">同城配送系统</a>
        </div>
        <ul class="nav navbar-nav">
            <li><a href="<c:url value='/index.jsp'/>">首页</a></li>
            <li><a href="<c:url value='/deliveryman/toLogin'/>">外卖员登录</a></li>
            <li><a href="<c:url value='/admin/login'/>">管理员页面</a></li>
            <!-- Add other page links as needed -->
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="#">欢迎，用户</a></li>
            <li><a href="<c:url value='/logout'/>">退出登录</a></li>
        </ul>
    </div>
</nav>

<div class="container">
    <div class="content">
        <h1>Hello World!</h1>
        <p>欢迎进入同城配送系统。</p>
        <a href="hello-servlet" class="btn btn-primary">Hello Servlet</a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>