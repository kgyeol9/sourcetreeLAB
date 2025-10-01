<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>문의 상세</title>
<style>
  .wrap{max-width:960px;margin:40px auto;padding:0 12px;color:#eee}
  .card{background:#1f1f1f;border:1px solid rgba(255,255,255,.08);border-radius:12px;padding:16px}
  .title{font-size:20px;margin:0 0 10px}
  .meta{color:#9aa0a6;font-size:12px;margin-bottom:10px}
  .badge{display:inline-block;padding:3px 8px;border-radius:999px;border:1px solid #333;background:#191919;font-size:12px;margin-right:6px}
  .badge.done{color:#9cd89c;border-color:#1f3b1f;background:#0f2a0f}
  .badge.wait{color:#ffd29c;border-color:#4d3a1f;background:#2a1e0f}
  pre{white-space:pre-wrap;word-break:break-word;margin:0}
</style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <c:choose>
      <c:when test="${not empty error}">
        <div class="meta">${error}</div>
      </c:when>
      <c:otherwise>
        <%-- ★ 카테고리 라벨 --%>
        <c:set var="label" value=""/>
        <c:choose>
          <c:when test="${t.category eq 'account'}"><c:set var="label" value="계정/로그인"/></c:when>
          <c:when test="${t.category eq 'billing'}"><c:set var="label" value="결제/환불"/></c:when>
          <c:when test="${t.category eq 'bug'}"><c:set var="label" value="버그 제보"/></c:when>
          <c:when test="${t.category eq 'etc'}"><c:set var="label" value="기타"/></c:when>
        </c:choose>

        <h1 class="title">
          <c:if test="${not empty label}">[${label}] </c:if>
          <c:out value="${t.title}"/>
        </h1>

        <div class="meta">
          <span class="badge ${t.status eq '답변완료' ? 'done' : 'wait'}"><c:out value="${t.status}"/></span>
          분류: <c:out value="${label}"/> &nbsp;|&nbsp;
          작성일: <c:out value="${t.createdAt}"/>
        </div>

        <pre><c:out value="${t.content}"/></pre>
      </c:otherwise>
    </c:choose>
  </div>
</div>
</body>
</html>
