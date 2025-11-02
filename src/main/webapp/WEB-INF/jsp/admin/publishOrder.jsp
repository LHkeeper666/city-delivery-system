<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>发布配送信息 - 同城配送系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 60px;
            padding-bottom: 40px;
        }
        .container {
            max-width: 1200px;
        }
        .required {
            color: red;
        }
        .search-form {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <jsp:include page="navbar.jsp"/>

    <div class="container">
        <h2>发布配送信息</h2>
        
        <!-- 错误提示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <!-- 成功消息 -->
        <c:if test="${success}">
            <div class="alert alert-success">
                <strong>发布成功！</strong>配送单编号：${orderId}<br>
                配送单已创建，等待配送员接单。
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/publish-order" method="post" class="form-horizontal">
            <!-- 接货信息 -->
            <div class="search-form">
                <h3>接货信息</h3>
                <div class="form-group">
                    <label for="pickupAddr" class="col-sm-3 control-label">接货地址 <span class="required">*</span></label>
                    <div class="col-sm-9">
                        <textarea id="pickupAddr" name="senderAddress" class="form-control" rows="3" placeholder="请输入详细接货地址（省、市、区、街道、门牌号）" required>${deliveryOrder.senderAddress}</textarea>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="pickupName" class="col-sm-3 control-label">接货人姓名 <span class="required">*</span></label>
                    <div class="col-sm-9">
                        <input type="text" id="pickupName" name="senderName" class="form-control" placeholder="请输入接货人姓名" required value="${deliveryOrder.senderName}">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="pickupPhone" class="col-sm-3 control-label">接货人电话 <span class="required">*</span></label>
                    <div class="col-sm-9">
                        <input type="tel" id="pickupPhone" name="senderPhone" class="form-control" placeholder="请输入11位手机号码" pattern="1[3-9]\d{9}" required value="${deliveryOrder.senderPhone}">
                    </div>
                </div>
            </div>
            
            <!-- 配送信息 -->
            <div class="search-form">
                <h3>配送信息</h3>
                <div class="form-group">
                    <label for="deliveryAddr" class="col-sm-3 control-label">配送地址 <span class="required">*</span></label>
                    <div class="col-sm-9">
                        <textarea id="deliveryAddr" name="consigneeAddress" class="form-control" rows="3" placeholder="请输入详细配送地址（省、市、区、街道、门牌号）" required>${deliveryOrder.consigneeAddress}</textarea>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="deliveryName" class="col-sm-3 control-label">收货人姓名 <span class="required">*</span></label>
                    <div class="col-sm-9">
                        <input type="text" id="deliveryName" name="consigneeName" class="form-control" placeholder="请输入收货人姓名" required value="${deliveryOrder.consigneeName}">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="deliveryPhone" class="col-sm-3 control-label">收货人电话 <span class="required">*</span></label>
                    <div class="col-sm-9">
                        <input type="tel" id="deliveryPhone" name="consigneePhone" class="form-control" placeholder="请输入11位手机号码" pattern="1[3-9]\d{9}" required value="${deliveryOrder.consigneePhone}">
                    </div>
                </div>
            </div>
            
            <!-- 货物信息 -->
            <div class="search-form">
                <h3>货物信息</h3>
                <div class="form-group">
                    <label for="goodsType" class="col-sm-3 control-label">货物类型 <span class="required">*</span></label>
                    <div class="col-sm-9">
                        <select id="goodsType" name="goodsType" class="form-control" required>
                            <option value="">请选择货物类型</option>
                            <option value="ordinary" <c:if test="${deliveryOrder.goodsType eq 'ordinary'}">selected</c:if>>普通货物</option>
                            <option value="fragile" <c:if test="${deliveryOrder.goodsType eq 'fragile'}">selected</c:if>>易碎品</option>
                            <option value="fresh" <c:if test="${deliveryOrder.goodsType eq 'fresh'}">selected</c:if>>生鲜</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="deliveryFee" class="col-sm-3 control-label">配送费用（元） <span class="required">*</span></label>
                    <div class="col-sm-9">
                        <input type="number" id="deliveryFee" name="deliveryFee" class="form-control" step="0.01" min="0" placeholder="请输入配送费用" required value="${deliveryOrder.deliveryFee}">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="expectedMins" class="col-sm-3 control-label">预计配送时效（小时）</label>
                    <div class="col-sm-9">
                        <input type="number" id="expectedMins" name="expectedMins" class="form-control" min="1" placeholder="请输入预计配送时效" value="${deliveryOrder.expectedMins}">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="weight" class="col-sm-3 control-label">货物重量（kg）</label>
                    <div class="col-sm-9">
                        <input type="number" id="weight" name="weight" class="form-control" step="0.1" min="0" placeholder="请输入货物重量" value="${deliveryOrder.weight}">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="volume" class="col-sm-3 control-label">货物体积（m³）</label>
                    <div class="col-sm-9">
                        <input type="number" id="volume" name="volume" class="form-control" step="0.01" min="0" placeholder="请输入货物体积" value="${deliveryOrder.volume}">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="remark" class="col-sm-3 control-label">备注信息</label>
                    <div class="col-sm-9">
                        <textarea id="remark" name="remark" class="form-control" rows="2" placeholder="如'需当面签收'、'请勿挤压'等" value="${deliveryOrder.remark}">${deliveryOrder.remark}</textarea>
                    </div>
                </div>
            </div>
            
            <!-- 提交按钮 -->
            <div class="form-group text-center">
                <div>
                    <button type="submit" class="btn btn-primary" style="margin-right: 15px;">提交发布</button>
                    <button type="button" class="btn btn-default" onclick="resetForm()">重置</button>
                </div>
            </div>
        </form>
    </div>
    
    <script>
        // 页面加载完成后执行
        document.addEventListener('DOMContentLoaded', function() {
            // 如果有成功消息，显示3秒后可以关闭
            const successAlert = document.querySelector('.alert-success');
            if (successAlert) {
                setTimeout(function() {
                    successAlert.style.display = 'none';
                }, 3000);
            }
        });
        
        // 自定义重置函数
        function resetForm() {
            // 获取表单中的所有输入元素
            const form = document.querySelector('form');
            const inputs = form.querySelectorAll('input, textarea, select');
            
            // 清空每个输入元素的值
            inputs.forEach(input => {
                // 对于下拉框，重置为第一个选项
                if (input.tagName === 'SELECT') {
                    input.selectedIndex = 0;
                } else {
                    // 对于其他输入元素，清空值
                    input.value = '';
                }
            });
        }
    </script>
</body>
</html>