<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>个人中心 - 同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 70px;
            background-color: #f4f5f7;
        }
        .container {
            width: 90%;
            max-width: 800px;
            margin: 30px auto;
        }
        .panel {
            margin-bottom: 20px;
        }
        .btn {
            margin-right: 10px;
            margin-bottom: 15px;
        }
        .navbar-inverse {
            background-color: #333;
            border-color: #333;
        }
        .navbar-inverse .navbar-nav > li > a {
            color: #fff;
        }
        .navbar-inverse .navbar-brand {
            color: #fff;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="<c:url value='/'/>">同城配送系统</a>
        </div>
        <ul class="nav navbar-nav">
            <li class="active"><a href="<c:url value='/deliveryman/toProfile'/>">个人中心</a></li>
            <li><a href="<c:url value='/deliveryman/toHistoryOrders'/>">历史订单</a></li>
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="#">欢迎，${deliveryman.username}</a></li>
            <li><a href="<c:url value='/logout'/>" onclick="return confirm('确定退出？')">退出登录</a></li>
        </ul>
    </div>
</nav>

<div class="container">
    <!-- 消息提示 -->
    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger">${errorMsg}</div>
    </c:if>

    <!-- 个人信息卡片 -->
    <div class="panel panel-primary">
        <div class="panel-heading">基本信息</div>
        <div class="panel-body">
            <table class="table">
                <tr><td>工号</td><td>${deliveryman.userId}</td></tr>
                <tr><td>用户名</td><td>${deliveryman.username}</td></tr>
                <tr><td>手机号</td><td>${deliveryman.phoneNo}</td></tr>
                <tr>
                    <td>当前状态</td>
                    <td>
                        <c:choose>
                            <c:when test="${deliveryman.workStatus == 1}"><span style="color: green; font-weight: bold;">在线</span></c:when>
                            <c:when test="${deliveryman.workStatus == 2}"><span style="color: orange; font-weight: bold;">休息中</span></c:when>
                            <c:otherwise><span style="color: gray;">离线</span></c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 工作统计 -->
    <div class="panel panel-success">
        <div class="panel-heading">工作统计</div>
        <div class="panel-body">
            <table class="table">
                <tr><td>总完成订单</td><td>${empty stats ? 0 : stats.totalCompleted}</td></tr>
                <tr><td>本月完成订单</td><td>${empty stats ? 0 : stats.monthCompleted}</td></tr>
                <tr><td>本月收益</td><td><fmt:formatNumber value="${empty stats ? 0.00 : stats.monthIncome}" pattern="0.00"/> 元</td></tr>
            </table>
        </div>
    </div>

    <!-- 操作按钮 -->
    <div class="panel panel-default">
        <div class="panel-body">
            <a href="${pageContext.request.contextPath}/deliveryman/toResetPassword" class="btn btn-warning btn-block">
                <span class="glyphicon glyphicon-lock"></span> 修改密码
            </a>
            <a href="${pageContext.request.contextPath}/deliveryman/toHistoryOrders" class="btn btn-info btn-block">
                <span class="glyphicon glyphicon-list"></span> 查看历史订单
            </a>
            <button class="btn btn-primary btn-block" data-toggle="modal" data-target="#updatePhoneModal">
                <span class="glyphicon glyphicon-phone"></span> 修改手机号
            </button>
        </div>
    </div>
</div>

<!-- 修改手机号弹窗 -->
<div class="modal fade" id="updatePhoneModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">修改手机号</h4>
            </div>
            <div class="modal-body">
                <div id="phoneMsg" class="alert hidden"></div>
                <form id="updatePhoneForm">
                    <div class="form-group">
                        <label>原手机号</label>
                        <input type="text" class="form-control" value="${deliveryman.phoneNo}" readonly>
                    </div>
                    <div class="form-group">
                        <label>新手机号</label>
                        <input type="text" class="form-control" id="newPhone" name="newPhone" placeholder="请输入11位手机号" required>
                    </div>
                    <div class="form-group">
                        <label>确认新手机号</label>
                        <input type="text" class="form-control" id="confirmPhone" name="confirmPhone" placeholder="请再次输入新手机号" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="updatePhone()">确认修改</button>
            </div>
        </div>
    </div>
</div>

<!-- 依赖JS -->
<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script>
    function updatePhone() {
        const newPhone = $("#newPhone").val();
        const confirmPhone = $("#confirmPhone").val();
        const phoneMsg = $("#phoneMsg");

        if (!/^1[3-9]\\d{9}$/.test(newPhone)) {
            phoneMsg.removeClass("hidden alert-success").addClass("alert-danger").text("请输入正确的11位手机号");
            return;
        }
        if (newPhone !== confirmPhone) {
            phoneMsg.removeClass("hidden alert-success").addClass("alert-danger").text("两次输入的手机号不一致");
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/deliveryman/updatePhone",
            type: "POST",
            data: { newPhone: newPhone, confirmPhone: confirmPhone },
            dataType: "json",
            success: function(res) {
                if (res.code === 200) {
                    phoneMsg.removeClass("hidden alert-danger").addClass("alert-success").text(res.msg);
                    setTimeout(() => {
                        window.location.reload();
                    }, 2000);
                } else {
                    phoneMsg.removeClass("hidden alert-success").addClass("alert-danger").text(res.msg);
                }
            },
            error: function() {
                phoneMsg.removeClass("hidden alert-success").addClass("alert-danger").text("网络错误，请重试");
            }
        });
    }
</script>
</body>
</html>