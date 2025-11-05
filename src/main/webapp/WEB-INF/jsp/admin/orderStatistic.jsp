<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="my" uri="/mytags" %>

<html>
<head>
    <title>订单统计分析</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/echarts@5"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts/map/js/china.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /*body {*/
        /*    background-color: #f3f6f9;*/
        /*    padding-top: 70px;*/
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
            max-width: 1300px;
        }
        .section-title {
            font-weight: 700;
            color: #333;
            border-left: 5px solid #007bff;
            padding-left: 10px;
            margin-bottom: 25px;
        }
        .search-form {
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        .info-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            padding: 20px;
            margin-bottom: 20px;
        }
        .info-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.12);
        }
        .info-card h5 {
            font-weight: 600;
        }
        .info-card h3 {
            font-size: 2rem;
            font-weight: bold;
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<main class="container">
    <h1>数据统计</h1>

    <!-- 查询区域 -->
    <form class="search-form mb-4" action="${pageContext.request.contextPath}/admin/order/statistic" method="GET">
        <div class="row align-items-center">
            <div class="col-md-3">
                <label for="timeRange" class="form-label">时间范围：</label>
                <select id="timeRange" class="form-control" name="timeRange">
                    <option value="7" ${7 eq timeRange ? 'selected' : ''}>过去一周</option>
                    <option value="30" ${30 eq timeRange ? 'selected' : ''}>过去一个月</option>
                    <option value="90" ${90 eq timeRange ? 'selected' : ''}>过去一个季度</option>
                    <option value="365" ${365 eq timeRange ? 'selected' : ''}>过去一年</option>
                </select>
                <input type="hidden" name="startTime" id="startTime">
                <input type="hidden" name="endTime" id="endTime">
            </div>
        </div>
    </form>

    <!-- 概览卡片 -->
    <h3 class="section-title">📈 订单统计概览</h3>
    <div class="row text-center">
        <div class="col-md-4">
            <div class="info-card border-success">
                <h5 class="text-success">总订单数</h5>
                <h3><c:out value="${orderStatistic.totalCount}" default="0"/> 单</h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="info-card border-primary">
                <h5 class="text-primary">总收入</h5>
                <h3>￥<fmt:formatNumber value="${orderStatistic.totalAmount}" pattern="#,##0.00" /></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="info-card border-danger">
                <h5 class="text-danger">平均配送时长</h5>
                <h3><fmt:formatNumber value="${orderStatistic.avgDeliveryTime}" pattern="#0.00" /> 分钟</h3>
            </div>
        </div>
    </div>

    <!-- 图表展示 -->
    <h3 class="section-title">📊 趋势与分布</h3>
    <div class="row align-items-stretch">
        <!-- 热力图 -->
<%--        <div class="col-md-7">--%>
<%--            <div class="info-card h-100">--%>
<%--                <h4 class="text-center fw-bold mb-3">各地区订单热力图</h4>--%>
<%--                <div id="orderHeatmap" style="width:100%;height:500px;"></div>--%>
<%--            </div>--%>
<%--        </div>--%>
        <my:heatmap id="orderHeatmap" title="各地区订单热力图" data="${heatmapData}" />

        <!-- 折线图 -->
<%--        <div class="col-md-5">--%>
<%--            <div class="info-card h-100">--%>
<%--                <h4 class="text-center fw-bold mb-3">历史订单趋势图</h4>--%>
<%--                <canvas id="ordersChart" style="width:100%;height:500px;"></canvas>--%>
<%--            </div>--%>
<%--        </div>--%>
        <my:orderTrend data="${trendList}" />
    </div>
</main>

<jsp:include page="/WEB-INF/jsp/admin/footer.jsp"/>

</body>
<!-- 热力图脚本 -->
<%--<script>--%>
<%--    const heatmapData = [--%>
<%--        <c:forEach var="item" items="${heatmapData}" varStatus="loop">--%>
<%--        {--%>
<%--            name: '${item.address}',--%>
<%--            value: ${item.normalized}, // 用归一化值来决定颜色--%>
<%--            realValue: ${item.count}   // 保存真实订单数用于提示显示--%>
<%--        }<c:if test="${!loop.last}">,</c:if>--%>
<%--        </c:forEach>--%>
<%--    ];--%>

<%--    console.log(heatmapData);--%>

<%--    const heatChart = echarts.init(document.getElementById('orderHeatmap'));--%>
<%--    heatChart.setOption({--%>
<%--        tooltip: {--%>
<%--            trigger: 'item',--%>
<%--            formatter: function (params) {--%>
<%--                &lt;%&ndash;return `${params.name}<br/>订单数: ${params.data.realValue}`;&ndash;%&gt;--%>
<%--                return params.name + '<br/>订单数：' + params.data.realValue;--%>
<%--            }--%>
<%--        },--%>
<%--        visualMap: {--%>
<%--            min: 0,--%>
<%--            max: 1, // 因为 value 是归一化值--%>
<%--            left: 'left',--%>
<%--            bottom: '10%',--%>
<%--            text: ['高', '低'],--%>
<%--            inRange: { color: ['#e4d9c2', '#fabb7d', '#f49506'] },--%>
<%--            calculable: true--%>
<%--        },--%>
<%--        series: [{--%>
<%--            name: '订单量',--%>
<%--            type: 'map',--%>
<%--            map: 'china',--%>
<%--            roam: true,--%>
<%--            label: { show: false },--%>
<%--            data: heatmapData--%>
<%--        }]--%>
<%--    });--%>
<%--</script>--%>

<!-- 折线图脚本 -->
<script>
    <%--const trendData = [--%>
    <%--    <c:forEach var="t" items="${trendList}" varStatus="loop">--%>
    <%--    {--%>
    <%--        date: '${t.date}',--%>
    <%--        orderCount: ${t.orderCount},--%>
    <%--        totalIncome: ${t.totalIncome},--%>
    <%--        avgDeliveryTime: ${t.avgDeliveryTime}--%>
    <%--    }<c:if test="${!loop.last}">,</c:if>--%>
    <%--    </c:forEach>--%>
    <%--];--%>

    <%--const dates = trendData.map(item => new Date(item.date).toLocaleDateString('zh-CN'));--%>
    <%--const orderCounts = trendData.map(item => item.orderCount);--%>
    <%--const incomes = trendData.map(item => item.totalIncome);--%>
    <%--const avgTimes = trendData.map(item => item.avgDeliveryTime);--%>

    <%--new Chart(document.getElementById('ordersChart'), {--%>
    <%--    type: 'line',--%>
    <%--    data: {--%>
    <%--        labels: dates,--%>
    <%--        datasets: [--%>
    <%--            { label: '订单数', data: orderCounts, borderColor: '#28a745', backgroundColor: 'rgba(40,167,69,0.15)', tension: 0.3, fill: true },--%>
    <%--            { label: '总收入（元）', data: incomes, borderColor: '#007bff', backgroundColor: 'rgba(0,123,255,0.15)', tension: 0.3, fill: true },--%>
    <%--            { label: '平均配送时长（分钟）', data: avgTimes, borderColor: '#dc3545', backgroundColor: 'rgba(220,53,69,0.15)', tension: 0.3, fill: true }--%>
    <%--        ]--%>
    <%--    },--%>
    <%--    options: {--%>
    <%--        responsive: true,--%>
    <%--        plugins: { legend: { position: 'top' } },--%>
    <%--        scales: { y: { beginAtZero: true } }--%>
    <%--    }--%>
    <%--});--%>

    // ⏱时间范围选择逻辑
    document.getElementById("timeRange").addEventListener("change", function() {
        const val = this.value;
        const end = new Date();
        const start = new Date();
        start.setDate(end.getDate() - parseInt(val) + 1);

        <%--const fmt = d => `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`;--%>

        // 格式化日期函数 - 只显示年月日
        function fmt(dateString) {
            const date = new Date(dateString);
            // 方法1: 使用toLocaleDateString
            // return date.toLocaleDateString('zh-CN', {
            //     year: 'numeric',
            //     month: '2-digit',
            //     day: '2-digit'
            // });

            // 方法2: 手动拼接（如果需要特定格式）
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            <%--return `${year}-${month}-${day}`;--%>
            return year + '-' + month + '-' + day;
        }

        document.getElementById("startTime").value = fmt(start);
        document.getElementById("endTime").value = fmt(end);
        this.form.submit();
    });
</script>

</html>
