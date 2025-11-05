package com.thirdgroup.cdms.tag;

import com.thirdgroup.cdms.model.OrderTrendDTO;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

public class OrderTrendTag extends SimpleTagSupport {
    private List<OrderTrendDTO> data; // ✅ 改为 DTO 类型

    public void setData(List<OrderTrendDTO> data) {
        this.data = data;
    }

    @Override
    public void doTag() throws IOException {
//        if (data == null || data.isEmpty()) return;

        JspWriter out = getJspContext().getOut();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // ✅ 构造 JavaScript 数据
        StringBuilder jsData = new StringBuilder("[");
        for (int i = 0; i < data.size(); i++) {
            OrderTrendDTO t = data.get(i);
            String dateStr = t.getDate() != null ? sdf.format(t.getDate()) : "";
            jsData.append("{")
                    .append("date:'").append(dateStr).append("',")
                    .append("orderCount:").append(t.getOrderCount()).append(",")
                    .append("totalIncome:").append(t.getTotalIncome()).append(",")
                    .append("avgDeliveryTime:").append(t.getAvgDeliveryTime())
                    .append("}");
            if (i < data.size() - 1) jsData.append(",");
        }
        jsData.append("]");

        // ✅ 输出 HTML + JS
        out.write(
                "<div class=\"col-md-5\">" +
                        "<div class=\"info-card h-100\">" +
                        "<h4 class=\"text-center fw-bold mb-3\">历史订单趋势图</h4>" +
                        "<canvas id=\"ordersChart\" style=\"width:100%;height:500px;\"></canvas>" +
                        "</div>" +
                        "</div>" +

                        "<script>" +
                        "const trendData = " + jsData + ";" +
                        "const dates = trendData.map(item => new Date(item.date).toLocaleDateString('zh-CN'));" +
                        "const orderCounts = trendData.map(item => item.orderCount);" +
                        "const incomes = trendData.map(item => item.totalIncome);" +
                        "const avgTimes = trendData.map(item => item.avgDeliveryTime);" +

                        "new Chart(document.getElementById('ordersChart'), {" +
                        "type: 'line'," +
                        "data: {" +
                        "labels: dates," +
                        "datasets: [" +
                        "{ label: '订单数', data: orderCounts, borderColor: '#28a745', backgroundColor: 'rgba(40,167,69,0.15)', tension: 0.3, fill: true }," +
                        "{ label: '总收入（元）', data: incomes, borderColor: '#007bff', backgroundColor: 'rgba(0,123,255,0.15)', tension: 0.3, fill: true }," +
                        "{ label: '平均配送时长（分钟）', data: avgTimes, borderColor: '#dc3545', backgroundColor: 'rgba(220,53,69,0.15)', tension: 0.3, fill: true }" +
                        "]" +
                        "}," +
                        "options: {" +
                        "responsive: true," +
                        "plugins: { legend: { position: 'top' } }," +
                        "scales: { y: { beginAtZero: true } }" +
                        "}" +
                        "});" +
                        "</script>"
        );
    }
}
