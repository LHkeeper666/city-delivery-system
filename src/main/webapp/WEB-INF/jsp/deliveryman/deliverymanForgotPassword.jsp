<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>忘记密码 - 外卖员端</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .forgot-container { max-width: 500px; margin: 80px auto; padding: 20px; border: 1px solid #eee; border-radius: 8px; }
        .error提示 { color: #d9534f; margin-top: 10px; display: <c:if test="${not empty errorMsg}">block</c:if><c:if test="${empty errorMsg}">none</c:if>; }
        .success提示 { color: #5cb85c; margin-top: 10px; display: <c:if test="${not empty successMsg}">block</c:if><c:if test="${empty successMsg}">none</c:if>; }
        #sendCodeBtn { width: 100%; }
        #sendCodeBtn:disabled { background-color: #ccc; border-color: #ccc; }
    </style>
</head>
<body>
<div class="container forgot-container">
    <h3 class="text-center">忘记密码</h3>
    <p class="text-center text-muted">通过手机号验证码重置密码</p>
    <hr>

    <form action="${pageContext.request.contextPath}/courier/resetPassword" method="post" class="mt-3">
        <!-- 手机号 -->
        <div class="form-group">
            <label for="phone">手机号</label>
            <input type="tel" id="phone" name="phone" class="form-control" required pattern="1[3-9]\d{9}" placeholder="请输入注册的手机号">
        </div>

        <!-- 验证码 -->
        <div class="form-group">
            <div class="row">
                <div class="col-xs-7">
                    <label for="verifyCode">验证码</label>
                    <input type="text" id="verifyCode" name="verifyCode" class="form-control" required placeholder="请输入6位验证码">
                </div>
                <div class="col-xs-5">
                    <label>&nbsp;</label> <!-- 占位，与左侧label对齐 -->
                    <button type="button" id="sendCodeBtn" class="btn btn-primary">发送验证码</button>
                </div>
            </div>
        </div>

        <!-- 新密码 -->
        <div class="form-group">
            <label for="newPassword">新密码</label>
            <input type="password" id="newPassword" name="newPassword" class="form-control" required pattern=".{6,16}" title="密码长度6-16位">
        </div>

        <!-- 确认新密码 -->
        <div class="form-group">
            <label for="confirmPassword">确认新密码</label>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
        </div>

        <!-- 提示信息 -->
        <div class="error提示 text-center">${errorMsg}</div>
        <div class="success提示 text-center">${successMsg}</div>

        <!-- 按钮 -->
        <button type="submit" class="btn btn-success btn-block">重置密码</button>
        <div class="text-center mt-2">
            <a href="${pageContext.request.contextPath}/courier/login.jsp">返回登录</a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script>
    // 发送验证码
    var countdown = 60;
    $("#sendCodeBtn").click(function() {
        var phone = $("#phone").val();
        if (!/^1[3-9]\d{9}$/.test(phone)) {
            alert("请输入正确的手机号");
            return;
        }

        // 发送AJAX请求获取验证码
        $.post("${pageContext.request.contextPath}/courier/sendVerifyCode",
            {phone: phone},
            function(data) {
                if (data.success) {
                    alert("验证码已发送至您的手机，请注意查收");
                    // 倒计时60秒，禁止重复发送
                    var btn = $("#sendCodeBtn");
                    btn.disabled = true;
                    btn.text(countdown + "秒后重新发送");
                    var timer = setInterval(function() {
                        countdown--;
                        btn.text(countdown + "秒后重新发送");
                        if (countdown <= 0) {
                            clearInterval(timer);
                            btn.disabled = false;
                            btn.text("发送验证码");
                            countdown = 60; // 重置倒计时
                        }
                    }, 1000);
                } else {
                    alert("发送失败：" + data.msg);
                }
            }, "json");
    });

    // 表单提交前校验：新密码一致性
    $("form[action*='resetPassword']").submit(function() {
        var newPwd = $("#newPassword").val();
        var confirmPwd = $("#confirmPassword").val();
        if (newPwd != confirmPwd) {
            alert("两次输入的新密码不一致");
            return false;
        }
        return true;
    });
</script>
</body>
</html>