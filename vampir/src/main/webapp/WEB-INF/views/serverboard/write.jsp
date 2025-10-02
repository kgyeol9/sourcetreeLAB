<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currWorld" value="${empty world  ? 'ALL' : world}" />
<c:set var="currServer" value="${empty server ? 'ALL' : server}" />

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
  .sel,.input,.btn,textarea,input[type=file]{border:1px solid var(--line);background:#202020;color:#fff;border-radius:10px}
  .sel,.input{height:38px;padding:0 12px}
  .input{flex:1}
  input[type=file]{height:38px;padding:6px 12px}
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
        <option value="ALL"   ${currWorld eq 'ALL'   ? 'selected' : ''}>전체</option>
        <option value="kapf"  ${currWorld eq 'kapf'  ? 'selected' : ''}>카프</option>
        <option value="olga"  ${currWorld eq 'olga'  ? 'selected' : ''}>올가</option>
        <option value="shima" ${currWorld eq 'shima' ? 'selected' : ''}>쉬마</option>
        <option value="oscar" ${currWorld eq 'oscar' ? 'selected' : ''}>오스카</option>
        <option value="damir" ${currWorld eq 'damir' ? 'selected' : ''}>다미르</option>
        <option value="moarte" ${currWorld eq 'moarte' ? 'selected' : ''}>모아르테</option>
        <option value="razvi" ${currWorld eq 'razvi' ? 'selected' : ''}>라즈비</option>
        <option value="foam" ${currWorld eq 'foam' ? 'selected' : ''}>포아메</option>
        <option value="dorlingen" ${currWorld eq 'dorlingen' ? 'selected' : ''}>돌링엔</option>
        <option value="kizaiya" ${currWorld eq 'kizaiya' ? 'selected' : ''}>키자이아</option>
        <option value="nel"  ${currWorld eq 'nel'  ? 'selected' : ''}>넬</option>
        <option value="mila" ${currWorld eq 'mila' ? 'selected' : ''}>밀라</option>
        <option value="lilith" ${currWorld eq 'lilith' ? 'selected' : ''}>릴리스</option>
        <option value="kain" ${currWorld eq 'kain' ? 'selected' : ''}>카인</option>
        <option value="ridel" ${currWorld eq 'ridel' ? 'selected' : ''}>리델</option>
      </select>

      <span class="label">서버</span>
      <select id="server" class="sel">
        <option value="ALL" ${currServer eq 'ALL' ? 'selected' : ''}>전체</option>
        <option value="1" ${currServer eq '1' ? 'selected' : ''}>1 서버</option>
        <option value="2" ${currServer eq '2' ? 'selected' : ''}>2 서버</option>
        <option value="3" ${currServer eq '3' ? 'selected' : ''}>3 서버</option>
      </select>

      <span class="spacer"></span>
    </div>
    <p class="hint">※ 글쓰기는 특정 <b>월드/서버</b>를 선택해야 등록됩니다. (전체 선택은 조회용)</p>
  </div>

  <!-- 글쓰기 폼 (이미지 업로드 포함) -->
  <form id="writeForm" class="card" method="post" action="${ctx}/serverboard/add.do" enctype="multipart/form-data">
    <input type="hidden" name="world"  id="f_world"  value="${currWorld}">
    <input type="hidden" name="server" id="f_server" value="${currServer}">

    <div class="row">
      <span class="label">제목</span>
      <input type="text" name="title" id="title" class="input" maxlength="120" placeholder="제목을 입력하세요" required>
    </div>

    <div class="row" style="align-items:flex-start;">
      <span class="label" style="margin-top:8px;">내용</span>
      <textarea name="content" id="content" placeholder="내용을 입력하세요 (일반 텍스트/HTML)" required></textarea>
    </div>

    <div class="row">
      <span class="label">이미지</span>
      <input type="file" name="image" accept="image/*">
      <span class="hint">최대 5MB, JPG/PNG/GIF</span>
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

    function applyWorldRules(){
      if(worldSel.value === 'ALL'){
        serverSel.value = 'ALL';
        serverSel.disabled = true;
      } else {
        serverSel.disabled = false;
        if(serverSel.value === 'ALL') serverSel.value = '1';
      }
      fWorld.value  = worldSel.value;
      fServer.value = serverSel.value;
    }
    worldSel.addEventListener('change', applyWorldRules);
    serverSel.addEventListener('change', function(){
      fServer.value = serverSel.value;
    });
    applyWorldRules();

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
      fWorld.value  = worldSel.value;
      fServer.value = serverSel.value;
    });
  })();
</script>
</body>
</html>
