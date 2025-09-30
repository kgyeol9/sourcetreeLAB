<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 게시판 - 글 수정</title>
<style>
  .wrap{max-width:900px;margin:40px auto;font-family:system-ui,AppleSDGothicNeo,Malgun Gothic,sans-serif}
  .row{display:flex;gap:10px;align-items:center;margin-bottom:10px;flex-wrap:wrap}
  .label{min-width:70px;color:#333}
  .input,textarea,input[type=file]{border:1px solid #ddd;background:#fff;color:#222;border-radius:10px}
  .input{height:38px;padding:0 12px;flex:1}
  textarea{width:100%;min-height:260px;padding:12px;border-radius:12px;resize:vertical}
  .btns{display:flex;gap:8px;margin-top:16px}
  .btn{padding:8px 14px;border:1px solid #ddd;border-radius:8px;background:#f9f9f9;text-decoration:none;color:#222;cursor:pointer}
  .btn.primary{background:#efefef;font-weight:600}
  .hint{color:#666;font-size:12px}
</style>
</head>
<body>
<div class="wrap">
  <h2>글 수정</h2>

  <!-- 이미지 업로드/삭제 지원을 위해 enctype 추가 -->
  <form method="post"
        action="${ctx}/serverboard/${world}/${server}/update.do"
        enctype="multipart/form-data">

    <input type="hidden" name="id" value="${post.id}" />

    <div class="row">
      <span class="label">제목</span>
      <input type="text" name="title" class="input" value="${post.title}" maxlength="120" required />
    </div>

    <div class="row" style="align-items:flex-start">
      <span class="label">내용</span>
      <textarea name="content" required>${post.content}</textarea>
    </div>

    <!-- 이미지: 수정 화면에서만 추가/삭제 가능 -->
    <div class="row">
      <span class="label">이미지</span>
      <input type="file" name="image" accept="image/*"/>
      <label style="margin-left:8px;">
        <input type="checkbox" name="deleteImage" value="1"/>
        이미지 삭제
      </label>
      <span class="hint">※ 새 파일 선택 시 이미지 갱신, 삭제 체크 시 제거. (둘 다 미사용 시 기존 유지)</span>
    </div>

    <div class="btns">
      <a class="btn" href="${ctx}/serverboard/${world}/${server}/view.do?id=${post.id}">취소</a>
      <button type="submit" class="btn primary">저장</button>
    </div>
  </form>
</div>
</body>
</html>
