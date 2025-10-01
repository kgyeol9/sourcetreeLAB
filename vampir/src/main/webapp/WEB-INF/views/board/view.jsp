<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
  request.setCharacterEncoding("UTF-8");
%> 

<head>
   <meta charset="UTF-8">
   <title>글보기</title>
   <script src="http://code.jquery.com/jquery-latest.min.js"></script> 
   <style>
      body { background-color: #1c1c1c; color: #f5f5f5; font-family: Arial; margin-top: 60px; padding:20px; }
      .post-container { width:80%; max-width:800px; margin:40px auto; padding:30px; background:#1e1e1e; border-radius:12px; box-shadow:0 0 15px rgba(224,59,59,0.2);}
      .post-title h1 { font-size:26px; margin:0 0 10px; color:#e03b3b; border-bottom:2px solid #e03b3b33; padding-bottom:8px;}
      .post-meta { font-size:14px; color:#aaa; margin-bottom:20px; display:flex; gap:20px; flex-wrap:wrap;}
      .post-meta span { background:#2a2a2a; padding:4px 10px; border-radius:4px;}
      .post-image { text-align:center; margin:20px 0; }
      .post-image img { max-width:100%; border-radius:8px; box-shadow:0 0 8px rgba(255,255,255,0.1);}
      .post-content { font-size:16px; line-height:1.8; white-space:pre-wrap; word-break:break-word; margin-bottom:30px;}
      .post-actions { text-align:right;}
      .post-actions .btn { padding:10px 20px; margin-left:10px; font-weight:bold; border:none; border-radius:6px; cursor:pointer;}
      .btn-red { background:#bb2222; color:#fff; }
      .btn-red:hover { background:#e03b3b; }
      .btn-gray { background:#555; color:#fff; }
      .btn-gray:hover { background:#666; }

      #commentSection { width:80%; max-width:800px; margin:0 auto; padding:20px; background:#1e1e1e; border-radius:8px; box-shadow:0 0 8px rgba(224,59,59,0.2);}
      #commentSection h3 { margin-bottom:16px; color:#e03b3b; font-size:20px; border-bottom:1px solid #333; padding-bottom:6px;}
      #commentList .comment { padding:12px 0; border-bottom:1px solid #333; }
      #commentList .comment:last-child { border-bottom:none; }
      #commentList .comment p { margin:0; line-height:1.5; color:#f5f5f5; }
      #commentList .comment small { display:block; margin-top:4px; font-size:12px; color:#999; }
      #commentList .comment button { background:none; border:none; color:#bb2222; cursor:pointer; font-size:12px; margin-top:4px; transition:color 0.2s; }
      #commentList .comment button:hover { color:#ff4444; text-decoration:underline; }
      #commentSection #commentContent { width:100%; min-height:60px; border:1px solid #444; border-radius:6px; padding:10px; background:#2b2b2b; color:#f5f5f5; font-size:14px; margin-top:16px; }
      #commentSection #commentContent:focus { outline:none; border-color:#e03b3b; box-shadow:0 0 5px rgba(224,59,59,0.5);}
      #commentSection #commentSubmit { margin-top:10px; padding:8px 16px; background:#bb2222; color:#fff; border:none; border-radius:6px; cursor:pointer; transition:0.2s;}
      #commentSection #commentSubmit:hover { background:#e03b3b; }
   </style>
</head>
<body>
<div class="post-container">
  <div class="post-title"><h1>${article.title}</h1></div>
  <div class="post-meta">
    <span>글번호: ${article.articleNO}</span>
    <span>작성자: ${article.id}</span>
    <span><fmt:formatDate value="${article.writeDate}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
  </div>
  <c:if test="${not empty article.imageFileName && article.imageFileName!='null'}">
    <div class="post-image">
      <img src="${contextPath}/download.do?articleNO=${article.articleNO}&imageFileName=${article.imageFileName}" alt="게시글 이미지">
    </div>
  </c:if>
  <div class="post-content"><p>${article.content}</p></div>

  <div class="post-actions">
    <c:if test="${member.id == article.id}">
      <button class="btn btn-gray" onclick="location.href='${contextPath}/board/edit.do?articleNO=${article.articleNO}'">수정하기</button>
      <button class="btn btn-red" onclick="location.href='${contextPath}/board/removeArticle.do?articleNO=${article.articleNO}'">삭제하기</button>
    </c:if>
    <button class="btn btn-gray" id="btnBack">리스트로 돌아가기</button>
  </div>
</div>

<div id="commentSection">
  <h3>댓글</h3>
  <div id="commentList"></div>
  <textarea id="commentContent" placeholder="댓글을 입력하세요"></textarea><br>
  <button id="commentSubmit" type="button">댓글 등록</button>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    var articleId = "${article.articleNO}";
    var ctxPath = "${contextPath}";
    var isLoggedIn = ${not empty sessionScope.member};
    var currentUserCode = "${not empty sessionScope.member ? sessionScope.member.memCode : ''}";


    function loadComments() {
        fetch(ctxPath + "/comment/list.do?articleId=" + articleId)
        .then(res => res.json())
        .then(comments => {
            var list = document.getElementById("commentList");
            if (!comments || comments.length===0) { list.innerHTML="<p class='no-comment'>댓글이 없습니다.</p>"; return; }
            list.innerHTML = comments.map(c => {
                var isOwner = currentUserCode && currentUserCode === c.memberId;
                return `<div class="comment" id="comment-${c.id}">
                    <p class="comment-text">${c.content}</p>
                    <small>${c.createdAt}</small>
                    ${isOwner ? `<button onclick="editComment(${c.id})">수정</button>
                                 <button onclick="deleteComment(${c.id})">삭제</button>` : ''}
                </div>`;
            }).join("");
        }).catch(err => console.error(err));
    }

    document.getElementById("commentSubmit").addEventListener("click", function() {
        if(!isLoggedIn) return alert("로그인 후 작성 가능합니다.");
        var content = document.getElementById("commentContent").value.trim();
        if(!content) return alert("댓글을 입력하세요.");
        fetch(ctxPath + "/comment/add.do", {
            method:"POST",
            headers: {"Content-Type":"application/json"},
            body: JSON.stringify({articleId: articleId, content: content})
        }).then(res => { if(!res.ok) throw Error("댓글 등록 실패"); document.getElementById("commentContent").value=""; loadComments(); })
          .catch(err => console.error(err));
    });

    window.deleteComment = function(id) {
        if(!confirm("정말 삭제하시겠습니까?")) return;
        fetch(ctxPath+"/comment/delete.do?id="+id, {method:"POST"})
        .then(res=>{if(!res.ok) throw Error("삭제 실패"); loadComments();})
        .catch(err=>console.error(err));
    }

    window.editComment = function(id) {
        var div = document.getElementById("comment-"+id);
        var oldText = div.querySelector(".comment-text").innerText;
        div.innerHTML = `<textarea id="edit-${id}">${oldText}</textarea>
                         <button onclick="saveComment(${id})">저장</button>
                         <button onclick="cancelEdit(${id}, '${oldText.replace(/'/g,"\\'")}')">취소</button>`;
    }

    window.saveComment = function(id) {
        var newText = document.getElementById("edit-"+id).value.trim();
        if(!newText) return alert("내용을 입력하세요.");
        if(!confirm("이 내용으로 수정하시겠습니까?")) return;
        fetch(ctxPath+"/comment/update.do", {
            method:"POST",
            headers: {"Content-Type":"application/x-www-form-urlencoded"},
            body: "id="+id+"&content="+encodeURIComponent(newText)
        }).then(res=>{if(!res.ok) throw Error("수정 실패"); loadComments();})
          .catch(err=>console.error(err));
    }

    window.cancelEdit = function(id, oldText) {
        var div = document.getElementById("comment-"+id);
        div.innerHTML = `<p class="comment-text">${oldText}</p>
                         <button onclick="editComment(${id})">수정</button>
                         <button onclick="deleteComment(${id})">삭제</button>`;
    }

    loadComments();

    // 리스트로 돌아가기
    document.getElementById("btnBack").addEventListener("click", function(){ location.href=ctxPath+"/board/list.do"; });
});
</script>
</body>
</html>
