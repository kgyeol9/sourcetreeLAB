<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  request.setCharacterEncoding("UTF-8");
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 게시판 - 글쓰기</title>
<style>
  :root{--bg:#111;--panel:#1a1a1a;--line:#2a2a2a;--muted:#9aa0a6;--ink:#eee;--accent:#bb0000;}
  body{background:var(--bg);color:var(--ink);font-family:system-ui,-apple-system,Segoe UI,Roboto;margin:0}
  .wrap{max-width:900px;margin:32px auto;padding:0 12px}
  .card{background:var(--panel);border:1px solid var(--line);border-radius:12px;padding:16px}
  .row{display:flex;gap:10px;align-items:center;margin-bottom:10px;flex-wrap:wrap}
  .label{min-width:70px;color:#ddd}
  .sel,.input,.btn,textarea{border:1px solid var(--line);background:#202020;color:#fff;border-radius:10px}
  .sel,.input{height:38px;padding:0 12px}
  .input{flex:1}
  textarea{width:100%;min-height:260px;padding:12px;border-radius:12px;resize:vertical}
  .btn{height:40px;padding:0 16px;cursor:pointer;font-weight:700}
  .btn.primary{background:var(--accent);border-color:var(--accent)}
  .btn.ghost{background:#262626}
  .hint{color:var(--muted);font-size:.9rem}
  .bar{display:flex;gap:8px;align-items:center;margin-bottom:12px}
  .spacer{flex:1}
</style>
</head>
<body>
<div class="wrap">
  <h2 style="margin:0 0 12px 0;">서버 게시판 글쓰기</h2>

  <!-- 상단 선택 바(월드/서버) -->
  <div class="card" style="margin-bottom:12px;">
    <div class="bar">
      <span class="label">월드</span>
      <select id="world" class="sel">
        <option value="ALL" <c:if test="${world eq 'ALL'}">selected</c:if>>전체</option>
        <option value="kapf"   <c:if test="${world eq 'kapf'}">selected</c:if>>카프</option>
        <option value="olga"   <c:if test="${world eq 'olga'}">selected</c:if>>올가</option>
        <option value="shima"  <c:if test="${world eq 'shima'}">selected</c:if>>쉬마</option>
        <option value="oscar"  <c:if test="${world eq 'oscar'}">selected</c:if>>오스카</option>
        <option value="damir"  <c:if test="${world eq 'damir'}">selected</c:if>>다미르</option>
        <option value="moarte" <c:if test="${world eq 'moarte'}">selected</c:if>>모아르테</option>
        <option value="razvi"  <c:if test="${world eq 'razvi'}">selected</c:if>>라즈비</option>
        <option value="foam"   <c:if test="${world eq 'foam'}">selected</c:if>>포아메</option>
        <option value="dorlingen" <c:if test="${world eq 'dorlingen'}">selected</c:if>>돌링엔</option>
        <option value="kizaiya"   <c:if test="${world eq 'kizaiya'}">selected</c:if>>키자이아</option>
        <option value="nel"    <c:if test="${world eq 'nel'}">selected</c:if>>넬</option>
        <option value="mila"   <c:if test="${world eq 'mila'}">selected</c:if>>밀라</option>
        <option value="lilith" <c:if test="${world eq 'lilith'}">selected</c:if>>릴리스</option>
        <option value="kain"   <c:if test="${world eq 'kain'}">selected</c:if>>카인</option>
        <option value="ridel"  <c:if test="${world eq 'ridel'}">selected</c:if>>리델</option>
      </select>

      <span class="label">서버</span>
      <select id="server" class="sel">
        <option value="ALL" <c:if test="${server eq 'ALL'}">selected</c:if>>전체</option>
        <option value="1" <c:if test="${server eq '1'}">selected</c:if>>1 서버</option>
        <option value="2" <c:if test="${server eq '2'}">selected</c:if>>2 서버</option>
        <option value="3" <c:if test="${server eq '3'}">selected</c:if>>3 서버</option>
      </select>

      <span class="spacer"></span>
      <a class="btn ghost" href="<%=ctx%>/serverboard/${world != null ? world : 'ALL'}/${server != null ? server : 'ALL'}">목록</a>
    </div>
    <p class="hint">※ 글쓰기는 특정 <b>월드/서버</b>를 선택해야 등록됩니다. (전체 선택은 조회용)</p>
  </div>

  <!-- 글쓰기 폼 -->
  <form id="writeForm" class="card" method="post" action="<%=ctx%>/serverboard/add.do">
    <input type="hidden" name="world"  id="f_world"  value="${world != null ? world : 'ALL'}">
    <input type="hidden" name="server" id="f_server" value="${server != null ? server : 'ALL'}">

    <div class="row">
      <span class="label">제목</span>
      <input type="text" name="title" id="title" class="input" maxlength="120" placeholder="제목을 입력하세요">
    </div>

    <div class="row">
      <span class="label" style="align-self:flex-start;">내용</span>
      <textarea name="content" id="content" placeholder="내용을 입력하세요 (Markdown/일반 텍스트)"></textarea>
    </div>

    <div class="row" style="justify-content:flex-end;">
      <button type="button" class="btn ghost" onclick="history.back()">취소</button>
      <button type="submit" class="btn primary">등록</button>
    </div>
  </form>
</div>

<script>
  (function(){
    var worldSel = document.getElementById('world');
    var serverSel = document.getElementById('server');
    var fWorld   = document.getElementById('f_world');
    var fServer  = document.getElementById('f_server');
    var form     = document.getElementById('writeForm');
    var title    = document.getElementById('title');
    var content  = document.getElementById('content');

    // 월드=전체면 서버=전체로 고정(비활성화), 아니면 활성화
    function applyWorldRules(){
      if(worldSel.value === 'ALL'){
        serverSel.value = 'ALL';
        serverSel.disabled = true;
      } else {
        serverSel.disabled = false;
        if(serverSel.value === 'ALL') serverSel.value = '1';
      }
      // 히든 필드 동기화
      fWorld.value  = worldSel.value;
      fServer.value = serverSel.value;
    }
    worldSel.addEventListener('change', applyWorldRules);
    serverSel.addEventListener('change', function(){
      fServer.value = serverSel.value;
    });
    // 초기 적용
    applyWorldRules();

    // 간단 검증
    form.addEventListener('submit', function(e){
      if(worldSel.value === 'ALL' || serverSel.value === 'ALL'){
        alert('글쓰기는 특정 월드와 서버를 선택해야 합니다.');
        e.preventDefault(); return false;
      }
      if(!title.value.trim()){
        alert('제목을 입력하세요.');
        title.focus(); e.preventDefault(); return false;
      }
      if(!content.value.trim()){
        alert('내용을 입력하세요.');
        content.focus(); e.preventDefault(); return false;
      }
      // 히든 값 최종 동기화
      fWorld.value  = worldSel.value;
      fServer.value = serverSel.value;
    });
  })();
</script>
</body>
</html>
