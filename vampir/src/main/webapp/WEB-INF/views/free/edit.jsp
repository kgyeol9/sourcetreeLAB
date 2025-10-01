<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자유게시판 - 글수정</title>
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
  .hint{color:var(--muted);font-size:.9rem}
</style>
</head>
<body>
<div class="wrap">
  <h2 style="margin:0 0 12px 0;">자유게시판 글수정</h2>

  <!-- 글수정 폼 (글쓰기와 동일한 카드/필드 구성) -->
  <form id="freeEditForm" class="card" method="post" action="${ctx}/free/update.do" enctype="multipart/form-data">
    <input type="hidden" name="postId" value="${post.postId}">

    <div class="row">
      <span class="label">제목</span>
      <input type="text" name="title" id="title" class="input" maxlength="120"
             value="<c:out value='${post.title}'/>" required>
    </div>

    <div class="row" style="align-items:flex-start;">
      <span class="label" style="margin-top:8px;">내용</span>
      <!-- 수정에서는 원문을 그대로 편집해야 하므로 escape(기본 true)로 출력 -->
      <textarea name="content" id="content" required><c:out value="${post.content}"/></textarea>
    </div>

    <div class="row">
      <span class="label">이미지</span>
      <input type="file" name="image" accept="image/*">
      <span class="hint">선택 업로드(미첨부 시 기존 이미지 유지) · 최대 5MB, JPG/PNG/GIF</span>
    </div>

    <div class="row" style="justify-content:flex-end;">
      <a class="btn ghost" href="${ctx}/free/view.do?postId=${post.postId}">취소</a>
      <button type="submit" class="btn primary">수정</button>
    </div>
  </form>
</div>

<script>
  (function(){
    var form    = document.getElementById('freeEditForm');
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
