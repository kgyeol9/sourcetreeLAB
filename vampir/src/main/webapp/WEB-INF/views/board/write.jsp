<%@ page language="java" contentType="text/html; charset=UTF-8"
     pageEncoding="UTF-8"
    isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  /> 
<%
  request.setCharacterEncoding("UTF-8");
%> 

<head>
<meta charset="UTF-8">
<title>글쓰기창</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
   function readURL(input) {
      if (input.files && input.files[0]) {
	      var reader = new FileReader();
	      reader.onload = function (e) {
	        $('#preview').attr('src', e.target.result);
          }
         reader.readAsDataURL(input.files[0]);
      }
  }  
  function backToList(obj){
    obj.action="${contextPath}/board/list.do";
    obj.submit();
  }
  
  var cnt=1;
  function fn_addFile(){
	  $("#d_file").append("<br><input type='file' name='file"+cnt+"' />");
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
      margin-top: 20px;
  }
  form {
      max-width: 900px;
      margin: 30px auto;
      padding: 20px;
      background-color: #222;
      border-radius: 8px;
      box-shadow: 0 0 10px #000;
  }
  table {
      border-collapse: collapse;
      width: 100%;
  }
  td {
      padding: 10px;
  }
  input[type=text], textarea, input[type=file] {
      width: 100%;
      padding: 6px;
      border-radius: 4px;
      border: 1px solid #444;
      background-color: #333;
      color: #f5f5f5;
  }
  input[type=button], input[type=submit] {
      padding: 8px 20px;
      border-radius: 4px;
      border: none;
      color: #f5f5f5;
      cursor: pointer;
  }
  input[type=button] {
      background-color: #555;
  }
  input[type=submit] {
      background-color: #bb2222;
      margin-right: 10px;
  }
  img#preview {
      border: 1px solid #444;
      border-radius: 4px;
      width: 200px;
      height: 200px;
  }
</style>
</head>

<body>
<h1>글쓰기</h1>

<form name="articleForm" method="post" action="${contextPath}/board/addNewArticle.do" enctype="multipart/form-data">
  <table>
      <tr>
          <td align="right" style="width:120px;">작성자</td>
          <td colspan="2"><input type="text" value="${member.name}" readonly /></td>
      </tr>
      <tr>
          <td align="right">글제목</td>
          <td colspan="2"><input type="text" name="title" maxlength="500" /></td>
      </tr>
      <tr>
          <td align="right" valign="top">글내용</td>
          <td colspan="2"><textarea name="content" rows="10" maxlength="4000"></textarea></td>
      </tr>
      <tr>
          <td align="right">이미지파일 첨부</td>
          <td><input type="file" name="imageFileName" onchange="readURL(this);" /></td>
          <td><img id="preview" src="#" /></td>
      </tr>
      <tr>
          <td align="right">추가 파일</td>
          <td><input type="button" value="파일 추가" onClick="fn_addFile()" /></td>
          <td><div id="d_file"></div></td>
      </tr>
      <tr>
          <td></td>
          <td colspan="2" style="text-align:center;">
              <input type="submit" value="글쓰기" />
              <input type="button" value="목록보기" onClick="backToList(this.form)" />
          </td>
      </tr>
  </table>
</form>
</body>
</html>
