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
/* 게시글 전체 박스 */
.post-container {
  width: 80%;
  max-width: 800px;
  margin: 40px auto;
  padding: 30px;
  background-color: #1e1e1e;
  border-radius: 12px;
  box-shadow: 0 0 15px rgba(224, 59, 59, 0.2);
}

/* 제목 */
.post-title h1 {
  font-size: 26px;
  margin: 0 0 10px 0;
  color: #e03b3b;
  border-bottom: 2px solid #e03b3b33;
  padding-bottom: 8px;
}

/* 메타 정보 */
.post-meta {
  font-size: 14px;
  color: #aaa;
  margin-bottom: 20px;
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.post-meta span {
  background: #2a2a2a;
  padding: 4px 10px;
  border-radius: 4px;
}

/* 이미지 */
.post-image {
  text-align: center;
  margin: 20px 0;
}
.post-image img {
  max-width: 100%;
  border-radius: 8px;
  box-shadow: 0 0 8px rgba(255, 255, 255, 0.1);
}

/* 본문 */
.post-content {
  font-size: 16px;
  line-height: 1.8;
  color: #f5f5f5;
  white-space: pre-wrap;
  word-break: break-word;
  margin-bottom: 30px;
}

/* 버튼 영역 */
.post-actions {
  text-align: right;
}

.post-actions .btn {
  padding: 10px 20px;
  margin-left: 10px;
  font-weight: bold;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}

.btn-red {
  background-color: #bb2222;
  color: #fff;
}
.btn-red:hover {
  background-color: #e03b3b;
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
 <div class="post-container">

  <!-- 제목 -->
  <div class="post-title">
    <h1>${article.title}</h1>
  </div>

  <!-- 메타정보 -->
  <div class="post-meta">
    <span class="post-id">글번호: ${article.articleNO}</span>
    <span class="post-writer">작성자: ${article.id}</span>
    <span class="post-date">
      <fmt:formatDate value="${article.writeDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
    </span>
  </div>

  <!-- 이미지 (있을 경우만) -->
  <c:if test="${not empty article.imageFileName && article.imageFileName!='null'}">
    <div class="post-image">
      <img src="${contextPath}/download.do?articleNO=${article.articleNO}&imageFileName=${article.imageFileName}" alt="게시글 이미지">
    </div>
  </c:if>

  <!-- 본문 -->
  <div class="post-content">
    <p>${article.content}</p>
  </div>

  <!-- 하단 버튼 -->
  <div class="post-actions">
    <c:if test="${member.id == article.id}">
      <button class="btn btn-gray" onclick="location.href='${contextPath}/board/edit.do?articleNO=${article.articleNO}'">수정하기</button>
      <button class="btn btn-red" onclick="location.href='${contextPath}/board/removeArticle.do?articleNO=${article.articleNO}'">삭제하기</button>
    </c:if>
    <button class="btn btn-gray" onclick="backToList()">리스트로 돌아가기</button>
  </div>

</div>
  
 <div id="commentSection">
  <h3>댓글</h3>
  <div id="commentList"></div>

  <textarea id="commentContent" placeholder="댓글을 입력하세요"></textarea><br>
  <button id="commentSubmit" type="button">댓글 등록</button>
</div>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function() {
    // ✅ JSP에서 변수 안전하게 받아오기
    var articleId = "${article.articleNO}";
    var ctxPath = "${contextPath}";
    var isLoggedIn = ${not empty sessionScope.member}; // true / false
    var currentUserCode = "<c:out value='${sessionScope.member.memCode}' default='' />";

    console.log("✅ DOM 로드 완료, articleId =", articleId);
    console.log("✅ 로그인 상태 =", isLoggedIn, " / memCode =", currentUserCode);

    // ✅ 댓글 목록 불러오기
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

                // ✅ 댓글이 없을 때 문구 표시
                if (!comments || comments.length === 0) {
                    list.innerHTML = "<p class='no-comment'>댓글이 없습니다.</p>";
                    return;
                }

                // ✅ 댓글 목록 표시
                list.innerHTML = comments.map(function(c) {
                    var nickname = c.nickname ? c.nickname : "익명";
                    var showDelete = (isLoggedIn && currentUserCode !== "" && currentUserCode == c.memberId);

                    return (
                        '<div class="comment">' +
                            '<p><strong>' + nickname + '</strong> ' + c.content + '</p>' +
                            '<small>' + c.createdAt + '</small>' +
                            (showDelete ? '<button onclick="deleteComment(' + c.id + ')">삭제</button>' : '') +
                        '</div>'
                    );
                }).join("");
            })
            .catch(function(err) {
                console.error(err);
            });
    }

    // ✅ 댓글 추가
    function addComment() {
        console.log("addComment 함수 실행됨");

        // 로그인 체크
        if (!isLoggedIn) {
            alert("댓글을 작성하려면 로그인해야 합니다.");
            return;
        }

        var content = document.getElementById("commentContent").value.trim();
        if (content === "") {
            alert("댓글을 입력하세요.");
            return;
        }

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

    // ✅ 댓글 삭제
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

    // ✅ 수정 (미루기로 했으니 유지)
    window.editComment = function(id) {
        const newContent = prompt("수정할 댓글 내용을 입력하세요:");
        if (!newContent) return;

        fetch(ctxPath + "/comment/update.do", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "id=" + id + "&content=" + encodeURIComponent(newContent)
        })
        .then(res => {
            if (!res.ok) throw new Error("댓글 수정 실패");
            loadComments();
        })
        .catch(err => console.error(err));
    }

    // ✅ 버튼 이벤트 연결
    document.getElementById("commentSubmit").addEventListener("click", addComment);

    // ✅ 페이지 로드 시 댓글 목록 불러오기
    loadComments();
});

// ✅ 리스트로 돌아가기
function backToList(){
    location.href="${contextPath}/board/list.do";
}
</script>
  
</body>
</html>
