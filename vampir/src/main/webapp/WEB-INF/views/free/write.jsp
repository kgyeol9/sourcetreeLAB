<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자유게시판 - 글쓰기</title>
<style>
  :root{--bg:#111;--panel:#1a1a1a;--line:#2a2a2a;--muted:#9aa0a6;--ink:#eee;--accent:#bb0000;}
  body{background:var(--bg);color:var(--ink);font-family:system-ui,-apple-system,Segoe UI,Roboto;margin:0}
  .wrap{max-width:900px;margin:32px auto;padding:0 12px}
  .card{background:var(--panel);border:1px solid var(--line);border-radius:12px;padding:16px}
  .row{display:flex;gap:10px;align-items:center;margin-bottom:10px;flex-wrap:wrap}
  .label{min-width:70px;color:#ddd}
  .sel,.input,.btn,textarea,input[type=file]{border:1px solid var(--line);background:#202020;color:#fff;border-radius:10px}
  .sel,.input{height:38px;padding:0 12px}
  .input{flex:1}
  input[type=file]{height:38px;padding:6px 12px}
  textarea{width:100%;min-height:260px;padding:12px;border-radius:12px;resize:vertical}
  .btn{height:40px;padding:0 16px;cursor:pointer;font-weight:700;text-decoration:none;display:inline-flex;align-items:center;justify-content:center}
  .btn.primary{background:var(--accent);border-color:var(--accent)}
  .btn.ghost{background:#262626}
</style>
</head>
<body>
<div class="wrap">
  <h2 style="margin:0 0 12px 0;">자유게시판 글쓰기</h2>

  <!-- 글쓰기 폼 (서버게시판과 동일 스타일 / 이미지 업로드 포함) -->
  <form id="freeWriteForm" class="card" method="post" action="${ctx}/free/write.do" enctype="multipart/form-data">
    <div class="row">
      <span class="label">제목</span>
      <input type="text" name="title" id="title" class="input" maxlength="120" placeholder="제목을 입력하세요" required>
    </div>

    <div class="row" style="align-items:flex-start;">
      <span class="label" style="margin-top:8px;">내용</span>
      <textarea name="content" id="content" placeholder="내용을 입력하세요 (일반 텍스트/HTML)" required></textarea>
    </div>

    <div class="row">
      <span class="label">이미지</span>
      <input type="file" name="image" accept="image/*">
      <span class="hint" style="color:var(--muted);font-size:.9rem">최대 5MB, JPG/PNG/GIF</span>
    </div>

    <div class="row" style="justify-content:flex-end;">
      <a class="btn ghost" href="${ctx}/free/list.do">취소</a>
      <button type="submit" class="btn primary">등록</button>
    </div>
  </form>
</div>

<script>
  (function(){
    var form    = document.getElementById('freeWriteForm');
    var title   = document.getElementById('title');
    var content = document.getElementById('content');

    form.addEventListener('submit', function(e){
      if(!title.value.trim()){
        alert('제목을 입력하세요.');
        title.focus(); e.preventDefault(); return false;
      }
      if(!content.value.trim()){
        alert('내용을 입력하세요.');
        content.focus(); e.preventDefault(); return false;
      }
    });
  })();
</script>
</body>
</html>
