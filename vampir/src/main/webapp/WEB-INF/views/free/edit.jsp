<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${ctx}/resources/css/free-view.css" />

<div class="wrap free-view">
  <h2 class="fv-title">자유게시판 글수정</h2>

  <section class="fv-card">
    <form method="post" action="<c:url value='/free/update.do'/>" class="form">
      <input type="hidden" name="postId" value="${post.postId}">
      <div class="row" style="margin-bottom:12px;">
        <label>제목</label>
        <input type="text" name="title" required value="${post.title}" style="width:100%;padding:10px;border-radius:8px;border:1px solid #ccc;">
      </div>
      <div class="row">
        <label>내용</label>
        <textarea name="content" rows="16" required style="width:100%;padding:10px;border-radius:8px;border:1px solid #ccc;"><c:out value="${post.content}"/></textarea>
      </div>
      <div class="fv-actions">
        <a class="fv-btn" href="<c:url value='/free/view.do'><c:param name='postId' value='${post.postId}'/></c:url>">취소</a>
        <button type="submit" class="fv-btn fv-btn-primary">수정</button>
      </div>
    </form>
  </section>

  <div class="fv-actions" style="margin-top:12px;">
    <form method="post" action="<c:url value='/free/delete.do'/>" onsubmit="return confirm('정말 삭제하시겠습니까?')">
      <input type="hidden" name="postId" value="${post.postId}">
      <button type="submit" class="fv-btn fv-btn-danger">삭제</button>
    </form>
  </div>
</div>
