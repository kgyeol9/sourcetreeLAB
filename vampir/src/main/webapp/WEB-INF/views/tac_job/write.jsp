<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setTimeZone value="Asia/Seoul"/>

<link rel="stylesheet" href="${ctx}/resources/css/freeboard.css"/>

<div class="wrap free-view">
  <h2>${type == 'job' ? '직업 게시판 글쓰기' : '공략 게시판 글쓰기'}</h2>

  <section class="fv-card">
    <form id="frmWrite" method="post" action="${ctx}/tac_job/add.do">
      <!-- 게시판 구분 hidden -->
 <input type="hidden" name="board_type" value="${type == 'guide' ? 'guide' : 'job'}" />

      <div class="row" style="margin-bottom:12px;">
        <label>제목</label>
        <input type="text" name="title" required style="width:100%;padding:10px;border-radius:8px;border:1px solid #ccc;">
      </div>
      <div class="row">
        <label>내용</label>
        <textarea name="content" rows="16" required style="width:100%;padding:10px;border-radius:8px;border:1px solid #ccc;"></textarea>
      </div>

      <div class="fv-actions">
        <a class="fv-btn" href="${ctx}/tac_job/list.do?type=${type}">목록</a>
        <button type="submit" class="fv-btn fv-btn-primary">등록</button>
      </div>
    </form>
  </section>
</div>

<script>
document.getElementById("frmWrite").addEventListener("submit", function(e){
	  e.preventDefault();
	  var form = e.target;
	  var data = new URLSearchParams(new FormData(form));

	  // 1. 데이터 확인
console.log('board_type:', form.board_type.value);  // 반드시 guide 또는 job
console.log('title:', form.title.value);
console.log('content:', form.content.value);
console.log('form.action:', form.action);

	  // 2. AJAX 전송
	  fetch(form.action, { method:'POST', body: data })
	    .then(r => r.text())
	    .then(txt => {
	      console.log("서버 응답:", txt);
	      if(txt==='success') location.href='${ctx}/tac_job/list.do?type=${type}';
	      else alert('실패: '+txt);
	    })
	    .catch(err => {
	      console.error("요청 실패:", err);
	      alert('요청 실패: 콘솔 확인');
	    });
	});
</script>
