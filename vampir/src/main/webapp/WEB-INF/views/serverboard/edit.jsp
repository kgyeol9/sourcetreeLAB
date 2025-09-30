<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>글 수정 - <c:out value="${post.title}"/></title>
<style>
  body{background:#111;color:#eee;font-family:system-ui,-apple-system,Segoe UI,Roboto;margin:0}
  .wrap{max-width:900px;margin:32px auto;padding:0 12px}
  .card{background:#1a1a1a;border:1px solid #2a2a2a;border-radius:12px;padding:16px}
  .row{display:flex;gap:10px;align-items:center;margin-bottom:10px;flex-wrap:wrap}
  .label{min-width:70px;color:#ddd}
  .input,textarea,input[type=file],.btn{border:1px solid #2a2a2a;background:#202020;color:#fff;border-radius:10px}
  .input{height:38px;padding:0 12px;flex:1}
  textarea{width:100%;min-height:280px;padding:12px;border-radius:12px;resize:vertical}
  input[type=file]{height:38px;padding:6px 12px}
  .btn{height:40px;padding:0 16px;cursor:pointer;font-weight:700}
  .btn.primary{background:#bb0000;border-color:#bb0000}
  .btn.ghost{background:#262626}
  .hint{color:#9aa0a6;font-size:.9rem}
  .imglist{display:flex;gap:10px;flex-wrap:wrap;margin:8px 0}
  .imglist img{max-height:120px;border-radius:8px;border:1px solid #2a2a2a}
</style>
</head>
<body>
<div class="wrap">
  <h2 style="margin:0 0 12px 0;">글 수정</h2>

  <div class="card" style="margin-bottom:12px;">
    <div class="hint">
      월드: <b>${world}</b> / 서버: <b>${server}</b> · 작성자: ${post.writer} ·
      등록: <fmt:formatDate value="${post.regDate}" pattern="yyyy-MM-dd HH:mm"/> · 조회: ${post.views}
    </div>
  </div>

  <form method="post"
        action="${ctx}/serverboard/${world}/${server}/update.do"
        enctype="multipart/form-data"
        class="card">
    <input type="hidden" name="id" value="${post.id}"/>

    <div class="row">
      <span class="label">제목</span>
      <input type="text" name="title" class="input" value="<c:out value='${post.title}'/>" maxlength="120" required/>
    </div>

    <div class="row" style="align-items:flex-start">
      <span class="label" style="margin-top:8px;">내용</span>
      <textarea name="content" required><c:out value="${post.content}"/></textarea>
    </div>

    <!-- 기존 삽입 이미지가 있다면 미리 보여주기(본문 내 <img>가 이미 있을 수 있음) -->
    <c:if test="${not empty post.imagePath}">
      <div class="imglist">
        <img src="${ctx}${post.imagePath}" alt="attached"/>
      </div>
    </c:if>

    <!-- 이미지 교체/추가 (컨트롤러: image, deleteImage, autoEmbed=1) -->
    <div class="row">
      <span class="label">이미지</span>
      <input type="file" name="image" accept="image/*"/>
      <label style="display:flex;align-items:center;gap:6px;">
        <input type="checkbox" name="deleteImage" value="1"/>
        기존 업로드 파일 삭제
      </label>
      <input type="hidden" name="autoEmbed" value="1"/>
    </div>
    <p class="hint">* 새 이미지를 올리면 본문 맨 아래에 자동으로 삽입됩니다. (원하면 위치를 옮기세요)</p>

    <div class="row" style="justify-content:flex-end;margin-top:8px">
      <a class="btn ghost" href="${ctx}/serverboard/${world}/${server}/view.do?id=${post.id}">취소</a>
      <button type="submit" class="btn primary">저장</button>
    </div>
  </form>
</div>
</body>
</html>
