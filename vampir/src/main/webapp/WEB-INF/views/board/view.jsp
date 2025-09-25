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
      /* 댓글 영역 */
#commentSection {
    width: 80%;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    background-color: #1e1e1e;
    border-radius: 8px;
    box-shadow: 0 0 8px rgba(224, 59, 59, 0.2);
}

#commentSection h3 {
    margin-bottom: 16px;
    color: #e03b3b;
    font-size: 20px;
    border-bottom: 1px solid #333;
    padding-bottom: 6px;
}

/* 댓글 리스트 */
#commentList .comment {
    padding: 12px 0;
    border-bottom: 1px solid #333;
}

#commentList .comment:last-child {
    border-bottom: none;
}

#commentList .comment p {
    margin: 0;
    color: #f5f5f5;
    line-height: 1.5;
}

#commentList .comment strong {
    color: #e03b3b;
    margin-right: 8px;
}

#commentList .comment small {
    display: block;
    margin-top: 4px;
    font-size: 12px;
    color: #999;
}

/* 댓글 삭제 버튼 */
#commentList .comment button {
    background: none;
    border: none;
    color: #bb2222;
    cursor: pointer;
    font-size: 12px;
    margin-top: 4px;
    transition: color 0.2s;
}

#commentList .comment button:hover {
    color: #ff4444;
    text-decoration: underline;
}

/* 댓글 입력 폼 */
#commentSection #commentContent {
    width: 100%;
    min-height: 60px;
    resize: vertical;
    border: 1px solid #444;
    border-radius: 6px;
    padding: 10px;
    background-color: #2b2b2b;
    color: #f5f5f5;
    font-size: 14px;
    margin-top: 16px;
}

#commentSection #commentContent:focus {
    outline: none;
    border-color: #e03b3b;
    box-shadow: 0 0 5px rgba(224, 59, 59, 0.5);
}

#commentSection #commentSubmit {
    margin-top: 10px;
    padding: 8px 16px;
    background-color: #bb2222;
    color: #fff;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: background-color 0.2s;
}

#commentSection #commentSubmit:hover {
    background-color: #e03b3b;
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
       <td>등록일자</td>
       <td><fmt:formatDate value="${article.writeDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
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
       <td colspan="2" style="text-align:center;">
          <c:if test="${member.id == article.id}">
             <input type="button" value="수정하기" class="btn btn-gray"
              onclick="location.href='${contextPath}/board/edit.do?articleNO=${article.articleNO}'">
             <input type="button" value="삭제하기" class="btn btn-red"
              onclick="location.href='${contextPath}/board/removeArticle.do?articleNO=${article.articleNO}'">
          </c:if>
          <input type="button" value="리스트로 돌아가기" class="btn btn-gray" onClick="backToList()">
         
       </td>
    </tr>
  </table>
  
 <div id="commentSection">
  <h3>댓글</h3>
  <div id="commentList"></div>

  <textarea id="commentContent" placeholder="댓글을 입력하세요"></textarea><br>
  <button id="commentSubmit" type="button">댓글 등록</button>
</div>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function() {
    // JSP에서 변수 받아오기
    var articleId = "${article.articleNO}";
    var ctxPath = "${contextPath}";

    console.log("✅ DOM 로드 완료, articleId =", articleId);
    console.log("✅ DOM 로드 완료, ctxPath =", ctxPath);

    // 댓글 목록 불러오기
    function loadComments() {
        console.log("loadComments 실행됨");
        fetch(ctxPath + "/comment/list.do?articleId=" + articleId)
            .then(function(res) {
                if (!res.ok) throw new Error("댓글 불러오기 실패");
                return res.json();
            })
            .then(function(comments) {
                console.log("📩 댓글 목록", comments);
                var list = document.getElementById("commentList");
                list.innerHTML = comments.map(function(c) {
                    return '<div class="comment">' +
                           '<p><strong>' + (c.nickname || '익명') + '</strong> ' + c.content + '</p>' +
                           '<small>' + c.createdAt + '</small>' +
                           '<button onclick="deleteComment(' + c.id + ')">삭제</button>' +
                           '</div>';
                }).join("");
            })
            .catch(function(err) {
                console.error(err);
            });
    }

    // 댓글 추가
    function addComment() {
        console.log("addComment 함수 실행됨");
        var content = document.getElementById("commentContent").value.trim();
        if (content === "") return alert("댓글을 입력하세요");

        fetch(ctxPath + "/comment/add.do", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ articleId: articleId, content: content })
        })
        .then(function(res) {
            console.log("댓글 추가 요청 완료", res.status);
            if (!res.ok) throw new Error("댓글 등록 실패");
            document.getElementById("commentContent").value = "";
            loadComments();
        })
        .catch(function(err) {
            console.error(err);
        });
    }

    // 댓글 삭제
    window.deleteComment = function(id) {
        fetch(ctxPath + "/comment/delete.do?id=" + id, { method: "POST" })
            .then(function(res) {
                if (!res.ok) throw new Error("삭제 실패");
                loadComments();
            })
            .catch(function(err) {
                console.error(err);
            });
    };

    // 버튼 이벤트 연결
    document.getElementById("commentSubmit").addEventListener("click", addComment);

    // 페이지 로드 시 댓글 목록 불러오기
    loadComments();
});

// 리스트로 돌아가기
function backToList(){
    location.href="${contextPath}/board/list.do";
}
</script>
  
</body>
</html>
