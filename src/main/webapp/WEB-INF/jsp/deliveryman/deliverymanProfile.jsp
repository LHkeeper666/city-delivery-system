<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>个人中心 - 同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 10%;
            margin-top: 10%;
            margin-left: 5%;
            margin-right: 5%;
            background-color: #f4f5f7;
            font-size: 14px;
        }
        .container {
            width: 95%;
            max-width: 800px;
            margin: 20px auto;
            padding: 10px;
        }
        .panel {
            margin-bottom: 15px;
        }
        .btn {
            margin-right: 5px;
            margin-bottom: 10px;
            font-size: 12px;
            padding: 8px 12px;
        }
        .navbar-inverse {
            background-color: #333;
            border-color: #333;
        }
        .navbar-inverse .navbar-nav > li > a,
        .navbar-inverse .navbar-brand {
            color: #fff;
            font-size: 12px;
        }
        .navbar-inverse .navbar-brand {
            font-size: 14px;
        }
        .table {
            font-size: 12px;
            margin-bottom: 10px;
        }
        .table td, .table th {
            padding: 8px 5px;
        }
        
        /* 移动端适配 */
        @media (max-width: 768px) {
            body {
                padding-top: 50px;
                font-size: 13px;
            }
            .container {
                width: 98%;
                margin: 10px auto;
                padding: 5px;
            }
            .panel {
                margin-bottom: 10px;
            }
            .btn {
                font-size: 11px;
                padding: 6px 10px;
                margin-bottom: 8px;
            }
            .navbar-brand {
                font-size: 15px !important;
            }
            .navbar-nav > li > a {
                font-size: 11px !important;
                padding: 8px 5px !important;
            }
            .table {
                font-size: 11px;
            }
            .table td, .table th {
                padding: 6px 3px;
            }
            .modal-dialog {
                margin: 10px;
                width: auto;
            }
        }
        
        /* 超小屏幕适配 */
        @media (max-width: 480px) {
            .container {
                width: 100%;
                margin: 5px auto;
                padding: 2px;
            }
            .btn {
                font-size: 10px;
                padding: 5px 8px;
                margin-bottom: 5px;
            }
            .table {
                font-size: 10px;
            }
            .table td, .table th {
                padding: 4px 2px;
                font-size: 10px;
            }
            .navbar-brand {
                font-size: 15px !important;
            }
            .navbar-nav > li > a {
                font-size: 10px !important;
                padding: 6px 3px !important;
            }
            .panel-body {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<%@include file="banner.jsp"%>


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
                            <c:when test="${deliveryman.workStatus == 1}">
                                <span style="color: green; font-weight: bold;">在线</span>
                            </c:when>
                            <c:when test="${deliveryman.workStatus == 2}">
                                <span style="color: orange; font-weight: bold;">休息中</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: gray;">离线</span>
                            </c:otherwise>
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
                <tr>
                    <th>总完成订单</th>
                    <th>本月完成订单</th>
                    <th>本月收益</th>
                </tr>
                <tr>
                    <td id="totalOrders">0</td>
                    <td id="monthOrders">0</td>
                    <td id="monthEarnings">0.00 元</td>
                </tr>
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
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
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
    // 修改手机号
    function updatePhone() {
        const newPhone = $("#newPhone").val().trim();
        const confirmPhone = $("#confirmPhone").val().trim();
        const phoneMsg = $("#phoneMsg");

        if (!/^1[3-9]\d{9}$/.test(newPhone)) {
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
                    setTimeout(() => location.reload(), 1500);
                } else {
                    phoneMsg.removeClass("hidden alert-success").addClass("alert-danger").text(res.msg);
                }
            },
            error: function() {
                phoneMsg.removeClass("hidden alert-success").addClass("alert-danger").text("网络错误，请重试");
            }
        });
    }

    // ★ 新增：动态刷新工作统计数据
    function refreshStats() {
        fetch("${pageContext.request.contextPath}/deliveryman/stats")
            .then(resp => resp.json())
            .then(res => {
                if (res.code === 200 && res.data) {
                    const data = res.data;
                    document.getElementById("totalOrders").textContent = data.completedOrders ?? 0;
                    document.getElementById("monthOrders").textContent = data.completedCount ?? 0;
                    const amount = data.totalAmount ?? 0;
                    document.getElementById("monthEarnings").textContent =
                        (typeof amount === 'number' ? amount.toFixed(2) : amount) + " 元";
                } else {
                    console.warn("获取工作统计失败:", res);
                }
            })
            .catch(err => console.error("调用接口异常:", err));
    }

    // 页面加载时刷新统计
    window.onload = refreshStats;
</script>
</body>
</html>