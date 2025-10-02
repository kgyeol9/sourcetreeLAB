<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setTimeZone value="Asia/Seoul"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><c:out value="${post.title}"/></title>
<!-- 자유게시판과 동일 스타일을 쓰기 위해 동일 CSS 사용 -->
<link rel="stylesheet" href="${ctx}/resources/css/free-view.css" />
</head>
<body>
<div class="wrap free-view">

  <!-- 제목 -->
  <h2 class="fv-title"><c:out value="${post.title}"/></h2>

  <!-- 메타: 오른쪽 정렬 (자유게시판과 동일 클래스) -->
  <div class="fv-meta fv-meta-right">
    월드: <b><c:out value="${world}"/></b> /
    서버: <b><c:out value="${server}"/></b> ·
    작성자: <b><c:out value="${post.writer}"/></b> ·
    조회수: <c:out value="${post.views}"/> ·
    <fmt:formatDate value="${post.regDate}" pattern="yyyy-MM-dd HH:mm"/>
  </div>

  <!-- 본문 카드 -->
  <section class="fv-card">
    <div class="fv-content">
      <!-- 이미지/HTML 그대로 렌더링 -->
      <c:out value="${post.content}" escapeXml="false"/>
    </div>
  </section>

  <!-- 액션 버튼들: 자유게시판과 동일 배치/클래스 -->
  <div class="fv-actions">
    <a class="fv-btn" href="${ctx}/serverboard/${world}/${server}.do">목록</a>

    <c:if test="${post.writer eq loginNick}">
      <a class="fv-btn" href="${ctx}/serverboard/${world}/${server}/edit/${post.id}.do">수정</a>

      <form method="post" action="${ctx}/serverboard/${world}/${server}/delete.do" style="display:inline" onsubmit="return confirm('삭제하시겠습니까?')">
        <input type="hidden" name="id" value="${post.id}">
        <button type="submit" class="fv-btn fv-btn-danger">삭제</button>
      </form>
    </c:if>
  </div>

  <!-- 댓글: 자유게시판과 동일 마크업/클래스 사용 -->
  <section class="fv-comments">
    <h3>댓글</h3>

    <!-- 로그인 사용자만 댓글 폼 -->
    <c:if test="${login}">
      <form method="post" action="${ctx}/serverboard/${world}/${server}/comment/add.do" class="fv-cmt-form">
        <input type="hidden" name="postId" value="${post.id}">
        <textarea name="content" placeholder="댓글을 입력하세요" required></textarea>
        <div class="fv-cmt-form-actions">
          <button type="submit" class="fv-btn">등록</button>
        </div>
      </form>
    </c:if>
    <c:if test="${not login}">
      <div class="fv-hint">로그인 후 댓글 작성이 가능합니다.</div>
    </c:if>

    <c:choose>
      <c:when test="${not empty comments}">
        <c:forEach var="cmt" items="${comments}">
          <article class="fv-cmt-item ${cmt.parentId != null ? 'reply' : ''}">
            <div class="fv-cmt-meta">
              <b><c:out value="${cmt.writer}"/></b>
              · <fmt:formatDate value="${cmt.regDate}" pattern="yyyy-MM-dd HH:mm"/>
              <c:if test="${cmt.parentId != null}"> · 대댓글</c:if>
            </div>

            <div class="fv-cmt-body"><c:out value="${cmt.content}"/></div>

            <!-- 본인 댓글만 수정/삭제, 로그인 시 답글 -->
            <div class="fv-cmt-actions">
              <c:if test="${login}">
                <!-- 답글 -->
                <a href="#" class="fv-link" onclick="this.nextElementSibling.style.display=(this.nextElementSibling.style.display==='block'?'none':'block');return false;">답글</a>
                <div style="display:none">
                  <form method="post" action="${ctx}/serverboard/${world}/${server}/comment/add.do" class="fv-cmt-inline">
                    <input type="hidden" name="postId" value="${post.id}">
                    <input type="hidden" name="parentId" value="${cmt.id}">
                    <textarea name="content" rows="3" placeholder="답글 내용을 입력" required></textarea>
                    <button type="submit" class="fv-btn">등록</button>
                  </form>
                </div>
              </c:if>

              <c:if test="${cmt.writer eq loginNick}">
                <!-- 수정 -->
                <a href="#" class="fv-link" onclick="this.nextElementSibling.style.display=(this.nextElementSibling.style.display==='block'?'none':'block');return false;">수정</a>
                <div style="display:none">
                  <form method="post" action="${ctx}/serverboard/${world}/${server}/comment/update.do" class="fv-cmt-inline" onsubmit="return confirm('수정하시겠습니까?')">
                    <input type="hidden" name="id" value="${cmt.id}">
                    <input type="hidden" name="postId" value="${post.id}">
                    <textarea name="content" rows="3" required><c:out value="${cmt.content}"/></textarea>
                    <button type="submit" class="fv-btn">저장</button>
                  </form>
                </div>

                <!-- 삭제 -->
                <form method="post" action="${ctx}/serverboard/${world}/${server}/comment/delete.do" class="fv-cmt-inline" onsubmit="return confirm('댓글을 삭제할까요?')">
                  <input type="hidden" name="id" value="${cmt.id}">
                  <input type="hidden" name="postId" value="${post.id}">
                  <button type="submit" class="fv-btn fv-btn-danger">삭제</button>
                </form>
              </c:if>
            </div>
          </article>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <div class="fv-hint">등록된 댓글이 없습니다.</div>
      </c:otherwise>
    </c:choose>
  </section>
</div>
</body>
</html>
