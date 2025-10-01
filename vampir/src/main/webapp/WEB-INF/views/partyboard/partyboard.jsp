<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
  :root{ --bg:#111; --panel:#1a1a1a; --line:#2a2a2a; --muted:#9aa0a6; --txt:#eee; --accent:#bb0000; }
  html,body{background:var(--bg); color:var(--txt); margin:0; font-family:system-ui,-apple-system,Segoe UI,Roboto;}
  .pb-wrap{max-width:1100px; margin:20px auto; padding:0 12px;}
  .pb-toolbar{display:flex; gap:8px; align-items:center; margin-bottom:10px;}
  .pb-select,.pb-input,.pb-btn{height:36px; border:1px solid var(--line); background:#1f1f1f; color:var(--txt); border-radius:8px; padding:0 10px;}
  .pb-input{min-width:340px;}
  .pb-btn{cursor:pointer; padding:0 14px; font-weight:600;}
  .pb-btn.primary{background:var(--accent); border-color:var(--accent); color:#fff;}
  .pb-btn.ghost{background:#222; color:#fff;}
  .pb-toolbar .spacer{flex:1;}

  .pb-table{display:grid; grid-template-columns:150px 1fr 180px 110px; row-gap:8px;}
  .pb-th, .pb-tr{display:grid; grid-template-columns:subgrid; grid-column:1 / -1; align-items:center;
                 background:var(--panel); border:1px solid var(--line); border-radius:10px; padding:10px 12px; overflow:hidden;}
  .pb-th{background:#1f1f1f; font-weight:700; opacity:.95;}
  .pb-title{cursor:pointer; color:#fff; text-decoration:none; display:inline-block; max-width:100%;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
  .pb-muted{color:var(--muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
  .pb-cap{white-space:nowrap; text-align:right;}
  .pb-countdown{font-weight:700; font-size:12px; padding:4px 8px; border-radius:8px; border:1px solid transparent; display:inline-block; white-space:nowrap;}
  .pb-live{color:#eaffea; background:#2a402a; border-color:#365a36;}
  .pb-dead{color:#eee; background:#333; border-color:#444;}
  .hidden{display:none !important;}

  /* 모달 */
  .modal-backdrop{position:fixed; inset:0; background:rgba(0,0,0,.58); display:none; align-items:center; justify-content:center; z-index:9999;}
  .modal-backdrop.show{display:flex;}
  .pb-modal{width:min(720px,96vw); background:#1b1b1b; border:1px solid #2a2a2a; border-radius:14px; padding:16px; box-shadow:0 20px 40px rgba(0,0,0,.5);}
  .pb-modal h3{margin:0 0 10px 0;}
  .form-row{display:grid; gap:8px; margin-bottom:8px;}
  .title-row{grid-template-columns:1fr;}
  .time-row{grid-template-columns:160px 110px 96px 96px 120px;}
  .pb-modal .pb-input, .pb-modal .pb-select, .pb-modal .pb-btn{width:100%; height:36px; box-sizing:border-box;}
  .pb-modal textarea.pb-input{height:120px; padding:10px; resize:vertical;}
  .pb-modal .actions{display:flex; justify-content:flex-end; gap:8px; margin-top:12px;}
  @media (max-width:720px){ .time-row{grid-template-columns:1fr 1fr 1fr 1fr 1fr;} }
</style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<div class="pb-wrap">

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

  <div class="pb-table" id="pbTable">
    <div class="pb-th">
      <div>남은시간</div><div>제목</div><div>작성자</div><div style="text-align:right;">모집인원</div>
    </div>

    <!-- 데모 행 (postId data-id로 부여) -->
    <div class="pb-tr pb-row"
         data-id="101" data-title="[레이드] 불의 사원 8인" data-author="운남남"
         data-content="불의 사원 공략 파티 모집" data-date="" data-hour="20" data-minute="00"
         data-capacity="8" data-current="5">
      <div><span class="pb-countdown" data-countdown>계산중…</span></div>
      <div><a class="pb-title">[레이드] 불의 사원 8인</a></div>
      <div class="pb-muted">운남남</div>
      <div class="pb-cap"><b class="pb-cur">5</b> / <b class="pb-max">8</b></div>
    </div>

    <div class="pb-tr pb-row"
         data-id="102" data-title="[던전] 그림자 회랑 4인" data-author="제로시스템즈"
         data-content="그림자 회랑 빠른 진행" data-date="" data-hour="14" data-minute="30"
         data-capacity="4" data-current="2">
      <div><span class="pb-countdown" data-countdown>계산중…</span></div>
      <div><a class="pb-title">[던전] 그림자 회랑 4인</a></div>
      <div class="pb-muted">제로시스템즈</div>
      <div class="pb-cap"><b class="pb-cur">2</b> / <b class="pb-max">4</b></div>
    </div>
  </div>
</div>

<!-- 작성 모달 -->
<div id="pbCreateModal" class="modal-backdrop" aria-hidden="true">
  <section class="pb-modal" role="dialog" aria-modal="true" aria-labelledby="cTitleLabel">
    <h3 id="cTitleLabel">모집글 작성</h3>
    <div class="form-row title-row"><input id="cTitle" class="pb-input" placeholder="제목 (예: [레이드] 불의 사원 8인)"></div>
    <div class="form-row time-row">
      <input id="cDate" type="date" class="pb-input">
      <select id="cAmPm" class="pb-select"><option value="AM">오전</option><option value="PM">오후</option></select>
      <select id="cHour" class="pb-select"></select>
      <select id="cMin" class="pb-select">
        <option>00</option><option>05</option><option>10</option><option>15</option><option>20</option><option>25</option>
        <option>30</option><option>35</option><option>40</option><option>45</option><option>50</option><option>55</option>
      </select>
      <input id="cCapacity" type="number" min="1" step="1" class="pb-input" placeholder="정원">
    </div>
    <div class="form-row"><textarea id="cContent" class="pb-input" placeholder="내용(검색용 자유기입). 엔터로 줄바꿈 가능"></textarea></div>
    <div class="actions">
      <button id="cCancel" class="pb-btn ghost">취소</button>
      <button id="cSubmit" class="pb-btn primary">등록</button>
    </div>
  </section>
</div>

<script>
  var CTX='${ctx}';
  function $(s,el){return (el||document).querySelector(s);}
  function $$(s,el){return Array.prototype.slice.call((el||document).querySelectorAll(s));}
  function todayISO(){return new Date().toISOString().slice(0,10);}
  function computeTargetDate(row){
    var d=row.getAttribute('data-date'); var h=parseInt(row.getAttribute('data-hour')||'0',10), m=parseInt(row.getAttribute('data-minute')||'0',10);
    var base=(d&&d.length===10)?new Date(d+'T00:00:00'):new Date(); base.setHours(h,m,0,0); return base;
  }
  function formatRemain(ms){ if(ms<=0) return {dead:true,text:'마감'};
    var s=Math.floor(ms/1000); var h=Math.floor(s/3600); s%=3600; var m=Math.floor(s/60);
    return {dead:false,text:(h>0?(h+'시간 '):'')+(m+'분 남음')}; }
  function tick(){
    var now=Date.now();
    $$('.pb-row').forEach(function(r){
      var t=computeTargetDate(r).getTime(); var ms=t-now;
      var out=formatRemain(ms); var badge=$('[data-countdown]', r);
      if(badge){ badge.textContent=out.text; badge.className='pb-countdown '+(out.dead?'pb-dead':'pb-live'); }
    });
  }
  setInterval(tick, 30000); tick();

  // 제목 클릭 → 상세로 이동 (postId 넘김)
  document.addEventListener('click', function(e){
    var a=e.target.closest('.pb-title'); if(!a) return;
    var row=e.target.closest('.pb-row');
    var postId=row.getAttribute('data-id')||'0';
    var params=new URLSearchParams({
      postId: postId,
      title:  row.getAttribute('data-title')||a.textContent.trim(),
      start:  (row.getAttribute('data-hour')||'0').toString().padStart(2,'0')+':' + (row.getAttribute('data-minute')||'00'),
      cur:    row.getAttribute('data-current')||'0',
      max:    row.getAttribute('data-capacity')||'0',
      note:   row.getAttribute('data-content')||'',
      date:   row.getAttribute('data-date')||'',
      h24:    row.getAttribute('data-hour')||''
    });
    location.href=CTX+'/partyboard/view.do?'+params.toString();
  });

  // 작성 모달
  function openCreate(){var m=$('#pbCreateModal'); m.classList.add('show'); m.setAttribute('aria-hidden','false');}
  function closeCreate(){var m=$('#pbCreateModal'); m.classList.remove('show'); m.setAttribute('aria-hidden','true');}
  function fillHourSelect(sel){ sel.innerHTML=''; for(var h=1; h<=12; h++){ var o=document.createElement('option'); o.value=String(h); o.textContent=(h+'').padStart(2,'0')+'시'; sel.appendChild(o);} }
  $('#pbOpenCreate').addEventListener('click', function(){ $('#cDate').value=todayISO(); fillHourSelect($('#cHour')); $('#cAmPm').value=(new Date().getHours()<12)?'AM':'PM'; $('#cMin').value='00'; $('#cCapacity').value=''; $('#cTitle').value=''; $('#cContent').value=''; openCreate(); });
  $('#cCancel').addEventListener('click', closeCreate);
  $('#pbCreateModal').addEventListener('click', function(e){ if(e.target===this) closeCreate(); });
  function to24h(ampm,h12){ var h=parseInt(h12,10)%12; if(ampm==='PM') h+=12; return h; }
  $('#cSubmit').addEventListener('click', function(){
    var title=($('#cTitle').value||'').trim(), date=$('#cDate').value, ampm=$('#cAmPm').value, hour12=$('#cHour').value, minute=$('#cMin').value, cap=parseInt($('#cCapacity').value||'0',10), content=($('#cContent').value||'').trim();
    if(!title){alert('제목을 입력하세요.');return;} if(!date){alert('날짜를 선택하세요.');return;} if(cap<=0){alert('정원은 1 이상.');return;}
    var hour24=to24h(ampm,hour12);
    var row=document.createElement('div'); row.className='pb-tr pb-row';
    // 새로 만든 글은 데모이므로 postId 임시 생성
    row.setAttribute('data-id', String(Date.now()).slice(-6));
    row.setAttribute('data-title', title); row.setAttribute('data-author','나');
    row.setAttribute('data-content', content); row.setAttribute('data-date', date);
    row.setAttribute('data-hour', String(hour24)); row.setAttribute('data-minute', String(minute));
    row.setAttribute('data-capacity', String(cap)); row.setAttribute('data-current','1');
    row.innerHTML='<div><span class="pb-countdown" data-countdown>계산중…</span></div><div><a class="pb-title"></a></div><div class="pb-muted"></div><div class="pb-cap"><b class="pb-cur"></b> / <b class="pb-max"></b></div>';
    row.querySelector('.pb-title').textContent=title; row.querySelector('.pb-muted').textContent='나'; row.querySelector('.pb-cur').textContent='1'; row.querySelector('.pb-max').textContent=String(cap);
    $('#pbTable').appendChild(row); closeCreate(); tick();
  });
</script>
</body>
</html>
