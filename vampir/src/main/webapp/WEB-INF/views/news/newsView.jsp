<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head><meta charset="UTF-8"><title>새소식 상세</title></head>
<body style="background:#111;color:#eee;font-family:sans-serif;">
  <main style="max-width:1040px;margin:24px auto;padding:0 12px;">
    <h2 style="margin:0 0 8px;"><c:out value="${news.title}" /></h2>
    <div style="color:#bbb;margin-bottom:12px;">
      글번호 <c:out value="${news.articleNO}" /> ·
      작성일 <fmt:formatDate value="${news.writedate}" pattern="yyyy-MM-dd HH:mm"/>
      <c:if test="${not empty news.id}"> · 작성자 <c:out value="${news.id}" /></c:if>
    </div>
    <div style="white-space:pre-wrap;line-height:1.6;">${news.content}</div>

    <div style="margin-top:16px;display:flex;gap:8px;">
      <a href="${contextPath}/news/editForm.do?articleNO=${news.articleNO}"
         style="color:#fff;border:1px solid #444;padding:8px 12px;border-radius:8px;">수정</a>
      <form action="${contextPath}/news/delete.do" method="post"
            onsubmit="return confirm('삭제할까요?');" style="display:inline;">
        <input type="hidden" name="articleNO" value="${news.articleNO}">
        <button type="submit"
          style="color:#fff;border:1px solid #5a0000;background:#2a0000;padding:8px 12px;border-radius:8px;">
          삭제
        </button>
      </form>
      <a href="${contextPath}/news/list.do"
         style="color:#fff;border:1px solid #444;padding:8px 12px;border-radius:8px;">목록</a>
    </div>
  </main>
</body>
</html>
