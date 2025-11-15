<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>订单 ${order.orderId} 详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
    <style>
        body {
            margin-left: 5%;
            margin-right: 5%;
            background-color: #f4f5f9;
            font-size: 14px;
            padding-bottom: 50px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 10px;
        }
        .header-btn {
            margin: 15px 0;
        }
        .status-tag {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 15px;
            color: #fff;
            font-size: 12px;
            margin-left: 10px;
        }
        .info-card {
            background-color: #fff;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        .map-box {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            height: 250px;
            overflow: auto;
        }
        h3 {
            font-weight: 600;
        }
        h4 {
            font-weight: 500;
            margin-top: 10px;
        }
        p {
            margin: 5px 0;
        }
        .btn-block {
            margin-top: 10px;
        }

        /* 响应式适配 */
        @media (max-width: 768px) {
            .map-box { height: 200px; padding: 10px; }
            .info-card { padding: 10px; margin: 8px 0; }
            h3 { font-size: 18px; }
            h4 { font-size: 16px; }
            p { font-size: 14px; }
            .btn { font-size: 14px; padding: 8px 15px; }
        }
        @media (max-width: 480px) {
            .map-box { height: 180px; padding: 8px; }
            h3 { font-size: 16px; }
            h4 { font-size: 14px; }
            p { font-size: 13px; }
            .btn { font-size: 13px; padding: 6px 12px; }
            .status-tag { font-size: 11px; padding: 3px 8px; }
        }
    </style>
</head>
<body>
<div class="container">

    <!-- 返回按钮 -->
    <div class="header-btn">
        <a href="${pageContext.request.contextPath}/deliveryman/workbench" class="btn btn-default btn-sm">
            <span class="glyphicon glyphicon-arrow-left"></span> 返回工作台
        </a>
    </div>

    <!-- 订单状态 -->
    <div class="text-center">
        <h3>订单 ${order.orderId} 详情
            <c:choose>
                <c:when test="${order.status == 0}">
                    <span class="status-tag" style="background-color: #6c757d;">待接单</span>
                </c:when>
                <c:when test="${order.status == 1}">
                    <span class="status-tag" style="background-color: #ffc107;">已接单待取货</span>
                </c:when>
                <c:when test="${order.status == 2}">
                    <span class="status-tag" style="background-color: #28a745;">配送中</span>
                </c:when>
                <c:when test="${order.status == 3}">
                    <span class="status-tag" style="background-color: #007bff;">已完成</span>
                </c:when>
                <c:when test="${order.status == 4}">
                    <span class="status-tag" style="background-color: #dc3545;">已取消</span>
                </c:when>
                <c:when test="${order.status == 5}">
                    <span class="status-tag" style="background-color: #6c757d;">放弃待审核</span>
                </c:when>
                <c:otherwise>
                    <span class="status-tag" style="background-color: #999;">未知状态</span>
                </c:otherwise>
            </c:choose>
        </h3>
    </div>

    <!-- 配送路线地图信息 -->
    <div class="row">
        <div class="col-xs-12 col-sm-6 map-box">
            <p><strong>商家位置：</strong>${order.senderAddress}</p>
            <p><strong>收货位置：</strong>${order.consigneeAddress}</p>
            <p><strong>预计配送时效：</strong>${order.expectedMins} 分钟</p>
        </div>
    </div>
<%--    <div class="map-box">--%>
<%--        <h4>配送路线</h4>--%>
<%--        <p><strong>商家位置：</strong>${order.senderAddress}</p>--%>
<%--        <p><strong>收货位置：</strong>${order.consigneeAddress}</p>--%>
<%--        <p><strong>预计配送时效：</strong>${order.expectedMins} 分钟</p>--%>
<%--    </div>--%>

    <!-- 寄件人 & 收货人信息 -->
    <div class="row">
        <div class="col-xs-12 col-sm-6 info-card">
            <h4>寄件人信息</h4>
            <p>名称：${order.senderName}</p>
            <p>电话：${order.senderPhone}</p>
            <p>地址：${order.senderAddress}</p>
        </div>
        <div class="col-xs-12 col-sm-6 info-card">
            <h4>收货人信息</h4>
            <p>姓名：${order.consigneeName}</p>
            <p>电话：${order.consigneePhone}</p>
            <p>地址：${order.consigneeAddress}</p>
        </div>
        <div class="col-xs-12 col-sm-6 info-card">
            <p>货物类型：${order.goodsType == 'fragile' ? '易碎品' : '普通货物'}</p>
            <p>配送费：<fmt:formatNumber value="${order.deliveryFee}" pattern="0.00" /> 元</p>
            <p>我的收益：<fmt:formatNumber value="${order.deliverymanIncome}" pattern="0.00" /> 元</p>
            <p>创建时间：${order.createTime}</p>
            <p>预计时间：${order.expectedMins} 分钟</p>
            <p>备注：${order.remark == null ? '无' : order.remark}</p>
        </div>
    </div>

    <!-- 订单详情 -->
<%--    <div class="info-card">--%>
<%--        <div class="row">--%>
<%--            <div class="col-xs-12 col-sm-4">--%>
<%--                <p>货物类型：${order.goodsType == 'fragile' ? '易碎品' : '普通货物'}</p>--%>
<%--                <p>配送费：<fmt:formatNumber value="${order.deliveryFee}" pattern="0.00" /> 元</p>--%>
<%--            </div>--%>
<%--            <div class="col-xs-12 col-sm-4">--%>
<%--                <p>我的收益：<fmt:formatNumber value="${order.deliverymanIncome}" pattern="0.00" /> 元</p>--%>
<%--                <p>创建时间：${order.createTime}</p>--%>
<%--            </div>--%>
<%--            <div class="col-xs-12 col-sm-4">--%>
<%--                <p>预计时间：${order.expectedMins} 分钟</p>--%>
<%--                <p>备注：${order.remark == null ? '无' : order.remark}</p>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>

    <!-- 操作按钮 -->
    <div class="text-center">
        <c:choose>
            <c:when test="${order.status == 1}">
                <button class="btn btn-primary btn-block" onclick="confirmTakeGoods('${order.orderId}')">
                    确认取货
                </button>
            </c:when>
            <c:when test="${order.status == 2}">
                <button class="btn btn-success btn-block" onclick="confirmComplete('${order.orderId}')">
                    确认送达
                </button>
            </c:when>
        </c:choose>
        <c:if test="${order.status != 3 && order.status != 4 && order.status != 5}">
            <button class="btn btn-danger btn-block" style="margin-top: 10px;" onclick="abandonOrder('${order.orderId}')">
                放弃订单
            </button>
        </c:if>
    </div>

</div>

<!-- 放弃订单模态框 -->
<div class="modal fade" id="abandonOrderModal" tabindex="-1" role="dialog" aria-labelledby="abandonModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="关闭">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="abandonModalLabel">放弃订单申请</h4>
            </div>
            <div class="modal-body">
                <form id="abandonOrderForm">
                    <input type="hidden" id="abandonOrderId">
                    <div class="form-group">
                        <label for="abandonReason">放弃原因 <span style="color: red;">*</span></label>
                        <select class="form-control" id="abandonReason" required>
                            <option value="">请选择放弃原因</option>
                            <option value="地址错误">地址错误</option>
                            <option value="突发疾病">突发疾病</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="abandonDescription">详细说明</label>
                        <textarea class="form-control" id="abandonDescription" rows="3" placeholder="请输入放弃订单的详细说明..."></textarea>
                    </div>
                    <div class="alert alert-warning">
                        <strong>温馨提示：</strong>放弃订单需等待管理员审核，频繁放弃可能影响您的接单评分。
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" onclick="submitAbandonRequest()">提交申请</button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
    const contextPath = "${pageContext.request.contextPath}";
    // 存储当前外卖员工作状态（1=在线，2=休息，3=离线）
    const currentWorkStatus = ${deliveryman.workStatus};

    // 确认取货（状态改为"配送中"）
    function confirmTakeGoods(orderId) {
        if (currentWorkStatus !== 1) {
            alert("⚠️ 只有【在线】状态才能操作订单，请先切换到在线状态！");
            return;
        }
        if (confirm("确定已从商家取货吗？取货后将开始配送计时~")) {
            updateOrderStatus(orderId, 2, "取货成功，开始配送！");
        }
    }

    // 确认送达（状态改为"已完成"）
    function confirmComplete(orderId) {
        if (currentWorkStatus !== 1) {
            alert("⚠️ 只有【在线】状态才能操作订单，请先切换到在线状态！");
            return;
        }
        if (confirm("确定已将订单送达收货人手中吗？")) {
            updateOrderStatus(orderId, 3, "送达成功，订单已完成！");
        }
    }

    // 放弃订单（显示模态框）
    function abandonOrder(orderId) {
        if (currentWorkStatus !== 1) {
            alert("⚠️ 只有【在线】状态才能操作订单，请先切换到在线状态！");
            return;
        }
        // 清空并填充模态框
        $('#abandonOrderId').val(orderId);
        $('#abandonReason').val('');
        $('#abandonDescription').val('');
        // 显示模态框
        $('#abandonOrderModal').modal('show');
    }
    
    // 提交放弃订单申请
    function submitAbandonRequest() {
        const orderId = $('#abandonOrderId').val();
        const abandonReason = $('#abandonReason').val();
        const abandonDescription = $('#abandonDescription').val();
        
        // 表单验证
        if (!abandonReason) {
            alert("请选择放弃原因");
            return;
        }
        
        // 提交请求到新的abandon接口
        $.ajax({
            url: contextPath + "/order/abandon",
            type: "POST",
            data: {
                orderId: orderId,
                abandonReason: abandonReason,
                abandonDescription: abandonDescription
            },
            dataType: "json",
            success: function(res) {
                console.log("放弃请求响应：", res);
                if (res.code === 200) {
                    alert("✅ " + res.msg);
                    // 隐藏模态框
                    $('#abandonOrderModal').modal('hide');
                    // 跳转回工作台
                    window.location.href = contextPath + "/deliveryman/workbench";
                } else {
                    alert("❌ " + res.msg);
                }
            },
            error: function(xhr, status, error) {
                console.log("请求失败：");
                console.log("状态码：", xhr.status);
                console.log("响应内容：", xhr.responseText);
                console.log("错误原因：", error);
                alert("❌ 请求失败，状态码：" + xhr.status + "，请查看控制台详情");
            }
        });
    }

    // 通用：更新订单状态
    function updateOrderStatus(orderId, statusCode, successMsg) {
        console.log("发送状态更新请求：", {
            url: contextPath + "/order/updateStatus",
            orderId: orderId,
            statusCode: statusCode
        });
        
        // 使用jQuery的ajax方法，添加更完善的错误处理
        $.ajax({
            url: contextPath + "/order/updateStatus",
            type: "POST",
            data: { orderId: orderId, statusCode: statusCode },
            dataType: "json",
            success: function(res) {
                console.log("请求成功响应：", res);
                if (res.code === 200) {
                    alert("✅ " + successMsg);
                    // 跳转回工作台
                    window.location.href = contextPath + "/deliveryman/workbench";
                } else {
                    alert("❌ " + res.msg);
                }
            },
            error: function(xhr, status, error) {
                console.log("请求失败：");
                console.log("状态码：", xhr.status);
                console.log("响应内容：", xhr.responseText);
                console.log("错误原因：", error);
                alert("❌ 请求失败，状态码：" + xhr.status + "，请查看控制台详情");
            }
        });
    }
</script>
</body>
</html>