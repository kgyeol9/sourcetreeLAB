<%@ page language="java" contentType="text/html; charset=UTF-8"
     pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
  request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>

<script>
  // TinyMCE 초기화
  tinymce.init({
    selector: '#content',
    height: 400,
    menubar: false,
    plugins: [
      "advlist autolink lists link image charmap preview anchor",
      "searchreplace visualblocks code fullscreen",
      "insertdatetime media table emoticons help wordcount"
    ],
    toolbar:
      "undo redo | styles | bold italic underline | " +
      "alignleft aligncenter alignright alignjustify | " +
      "bullist numlist outdent indent | link image media | emoticons | removeformat | help"
  });

  // 이미지 미리보기
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('#preview').attr('src', e.target.result).show();
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  // 목록으로 이동
  function backToList(obj) {
    obj.action = "${contextPath}/board/list.do";
    obj.submit();
  }
</script>

<style>
  body {
    font-family: Arial, sans-serif;
    background: #f9f9f9;
    margin: 0;
    padding: 40px;
  }
  .write-container {
    max-width: 900px;
    margin: 0 auto;
    background: #fff;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  }
  h1 {
    text-align: center;
    margin-bottom: 30px;
    color: #333;
  }
  .form-group {
    margin-bottom: 20px;
  }
  label {
    display: block;
    font-weight: bold;
    margin-bottom: 8px;
    color: #444;
  }
  input[type="text"], input[type="file"], textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #bbb;
    border-radius: 5px;
    font-size: 14px;
  }
  .btn-group {
    text-align: center;
    margin-top: 30px;
  }
  input[type="submit"], input[type="button"] {
    background: #bb0000;
    color: white;
    border: none;
    padding: 10px 20px;
    margin: 0 5px;
    border-radius: 5px;
    font-size: 15px;
    cursor: pointer;
  }
  input[type="submit"]:hover, input[type="button"]:hover {
    background: #ff3333;
  }
  #preview {
    margin-top: 10px;
    max-width: 200px;
    display: none;
    border: 1px solid #ccc;
    border-radius: 4px;
  }
</style>
</head>

<body>
<div class="write-container">
  <h1>글쓰기</h1>
  <form name="articleForm" method="post" action="${contextPath}/board/addNewArticle.do" enctype="multipart/form-data">
    
    <div class="form-group">
      <label>작성자</label>
      <input type="text" value="${member.name}" readonly />
    </div>

    <div class="form-group">
      <label>제목</label>
      <input type="text" name="title" maxlength="500" required />
    </div>

    <div class="form-group">
      <label>내용</label>
      <textarea id="content" name="content"></textarea>
    </div>

    <div class="form-group">
      <label>대표 이미지</label>
      <input type="file" name="imageFileName" onchange="readURL(this);" />
      <img id="preview" />
    </div>

    <div class="btn-group">
      <input type="submit" value="글쓰기" />
      <input type="button" value="목록보기" onclick="backToList(this.form)" />
    </div>
  </form>
</div>
</body>
</html>
