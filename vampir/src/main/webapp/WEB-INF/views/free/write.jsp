<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${ctx}/resources/css/free-view.css" />

<div class="wrap free-view">
  <h2 class="fv-title">자유게시판 글쓰기</h2>

  <section class="fv-card">
    <form method="post" action="<c:url value='/free/write.do'/>" class="form">
      <div class="row" style="margin-bottom:12px;">
        <label>제목</label>
        <input type="text" name="title" required style="width:100%;padding:10px;border-radius:8px;border:1px solid #ccc;">
      </div>
      <div class="row">
        <label>내용</label>
        <textarea name="content" rows="16" required style="width:100%;padding:10px;border-radius:8px;border:1px solid #ccc;"></textarea>
      </div>
      <div class="fv-actions">
        <a class="fv-btn" href="<c:url value='/free/list.do'/>">목록</a>
        <button type="submit" class="fv-btn fv-btn-primary">등록</button>
      </div>
    </form>
  </section>
</div>
