<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" /> 
<%
  request.setCharacterEncoding("UTF-8");
%>

<head>
<meta charset="UTF-8">
<title>글쓰기</title>
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

  function backToList(obj){
    obj.action="${contextPath}/board/list.do";
    obj.submit();
  }

  var cnt=1;
  function fn_addFile(){
    $("#d_file").append("<input type='file' name='file"+cnt+"' style='margin-top:8px; display:block;'/>");
    cnt++;
  }
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
  #preview {
    margin-top: 10px;
    border: 1px solid #444;
    border-radius: 4px;
    width: 200px;
    height: 200px;
    object-fit: contain;
  }
</style>
</head>

<body>
<h1>글쓰기</h1>

<form name="articleForm" method="post" action="${contextPath}/board/addNewArticle.do" enctype="multipart/form-data">
  
  <!-- 작성자 -->
  <div class="form-group">
    <label class="form-label">작성자</label>
    <input type="text" class="form-input" value="${member.name}" readonly />
  </div>

  <!-- 제목 -->
  <div class="form-group">
    <label class="form-label">글제목</label>
    <input type="text" name="title" class="form-input" maxlength="500" />
  </div>

  <!-- 본문 (TinyMCE 에디터 적용) -->
  <div class="form-group">
    <label class="form-label">글내용</label>
    <textarea name="content" maxlength="4000"></textarea>
  </div>

  <!-- 대표 이미지 업로드 -->
  <div class="form-group">
    <label class="form-label">이미지파일 첨부</label>
    <input type="file" name="imageFileName" class="form-file" onchange="readURL(this);" />
    <img id="preview" src="#" alt="미리보기"/>
  </div>

  <!-- 추가 파일 업로드 -->
  <div class="form-group">
    <label class="form-label">추가 파일</label>
    <input type="button" class="btn btn-cancel" value="파일 추가" onClick="fn_addFile()" />
    <div id="d_file"></div>
  </div>

  <!-- 버튼 영역 -->
  <div style="text-align:center;">
    <input type="submit" class="btn btn-submit" value="글쓰기" />
    <input type="button" class="btn btn-cancel" value="목록보기" onClick="backToList(this.form)" />
  </div>
</form>
</body>
</html>
