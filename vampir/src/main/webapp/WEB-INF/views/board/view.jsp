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
   <title>글보기</title>
   <script src="http://code.jquery.com/jquery-latest.min.js"></script> 
   <script type="text/javascript">
     function backToList(obj){
        obj.action="${contextPath}/board/list.do";
        obj.submit();
     }
     function fn_enable(obj){
         document.getElementById("i_title").disabled=false;
         document.getElementById("i_content").disabled=false;
         document.getElementById("i_imageFileName").disabled=false;
         document.getElementById("tr_btn_modify").style.display="block";
         document.getElementById("tr_file_upload").style.display="block";
         document.getElementById("tr_btn").style.display="none";
     }
     function fn_modify_article(obj){
         obj.action="${contextPath}/board/modArticle.do";
         obj.submit();
     }
     function fn_remove_article(url,articleNO){
         var form = document.createElement("form");
         form.setAttribute("method", "post");
         form.setAttribute("action", url);
         var articleNOInput = document.createElement("input");
         articleNOInput.setAttribute("type","hidden");
         articleNOInput.setAttribute("name","articleNO");
         articleNOInput.setAttribute("value", articleNO);
         form.appendChild(articleNOInput);
         document.body.appendChild(form);
         form.submit();
     }
     function fn_reply_form(url, parentNO){
         var form = document.createElement("form");
         form.setAttribute("method", "post");
         form.setAttribute("action", url);
         var parentNOInput = document.createElement("input");
         parentNOInput.setAttribute("type","hidden");
         parentNOInput.setAttribute("name","parentNO");
         parentNOInput.setAttribute("value", parentNO);
         form.appendChild(parentNOInput);
         document.body.appendChild(form);
         form.submit();
     }
     function readURL(input) {
         if (input.files && input.files[0]) {
             var reader = new FileReader();
             reader.onload = function (e) {
                 $('#preview').attr('src', e.target.result);
             }
             reader.readAsDataURL(input.files[0]);
         }
     }  
   </script>

   <style>

      body {
         background-color: #1c1c1c;
         color: #f5f5f5;
         font-family: Arial, sans-serif;
         margin: 0;
         padding: 20px;
		 margin-top: 60px; /* 헤더 높이만큼 본문 내림 */
    	 padding: 20px;
      }
      table {
         border-collapse: collapse;
         width: 80%;
         margin: 0 auto;
         background-color: #222;
         border-radius: 8px;
         overflow: hidden;
         box-shadow: 0 0 10px #000;
      }
      td {
         padding: 12px;
         vertical-align: top;
         border-bottom: 1px solid #333;
      }
      td:first-child {
         width: 180px;
         text-align: center;
         background-color: #2a2a2a;
         font-weight: bold;
         color: #e03b3b;
      }
      input[type=text], textarea {
         width: 100%;
         padding: 8px;
         border-radius: 4px;
         border: 1px solid #444;
         background-color: #333;
         color: #f5f5f5;
      }
      textarea {
         resize: vertical;
      }
      input[disabled], textarea[disabled] {
         background-color: #2a2a2a;
         color: #bbb;
      }
      input[type=file] {
         color: #f5f5f5;
      }
      img#preview {
         max-width: 300px;
         max-height: 300px;
         border: 1px solid #444;
         border-radius: 6px;
         margin-top: 10px;
      }
      tr:last-child td {
         border-bottom: none;
      }
      .btn {
         padding: 8px 18px;
         margin: 5px;
         border: none;
         border-radius: 4px;
         cursor: pointer;
         font-weight: bold;
      }
      .btn-red {
         background-color: #bb2222;
         color: #fff;
      }
      .btn-red:hover {
         background-color: #a11b1b;
      }
      .btn-gray {
         background-color: #555;
         color: #fff;
      }
      .btn-gray:hover {
         background-color: #666;
      }
      #tr_file_upload {
         display:none;
      }
      #tr_btn_modify {
         display:none;
      }
   </style>
</head>
<body>
  <form name="frmArticle" method="post" action="${contextPath}" enctype="multipart/form-data">
  <table>
    <tr>
       <td>글번호</td>
       <td>
          <input type="text" value="${article.articleNO}" disabled />
          <input type="hidden" name="articleNO" value="${article.articleNO}" />
       </td>
    </tr>
    <tr>
       <td>작성자 아이디</td>
       <td><input type="text" value="${article.id}" name="writer" disabled /></td>
    </tr>
    <tr>
       <td>제목</td>
       <td><input type="text" value="${article.title}" name="title" id="i_title" disabled /></td>
    </tr>
    <tr>
       <td>내용</td>
       <td><textarea rows="20" name="content" id="i_content" disabled>${article.content}</textarea></td>
    </tr>

    <c:choose> 
      <c:when test="${not empty article.imageFileName && article.imageFileName!='null' }">
        <tr>
           <td>이미지</td>
           <td>
             <input type="hidden" name="originalFileName" value="${article.imageFileName}" />
             <img src="${contextPath}/download.do?articleNO=${article.articleNO}&imageFileName=${article.imageFileName}" id="preview" />
           </td>
        </tr>  
        <tr>
           <td></td>
           <td><input type="file" name="imageFileName" id="i_imageFileName" disabled onchange="readURL(this);" /></td>
        </tr> 
      </c:when>
      <c:otherwise>
        <tr id="tr_file_upload">
           <td>이미지</td>
           <td>
             <input type="hidden" name="originalFileName" value="${article.imageFileName}" />
             <img id="preview" /><br>
             <input type="file" name="imageFileName" id="i_imageFileName" disabled onchange="readURL(this);" />
           </td>
        </tr>
      </c:otherwise>
    </c:choose>

    <tr>
       <td>등록일자</td>
       <td><input type="text" value="<fmt:formatDate value='${article.writeDate}' />" disabled /></td>
    </tr>

    <tr id="tr_btn_modify" align="center">
       <td colspan="2" style="text-align:center;">
           <input type="button" value="수정반영하기" class="btn btn-red" onClick="fn_modify_article(frmArticle)">
           <input type="button" value="취소" class="btn btn-gray" onClick="backToList(frmArticle)">
       </td>
    </tr>
    
    <tr id="tr_btn">
       <td colspan="2" style="text-align:center;">
          <c:if test="${member.id == article.id}">
             <input type="button" value="수정하기" class="btn btn-gray" onClick="fn_enable(this.form)">
             <input type="button" value="삭제하기" class="btn btn-red" onClick="fn_remove_article('${contextPath}/board/removeArticle.do', ${article.articleNO})">
          </c:if>
          <input type="button" value="리스트로 돌아가기" class="btn btn-gray" onClick="backToList(this.form)">
          <input type="button" value="답글쓰기" class="btn btn-red" onClick="fn_reply_form('${contextPath}/board/replyForm.do', ${article.articleNO})">
       </td>
    </tr>
  </table>
  </form>
</body>
</html>
