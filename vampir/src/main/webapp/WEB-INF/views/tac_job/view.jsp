<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setTimeZone value="Asia/Seoul"/>

<link rel="stylesheet" href="${ctx}/resources/css/free-view.css"/>

<div class="wrap free-view">
  <c:if test="${notFound}">
    <div class="empty-message">존재하지 않거나 삭제된 글입니다.</div>
  </c:if>

  <c:if test="${not notFound}">
    <!-- 제목 -->
    <h2 class="fv-title">${board.board_type == 'job' ? '직업 게시판 글보기' : '공략 게시판 글보기'}</h2>

    <!-- 메타 정보 -->
    <div class="fv-meta">
      <span>작성자: <b>${board.nickname}</b></span>
      <span>작성일: <fmt:formatDate value="${board.created_at}" pattern="yyyy-MM-dd HH:mm"/></span>
      <span>조회수: ${board.view_count}</span>
    </div>

    <!-- 본문 카드 -->
    <section class="fv-card">
      <div class="fv-content" style="white-space:pre-wrap;">
        ${board.content}
      </div>
    </section>

    <!-- 버튼 영역 -->
    <div class="fv-actions">
      <a class="fv-btn" href="${ctx}/tac_job/list.do?type=${board.board_type}">목록</a>

      <c:if test="${login}">
        <a class="fv-btn fv-btn-primary" href="${ctx}/tac_job/edit.do?board_id=${board.board_id}">수정</a>
        <button type="button" class="fv-btn fv-btn-danger" onclick="deleteBoard(${board.board_id})">삭제</button>
      </c:if>
    </div>
  </c:if>
</div>

<script>
function deleteBoard(id) {
  if(!confirm('정말 삭제하시겠습니까?')) return;

  fetch('${ctx}/tac_job/delete.do?board_id=' + id, { method:'POST' })
    .then(r => r.text())
    .then(txt => {
      if(txt === 'success') {
        location.href='${ctx}/tac_job/list.do?type=${board.board_type}';
      } else {
        alert('삭제 실패: ' + txt);
      }
    })
    .catch(err => {
      console.error(err);
      alert('삭제 요청 실패');
    });
}
</script>

<style>
/* 카드 스타일 */
.fv-card {
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
  padding: 20px;
  margin-bottom: 20px;
}

/* 메타 정보 */
.fv-meta {
  display: flex;
  gap: 15px;
  font-size: 0.9rem;
  color: #666;
  margin-bottom: 15px;
}

/* 본문 내용 */
.fv-content {
  font-size: 1rem;
  line-height: 1.6;
  color: #333;
}

/* 버튼 */
.fv-actions {
  margin-top: 20px;
  display: flex;
  gap: 10px;
}

.fv-btn {
  display: inline-block;
  padding: 8px 16px;
  border-radius: 6px;
  border: none;
  text-decoration: none;
  cursor: pointer;
  font-size: 0.95rem;
  transition: background 0.2s;
}

.fv-btn:hover {
  opacity: 0.9;
}

.fv-btn-primary {
  background-color: #4a90e2;
  color: #fff;
}

.fv-btn-danger {
  background-color: #e24a4a;
  color: #fff;
}

.empty-message {
  padding: 20px;
  text-align: center;
  color: #999;
  font-size: 1.1rem;
}
</style>
