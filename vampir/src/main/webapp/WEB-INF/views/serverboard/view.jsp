<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><c:out value="${post.title}"/></title>
<style>
  .wrap{max-width:900px;margin:40px auto;font-family:system-ui,AppleSDGothicNeo,Malgun Gothic,sans-serif}
  .meta{color:#666;font-size:13px;margin-top:8px}
  .content{white-space:pre-wrap;line-height:1.6;border:1px solid #eee;padding:16px;border-radius:8px;margin-top:16px}
  .btns{display:flex;gap:8px;margin-top:24px}
  .btn{padding:8px 14px;border:1px solid #ddd;border-radius:8px;background:#f9f9f9;text-decoration:none;color:#222}
  .btn.primary{background:#efefef;font-weight:600}
  .comments{margin-top:28px}
  .c-item{border-top:1px solid #eee;padding:12px 0}
  .c-meta{color:#666;font-size:13px;margin-bottom:6px}
  .c-content{white-space:pre-wrap}
  .c-actions{display:flex;gap:6px;margin-top:8px;align-items:flex-start}
  .reply{margin-left:24px;border-left:3px solid #eee;padding-left:12px}
</style>
</head>
<body>
<div class="wrap">
  <h2><c:out value="${post.title}"/></h2>
  <div class="meta">
    월드: <b><c:out value="${world}"/></b> /
    서버: <b><c:out value="${server}"/></b> ·
    작성자: <c:out value="${post.writer}"/> ·
    조회수: <c:out value="${post.views}"/> ·
    <fmt:formatDate value="${post.regDate}" pattern="yyyy-MM-dd HH:mm"/>
  </div>

  <!-- ★ 본문을 HTML로 렌더링 (이미지 태그 보이게) -->
  <div class="content"><c:out value="${post.content}" escapeXml="false"/></div>

  <div class="btns">
    <a class="btn" href="${ctx}/serverboard/${world}/${server}.do">목록</a>
    <c:if test="${post.writer eq loginNick}">
      <a class="btn" href="${ctx}/serverboard/${world}/${server}/edit/${post.id}.do">수정</a>
      <form method="post" action="${ctx}/serverboard/${world}/${server}/delete.do" style="display:inline">
        <input type="hidden" name="id" value="${post.id}">
        <button type="submit" class="btn primary" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
      </form>
    </c:if>
  </div>

  <!-- 댓글 -->
  <div class="comments">
    <h3>댓글</h3>

    <form method="post" action="${ctx}/serverboard/${world}/${server}/comment/add.do" style="margin-bottom:16px">
      <input type="hidden" name="postId" value="${post.id}">
      <textarea name="content" style="width:100%;min-height:80px" placeholder="댓글을 입력하세요" required></textarea>
      <div style="margin-top:8px">
        <button type="submit" class="btn">등록</button>
      </div>
    </form>

    <c:forEach var="cmt" items="${comments}">
      <div class="c-item ${cmt.parentId != null ? 'reply' : ''}">
        <div class="c-meta">
          <b><c:out value="${cmt.writer}"/></b>
          · <fmt:formatDate value="${cmt.regDate}" pattern="yyyy-MM-dd HH:mm"/>
          <c:if test="${cmt.parentId != null}"> · 대댓글</c:if>
        </div>
        <div class="c-content"><c:out value="${cmt.content}"/></div>

        <div class="c-actions">
          <a href="#" onclick="this.nextElementSibling.style.display = (this.nextElementSibling.style.display==='block'?'none':'block'); return false;">답글</a>
          <div style="display:none;margin-top:8px;flex:1">
            <form method="post" action="${ctx}/serverboard/${world}/${server}/comment/add.do">
              <input type="hidden" name="postId" value="${post.id}">
              <input type="hidden" name="parentId" value="${cmt.id}">
              <textarea name="content" style="width:100%;min-height:60px" placeholder="답글 내용을 입력" required></textarea>
              <div style="margin-top:6px"><button type="submit" class="btn">등록</button></div>
            </form>
          </div>

          <c:if test="${cmt.writer eq loginNick}">
            <a href="#" onclick="this.nextElementSibling.style.display = (this.nextElementSibling.style.display==='block'?'none':'block'); return false;">수정</a>
            <div style="display:none;margin-top:8px;flex:1">
              <form method="post" action="${ctx}/serverboard/${world}/${server}/comment/update.do">
                <input type="hidden" name="id" value="${cmt.id}">
                <input type="hidden" name="postId" value="${post.id}">
                <textarea name="content" style="width:100%;min-height:60px" required><c:out value="${cmt.content}"/></textarea>
                <div style="margin-top:6px"><button type="submit" class="btn">저장</button></div>
              </form>
            </div>

            <form method="post" action="${ctx}/serverboard/${world}/${server}/comment/delete.do" onsubmit="return confirm('댓글을 삭제할까요?')" style="display:inline">
              <input type="hidden" name="id" value="${cmt.id}">
              <input type="hidden" name="postId" value="${post.id}">
              <button type="submit" class="btn">삭제</button>
            </form>
          </c:if>
        </div>
      </div>
    </c:forEach>

    <c:if test="${empty comments}">
      <div style="color:#666">등록된 댓글이 없습니다.</div>
    </c:if>
  </div>
</div>
</body>
</html>
