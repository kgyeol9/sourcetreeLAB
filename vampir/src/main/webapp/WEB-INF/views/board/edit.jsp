<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" /> 
<%
  request.setCharacterEncoding("UTF-8");
%>

<head>
<meta charset="UTF-8">
<title>글 수정</title>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<!-- TinyMCE -->
<script src="https://cdn.tiny.cloud/1/r2t7fl9os6sksmww8gr8qwlu772dk2b368fb3ohilgu8y0vt/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
<script>
  tinymce.init({
    selector: 'textarea[name=content]',
    height: 400,
    menubar: false,
    plugins: 'image link lists code',
    toolbar: 'undo redo | styles | bold italic underline forecolor | alignleft aligncenter alignright | bullist numlist | link image | code',
    content_style: "body { background-color:#1c1c1c; color:#f5f5f5; font-family: Arial, sans-serif; }"
  });
</script>

<style>
  body {
    background-color: #1c1c1c;
    color: #f5f5f5;
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
  }
  h1 {
    text-align: center;
    color: #e03b3b;
    margin: 30px 0;
  }
  form {
    max-width: 900px;
    margin: 0 auto;
    padding: 20px;
    background-color: #222;
    border-radius: 8px;
    box-shadow: 0 0 10px #000;
  }
  .form-group {
    margin-bottom: 20px;
  }
  .form-label {
    display: block;
    margin-bottom: 8px;
    font-weight: bold;
    color: #e03b3b;
  }
  .form-input, .form-file {
    width: 100%;
    padding: 8px;
    border-radius: 4px;
    border: 1px solid #444;
    background-color: #333;
    color: #f5f5f5;
  }
  .btn {
    padding: 10px 20px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
    margin-right: 10px;
  }
  .btn-submit {
    background-color: #bb2222;
    color: #f5f5f5;
  }
  .btn-cancel {
    background-color: #555;
    color: #f5f5f5;
  }
</style>
</head>

<body>
<h1>글 수정</h1>

<form name="editForm" method="post" action="${contextPath}/board/modArticle.do" enctype="multipart/form-data">
  <!-- 글 번호 hidden -->
  <input type="hidden" name="articleNO" value="${article.articleNO}" />

  <!-- 제목 -->
  <div class="form-group">
    <label class="form-label">글제목</label>
    <input type="text" name="title" class="form-input" maxlength="500" value="${article.title}" required />
  </div>

  <!-- 작성자 (읽기 전용) -->
  <div class="form-group">
    <label class="form-label">작성자</label>
    <input type="text" class="form-input" value="${article.id}" readonly />
    <input type="hidden" name="author" value="${article.id}" />
  </div>

  <!-- 본문 (TinyMCE 에디터 적용) -->
  <div class="form-group">
    <label class="form-label">글내용</label>
    <textarea name="content" maxlength="40000">${article.content}</textarea>
  </div>

  <!-- 버튼 영역 -->
  <div style="text-align:center;">
    <input type="submit" class="btn btn-submit" value="수정 완료" />
    <a href="${contextPath}/board/viewArticle.do?articleNO=${article.articleNO}" class="btn btn-cancel">취소</a>
  </div>
</form>
</body>
</html>
