<%--
  Created by IntelliJ IDEA.
  User: LHkeeper
  Date: 2025/10/30
  Time: 22:43
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>订单统计</title>
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
    </style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <jsp:include page="navbar.jsp"/>

    <div class="container mt-4">
        <form class="search-form d-flex align-items-center gap-3"
              action="${pageContext.request.contextPath}/admin/order/statistic"
              method="GET">
            <label for="timeRange" class="form-label mb-0">时间范围：</label>
            <select id="timeRange" class="form-select" style="width: 200px;">
                <option value="">选择时间范围</option>
                <option value="7">过去一周</option>
                <option value="30">过去一个月</option>
                <option value="90">过去一个季度</option>
                <option value="365">过去一年</option>
            </select>
            <input type="hidden" name="startTime" id="startTime">
            <input type="hidden" name="endTime" id="endTime">
        </form>
    </div>

    <!-- 订单统计概览卡片 -->
    <div class="container mt-4">
        <h4>📊 订单统计概览</h4>
        <div class="row text-center mt-3">

            <div class="col-md-4">
                <div class="card shadow-sm border-success">
                    <div class="card-body">
                        <h6 class="card-title text-success">总订单数</h6>
                        <h5 class="fw-bold">
                            <c:out value="${orderStatistic.totalCount}" default="0"/> 单
                        </h5>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-primary">
                    <div class="card-body">
                        <h6 class="card-title text-primary">总收入</h6>
                        <h5 class="fw-bold">
                            ￥<fmt:formatNumber value="${orderStatistic.totalAmount}" pattern="#,##0.00" />
                        </h5>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-danger">
                    <div class="card-body">
                        <h6 class="card-title text-danger">平均配送时长</h6>
                        <h5 class="fw-bold">
                            <fmt:formatNumber value="${orderStatistic.avgDeliveryTime}" pattern="#0.00" /> 分钟
                        </h5>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- 在页面中添加图表区域 -->
    <div class="container mt-4">
        <canvas id="ordersChart" height="120"></canvas>
    </div>
</body>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const trendData = [
        <c:forEach var="t" items="${trendList}" varStatus="loop">
        {
            date: '${t.date}',
            orderCount: ${t.orderCount},
            totalIncome: ${t.totalIncome},
            avgDeliveryTime: ${t.avgDeliveryTime}
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const dates = trendData.map(item => item.date);
    const orderCounts = trendData.map(item => item.orderCount);
    const incomes = trendData.map(item => item.totalIncome);
    const avgTimes = trendData.map(item => item.avgDeliveryTime);

    const ctx = document.getElementById('ordersChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: dates,
            datasets: [
                {
                    label: '订单数',
                    data: orderCounts,
                    borderColor: 'rgba(75, 192, 192, 1)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.3,
                    fill: true
                },
                {
                    label: '总收入（元）',
                    data: incomes,
                    borderColor: 'rgba(255, 99, 132, 1)',
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    tension: 0.3,
                    fill: true
                },
                {
                    label: '平均配送时长（分钟）',
                    data: avgTimes,
                    borderColor: 'rgba(54, 162, 235, 1)',
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    tension: 0.3,
                    fill: true
                }
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'top' },
                title: {
                    display: true,
                    text: '历史订单趋势图'
                }
            },
            scales: {
                y: { beginAtZero: true }
            }
        }
    });

    // 根据选择的时间范围重新GET
    document.getElementById("timeRange").addEventListener("change", function() {
        const value = this.value;
        if (!value) return;

        const endTime = new Date();
        const startTime = new Date();
        startTime.setDate(endTime.getDate() - parseInt(value) + 1);

        // 日期格式化函数（非常关键）
        const fmt = (d) => {
            if (!(d instanceof Date) || isNaN(d)) {
                return "";
            }
            const y = d.getFullYear();
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const da = String(d.getDate()).padStart(2, '0');
            return y + '-' + m + '-' + da;
        };

        const startStr = fmt(startTime);
        const endStr = fmt(endTime);

        console.log("startStr =", startStr);
        console.log("endStr =", endStr);

        document.getElementById("startTime").value = startStr;
        document.getElementById("endTime").value = endStr;

        const form = this.closest("form");
        form.submit();
    });
</script>
</html>
