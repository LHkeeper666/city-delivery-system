<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>编辑账号 - 同城配送系统</title>
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
            max-width: 800px;
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
        <h2>编辑账号</h2>
        
        <!-- 错误提示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <script>
            // 处理表单提交
            document.addEventListener('DOMContentLoaded', function() {
                const form = document.querySelector('form');
                
                form.addEventListener('submit', function(event) {
                    // 显示成功消息弹窗
                    alert('账号修改成功');
                    // 弹窗确认后，表单会继续提交并重定向到账号管理界面
                });
            });
        </script>
        
        <form action="${pageContext.request.contextPath}/admin/accounts/edit" method="post" class="form-horizontal">
            <input type="hidden" name="userId" value="${user.userId}">
            
            <div class="form-group">
                <label for="username" class="col-sm-3 control-label">用户名</label>
                <div class="col-sm-9">
                    <input type="text" id="username" name="username" class="form-control" value="${user.username}" readonly>
                    <small class="text-muted">用户名不可修改</small>
                </div>
            </div>
            
            <div class="form-group">
                <label for="role" class="col-sm-3 control-label">角色</label>
                <div class="col-sm-9">
                    <select id="role" name="role" class="form-control" disabled>
                        <c:forEach items="${roles}" var="role">
                            <option value="${role.code}" <c:if test="${role.code eq user.role}">selected</c:if>>${role.desc}</option>
                        </c:forEach>
                    </select>
                    <small class="text-muted">角色不可修改</small>
                </div>
            </div>
            
            <div class="form-group">
                <label for="phoneNo" class="col-sm-3 control-label">手机号</label>
                <div class="col-sm-9">
                    <input type="text" id="phoneNo" name="phoneNo" class="form-control" value="${user.phoneNo}" placeholder="11位手机号" pattern="1[3-9]\d{9}">
                    <small class="text-muted">请输入11位手机号码</small>
                </div>
            </div>
            
            <div class="form-group">
                <label for="status" class="col-sm-3 control-label">状态 <span style="color: red;">*</span></label>
                <div class="col-sm-9">
                    <select id="status" name="status" class="form-control" required>
                        <c:forEach items="${statuses}" var="status">
                            <option value="${status.code}" <c:if test="${status.code eq user.status}">selected</c:if>>
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
                    <button type="submit" class="btn btn-primary">更新账号</button>
                    <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-default">取消</a>
                    <a href="${pageContext.request.contextPath}/admin/accounts/resetPassword/${user.userId}" class="btn btn-info">重置密码</a>
                </div>
            </div>
        </form>
    </main>

    <jsp:include page="/WEB-INF/jsp/admin/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
    <script>
        // 表单验证
        document.querySelector('form').onsubmit = function() {
            const phoneNo = document.getElementById('phoneNo').value;
            
            // 手机号验证（如果填写）
            if (phoneNo && !/^1[3-9]\d{9}$/.test(phoneNo)) {
                alert('请输入有效的11位手机号码');
                return false;
            }
            
            return true;
        };
    </script>
</body>
</html>