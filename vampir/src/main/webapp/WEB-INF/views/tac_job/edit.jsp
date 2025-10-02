<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${ctx}/resources/css/freeboard.css"/>
<link rel="stylesheet" href="${ctx}/resources/css/tac_job_button.css"/>

<div class="wrap free-edit" style="margin-left:270px; padding:20px; color:#fff;">
  <h2>${board.board_type == 'job' ? '직업 게시판 글수정' : '공략 게시판 글수정'}</h2>

  <section class="fv-card" style="background:#111; border-radius:12px; padding:20px; box-shadow:0 0 10px rgba(255,0,0,0.3);">
    <form id="frmEdit" method="post" action="${ctx}/tac_job/edit.do">
      <input type="hidden" name="board_id" value="${board.board_id}" />

      <div class="row" style="margin-bottom:12px;">
        <label style="display:block; margin-bottom:6px; color:#f55;">제목</label>
        <input type="text" name="title" value="${board.title}" required style="width:100%; padding:10px; border-radius:8px; border:1px solid #444; background:#222; color:#fff;">
      </div>

      <div class="row" style="margin-bottom:12px;">
        <label style="display:block; margin-bottom:6px; color:#f55;">내용</label>
        <textarea id="editor" name="content">${board.content}</textarea>
      </div>

<div class="fv-actions">
  <a class="fv-btn fv-btn-list" href="${ctx}/tac_job/list.do?type=${board.board_type}">목록</a>
  <button type="submit" class="fv-btn fv-btn-primary">수정</button>
  <button type="button" class="fv-btn fv-btn-danger" onclick="deleteBoard(${board.board_id})">삭제</button>
</div>
    </form>
  </section>
</div>

<script src="https://cdn.tiny.cloud/1/r2t7fl9os6sksmww8gr8qwlu772dk2b368fb3ohilgu8y0vt/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
<script>
tinymce.init({
  selector: '#editor',
  height: 400,
  menubar: false,
  skin: 'oxide-dark',
  content_css: 'dark',
  plugins: 'lists link image table code wordcount',
  toolbar: 'undo redo | bold italic underline | forecolor backcolor | alignleft aligncenter alignright | bullist numlist | link image table | code',
  setup: function(editor){
    document.getElementById("frmEdit").addEventListener("submit", function(e){
      e.preventDefault();
      var form = e.target;
      form.content.value = editor.getContent();
      var data = new URLSearchParams(new FormData(form));
      fetch(form.action, { method:'POST', body:data })
        .then(r=>r.text())
        .then(txt=>{ if(txt==='success') location.href='${ctx}/tac_job/view.do?board_id=${board.board_id}'; else alert('저장 실패'); })
        .catch(err=>{ console.error(err); alert('요청 실패'); });
    });
  }
});
</script>
