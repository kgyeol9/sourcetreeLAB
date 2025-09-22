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
     function backToList(){
        location.href="${contextPath}/board/list.do";
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
   </script>

   <style>
      body {
         background-color: #1c1c1c;
         color: #f5f5f5;
         font-family: Arial, sans-serif;
         margin: 0;
         padding: 20px;
         margin-top: 60px;
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
      .content-box {
         white-space: pre-wrap; /* 줄바꿈 유지 */
         word-break: break-word;
         line-height: 1.6;
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
   </style>
</head>
<body>
  <table>
    <tr>
       <td>글번호</td>
       <td>${article.articleNO}</td>
    </tr>
    <tr>
       <td>작성자 아이디</td>
       <td>${article.id}</td>
    </tr>
    <tr>
       <td>제목</td>
       <td>${article.title}</td>
    </tr>
    <tr>
       <td>내용</td>
       <td class="content-box">${article.content}</td>
    </tr>

    <c:if test="${not empty article.imageFileName && article.imageFileName!='null'}">
      <tr>
         <td>이미지</td>
         <td>
           <img src="${contextPath}/download.do?articleNO=${article.articleNO}&imageFileName=${article.imageFileName}" id="preview" />
         </td>
      </tr>
    </c:if>

    <tr>
       <td>등록일자</td>
       <td><fmt:formatDate value="${article.writeDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
    </tr>

    <tr>
       <td colspan="2" style="text-align:center;">
          <c:if test="${member.id == article.id}">
             <input type="button" value="수정하기" class="btn btn-gray"
              onclick="location.href='${contextPath}/board/edit.do?articleNO=${article.articleNO}'">
             <input type="button" value="삭제하기" class="btn btn-red"
              onclick="location.href='${contextPath}/board/removeArticle.do?articleNO=${article.articleNO}'">
          </c:if>
          <input type="button" value="리스트로 돌아가기" class="btn btn-gray" onClick="backToList()">
          <input type="button" value="답글쓰기" class="btn btn-red" onClick="fn_reply_form('${contextPath}/board/replyForm.do', ${article.articleNO})">
       </td>
    </tr>
  </table>
</body>
</html>
