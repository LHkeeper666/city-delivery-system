<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>修改密码</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container { max-width: 500px; margin: 50px auto; }
        .form-group { margin-bottom: 20px; }
        .alert { margin-bottom: 20px; }
    </style>
</head>
<body>
<div class="container">
    <h3 class="text-center">修改密码</h3>

    <!-- 消息提示（接口返回结果） -->
    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger">${errorMsg}</div>
    </c:if>

    <!-- 密码修改表单（POST提交到接口） -->
    <form id="resetPwdForm" action="${pageContext.request.contextPath}/deliveryman/resetPassword" method="post">
        <div class="form-group">
            <label for="phone">手机号</label>
            <input type="text" class="form-control" id="phone" name="phone"
                   value="${deliveryman.phoneNo}" readonly
                   placeholder="当前账号手机号，不可修改">
        </div>
        <div class="form-group">
            <label for="newPwd">新密码</label>
            <input type="password" class="form-control" id="newPwd" name="newPwd"
                   placeholder="请输入6-20位密码（含数字和字母）" required>
        </div>
        <div class="form-group">
            <label for="confirmPwd">确认新密码</label>
            <input type="password" class="form-control" id="confirmPwd" name="confirmPwd"
                   placeholder="请再次输入新密码" required>
        </div>
        <button type="submit" class="btn btn-primary btn-block">确认修改</button>
        <a href="${pageContext.request.contextPath}/deliveryman/toProfile" class="btn btn-default btn-block" style="margin-top: 10px;">
            返回个人中心
        </a>
    </form>
</div>

<!-- 前端密码校验 -->
<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script>
    $("#resetPwdForm").submit(function(e) {
        const newPwd = $("#newPwd").val();
        const confirmPwd = $("#confirmPwd").val();

        // 密码格式校验（6-20位，含数字和字母）
        if (!/^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$/.test(newPwd)) {
            alert("密码需6-20位，且同时包含数字和字母");
            e.preventDefault();
            return;
        }
        // 密码一致性校验
        if (newPwd !== confirmPwd) {
            alert("两次输入的密码不一致");
            e.preventDefault();
            return;
        }
    });
</script>
</body>
</html>