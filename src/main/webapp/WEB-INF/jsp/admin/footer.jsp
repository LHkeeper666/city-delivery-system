<%--
  Created by IntelliJ IDEA.
  User: LHkeeper
  Date: 2025/11/4
  Time: 21:31
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<footer class="footer bg-dark text-light text-center mt-auto">
    <div class="container py-3">
        <p class="mb-1">
            🚚 <strong>同城配送后台管理系统</strong>
        </p>
        <p class="mb-1">
            © <%= java.time.Year.now() %> 同城配送团队 | 版本 v1.0.0
        </p>
        <p class="small text-secondary mb-0">
            建议使用现代浏览器（Chrome / Edge / Firefox）以获得最佳体验
        </p>
    </div>
</footer>

<style>
    /*html, body {*/
    /*    height: 100%;*/
    /*    margin: 0;*/
    /*    display: flex;*/
    /*    flex-direction: column;*/
    /*}*/

    /*!* 页面主要内容区域（需包裹你的主体部分） *!*/
    /*main {*/
    /*    flex: 1;*/
    /*    background-color: #f7f8fa; !* 可选 *!*/
    /*    padding-top: 60px; !* 防止被顶部导航栏挡住 *!*/
    /*}*/

    .footer {
        background-color: #222;
        color: #ccc;
        font-size: 14px;
        border-top: 1px solid #333;
        width: 100%;
        margin-top: auto;
    }

    .footer p {
        margin: 0;
        line-height: 1.6;
    }

    .footer a {
        color: #66b3ff;
        text-decoration: none;
    }

    .footer a:hover {
        color: #fff;
        text-decoration: underline;
    }
</style>
