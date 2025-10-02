<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setTimeZone value="Asia/Seoul"/>

<link rel="stylesheet" href="${ctx}/resources/css/free-view.css"/>
<link rel="stylesheet" href="${ctx}/resources/css/tac_job_button.css"/>

<div class="wrap free-view" style="margin-left:270px; padding:20px; color:#fff;">

  <c:if test="${notFound}">
    <div class="empty-message">존재하지 않거나 삭제된 글입니다.</div>
  </c:if>

  <c:if test="${not notFound}">
    <h2 class="fv-title">
      ${board.board_type == 'job' ? '직업 게시판 글보기' : '공략 게시판 글보기'}
    </h2>

    <div class="fv-meta" style="display:flex; gap:20px; color:#aaa; margin-bottom:10px;">
      <span>작성자: <b>${board.nickname}</b></span>
      <span>작성일: <fmt:formatDate value="${board.created_at}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
      <span>조회수: ${board.view_count}</span>
    </div>

    <section class="fv-card" style="background:#111; border-radius:12px; padding:20px; box-shadow:0 0 10px rgba(255,0,0,0.3);">
      <div class="fv-content" style="white-space:pre-wrap; color:#fff;">
        ${board.content}
      </div>
    </section>

    <div class="fv-actions">
      <a class="fv-btn fv-btn-list" href="${ctx}/tac_job/list.do?type=${board.board_type}">목록</a>
      <c:if test="${isLogOn and member != null and member.memCode eq board.mem_code}">
        <a class="fv-btn fv-btn-primary" href="${ctx}/tac_job/edit.do?board_id=${board.board_id}">수정</a>
        <button type="button" class="fv-btn fv-btn-danger" onclick="deleteBoard(${board.board_id})">삭제</button>
      </c:if>
    </div>

    <!-- 댓글 영역 -->
    <section class="fv-comments" style="margin-top:30px;">
      <h3>댓글</h3>

      <c:if test="${isLogOn and member != null}">
        <form id="commentForm" class="fv-cmt-form">
          <input type="hidden" name="board_id" value="${board.board_id}" />
          <textarea name="content" placeholder="댓글을 입력하세요" required></textarea>
          <div class="fv-cmt-form-actions">
            <button type="submit" class="fv-btn fv-btn-primary">등록</button>
          </div>
        </form>
      </c:if>

      <div id="commentList"></div>
    </section>
  </c:if>
</div>

<script type="text/javascript">
var ctx = '${ctx}';
var boardId = ${board != null ? board.board_id : 0};
var sessionMemCode = '${member != null ? member.memCode : ""}';
var login = ${isLogOn && member != null ? true : false}; // Boolean
var commentListEl = document.getElementById('commentList');

function deleteBoard(id){
    if(!confirm('정말 삭제하시겠습니까?')) return;
    fetch(ctx + '/tac_job/delete.do?board_id=' + id, { method:'POST' })
      .then(r => r.text())
      .then(txt => { if(txt==='success') location.href=ctx + '/tac_job/list.do?type=${board.board_type}'; else alert('삭제 실패'); })
      .catch(()=>alert('삭제 실패'));
}

function loadComments() {
    if(!boardId) return;
    fetch(ctx + '/tac_job/comment/list.do?board_id=' + boardId)
      .then(r => r.json())
      .then(comments => {
        commentListEl.innerHTML = '';
        if(comments.length === 0){
          commentListEl.innerHTML = '<div class="no-comments">댓글이 없습니다.</div>';
          return;
        }

        var commentMap = {};
        comments.forEach(c => { c.children=[]; commentMap[c.comment_id]=c; });
        comments.forEach(c => { if(c.parent_id && commentMap[c.parent_id]) commentMap[c.parent_id].children.push(c); });
        comments.filter(c => !c.parent_id).forEach(c => appendComment(c, commentListEl));
      });
}

function appendComment(c, container){
    var formattedTime = c.createdAtStr || (c.created_at ? new Date(c.created_at).toLocaleString() : "");
    
    var div = document.createElement('div');
    div.className = 'fv-cmt-item' + (c.parent_id ? ' reply' : '');

    var isAuthor = false;
    if(sessionMemCode && c.mem_code != null){
        isAuthor = sessionMemCode.toString() === c.mem_code.toString();
    }

    var html = '<div class="fv-cmt-meta"><b>' + c.nickname + '</b> · ' + formattedTime + (c.parent_id ? ' · 대댓글' : '') + '</div>'
             + '<div class="fv-cmt-body">' + c.content + '</div>'
             + '<div class="fv-cmt-actions">';

    // ✅ 답글 버튼: 로그인만 되어 있으면 항상 표시
    if(login){
        html += '<a href="#" class="fv-reply-btn" onclick="showReplyForm(' + c.comment_id + ');return false;">답글</a>';
    }

    // 작성자면 수정/삭제
    if(isAuthor){
        html += '<a href="#" onclick="showEditForm(' + c.comment_id + ', \'' + c.content.replace(/'/g,"\\'") + '\');return false;">수정</a>'
             + '<a href="#" onclick="deleteComment(' + c.comment_id + ');return false;">삭제</a>';
    }

    html += '</div>'
         + '<div id="replyForm-' + c.comment_id + '" style="display:none;"></div>'
         + '<div id="editForm-' + c.comment_id + '" style="display:none;"></div>';

    div.innerHTML = html;
    container.appendChild(div);

    if(c.children && c.children.length > 0){
        c.children.forEach(child => appendComment(child, div));
    }
}

document.getElementById('commentForm')?.addEventListener('submit', function(e){
    e.preventDefault();
    var data = new URLSearchParams(new FormData(this));
    fetch(ctx + '/tac_job/comment/add.do', {method:'POST', body:data})
        .then(r=>r.text())
        .then(txt => { if(txt==='success'){ loadComments(); this.reset(); } else alert(txt); })
        .catch(()=>alert('댓글 등록 실패'));
});

function showEditForm(id, content){
    var container = document.getElementById('editForm-'+id);
    container.style.display = 'block';
    container.innerHTML = '<form onsubmit="submitEdit(event,'+id+')">'
        + '<textarea name="content" style="width:100%;">'+ content.replace(/'/g,"\\'") +'</textarea>'
        + '<button type="submit">저장</button></form>';
}

function submitEdit(e, id){
    e.preventDefault();
    var data = new URLSearchParams(new FormData(e.target));
    data.append('comment_id', id);
    fetch(ctx + '/tac_job/comment/update.do', {method:'POST', body:data})
        .then(r=>r.text())
        .then(txt => { if(txt==='success'){ loadComments(); } else alert('수정 실패'); });
}

function deleteComment(id){
    if(!confirm('댓글을 삭제하시겠습니까?')) return;
    fetch(ctx + '/tac_job/comment/delete.do?comment_id='+id, {method:'POST'})
        .then(r=>r.text())
        .then(txt => { if(txt==='success') loadComments(); else alert('삭제 실패'); });
}

function showReplyForm(parentId){
    var container = document.getElementById('replyForm-'+parentId);
    container.style.display = 'block';
    container.innerHTML = '<form onsubmit="submitReply(event,'+parentId+')">'
        + '<textarea name="content" style="width:100%;" required></textarea>'
        + '<button type="submit">등록</button></form>';
}

function submitReply(e, parentId){
    e.preventDefault();
    var form = e.target;
    var data = new URLSearchParams(new FormData(form));
    data.append('parent_id', parentId);
    data.append('board_id', boardId);
    fetch(ctx + '/tac_job/comment/add.do', {method:'POST', body:data})
        .then(r=>r.text())
        .then(txt => { if(txt==='success'){ loadComments(); } else alert('대댓글 등록 실패'); });
}

loadComments();
</script>

<style>
.fv-comments { margin-top: 30px; }
.fv-cmt-item { background: #1a1a1a; padding: 10px; margin-bottom: 8px; border-radius: 6px; color: #eee; }
.fv-cmt-item.reply { margin-left: 20px; background: #222; }
.fv-cmt-meta { font-size: 0.85rem; color: #ccc; margin-bottom: 4px; }
.fv-cmt-body { font-size: 0.9rem; }
.fv-cmt-actions a { margin-right: 10px; font-size:0.8rem; color:#f88; cursor:pointer; }
.fv-cmt-form textarea { width:100%; min-height:60px; margin-bottom:8px; }
.fv-cmt-form-actions { text-align:right; }
.fv-btn { padding:4px 12px; border:none; border-radius:4px; cursor:pointer; }
.fv-btn-primary { background:#ff4444; color:#fff; }
.fv-btn-danger { background:#aa0000; color:#fff; }
.fv-btn-list { background:#444; color:#fff; }
.no-comments { color:#aaa; font-size:0.9rem; padding:15px; background:#1a1a1a; border-radius:6px; text-align:center; }
</style>
