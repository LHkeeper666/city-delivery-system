<!-- 订单列表页面示例（JSP） -->
<table class="table">
    <tbody>
    <!-- 遍历当前页订单列表 -->
    <c:forEach items="${pageResult.list}" var="order">
        <tr>
            <td>${order.orderId}</td>
            <td>${order.consigneeName}</td>
            <td>${order.status}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<!-- 分页控件 -->
<div class="pagination">
    总条数：${pageResult.total} 条 |
    当前第 ${pageResult.page} 页 / 共 ${(pageResult.total + pageResult.size - 1) / pageResult.size} 页
    <a href="/admin/orders?page=${pageResult.page-1}&size=10">上一页</a>
    <a href="/admin/orders?page=${pageResult.page+1}&size=10">下一页</a>
</div>