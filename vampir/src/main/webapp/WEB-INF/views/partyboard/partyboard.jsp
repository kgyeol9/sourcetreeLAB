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

  .pb-toolbar{display:flex; gap:8px; align-items:center; margin-bottom:10px; flex-wrap:wrap;}
  .pb-select,.pb-input,.pb-btn{height:36px; border:1px solid var(--line); background:#1f1f1f; color:var(--txt); border-radius:8px; padding:0 10px;}
  .pb-input{min-width:260px;}
  .pb-btn{cursor:pointer; padding:0 14px; font-weight:600;}
  .pb-btn.primary{background:var(--accent); border-color:var(--accent); color:#fff;}
  .pb-btn.ghost{background:#222; color:#fff;}
  .pb-toolbar .spacer{flex:1;}

  .pb-table{display:grid; grid-template-columns:1fr 160px 120px; row-gap:8px;}
  .pb-th, .pb-tr{display:grid; grid-template-columns:subgrid; grid-column:1 / -1; align-items:center;
                 background:var(--panel); border:1px solid var(--line); border-radius:10px; padding:8px 10px; overflow:hidden;}
  .pb-th{background:#1f1f1f; font-weight:700; opacity:.95;}
  .pb-title{cursor:pointer; color:#fff; text-decoration:none; display:inline-block; max-width:100%;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
  .pb-muted{color:var(--muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
  .pb-cap{white-space:nowrap; text-align:right;}

  .title-wrap{display:flex; align-items:center; gap:8px; min-width:0;}
  .time-badge{font-weight:800; font-variant-numeric:tabular-nums; font-size:12px; padding:3px 6px;
              border-radius:8px; border:1px solid transparent; white-space:nowrap; line-height:1;}
  .pb-live{color:#eaffea; background:#2a402a; border-color:#365a36;}
  .pb-dead{color:#eee; background:#333; border-color:#444;}
  .server-chip{display:inline-block; font-size:12px; padding:2px 8px; border-radius:999px; border:1px solid #444; color:#ddd; white-space:nowrap; flex:0 0 auto;}
  .title-line{display:flex; align-items:center; gap:8px; min-width:0; flex:1; overflow:hidden;}

  .modal-backdrop{position:fixed; inset:0; background:rgba(0,0,0,.58); display:none; align-items:center; justify-content:center; z-index:9999;}
  .modal-backdrop.show{display:flex;}
  .pb-modal{width:min(720px,96vw); background:#1b1b1b; border:1px solid #2a2a2a; border-radius:14px; padding:16px; box-shadow:0 20px 40px rgba(0,0,0,.5);}
  .pb-modal h3{margin:0 0 10px 0;}
  .form-row{display:grid; gap:8px; margin-bottom:8px;}
  .title-row{grid-template-columns:1fr;}
  .time-row{grid-template-columns:160px 110px 96px 96px 120px;}
  .row-two{grid-template-columns:1fr 1fr;}
  .pb-modal .pb-input, .pb-modal .pb-select, .pb-modal .pb-btn{width:100%; height:36px; box-sizing:border-box;}
  .pb-modal textarea.pb-input{height:120px; padding:10px; resize:vertical;}
  .pb-modal .actions{display:flex; justify-content:flex-end; gap:8px; margin-top:12px;}
  @media (max-width:720px){ .time-row{grid-template-columns:1fr 1fr 1fr 1fr 1fr;} .row-two{grid-template-columns:1fr;} }
</style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<div class="pb-wrap">

  <div class="pb-toolbar" id="pbToolbar">
    <select id="pbWorld" class="pb-select" aria-label="월드"></select>
    <select id="pbServer" class="pb-select" aria-label="서버"></select>

    <select id="pbFilter" class="pb-select" aria-label="검색 필터">
      <option value="title">제목</option>
      <option value="author">작성자</option>
      <option value="title+content">제목+내용</option>
      <option value="content">내용</option>
    </select>
    <input id="pbQuery" class="pb-input" placeholder="검색할 단어(2+자)" />
    <button id="pbSearch" class="pb-btn primary">검색</button>
    <button id="pbRefresh" class="pb-btn ghost">새로고침</button>

    <span class="spacer"></span>
    <button id="pbOpenCreate" class="pb-btn primary">모집 등록</button>
  </div>

  <div class="pb-table" id="pbTable">
    <div class="pb-th">
      <div>남은시간 서버 제목</div>
      <div>작성자</div>
      <div style="text-align:right;">모집인원</div>
    </div>
    <!-- 데이터 행은 JS로 렌더링 -->
  </div>
</div>

<!-- 작성 모달 -->
<div id="pbCreateModal" class="modal-backdrop" aria-hidden="true">
  <section class="pb-modal" role="dialog" aria-modal="true" aria-labelledby="cTitleLabel">
    <h3 id="cTitleLabel">모집글 작성</h3>

    <div class="form-row row-two">
      <select id="cWorld" class="pb-select" aria-label="월드 선택"></select>
      <select id="cServer" class="pb-select" aria-label="서버 선택" disabled></select>
    </div>

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
    <div class="form-row"><textarea id="cContent" class="pb-input" placeholder="내용(선택)"></textarea></div>
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

  // 월드/서버
  const WORLDS = {
    "카프": ["카프1","카프2","카프3"], "올가": ["올가1","올가2","올가3"], "쉬마": ["쉬마1","쉬마2","쉬마3"],
    "오스카": ["오스카1","오스카2","오스카3"], "다미르": ["다미르1","다미르2","다미르3"],
    "모아르테": ["모아르테1","모아르테2","모아르테3"], "라즈비": ["라즈비1","라즈비2","라즈비3"],
    "포아메": ["포아메1","포아메2","포아메3"], "돌링엔": ["돌링엔1","돌링엔2","돌링엔3"],
    "키자이아": ["키자이아1","키자이아2","키자이아3"], "넬": ["넬1","넬2","넬3"],
    "밀라": ["밀라1","밀라2","밀라3"], "릴리스": ["릴리스1","릴리스2","릴리스3"],
    "카인": ["카인1","카인2","카인3"], "리델": ["리델1","리델2","리델3"]
  };

  function fillWorldSelect(sel, includeAll=true){
    sel.innerHTML='';
    if(includeAll) sel.appendChild(new Option('월드 전체','__ALL__'));
    Object.keys(WORLDS).forEach(w => sel.appendChild(new Option(w, w)));
  }
  function fillServerSelect(sel, worldValue, includeAll=true){
    sel.innerHTML='';
    if(worldValue==='__ALL__' || !worldValue){
      if(includeAll) sel.appendChild(new Option('서버 전체','__ALL__'));
      sel.disabled = (worldValue==='__ALL__');
      return;
    }
    if(includeAll) sel.appendChild(new Option('서버 전체','__ALL__'));
    (WORLDS[worldValue]||[]).forEach(s => sel.appendChild(new Option(s, s)));
    sel.disabled = false;
  }

  const pbWorld = $('#pbWorld'), pbServer = $('#pbServer');
  fillWorldSelect(pbWorld, true); fillServerSelect(pbServer, '__ALL__', true);
  pbWorld.addEventListener('change', ()=>{ fillServerSelect(pbServer, pbWorld.value, true); loadPosts(); });
  pbServer.addEventListener('change', loadPosts);

  // 검색 필터
  $('#pbSearch').addEventListener('click', loadPosts);
  $('#pbRefresh').addEventListener('click', function(){
    $('#pbQuery').value=''; pbWorld.value='__ALL__'; fillServerSelect(pbServer, '__ALL__', true); loadPosts();
  });

  // 서버에서 목록 로드 & 렌더
  function renderRows(items){
    // 기존 행 제거(헤더 제외)
    $$('.pb-row', $('#pbTable')).forEach(n => n.remove());

    items.forEach(function(it){
      const row = document.createElement('div');
      row.className = 'pb-tr pb-row';
      row.setAttribute('data-id', it.id);
      row.setAttribute('data-world', it.world);
      row.setAttribute('data-server', it.serverName);
      row.setAttribute('data-title', it.title);
      row.setAttribute('data-author', it.authorNick||'');
      row.setAttribute('data-content', it.content||'');
      row.setAttribute('data-date', (it.partyDate||'').slice(0,10));
      row.setAttribute('data-hour', String(it.startHour||0));
      row.setAttribute('data-minute', String(it.startMinute||0));
      row.setAttribute('data-capacity', String(it.capacity||0));
      row.setAttribute('data-current', String(it.currentCount||0));

      row.innerHTML =
        '<div class="title-wrap">' +
          '<span class="time-badge pb-dead" data-countdown>00:00</span>' +
          '<div class="title-line">' +
            '<span class="server-chip">'+ (it.serverName||'') +'</span>' +
            '<a class="pb-title"></a>' +
          '</div>' +
        '</div>' +
        '<div class="pb-muted"></div>' +
        '<div class="pb-cap"><b class="pb-cur"></b> / <b class="pb-max"></b></div>';

      row.querySelector('.pb-title').textContent = it.title||'';
      row.querySelector('.pb-muted').textContent = it.authorNick||'';
      row.querySelector('.pb-cur').textContent = String(it.currentCount||0);
      row.querySelector('.pb-max').textContent = String(it.capacity||0);

      $('#pbTable').appendChild(row);
    });

    tick(); // 남은시간 갱신
  }

  function loadPosts(){
    const params = new URLSearchParams();
    const w = pbWorld.value, s = pbServer.value, q = ($('#pbQuery').value||'').trim();
    if(w && w!=='__ALL__') params.append('world', w);
    if(s && s!=='__ALL__') params.append('server', s);
    if(q) params.append('q', q);

    fetch(CTX + '/partyboard/post/list.json?' + params.toString())
      .then(r=>r.json())
      .then(j=>{ if(j.ok){ renderRows(j.items||[]); }});
  }

  // 카운트다운 (HH:MM)
  function computeTargetDate(row){
    var d=row.getAttribute('data-date');
    var h=parseInt(row.getAttribute('data-hour')||'0',10);
    var m=parseInt(row.getAttribute('data-minute')||'0',10);
    var base=(d&&d.length===10)?new Date(d+'T00:00:00'):new Date();
    base.setHours(h,m,0,0); return base;
  }
  function fmtHM(ms){
    if (ms<=0) return {dead:true, text:'마감'};
    var totalMin = Math.floor(ms/60000);
    var hh = Math.floor(totalMin/60);
    var mm = totalMin%60;
    return {dead:false, text: String(hh).padStart(2,'0')+':'+String(mm).padStart(2,'0')};
  }
  function tick(){
    var now=Date.now();
    $$('.pb-row').forEach(function(r){
      var t=computeTargetDate(r).getTime();
      var out=fmtHM(t-now);
      var badge=$('[data-countdown]', r);
      if(badge){ badge.textContent=out.text; badge.className='time-badge '+(out.dead?'pb-dead':'pb-live'); }
    });
  }
  setInterval(tick, 30000);

  // 상세 이동(제목 클릭)
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
      h24:    row.getAttribute('data-hour')||'',
      world:  row.getAttribute('data-world')||'',
      server: row.getAttribute('data-server')||''
    });
    location.href=CTX+'/partyboard/view.do?'+params.toString();
  });

  // 작성 모달
  function openCreate(){var m=$('#pbCreateModal'); m.classList.add('show'); m.setAttribute('aria-hidden','false');}
  function closeCreate(){var m=$('#pbCreateModal'); m.classList.remove('show'); m.setAttribute('aria-hidden','true');}
  function fillHourSelect(sel){ sel.innerHTML=''; for(var h=1; h<=12; h++){ var o=document.createElement('option'); o.value=String(h); o.textContent=(h+'').padStart(2,'0')+'시'; sel.appendChild(o);} }

  const cWorld = $('#cWorld'), cServer = $('#cServer');
  function initCreateWorlds(){
    cWorld.innerHTML=''; cWorld.appendChild(new Option('월드 선택',''));
    Object.keys(WORLDS).forEach(w => cWorld.appendChild(new Option(w, w)));
    cServer.innerHTML=''; cServer.appendChild(new Option('서버 선택','')); cServer.disabled = true;
  }
  cWorld.addEventListener('change', ()=>{
    const w = cWorld.value;
    cServer.innerHTML=''; cServer.appendChild(new Option('서버 선택',''));
    if(!w){ cServer.disabled = true; return; }
    (WORLDS[w]||[]).forEach(s => cServer.appendChild(new Option(s, s)));
    cServer.disabled = false;
  });

  $('#pbOpenCreate').addEventListener('click', function(){
    $('#cDate').value=todayISO(); fillHourSelect($('#cHour'));
    $('#cAmPm').value=(new Date().getHours()<12)?'AM':'PM'; $('#cMin').value='00';
    $('#cCapacity').value=''; $('#cTitle').value=''; $('#cContent').value='';
    initCreateWorlds(); openCreate();
  });
  $('#cCancel').addEventListener('click', closeCreate);
  $('#pbCreateModal').addEventListener('click', function(e){ if(e.target===this) closeCreate(); });

  function to24h(ampm,h12){ var h=parseInt(h12,10)%12; if(ampm==='PM') h+=12; return h; }

  // 등록 → 서버 저장 → 목록 갱신
  $('#cSubmit').addEventListener('click', function(){
    var w=cWorld.value, s=cServer.value;
    var title=($('#cTitle').value||'').trim();
    var date=$('#cDate').value, ampm=$('#cAmPm').value, hour12=$('#cHour').value, minute=$('#cMin').value;
    var cap=parseInt($('#cCapacity').value||'0',10);
    var content=($('#cContent').value||'').trim();

    if(!w){ alert('월드를 선택하세요.'); return; }
    if(!s){ alert('서버를 선택하세요.'); return; }
    if(!title){alert('제목을 입력하세요.');return;}
    if(!date){alert('날짜를 선택하세요.');return;}
    if(cap<=0){alert('정원은 1 이상이어야 합니다.');return;}

    var hour24=to24h(ampm,hour12);

    var form=new FormData();
    form.append('world', w);
    form.append('server', s);
    form.append('title', title);
    form.append('content', content);
    form.append('date', date);
    form.append('hour', hour24);
    form.append('minute', minute);
    form.append('capacity', cap);

    fetch(CTX + '/partyboard/post/create.do', { method:'POST', body:form })
      .then(r=>r.json())
      .then(j=>{
        if(!j.ok){ alert(j.message||'등록 실패'); return; }
        closeCreate(); loadPosts();
      })
      .catch(e=>alert('네트워크 오류: '+e));
  });

  // 최초 로드
  (function start(){ loadPosts(); setTimeout(tick, 50); })();
</script>
</body>
</html>
