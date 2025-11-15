<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>忘记密码</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"> <!-- 关键：移动端适配 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            min-height: 100vh;

            display: flex;
            justify-content: center;
            align-items: center; /* 完全居中 */
        }

        .container-box {
            width: 90%;
            max-width: 420px;
            padding: 24px 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0px 4px 14px rgba(0,0,0,0.1);
        }


        h3 {
            margin-bottom: 25px;
            font-weight: 600;
            text-align: center;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 6px;
        }

        .form-control {
            height: 42px;
            border-radius: 6px;
        }

        .btn-success {
            height: 42px;
            font-size: 16px;
            border-radius: 6px;
            margin-top: 10px;
        }

        .tip {
            color: #d9534f;
            font-size: 12px;
            margin-top: 3px;
            display: inline-block;
        }

        .footer-link {
            margin-top: 15px;
            text-align: center;
        }

        .footer-link a {
            color: #337ab7;
            text-decoration: none;
        }

        .footer-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<div class="container-box">
    <h3>重置密码</h3>

    <form action="${pageContext.request.contextPath}/deliveryman/resetPassword"
          method="post" onsubmit="return checkForm()">

        <div class="form-group">
            <label>注册手机号</label>
            <input type="tel" name="phone" class="form-control"
                   required placeholder="请输入手机号"
                   onblur="checkPhone(this.value)">
            <span id="phoneTip" class="tip"></span>
        </div>

        <div class="form-group">
            <label>新密码</label>
            <input type="password" name="newPwd" id="newPwd" class="form-control"
                   required placeholder="6-16位密码">
        </div>

        <div class="form-group">
            <label>确认密码</label>
            <input type="password" name="confirmPwd" id="confirmPwd" class="form-control"
                   required placeholder="再次输入密码">
            <span id="pwdTip" class="tip"></span>
        </div>

        <button type="submit" class="btn btn-success btn-block">重置</button>

        <div class="footer-link">
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
            tip.innerText = res.success ? "" : (res.msg || "该手机号未注册");
        });
    }

    // 表单校验
    function checkForm() {
        const newPwd = document.getElementById("newPwd").value;
        const confirmPwd = document.getElementById("confirmPwd").value;
        const pwdTip = document.getElementById("pwdTip");

        if (newPwd.length < 6 || newPwd.length > 16) {
            pwdTip.innerText = "密码长度必须为 6-16 位";
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
