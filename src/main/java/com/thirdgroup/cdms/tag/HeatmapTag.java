package com.thirdgroup.cdms.tag;

import javax.servlet.jsp.tagext.SimpleTagSupport;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.JspException;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class HeatmapTag extends SimpleTagSupport {
    private String id;         // 容器 div 的 id
    private String title;      // 标题
    private List<Map<String, Object>> data; // 热力图数据列表

    public void setId(String id) { this.id = id; }
    public void setTitle(String title) { this.title = title; }
    public void setData(List<Map<String, Object>> data) { this.data = data; }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();

        // 输出容器 HTML
        out.write("<div class='col-md-7'>");
        out.write("<div class='info-card h-100'>");
        out.write("<h4 class='text-center fw-bold mb-3'>" + title + "</h4>");
        out.write("<div id='" + id + "' style='width:100%;height:500px;'></div>");
        out.write("</div></div>");

        // 输出脚本
        out.write("<script>");
        out.write("const heatmapData = [");
        if (data != null && !data.isEmpty()) {
            for (int i = 0; i < data.size(); i++) {
                Map<String, Object> item = data.get(i);
                String address = String.valueOf(item.get("address"));
                Object normalized = item.get("normalized");
                Object count = item.get("count");
                out.write(String.format("{name:'%s', value:%s, realValue:%s}", address, normalized, count));
                if (i < data.size() - 1) out.write(",");
            }
        }
        out.write("];");

        out.write("const chart = echarts.init(document.getElementById('" + id + "'));");
        out.write("chart.setOption({");
        out.write("tooltip:{trigger:'item',formatter:function(p){return p.name+'<br/>订单数：'+p.data.realValue;}}," +
                "visualMap:{min:0,max:1,left:'left',bottom:'10%',text:['高','低'],inRange:{color:['#e4d9c2','#fabb7d','#f49506']},calculable:true}," +
                "series:[{name:'订单量',type:'map',map:'china',roam:true,label:{show:false},data:heatmapData}]");
        out.write("});");
        out.write("</script>");
    }
}
