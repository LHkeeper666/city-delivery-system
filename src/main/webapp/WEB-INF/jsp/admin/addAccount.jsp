<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>新增账号 - 同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 60px;
            padding-bottom: 40px;
        }
        .container {
            max-width: 800px;
        }
        .form-group {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/accounts">同城配送系统 - 管理员后台</a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/admin/accounts">账号管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders">订单管理</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="#">欢迎，${sessionScope.user.username}</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h2>新增账号</h2>
        
        <!-- 错误提示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/accounts/add" method="post" class="form-horizontal">
            <div class="form-group">
                <label for="username" class="col-sm-3 control-label">用户名 <span style="color: red;">*</span></label>
                <div class="col-sm-9">
                    <input type="text" id="username" name="username" class="form-control" placeholder="6-20位字母/数字组合" required value="${user.username}">
                    <small class="text-muted">用户名长度6-20位，只能包含字母和数字</small>
                </div>
            </div>
            
            <div class="form-group">
                <label for="password" class="col-sm-3 control-label">密码 <span style="color: red;">*</span></label>
                <div class="col-sm-9">
                    <input type="password" id="password" name="password" class="form-control" placeholder="8-20位，包含字母、数字和特殊符号" required value="${user.password}">
                    <small class="text-muted">密码长度8-20位，必须包含字母、数字和特殊符号</small>
                </div>
            </div>
            
            <div class="form-group">
                <label for="role" class="col-sm-3 control-label">角色 <span style="color: red;">*</span></label>
                <div class="col-sm-9">
                    <select id="role" name="role" class="form-control" required>
                        <option value="">请选择角色</option>
                        <c:forEach items="${roles}" var="role">
                            <option value="${role.code}" <c:if test="${role.code eq user.role}">selected</c:if>>${role.desc}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label for="phoneNo" class="col-sm-3 control-label">手机号</label>
                <div class="col-sm-9">
                    <input type="text" id="phoneNo" name="phoneNo" class="form-control" placeholder="11位手机号" pattern="1[3-9]\d{9}" value="${user.phoneNo}">
                    <small class="text-muted">请输入11位手机号码，配送员账号建议必填</small>
                </div>
            </div>
            
            <div class="form-group">
                <label for="status" class="col-sm-3 control-label">状态 <span style="color: red;">*</span></label>
                <div class="col-sm-9">
                    <select id="status" name="status" class="form-control" required>
                        <c:forEach items="${statuses}" var="status">
                            <option value="${status.code}" <c:if test="${status.code eq 0}">selected</c:if>>
                                <c:choose>
                                    <c:when test="${status.code eq 0}">启用</c:when>
                                    <c:when test="${status.code eq 1}">禁用</c:when>
                                    <c:when test="${status.code eq 2}">锁定</c:when>
                                    <c:otherwise>未知</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <div class="col-sm-offset-3 col-sm-9">
                    <button type="submit" class="btn btn-primary">创建账号</button>
                    <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-default">取消</a>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
    <script>
        // 表单验证
        document.querySelector('form').onsubmit = function() {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const phoneNo = document.getElementById('phoneNo').value;
            const role = document.getElementById('role').value;
            
            // 用户名验证
            if (!/^[a-zA-Z0-9]{6,20}$/.test(username)) {
                alert('用户名必须是6-20位字母和数字的组合');
                return false;
            }
            
            // 密码验证
            if (!/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$/.test(password)) {
                alert('密码必须是8-20位，包含字母、数字和特殊符号');
                return false;
            }
            
            // 手机号验证（如果填写）
            if (phoneNo && !/^1[3-9]\d{9}$/.test(phoneNo)) {
                alert('请输入有效的11位手机号码');
                return false;
            }
            
            // 配送员角色时手机号必填
            if (role == 1 && !phoneNo) {
                alert('配送员账号必须填写手机号');
                return false;
            }
            
            return true;
        };
    </script>
     <script>
         // 页面加载时检查错误消息并弹窗显示
         document.addEventListener('DOMContentLoaded', function() {
             // 检查页面上的错误消息div
             var errorDiv = document.querySelector('.alert-danger');
             if (errorDiv) {
                 // 使用alert弹窗显示错误信息
                 alert(errorDiv.textContent.trim());
                 // 移除页面上的错误消息div，避免重复显示
                 errorDiv.style.display = 'none';
             }
             
             // 检查URL参数中的错误信息
             const urlParams = new URLSearchParams(window.location.search);
             const errorParam = urlParams.get('error');
             if (errorParam) {
                 alert(decodeURIComponent(errorParam));
             }
         });
     </script>
</body>
</html>