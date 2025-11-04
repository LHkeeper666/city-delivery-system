<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>重置密码 - 同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /*body {*/
        /*    padding-top: 60px;*/
        /*    padding-bottom: 40px;*/
        /*}*/
        html, body {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        main {
            flex: 1;
        }
        .container {
            max-width: 1200px;
        }
        .form-container {
            max-width: 600px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <jsp:include page="navbar.jsp"/>

    <main class="container">
        <div class="form-container">
        <h2>重置密码</h2>
        
        <!-- 错误提示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/accounts/resetPassword" method="post" class="form-horizontal">
            <input type="hidden" name="userId" value="${userId}">
            
            <div class="form-group">
                <label for="newPassword" class="col-sm-4 control-label">新密码 <span style="color: red;">*</span></label>
                <div class="col-sm-8">
                    <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="8-20位，包含字母、数字和特殊符号" required>
                    <small class="text-muted">密码长度8-20位，必须包含字母、数字和特殊符号</small>
                </div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword" class="col-sm-4 control-label">确认密码 <span style="color: red;">*</span></label>
                <div class="col-sm-8">
                    <input type="password" id="confirmPassword" class="form-control" placeholder="请再次输入新密码" required>
                </div>
            </div>
            
            <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                    <button type="submit" class="btn btn-primary">确认重置</button>
                    <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-default">取消</a>
                </div>
            </div>
        </form>
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/admin/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
    <script>
        // 表单验证
        document.querySelector('form').onsubmit = function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // 密码验证
            if (!/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$/.test(newPassword)) {
                alert('密码必须是8-20位，包含字母、数字和特殊符号');
                return false;
            }
            
            // 确认密码
            if (newPassword !== confirmPassword) {
                alert('两次输入的密码不一致');
                return false;
            }
            
            return true;
        };
    </script>
</body>
</html>