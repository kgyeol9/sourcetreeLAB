<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="isEdit" value="${not empty news and not empty news.articleNO}" />
<!DOCTYPE html>
<html lang="ko">
<head><meta charset="UTF-8"><title>새소식 작성/수정</title></head>
<body style="background:#111;color:#eee;font-family:sans-serif;">
  <main style="max-width:1040px;margin:24px auto;padding:0 12px;">
    <h2><c:choose><c:when test="${isEdit}">뉴스 수정</c:when><c:otherwise>뉴스 작성</c:otherwise></c:choose></h2>

    <form action="${contextPath}/news/<c:choose><c:when test='${isEdit}'>update</c:when><c:otherwise>write</c:otherwise></c:choose>.do" method="post">
      <c:if test="${isEdit}">
        <input type="hidden" name="articleNO" value="${news.articleNO}">
      </c:if>

      <div style="margin:8px 0;">
        <label>제목</label><br/>
        <input type="text" name="title" value="${isEdit ? news.title : ''}" style="width:100%;padding:8px" required>
      </div>

      <div style="margin:8px 0;">
        <label>내용</label><br/>
        <textarea name="content" rows="12" style="width:100%;padding:8px" required>${isEdit ? news.content : ''}</textarea>
      </div>

      <div style="margin:8px 0;">
        <label>작성자 ID</label><br/>
        <input type="text" name="id" value="${isEdit ? news.id : ''}" style="width:240px;padding:8px">
      </div>

      <div style="margin-top:12px; display:flex; gap:8px;">
        <button type="submit" style="padding:8px 12px;border-radius:8px;">
          <c:choose><c:when test="${isEdit}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose>
        </button>
        <a href="${contextPath}/news/list.do" style="color:#fff;border:1px solid #444;padding:8px 12px;border-radius:8px;">취소</a>
      </div>
    </form>
  </main>
</body>
</html>
