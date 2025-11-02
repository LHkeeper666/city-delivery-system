<%--
  Created by IntelliJ IDEA.
  User: LHkeeper
  Date: 2025/11/1
  Time: 22:24
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>密钥管理</title>
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
        .status-badge {
          display: inline-block;
          padding: 3px 8px;
          border-radius: 10px;
          font-size: 12px;
          font-weight: 500;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="navbar.jsp"/>

<div class="container">
    <h1>密钥管理</h1>
    <!-- 搜索表单 -->
    <div class="search-form">
        <form action="${pageContext.request.contextPath}/admin/api-key-list" method="get" class="form-inline">

            <div class="form-group">
                <label for="status">状态：</label>
                <select name="status" id="status" class="form-control">
                    <option value="">全部</option>
                    <option value="enabled" <c:if test="${status eq 'enabled'}">selected</c:if>>启用</option>
                    <option value="disabled" <c:if test="${status eq 'disabled'}">selected</c:if>>禁用</option>
                </select>
            </div>

            <div class="form-group">
                <label for="keyword">关键词：</label>
                <input type="text" name="keyword" id="keyword" class="form-control" value="${keyword}" placeholder="应用名称">
            </div>

            <button type="submit" class="btn btn-primary">搜索</button>
            <a href="${pageContext.request.contextPath}/admin/api-key-list" class="btn btn-default" style="margin-left: 10px;">重置</a>
        </form>
        <button type="button" class="btn btn-primary" onclick="showAddAPIKeyModal()">添加API Key</button>
    </div>

      <!-- 错误提示 -->
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger">${errorMsg}</div>
    </c:if>

      <!-- 订单列表 -->
    <table class="table table-striped table-hover">
        <thead>
        <tr>
            <th>keyID</th>
            <th>应用名称</th>
            <th>APIKey</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${apiKeys != null && apiKeys.list != null && not empty apiKeys.list}">
            <c:forEach var="apiKey" items="${apiKeys.list}">
            <tr>
                <td>${apiKey.keyId}</td>
                <td>${apiKey.appName}</td>
<%--                <td>${apiKey.apiKey}</td>--%>
                <td>
                    <span class="text-primary" style="cursor: pointer;"
                          onclick="showFullKey('${apiKey.apiKey}')">
                        ${fn:substring(apiKey.apiKey, 0, 8)}...
                    </span>
                </td>
<%--                <td>${apiKey.status}</td>--%>
                <td>
                    <c:choose>
                        <c:when test="${apiKey.status eq 'enabled'}">启用</c:when>
                        <c:otherwise>禁用</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <fmt:formatDate value="${apiKey.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                </td>
                <td class="table-actions" style="min-width: 100px;">
                    <a href="${pageContext.request.contextPath}/admin/api-key-set-status?keyId=${apiKey.keyId}" class="btn btn-sm btn-info">
                        <c:choose>
                            <c:when test="${apiKey.status eq 'enabled'}">禁用</c:when>
                            <c:otherwise>启用</c:otherwise>
                        </c:choose>
                    </a>
                </td>
            </tr>
            </c:forEach>
        </c:if>
        </tbody>
    </table>

    <!-- 分页 -->
    <c:if test="${apiKeys != null && apiKeys.total > 0}">
        <nav aria-label="Page navigation" class="text-center">
            <ul class="pagination">
                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(1)" aria-label="First">
                        <span aria-hidden="true">首页</span>
                    </a>
                </li>
                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(${apiKeys.page > 1 ? apiKeys.page - 1 : 1})" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>

                <c:set var="startPage" value="${apiKeys.page - 2}" />
                <c:set var="endPage" value="${apiKeys.page + 2}" />
                <c:set var="totalPages" value="${(apiKeys.total + apiKeys.size - 1) / apiKeys.size}" />

                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1" />
                    <c:set var="endPage" value="${Math.min(5.0, totalPages)}" />
                </c:if>
                <c:if test="${endPage > totalPages}">
                    <c:set var="endPage" value="${totalPages}" />
                    <c:set var="startPage" value="${Math.max(1.0, totalPages - 4)}" />
                </c:if>

                <c:forEach begin="${startPage}" end="${endPage}" var="p">
                    <li class="${p == apiKeys.page ? 'active' : ''}">
                        <a href="javascript:void(0)" onclick="gotoPage(${p})"><c:out value="${p}"/></a>
                    </li>
                </c:forEach>

                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(${apiKeys.page < totalPages ? apiKeys.page + 1 : totalPages})" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
                <li>
                    <a href="javascript:void(0)" onclick="gotoPage(${totalPages})" aria-label="Last">
                        <span aria-hidden="true">末页</span>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<!-- API Key 弹窗 -->
<div class="modal fade" id="apiKeyModal" tabindex="-1" role="dialog" aria-labelledby="apiKeyModalLabel">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="关闭">&times;</button>
                <h4 class="modal-title" id="apiKeyModalLabel">完整 API Key</h4>
            </div>
            <div class="modal-body">
                <pre id="fullApiKey" style="user-select: all; white-space: pre-wrap; word-break: break-all;"></pre>
                <div class="text-right" style="margin-top: 10px;">
                    <span id="copyFullApiKeyTip" class="text-success" style="display:none;">已复制!</span>
                    <button class="btn btn-sm btn-primary" onclick="copyFullApiKey()">复制到剪贴板</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 添加 API Key 模态框 -->
<%--TODO: 美化--%>
<div class="modal fade" id="addApiKeyModal" tabindex="-1" role="dialog" aria-labelledby="addApiKeyModalLabel">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <!-- 标题栏 -->
            <div class="modal-header bg-primary text-white" style="color:white;">
                <button type="button" class="close" data-dismiss="modal" aria-label="关闭" style="color:white;">&times;</button>
                <h4 class="modal-title" id="addApiKeyModalLabel">
                    <span class="glyphicon glyphicon-plus"></span> 添加新的 API Key
                </h4>
            </div>

            <!-- 内容区 -->
            <form action="${pageContext.request.contextPath}/admin/new-api-key" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="appName">应用名称：</label>
                        <input type="text" class="form-control" id="appName" name="appName"
                               placeholder="请输入应用名称" required>
                    </div>
                </div>

                <!-- 底部按钮 -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">
                        <span class="glyphicon glyphicon-ok"></span> 提交
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="newApiKeyModal" tabindex="-1" role="dialog" aria-labelledby="newKeyLabel">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="newKeyLabel">新添加的 API Key</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="关闭">&times;</button>
            </div>
            <div class="modal-body text-center">
                <p class="text-muted">请妥善保存此 Key，离开此页面后将无法再次查看。</p>
                <pre id="newApiKeyValue" class="bg-light p-3 rounded border"></pre>
                <button class="btn btn-success btn-sm" onclick="copyNewApiKey()">复制 Key</button>
                <span id="copyTip" class="text-success ml-2" style="display:none;">已复制!</span>
            </div>
        </div>
    </div>
</div>
</body>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script>
    // TODO: 测试翻页功能
    function gotoPage(pageNum) {
        window.location.href = '${pageContext.request.contextPath}/admin/api-key-list?page=' + pageNum + '&size=${apiKeys.size}&keyword=${keyword}';
    }

    function showFullKey(apiKey) {
        $('#fullApiKey').text(apiKey);
        $('#copyFullApiKeyTip').hide();
        $('#apiKeyModal').modal('show');
    }

    function copyFullApiKey() {
        const text = $('#fullApiKey').text();
        navigator.clipboard.writeText(text).then(() => {
            $('#copyFullApiKeyTip').show();
            setTimeout(() => $('#copyFullApiKeyTip').hide(), 1500);
        }).catch(err => alert("复制失败：" + err));
    }

    function showAddAPIKeyModal() {
        console.log('点击了');
        $('#addApiKeyModal').modal('show');
    }

    function copyNewApiKey() {
        const key = document.getElementById("newApiKeyValue").innerText;
        navigator.clipboard.writeText(key).then(() => {
            document.getElementById("copyTip").style.display = "inline";
        });
    }
</script>
<c:if test="${not empty newKey}">
    <script>
        $(document).ready(function() {
            // 动态设置modal内容
            $("#newApiKeyValue").text("${newKey}");
            $("#newApiKeyModal").modal("show");
        });
    </script>
</c:if>

</html>
