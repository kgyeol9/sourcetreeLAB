<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>파티 상세</title>
  <style>
    body{background:#111;color:#eee;margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto}
    .wrap{max-width:920px;margin:24px auto;padding:16px}
    .card{background:#1a1a1a;border:1px solid #2a2a2a;border-radius:12px;padding:16px}
    .meta{opacity:.9}
    a{color:#fff}
    .btn{display:inline-block;margin-top:12px;padding:8px 14px;border-radius:8px;border:1px solid #444;background:#222;color:#fff;text-decoration:none}
  </style>
</head>
<body>
<div class="wrap">
  <h2 style="margin-top:0;"><c:out value="${param.title}"/></h2>

  <div class="card">
    <p class="meta">
      <strong>일시:</strong>
      <c:out value="${param.start}"/>
      <!-- am/pm 결정: param.ampm 있으면 그걸 쓰고, 없으면 h24 기준 -->
      <c:set var="ampmVal" value="${empty param.ampm ? (param.h24 lt 12 ? 'AM' : 'PM') : param.ampm}" />
      <c:choose>
        <c:when test="${ampmVal eq 'AM'}">(오전)</c:when>
        <c:otherwise>(오후)</c:otherwise>
      </c:choose>
    </p>

    <p class="meta"><strong>종류:</strong> <c:out value="${param.type}"/></p>
    <p class="meta"><strong>인원:</strong> <c:out value="${param.cur}"/> / <c:out value="${param.max}"/></p>

    <c:if test="${not empty param.note}">
      <p class="meta"><strong>메모:</strong> <c:out value="${param.note}"/></p>
    </c:if>
  </div>

  <a class="btn" href="${pageContext.request.contextPath}/partyboard.do">← 목록으로</a>
</div>
</body>
</html>
