<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setTimeZone value="Asia/Seoul"/>

<link rel="stylesheet" href="${ctx}/resources/css/free-view.css" />

<div class="wrap free-view">
  <c:if test="${notFound}">
    <div class="empty">존재하지 않거나 삭제된 글입니다.</div>
  </c:if>

  <c:if test="${not notFound}">
    <h2 class="fv-title"><c:out value="${post.title}"/></h2>

    <!-- 메타: 오른쪽 정렬 -->
    <div class="fv-meta fv-meta-right">
      작성자: <b><c:out value="${post.writerName}"/></b> ·
      조회수: <c:out value="${post.viewCnt}"/> ·
      <fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
    </div>

    <!-- 본문 카드 -->
    <section class="fv-card">
      <div class="fv-content">
        <c:out value="${post.content}" escapeXml="false"/>
      </div>
    </section>

    <!-- 박스 밖, 오른쪽 정렬 버튼들 -->
    <div class="fv-actions">
      <a class="fv-btn" href="<c:url value='/free/list.do'/>">목록</a>

      <c:if test="${mine}">
        <a class="fv-btn" href="<c:url value='/free/edit.do'><c:param name='postId' value='${post.postId}'/></c:url>">수정</a>

        <form method="post" action="<c:url value='/free/delete.do'/>" style="display:inline" onsubmit="return confirm('삭제하시겠습니까?')">
          <input type="hidden" name="postId" value="${post.postId}">
          <button type="submit" class="fv-btn fv-btn-danger">삭제</button>
        </form>
      </c:if>
    </div>

    <!-- 댓글 -->
    <section class="fv-comments">
      <h3>댓글</h3>

      <c:if test="${login}">
        <form method="post" action="<c:url value='/free/comment/add.do'/>" class="fv-cmt-form">
          <input type="hidden" name="postId" value="${post.postId}">
          <textarea name="content" placeholder="댓글을 입력하세요" required></textarea>
          <div class="fv-cmt-form-actions">
            <button type="submit" class="fv-btn">등록</button>
          </div>
        </form>
      </c:if>

      <c:choose>
        <c:when test="${not empty comments}">
          <c:forEach var="cmt" items="${comments}">
            <article class="fv-cmt-item ${cmt.parentId != null ? 'reply' : ''}">
              <div class="fv-cmt-meta">
                <b><c:out value="${cmt.writerName}"/></b>
                · <fmt:formatDate value="${cmt.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                <c:if test="${cmt.parentId != null}"> · 대댓글</c:if>
              </div>

              <c:choose>
                <c:when test="${cmt.isDeleted}">
                  <div class="fv-cmt-body deleted"><em>삭제된 댓글입니다.</em></div>
                </c:when>
                <c:otherwise>
                  <div class="fv-cmt-body"><c:out value="${cmt.content}"/></div>
                </c:otherwise>
              </c:choose>

              <c:if test="${login}">
                <div class="fv-cmt-actions">
                  <!-- 답글 -->
                  <a href="#" class="fv-link" onclick="this.nextElementSibling.style.display=(this.nextElementSibling.style.display==='block'?'none':'block');return false;">답글</a>
                  <div style="display:none">
                    <form method="post" action="<c:url value='/free/comment/add.do'/>" class="fv-cmt-inline">
                      <input type="hidden" name="postId" value="${post.postId}">
                      <input type="hidden" name="parentId" value="${cmt.id}">
                      <textarea name="content" rows="3" placeholder="답글 내용을 입력" required></textarea>
                      <button type="submit" class="fv-btn">등록</button>
                    </form>
                  </div>

                  <!-- 수정 -->
                  <a href="#" class="fv-link" onclick="this.nextElementSibling.style.display=(this.nextElementSibling.style.display==='block'?'none':'block');return false;">수정</a>
                  <div style="display:none">
                    <form method="post" action="<c:url value='/free/comment/update.do'/>" class="fv-cmt-inline" onsubmit="return confirm('수정하시겠습니까?')">
                      <input type="hidden" name="id" value="${cmt.id}">
                      <input type="hidden" name="postId" value="${post.postId}">
                      <textarea name="content" rows="3" required><c:out value="${cmt.content}"/></textarea>
                      <button type="submit" class="fv-btn">저장</button>
                    </form>
                  </div>

                  <!-- 삭제 -->
                  <form method="post" action="<c:url value='/free/comment/delete.do'/>" class="fv-cmt-inline" onsubmit="return confirm('댓글을 삭제할까요?')">
                    <input type="hidden" name="id" value="${cmt.id}">
                    <input type="hidden" name="postId" value="${post.postId}">
                    <button type="submit" class="fv-btn fv-btn-danger">삭제</button>
                  </form>
                </div>
              </c:if>
            </article>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="fv-hint">등록된 댓글이 없습니다.</div>
        </c:otherwise>
      </c:choose>
    </section>
  </c:if>
</div>
