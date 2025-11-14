<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>外卖员注册</title>
    <!-- 引入Bootstrap样式，确保表单样式正常 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 页面整体样式优化 */
        body {
            background-color: #f5f5f5; /* 浅灰背景，提升视觉层次 */
            font-family: "Microsoft YaHei", sans-serif;
            padding: 20px 0;
        }
        .register-box {
            width: 380px;
            margin: 30px auto;
            padding: 25px;
            border: 1px solid #e0e0e0;
            border-radius: 8px; /* 圆角设计，更现代 */
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); /* 轻微阴影，增强立体感 */
        }
        .register-box h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
            font-weight: normal;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        /* 提示信息样式统一（使用Bootstrap alert类，样式更规范） */
        .alert {
            margin-bottom: 20px;
            padding: 12px;
            border-radius: 4px;
            text-align: center;
        }
        /* 表单组间距优化 */
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
            display: block;
        }
        .form-control {
            border-radius: 4px;
            border: 1px solid #ddd;
            padding: 10px 12px;
            font-size: 14px;
        }
        /* 按钮样式优化 */
        .btn-primary {
            background-color: #2f54eb; /* 深蓝色按钮，更醒目 */
            border-color: #2f54eb;
            padding: 11px;
            font-size: 16px;
            border-radius: 4px;
        }
        .btn-primary:hover {
            background-color: #1d4ed8; /*  hover时加深颜色，提升交互感 */
            border-color: #1d4ed8;
        }
        /* 底部链接样式 */
        .link-area {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }
        .link-area a {
            color: #2f54eb;
            text-decoration: none;
        }
        .link-area a:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }
        /* 输入框聚焦样式优化 */
        .form-control:focus {
            border-color: #2f54eb;
            box-shadow: 0 0 0 2px rgba(47, 84, 235, 0.2);
        }
        /* 移动端适配 */
        @media (max-width: 768px) {
            body {
                padding: 10px 0;
            }
            .register-box {
                width: 90%;
                margin: 20px auto;
                padding: 20px;
            }
            .register-box h2 {
                font-size: 20px;
                margin-bottom: 20px;
                padding-bottom: 12px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                font-size: 13px;
                margin-bottom: 6px;
            }
            .form-control {
                font-size: 16px;
                padding: 12px;
                height: 44px;
            }
            .btn-primary {
                font-size: 16px;
                padding: 12px;
            }
            .alert {
                padding: 10px;
                margin-bottom: 15px;
                font-size: 13px;
            }
            .link-area {
                font-size: 13px;
                margin-top: 15px;
            }
        }
        @media (max-width: 480px) {
            body {
                padding: 5px 0;
            }
            .register-box {
                width: 95%;
                margin: 15px auto;
                padding: 15px;
            }
            .register-box h2 {
                font-size: 18px;
                margin-bottom: 15px;
                padding-bottom: 10px;
            }
            .form-group {
                margin-bottom: 12px;
            }
            .form-group label {
                font-size: 12px;
                margin-bottom: 5px;
            }
            .form-control {
                font-size: 14px;
                padding: 10px;
                height: 40px;
            }
            .btn-primary {
                font-size: 14px;
                padding: 10px;
            }
            .alert {
                padding: 8px;
                margin-bottom: 12px;
                font-size: 12px;
            }
            .link-area {
                font-size: 12px;
                margin-top: 12px;
            }
        }
    </style>
</head>
<body>
<div class="register-box">
    <h2>外卖员注册</h2>

    <!-- 注册结果提示：覆盖所有校验场景，提示语更清晰 -->
    <c:if test="${param.error == '1'}">
        <div class="alert alert-danger">两次输入的密码不一致，请重新确认！</div>
    </c:if>
    <c:if test="${param.error == '2'}">
        <div class="alert alert-danger">该手机号已注册，可直接<a href="${pageContext.request.contextPath}/deliveryman/toLogin" style="color:#fff">登录</a>或更换手机号！</div>
    </c:if>
    <c:if test="${param.error == '3'}">
        <div class="alert alert-danger">用户名长度需在3-20位之间，且不能包含特殊字符！</div>
    </c:if>
    <c:if test="${param.error == '5'}">
        <div class="alert alert-danger">该用户名已被占用，请更换其他用户名！</div>
    </c:if>
    <c:if test="${param.error == '4'}">
        <div class="alert alert-danger">注册失败，请稍后重试或联系管理员！</div>
    </c:if>
    <c:if test="${param.success == '1'}">
        <div class="alert alert-success">注册成功！<a href="${pageContext.request.contextPath}/deliveryman/toLogin" style="color:#fff">立即登录</a></div>
    </c:if>

    <!-- 注册表单：提交地址正确，参数完整 -->
    <form method="post" action="${pageContext.request.contextPath}/deliveryman/register" onsubmit="return checkForm()">
        <!-- 用户名输入框 -->
        <div class="form-group">
            <label for="username">用户名</label>
            <input type="text" id="username" name="username" class="form-control"
                   placeholder="请输入3-20位用户名（字母/数字/下划线）" required
                   maxlength="20" minlength="3" pattern="^[a-zA-Z0-9_]+$">
        </div>

        <!-- 手机号输入框：添加正则校验，确保格式正确 -->
        <div class="form-group">
            <label for="phone">手机号</label>
            <input type="tel" id="phone" name="phone" class="form-control"
                   placeholder="请输入11位手机号" required
                   maxlength="11" minlength="11" pattern="^1[3-9]\d{9}$">
        </div>

        <!-- 密码输入框 -->
        <div class="form-group">
            <label for="password">设置密码</label>
            <input type="password" id="password" name="password" class="form-control"
                   placeholder="请输入6-16位密码（字母+数字组合更佳）" required
                   maxlength="16" minlength="6">
        </div>

        <!-- 确认密码输入框 -->
        <div class="form-group">
            <label for="confirmPwd">确认密码</label>
            <input type="password" id="confirmPwd" name="confirmPwd" class="form-control"
                   placeholder="请再次输入密码" required
                   maxlength="16" minlength="6">
            <!-- 新增：密码强度提示区域 -->
            <div id="pwdStrength" style="margin-top: 5px; font-size: 12px;"></div>
        </div>

        <!-- 注册按钮 -->
        <button type="submit" class="btn btn-primary btn-block">立即注册</button>

        <!-- 底部登录链接 -->
        <div class="link-area">
            已有账号？<a href="${pageContext.request.contextPath}/deliveryman/toLogin">去登录</a>
        </div>
    </form>
</div>

<!-- 新增前端基础校验（避免无效请求，提升体验） -->
<script>
    // 1. 实时监听密码输入，显示强度提示（输入时就更新）
    document.getElementById('password').addEventListener('input', function() {
        const password = this.value;
        const strengthText = document.getElementById('pwdStrength');

        if (password.length < 6) {
            strengthText.textContent = '密码长度需至少6位';
            strengthText.style.color = '#ff4d4f'; // 红色：弱
        } else if (/^(?=.*[a-zA-Z])(?=.*\d).{6,16}$/.test(password)) {
            strengthText.textContent = '密码强度：强（推荐）';
            strengthText.style.color = '#52c41a'; // 绿色：强
        } else if (/^(?=.*[a-zA-Z]).{6,16}$/.test(password) || /^(?=.*\d).{6,16}$/.test(password)) {
            strengthText.textContent = '密码强度：中（建议添加字母+数字组合）';
            strengthText.style.color = '#faad14'; // 橙色：中
        } else {
            strengthText.textContent = '密码强度：弱（仅支持字母、数字）';
            strengthText.style.color = '#ff4d4f'; // 红色：弱
        }
    });

    // 2. 保留原有的表单提交校验（删除原有的密码强度弹窗逻辑）
    function checkForm() {
        const username = document.getElementById('username').value;
        const phone = document.getElementById('phone').value;
        const password = document.getElementById('password').value;
        const confirmPwd = document.getElementById('confirmPwd').value;

        // 1. 用户名校验
        const usernameReg = /^[a-zA-Z0-9_]+$/;
        if (!usernameReg.test(username)) {
            alert('用户名仅支持字母、数字和下划线！');
            return false;
        }

        // 2. 手机号格式校验
        const phoneReg = /^1[3-9]\d{9}$/;
        if (!phoneReg.test(phone)) {
            alert('请输入有效的11位手机号！');
            return false;
        }

        // 3. 密码一致性校验
        if (password !== confirmPwd) {
            alert('两次输入的密码不一致，请重新确认！');
            return false;
        }

        // 校验通过，允许提交
        return true;
    }
</script>
</body>
</html>