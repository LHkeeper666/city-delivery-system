<%--
  Created by IntelliJ IDEA.
  User: LHkeeper
  Date: 2025/11/4
  Time: 21:31
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<footer class="footer text-center mt-auto">
    <div class="container py-3">
        <p class="mb-1 text-muted">
            🚚 <strong>同城配送后台管理系统</strong>
        </p>
        <p class="mb-1 text-secondary">
            © <%= java.time.Year.now() %> 同城配送团队 | 版本 v1.0.0
        </p>
        <p class="small text-muted mb-0">
            建议使用现代浏览器（Chrome / Edge / Firefox）以获得最佳体验
        </p>
    </div>
</footer>

<style>
    .footer {
        background-color: #fff;      /* 白色背景 */
        color: #555;                /* 深灰文字 */
        font-size: 14px;
        width: 100%;
        margin-top: auto;
        border-top: none;           /* 去除上边框 */
        box-shadow: 0 -1px 3px rgba(0,0,0,0.05); /* 微阴影更自然 */
    }

    .footer p {
        margin: 0;
        line-height: 1.6;
    }

    .footer a {
        color: #007bff;
        text-decoration: none;
        transition: color 0.2s ease;
    }

    .footer a:hover {
        color: #0056b3;
        text-decoration: underline;
    }
</style>
