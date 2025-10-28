<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>忘记密码</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .box { width: 400px; margin: 80px auto; padding: 20px; border: 1px solid #ddd; }
        .tip { color: red; font-size: 12px; margin-top: 5px; }
    </style>
</head>
<body>
<div class="box">
    <h3>重置密码</h3>
    <form action="${pageContext.request.contextPath}/deliveryman/resetPassword" method="post" onsubmit="return checkForm()">
        <div class="form-group">
            <label>注册手机号</label>
            <input type="tel" name="phone" class="form-control" required placeholder="输入手机号" onblur="checkPhone(this.value)">
            <span id="phoneTip" class="tip"></span>
        </div>
        <div class="form-group">
            <label>新密码</label>
            <input type="password" name="newPwd" id="newPwd" class="form-control" required placeholder="6-16位">
        </div>
        <div class="form-group">
            <label>确认密码</label>
            <input type="password" name="confirmPwd" id="confirmPwd" class="form-control" required>
            <span id="pwdTip" class="tip"></span>
        </div>
        <button type="submit" class="btn btn-success btn-block">重置</button>
        <div class="text-center mt-2">
            <a href="${pageContext.request.contextPath}/deliveryman/toLogin">返回登录</a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<script>
    // 校验手机号是否存在
    function checkPhone(phone) {
        if (!phone) return;
        $.get("${pageContext.request.contextPath}/deliveryman/checkPhone?phone=" + phone, function(res) {
            const tip = document.getElementById("phoneTip");
            if (res.success) {
                tip.innerText = "";
            } else {
                tip.innerText = res.msg || "该手机号未注册";
            }
        });
    }

    // 校验密码一致性
    function checkForm() {
        const newPwd = document.getElementById("newPwd").value;
        const confirmPwd = document.getElementById("confirmPwd").value;
        const pwdTip = document.getElementById("pwdTip");

        if (newPwd.length < 6 || newPwd.length > 16) {
            pwdTip.innerText = "密码长度必须为6-16位";
            return false;
        }

        if (newPwd !== confirmPwd) {
            pwdTip.innerText = "两次密码输入不一致";
            return false;
        }

        pwdTip.innerText = "";
        return true;
    }
</script>
</body>
</html>