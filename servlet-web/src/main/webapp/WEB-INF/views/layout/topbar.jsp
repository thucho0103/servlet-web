<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<header class="topbar">
    <nav class="crumbs" aria-label="Breadcrumb">
        <a href="${ctx}/">${appName}</a>
        <span class="sep">/</span>
        <span class="current">${crumbsCurrent != null ? crumbsCurrent : 'Home'}</span>
    </nav>
    <div class="right">
        <span class="pill" title="Server status"><span class="dot"></span>UP</span>
    </div>
</header>
