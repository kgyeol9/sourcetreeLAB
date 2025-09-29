<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  request.setCharacterEncoding("UTF-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>파티 게시판</title>
<style>
  :root{
    --bg:#111; --panel:#1a1a1a; --line:#2a2a2a; --muted:#9aa0a6; --txt:#eee; --accent:#bb0000;
  }
  html,body{background:var(--bg); color:var(--txt); margin:0; font-family:system-ui,-apple-system,Segoe UI,Roboto;}
  .pb-wrap{max-width:1100px; margin:20px auto; padding:0 12px;}

  /* 툴바 */
  .pb-toolbar{display:flex; gap:8px; align-items:center; margin-bottom:10px;}
  .pb-select,.pb-input,.pb-btn{
    height:36px; border:1px solid var(--line); background:#1f1f1f; color:var(--txt); border-radius:8px; padding:0 10px;
  }
  .pb-input{min-width:340px;}
  .pb-btn{cursor:pointer; padding:0 14px; font-weight:600;}
  .pb-btn.primary{background:var(--accent); border-color:var(--accent); color:#fff;}
  .pb-btn.ghost{background:#222; color:#fff;}
  .pb-toolbar .spacer{flex:1;}

  /* 표 */
  .pb-table{display:grid; grid-template-columns:150px 1fr 180px 110px; row-gap:8px;}
  .pb-th, .pb-tr{
    display:grid; grid-template-columns:subgrid; grid-column:1 / -1; align-items:center;
    background:var(--panel); border:1px solid var(--line); border-radius:10px; padding:10px 12px; overflow:hidden;
  }
  .pb-th{background:#1f1f1f; font-weight:700; opacity:.95;}
  .pb-tr > div{overflow:hidden;}
  .pb-title{cursor:pointer; color:#fff; text-decoration:none; display:inline-block; max-width:100%;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
  .pb-muted{color:var(--muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
  .pb-cap{white-space:nowrap;}
  .pb-countdown{font-weight:700; font-size:12px; padding:4px 8px; border-radius:8px; border:1px solid transparent; display:inline-block; white-space:nowrap;}
  .pb-live{color:#eaffea; background:#2a402a; border-color:#365a36;}
  .pb-dead{color:#eee; background:#333; border-color:#444;}
  .hidden{display:none !important;}

  /* ===== 모달 ===== */
  .modal-backdrop{
    position:fixed; inset:0; background:rgba(0,0,0,.58);
    display:none; align-items:center; justify-content:center; z-index:9999;
  }
  .modal-backdrop.show{ display:flex; }

  .pb-modal{
    width:min(720px, 96vw);
    background:#1b1b1b; border:1px solid #2a2a2a; border-radius:14px; padding:16px;
    box-shadow:0 20px 40px rgba(0,0,0,.5);
  }
  .pb-modal h3{margin:0 0 10px 0;}

  .form-row{ display:grid; gap:8px; margin-bottom:8px; }
  .title-row{ grid-template-columns: 1fr; }                  /* 제목만 */
  .time-row{ grid-template-columns: 160px 110px 96px 96px 120px; } /* 날짜 | AM/PM | 시 | 분 | 정원 */
  .form-row > *{ min-width:0; }

  .pb-modal .pb-input, .pb-modal .pb-select, .pb-modal .pb-btn{ width:100%; height:36px; box-sizing:border-box; }
  .pb-modal textarea.pb-input{ height:120px; padding:10px; resize:vertical; }
  .pb-modal .actions{ display:flex; justify-content:flex-end; gap:8px; margin-top:12px; }

  @media (max-width:720px){
    .time-row{ grid-template-columns: 1fr 1fr 1fr 1fr 1fr; }
  }
</style>
</head>
<body>
<div class="pb-wrap">

  <!-- 툴바 -->
  <div class="pb-toolbar" id="pbToolbar">
    <select id="pbFilter" class="pb-select" aria-label="검색 필터">
      <option value="title">제목</option>
      <option value="author">작성자</option>
      <option value="title+content">제목+내용</option>
      <option value="content">내용</option>
    </select>
    <input id="pbQuery" class="pb-input" placeholder="검색할 단어를 입력하세요(2글자 이상)" />
    <button id="pbSearch" class="pb-btn primary">검색</button>
    <button id="pbRefresh" class="pb-btn ghost" title="새로고침">새로고침</button>
    <span class="spacer"></span>
    <button id="pbOpenCreate" class="pb-btn primary">모집 등록</button>
  </div>

  <!-- 표 헤더 + 데이터 -->
  <div class="pb-table" id="pbTable">
    <div class="pb-th">
      <div>남은시간</div>
      <div>제목</div>
      <div>작성자</div>
      <div style="text-align:right;">모집인원</div>
    </div>

    <!-- 데모 행 1 -->
    <div class="pb-tr pb-row"
         data-title="[레이드] 불의 사원 8인"
         data-author="운남남"
         data-content="불의 사원 공략 파티 모집"
         data-date="" data-hour="20" data-minute="00"
         data-capacity="8" data-current="5">
      <div><span class="pb-countdown" data-countdown>계산중…</span></div>
      <div><a class="pb-title">[레이드] 불의 사원 8인</a></div>
      <div class="pb-muted">운남남</div>
      <div class="pb-cap" style="text-align:right;"><b class="pb-cur">5</b> / <b class="pb-max">8</b></div>
    </div>

    <!-- 데모 행 2 -->
    <div class="pb-tr pb-row"
         data-title="[던전] 그림자 회랑 4인"
         data-author="제로시스템즈"
         data-content="그림자 회랑 빠른 진행"
         data-date="" data-hour="14" data-minute="30"
         data-capacity="4" data-current="2">
      <div><span class="pb-countdown" data-countdown>계산중…</span></div>
      <div><a class="pb-title">[던전] 그림자 회랑 4인</a></div>
      <div class="pb-muted">제로시스템즈</div>
      <div class="pb-cap" style="text-align:right;"><b class="pb-cur">2</b> / <b class="pb-max">4</b></div>
    </div>
  </div>
</div>

<!-- ===== 로그인 닉네임 세션에서 꺼내기 ===== -->
<c:choose>
  <c:when test="${not empty sessionScope.loginMember and not empty sessionScope.loginMember.nickname}">
    <c:set var="loginNick" value="${sessionScope.loginMember.nickname}" />
  </c:when>
  <c:when test="${not empty sessionScope.member and not empty sessionScope.member.nickname}">
    <c:set var="loginNick" value="${sessionScope.member.nickname}" />
  </c:when>
  <c:otherwise>
    <c:set var="loginNick" value="" />
  </c:otherwise>
</c:choose>

<!-- 모집 등록 모달 -->
<div id="pbCreateModal" class="modal-backdrop" aria-hidden="true">
  <section class="pb-modal" role="dialog" aria-modal="true" aria-labelledby="cTitleLabel">
    <h3 id="cTitleLabel">모집글 작성</h3>

    <!-- 1줄: 제목 -->
    <div class="form-row title-row">
      <input id="cTitle" class="pb-input" placeholder="제목 (예: [레이드] 불의 사원 8인)">
    </div>

    <!-- 2줄: 날짜/시간 + 정원(오른쪽) -->
    <div class="form-row time-row">
      <input id="cDate" type="date" class="pb-input">
      <select id="cAmPm" class="pb-select">
        <option value="AM">오전</option>
        <option value="PM">오후</option>
      </select>
      <select id="cHour" class="pb-select"></select>
      <select id="cMin" class="pb-select">
        <option value="00">00</option><option value="05">05</option><option value="10">10</option>
        <option value="15">15</option><option value="20">20</option><option value="25">25</option>
        <option value="30">30</option><option value="35">35</option><option value="40">40</option>
        <option value="45">45</option><option value="50">50</option><option value="55">55</option>
      </select>
      <input id="cCapacity" type="number" min="1" step="1" class="pb-input" placeholder="정원">
    </div>

    <!-- 내용 -->
    <div class="form-row">
      <textarea id="cContent" class="pb-input" placeholder="내용(검색용 자유기입). 엔터로 줄바꿈 가능"></textarea>
    </div>

    <div class="actions">
      <button id="cCancel" class="pb-btn ghost">취소</button>
      <button id="cSubmit" class="pb-btn primary">등록</button>
    </div>
  </section>
</div>

<script>
  // ==== 유틸 ====
  var CTX = '<%= request.getContextPath() %>';       // 예: /vampir
  var CURRENT_USER_NICK = '<c:out value="${loginNick}" />'; // 세션 닉네임(없으면 빈값)
  var $ = function(sel, el){ return (el||document).querySelector(sel); };
  var $$ = function(sel, el){ return Array.prototype.slice.call((el||document).querySelectorAll(sel)); };
  function todayISO(){ return new Date().toISOString().slice(0,10); }
  function normalize(s){ return (s||'').toLowerCase(); }

  // ==== 카운트다운 ====
  function computeTargetDate(row){
    var d = row.getAttribute('data-date');
    var hour = parseInt(row.getAttribute('data-hour') || '0', 10);
    var min  = parseInt(row.getAttribute('data-minute') || '0', 10);
    var base = (d && d.length===10) ? new Date(d + 'T00:00:00') : new Date();
    base.setHours(hour, min, 0, 0);
    return base;
  }
  function formatRemain(ms){
    if(ms <= 0) return {dead:true, text:'마감'};
    var s = Math.floor(ms/1000);
    var h = Math.floor(s/3600); s%=3600;
    var m = Math.floor(s/60);
    var text = (h>0? (h+'시간 '):'') + (m+'분 남음');
    return {dead:false, text:text};
  }
  function tickCountdown(){
    var now = Date.now();
    $$('.pb-row').forEach(function(row){
      var t = computeTargetDate(row).getTime();
      var ms = t - now;
      row.dataset.remain = String(ms);
      row.dataset.dead = (ms <= 0) ? '1' : '0';

      var out = formatRemain(ms);
      var badge = $('[data-countdown]', row);
      if(badge){
        badge.textContent = out.text;
        badge.className = 'pb-countdown ' + (out.dead ? 'pb-dead' : 'pb-live');
      }
    });
    sortByRemain();
  }
  function sortByRemain(){
    var table = $('#pbTable');
    var rows = $$('.pb-row', table);
    var live = [], dead = [];
    rows.forEach(function(r){ (r.dataset.dead === '1' ? dead : live).push(r); });
    live.sort(function(a,b){ return (parseInt(a.dataset.remain,10)||0) - (parseInt(b.dataset.remain,10)||0); });
    live.concat(dead).forEach(function(r){ table.appendChild(r); });
  }

  // ==== 검색 ====
  function applySearch(){
    var filter = $('#pbFilter').value;
    var q = normalize($('#pbQuery').value.trim());
    var on = q.length >= 2;

    $$('.pb-row').forEach(function(row){
      if(!on){ row.classList.remove('hidden'); return; }
      var title = normalize(row.getAttribute('data-title'));
      var author= normalize(row.getAttribute('data-author'));
      var content=normalize(row.getAttribute('data-content'));
      var ok = false;
      if(filter==='title') ok = title.indexOf(q)>-1;
      else if(filter==='author') ok = author.indexOf(q)>-1;
      else if(filter==='content') ok = content.indexOf(q)>-1;
      else ok = (title.indexOf(q)>-1) || (content.indexOf(q)>-1);
      row.classList.toggle('hidden', !ok);
    });
  }
  $('#pbSearch').addEventListener('click', applySearch);
  $('#pbQuery').addEventListener('keydown', function(e){ if(e.key==='Enter') applySearch(); });
  $('#pbRefresh').addEventListener('click', function(){ location.reload(); });

  // ==== 제목 클릭 → 상세 ====
  document.addEventListener('click', function(e){
    var a = e.target.closest('.pb-title');
    if(!a) return;
    var row = e.target.closest('.pb-row');
    var params = new URLSearchParams({
      title: row.getAttribute('data-title') || a.textContent.trim(),
      start: (row.getAttribute('data-hour')||'0').toString().padStart(2,'0') + ':' + (row.getAttribute('data-minute')||'00'),
      cur:   row.getAttribute('data-current') || '0',
      max:   row.getAttribute('data-capacity') || '0',
      note:  row.getAttribute('data-content') || '',
      date:  row.getAttribute('data-date') || '',
      type:  '',
      h24:   row.getAttribute('data-hour') || ''
    });
    location.href = CTX + '/partyboard/view.do?' + params.toString();
  });

  // ==== 모달 열고/닫고 ====
  function openCreate(){
    var m = $('#pbCreateModal');
    m.classList.add('show'); m.setAttribute('aria-hidden','false');
  }
  function closeCreate(){
    var m = $('#pbCreateModal');
    m.classList.remove('show'); m.setAttribute('aria-hidden','true');
  }

  function fillHourSelect(sel){
    sel.innerHTML = '';
    for(var h=1; h<=12; h++){
      var opt = document.createElement('option');
      opt.value = String(h);
      opt.textContent = (h+'').padStart(2,'0') + '시';
      sel.appendChild(opt);
    }
  }

  $('#pbOpenCreate').addEventListener('click', function(){
    $('#cDate').value = todayISO();
    fillHourSelect($('#cHour'));
    $('#cAmPm').value = (new Date().getHours()<12) ? 'AM' : 'PM';
    $('#cMin').value = '00';
    $('#cCapacity').value = '';
    $('#cTitle').value = '';
    $('#cContent').value = '';
    openCreate();
  });
  $('#cCancel').addEventListener('click', closeCreate);
  document.getElementById('pbCreateModal').addEventListener('click', function(e){
    if(e.target === this) closeCreate();
  });

  function to24h(ampm, h12){
    var h = parseInt(h12,10) % 12;
    if(ampm === 'PM') h += 12;
    return h;
  }

  // 등록 → 표에 행 추가 (작성자는 세션 닉네임, 현재인원 1)
  $('#cSubmit').addEventListener('click', function(){
    if(!CURRENT_USER_NICK){
      alert('로그인이 필요합니다. 로그인 후 다시 시도하세요.'); return;
    }

    var title = ($('#cTitle').value||'').trim();
    var date  = $('#cDate').value;
    var ampm  = $('#cAmPm').value;
    var hour12= $('#cHour').value;
    var minute= $('#cMin').value;
    var cap   = parseInt($('#cCapacity').value||'0',10);
    var content = ($('#cContent').value||'').trim();

    if(title.length===0){ alert('제목을 입력하세요.'); return; }
    if(!date){ alert('날짜를 선택하세요.'); return; }
    if(cap<=0){ alert('정원은 1 이상이어야 합니다.'); return; }

    var hour24 = to24h(ampm, hour12);

    var row = document.createElement('div');
    row.className = 'pb-tr pb-row';
    row.setAttribute('data-title', title);
    row.setAttribute('data-author', CURRENT_USER_NICK);
    row.setAttribute('data-content', content);
    row.setAttribute('data-date', date);
    row.setAttribute('data-hour', String(hour24));
    row.setAttribute('data-minute', String(minute));
    row.setAttribute('data-capacity', String(cap));
    row.setAttribute('data-current', '1'); // 파티장 1명 포함

    row.innerHTML =
      '<div><span class="pb-countdown" data-countdown>계산중…</span></div>' +
      '<div><a class="pb-title"></a></div>' +
      '<div class="pb-muted"></div>' +
      '<div class="pb-cap" style="text-align:right;"><b class="pb-cur"></b> / <b class="pb-max"></b></div>';

    row.querySelector('.pb-title').textContent = title;
    row.querySelector('.pb-muted').textContent = CURRENT_USER_NICK;
    row.querySelector('.pb-cur').textContent = '1';
    row.querySelector('.pb-max').textContent = String(cap);

    $('#pbTable').appendChild(row);
    closeCreate();
    tickCountdown();
    applySearch();
  });

  // ==== 초기화 ====
  (function init(){
    tickCountdown();
    setInterval(tickCountdown, 30 * 1000);
  })();
</script>
</body>
</html>
