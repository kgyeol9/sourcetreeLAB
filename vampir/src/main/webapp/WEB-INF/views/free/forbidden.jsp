<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${ctx}/resources/css/freeboard.css"/>

<div class="wrap">
  <h1 class="muted">접근 제한</h1>
  <div class="notice" style="background:#fdecea;border-color:#f5c2c7;">
    <c:out value="${empty message ? '권한이 없습니다.' : message}"/>
  </div>
  <div class="actions">
    <a class="btn" href="${ctx}/free/list.do">목록으로</a>
    <a class="btn" href="${ctx}/member/loginForm.do">로그인</a>
  </div>
</div>
