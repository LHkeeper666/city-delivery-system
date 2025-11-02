<%@ page contentType="text/html;charset=UTF-8" language="java" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<html>  
<head>  
    <title>配送信息跟踪 - 同城配送系统</title>  
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">  
    <style>  
        body {  
            padding-top: 60px;  
            padding-bottom: 40px;  
        }  
        .container {  
            max-width: 1200px;  
        }  
        .search-form {  
            margin-bottom: 20px;  
            padding: 15px;  
            background-color: #f8f9fa;  
            border-radius: 5px;  
        }  
        .table-actions {  
            white-space: nowrap;  
        }  
        .status-tag {  
            display: inline-block;  
            padding: 3px 8px;  
            border-radius: 4px;  
            font-size: 12px;  
            color: white;  
        }  
        .btn-search {  
            margin-top: 23px;  
        }  
    </style>  
</head>  
<body>  
    <!-- 导航栏 -->
    <jsp:include page="navbar.jsp"/>

    <div class="container">  
        <h2>配送信息跟踪</h2>  
        
        <!-- 消息提示 -->  
        <c:if test="${not empty message}">  
            <div class="alert alert-success">${message}</div>  
        </c:if>  
        <c:if test="${not empty error}">  
            <div class="alert alert-danger">${error}</div>  
        </c:if>  
        
        <!-- 搜索表单 -->  
        <div class="search-form">  
            <form action="${pageContext.request.contextPath}/admin/delivery-tracking" method="get" class="form-horizontal">  
                <div class="form-group">  
                    <label for="orderId" class="col-sm-2 control-label">配送单编号：</label>  
                    <div class="col-sm-3">  
                        <input type="text" name="orderId" id="orderId" class="form-control" value="${orderId}" placeholder="如 DEL20251012001">  
                    </div>  
                    
                    <label for="senderPhone" class="col-sm-2 control-label">接货人电话：</label>  
                    <div class="col-sm-3">  
                        <input type="text" name="senderPhone" id="senderPhone" class="form-control" value="${senderPhone}" placeholder="11位手机号">  
                    </div>  
                </div>  
                
                <div class="form-group">  
                    <label for="consigneePhone" class="col-sm-2 control-label">收货人电话：</label>  
                    <div class="col-sm-3">  
                        <input type="text" name="consigneePhone" id="consigneePhone" class="form-control" value="${consigneePhone}" placeholder="11位手机号">  
                    </div>  
                    
                    <label for="deliverymanId" class="col-sm-2 control-label">配送员ID/姓名：</label>  
                    <div class="col-sm-3">  
                        <input type="text" name="deliverymanInfo" id="deliverymanInfo" class="form-control" value="${deliverymanInfo}" placeholder="配送员ID或姓名">  
                    </div>  
                </div>  
                
                <div class="form-group">  
                    <label for="status" class="col-sm-2 control-label">配送状态：</label>  
                    <div class="col-sm-3">  
                        <select name="status" id="status" class="form-control">  
                            <option value="">全部</option>  
                            <option value="0" <c:if test="status == 0">selected</c:if>>待接单</option>  
                            <option value="1" <c:if test="status == 1">selected</c:if>>已接单待取货</option>  
                            <option value="2" <c:if test="status == 2">selected</c:if>>配送中</option>  
                            <option value="3" <c:if test="status == 3">selected</c:if>>已完成</option>  
                            <option value="4" <c:if test="status == 4">selected</c:if>>已取消</option>  
                        </select>  
                    </div>  
                    
                    <label class="col-sm-2 control-label">时间范围：</label>  
                    <div class="col-sm-3">  
                        <div class="input-group">  
                            <input type="date" name="startTime" id="startTime" class="form-control" value="${startTime}">  
                            <span class="input-group-addon">至</span>  
                            <input type="date" name="endTime" id="endTime" class="form-control" value="${endTime}">  
                        </div>  
                    </div>  
                </div>  
                
                <div class="form-group">  
                    <div class="col-sm-offset-2 col-sm-10">  
                        <button type="submit" class="btn btn-primary">查询</button>  
                        <a href="${pageContext.request.contextPath}/admin/delivery-tracking" class="btn btn-default">重置</a>  
                    </div>  
                </div>  
            </form>  
        </div>  
        
        <!-- 配送单列表 -->  
        <c:if test="${not empty pageResult.list and pageResult.total > 0}">  
            <div class="table-responsive">  
                <table class="table table-bordered table-striped">  
                    <thead>  
                        <tr>  
                            <th>配送单编号</th>  
                            <th>接货地址</th>  
                            <th>收货人地址</th>  
                            <th>配送状态</th>  
                            <th>创建时间</th>  
                            <th>操作</th>  
                        </tr>  
                    </thead>  
                    <tbody>  
                        <c:forEach items="${pageResult.list}" var="order">  
                            <tr>  
                                <td>${order.orderId}</td>  
                                <td>${order.senderAddress}</td>  
                                <td>${order.consigneeAddress}</td>  
                                <td>  
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
                                        <c:otherwise>  
                                            <span class="status-tag" style="background-color: #999;">未知状态</span>  
                                        </c:otherwise>  
                                    </c:choose>  
                                </td>  
                                <td>  
                                    <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>  
                                </td>  
                                <td class="table-actions">  
                                    <a href="${pageContext.request.contextPath}/admin/track/${order.orderId}" class="btn btn-info btn-sm">查看详情</a>  
                                </td>  
                            </tr>  
                        </c:forEach>  
                    </tbody>  
                </table>  
            </div>  
            
            <!-- 分页 -->  
            <div class="text-center">  
                <nav aria-label="Page navigation">  
                    <ul class="pagination">  
                        <li <c:if test="${pageResult.page == 1}">class="disabled"</c:if>>  
                            <a href="${pageContext.request.contextPath}/admin/delivery-tracking?page=1&size=${pageResult.size}" aria-label="Previous">  
                                <span aria-hidden="true">&laquo;</span>  
                            </a>  
                        </li>  
                        <c:forEach begin="1" end="${pageResult.totalPages}" var="i">  
                            <li <c:if test="${i == pageResult.page}">class="active"</c:if>>  
                                <a href="${pageContext.request.contextPath}/admin/delivery-tracking?page=${i}&size=${pageResult.size}">${i}</a>  
                            </li>  
                        </c:forEach>  
                        <li <c:if test="${pageResult.page == pageResult.totalPages}">class="disabled"</c:if>>  
                            <a href="${pageContext.request.contextPath}/admin/delivery-tracking?page=${pageResult.totalPages}&size=${pageResult.size}" aria-label="Next">  
                                <span aria-hidden="true">&raquo;</span>  
                            </a>  
                        </li>  
                    </ul>  
                </nav>  
                <p>共 ${pageResult.total} 条记录，第 ${pageResult.page} / ${pageResult.totalPages} 页</p>  
            </div>  
        </c:if>  
        
        <!-- 空结果提示 -->  
        <c:if test="${empty pageResult.list or pageResult.total == 0}">  
            <div class="alert alert-warning text-center">  
                未查询到符合条件的配送单，请调整查询条件  
            </div>  
        </c:if>  
    </div>  
    
    <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
        <script>
            $(document).ready(function() {
                // 确保表单有ID
                if (!$('form').attr('id')) {
                    $('form').attr('id', 'searchForm');
                }
                
                // 添加隐藏的页码输入框
                if ($('#page').length === 0) {
                    $('form').append('<input type="hidden" id="page" name="page" value="1">');
                }
                
                // 表单提交验证
            $('#searchForm').submit(function(e) {
                // 验证手机号格式
                var senderPhone = $('#senderPhone').val();
                var consigneePhone = $('#consigneePhone').val();
                var phoneRegex = /^1[3-9]\d{9}$/;
                
                if (senderPhone && !phoneRegex.test(senderPhone)) {
                    alert('接货人电话格式不正确，请输入11位手机号码');
                    return false;
                }
                
                if (consigneePhone && !phoneRegex.test(consigneePhone)) {
                    alert('收货人电话格式不正确，请输入11位手机号码');
                    return false;
                }
                    
                    // 验证日期范围
                    var startTime = $('#startTime').val();
                    var endTime = $('#endTime').val();
                    if (startTime && endTime && endTime < startTime) {
                        alert('结束日期不能早于开始日期');
                        return false;
                    }
                    
                    return true;
                });
            });
            
            // 分页功能
            function changePage(page) {
                $('#page').val(page);
                $('#searchForm').submit();
            }
            
            // 重置表单
            function resetForm() {
                $('#searchForm')[0].reset();
                $('#page').val(1);
            }
        </script>  
</body>  
</html>