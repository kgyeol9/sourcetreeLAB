<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>파티게시판</title>
<style>
  .pb-wrap{padding:16px; box-sizing:border-box;}
  .pb-toolbar{display:flex; flex-wrap:wrap; gap:8px; align-items:center; margin-bottom:12px;}
  .pb-field{display:flex; gap:6px; align-items:center;}
  .pb-field label{font-size:14px; opacity:.9; white-space:nowrap;}
  .pb-input, .pb-select, .pb-btn{height:36px; padding:0 10px; border:1px solid #2a2a2a; background:#1f1f1f; color:#eee; border-radius:8px;}
  .pb-select{padding-right:24px;}
  .pb-toggle{display:flex; gap:6px; flex-wrap:wrap;}
  .pb-toggle .pb-btn{opacity:.8;}
  .pb-btn[aria-pressed="true"]{border-color:#bb0000; outline:1px solid #bb0000; opacity:1;}
  .pb-primary{background:#bb0000; border-color:#bb0000; color:#fff;}
  .pb-list{display:grid; grid-template-columns:repeat(2, minmax(0,1fr)); gap:10px;}
  .pb-card{background:#1a1a1a; border:1px solid #2a2a2a; border-radius:12px; padding:12px; display:flex; flex-direction:column; gap:8px; min-height:120px;}
  .pb-card h3{margin:0; font-size:16px; word-break:break-word; white-space:normal; cursor:pointer;}
  .pb-meta{font-size:13px; opacity:.85; display:flex; gap:10px; flex-wrap:wrap; word-break:break-word; white-space:normal;}
  .pb-actions{display:flex; gap:8px; margin-top:6px; flex-wrap:wrap;}
  .pb-fab{position:fixed; right:24px; bottom:24px; height:48px; padding:0 16px; border-radius:24px; border:0; background:#bb0000; color:#fff; font-weight:600; box-shadow:0 6px 18px rgba(0,0,0,.35); cursor:pointer;}
  .pb-modal-backdrop{position:fixed; inset:0; background:rgba(0,0,0,.58); display:none; align-items:center; justify-content:center; z-index:9999;}
  .pb-modal{width:min(520px, 92vw); background:#1b1b1b; border:1px solid #2a2a2a; border-radius:14px; padding:16px;}
  .pb-modal h4{margin:0 0 10px 0;}
  .pb-modal .pb-row{display:flex; gap:8px; margin-bottom:8px;}
  .pb-modal .pb-row>*{flex:1;}
  .pb-modal .pb-actions{justify-content:flex-end; margin-top:12px;}
  @media (max-width: 900px){ .pb-list{grid-template-columns:1fr;} }
</style>
</head>
<body>
<div class="pb-wrap">

  <!-- 툴바 -->
  <div class="pb-toolbar" id="pbToolbar">
    <div class="pb-field">
      <label for="pbDate">날짜</label>
      <input id="pbDate" type="date" class="pb-input">
      <select id="pbAmPm" class="pb-select" aria-label="오전/오후">
        <option value="AM">오전</option>
        <option value="PM">오후</option>
      </select>
      <select id="pbTime" class="pb-select" aria-label="시간"><!-- JS로 1~12시 채움 --></select>
    </div>

    <div class="pb-field">
      <label>종류</label>
      <div class="pb-toggle" id="pbType">
        <button type="button" class="pb-btn" data-val="all" aria-pressed="true">전체</button>
        <button type="button" class="pb-btn" data-val="일반">일반</button>
        <button type="button" class="pb-btn" data-val="레이드">레이드</button>
        <button type="button" class="pb-btn" data-val="던전">던전</button>
      </div>
    </div>
  </div>

  <!-- 리스트 -->
  <div class="pb-list" id="pbList">
    <!-- 데모 카드 1 -->
    <article class="pb-card" data-type="레이드" data-hour="20" data-date="" data-capacity="8" data-current="5">
      <h3>[레이드] 불의 사원 8인</h3>
      <div class="pb-meta">
        <span>시작: 20:00</span>
        <span class="pb-cap">모집: <b class="pb-cur">5</b>/<b class="pb-max">8</b></span>
      </div>
      <div class="pb-actions">
        <button type="button" class="pb-btn pb-primary" data-action="apply">지원하기</button>
        <button type="button" class="pb-btn" data-action="applicants">신청자 관리</button>
      </div>
    </article>

    <!-- 데모 카드 2 -->
    <article class="pb-card" data-type="던전" data-hour="14" data-date="" data-capacity="4" data-current="2">
      <h3>[던전] 그림자 회랑 4인</h3>
      <div class="pb-meta">
        <span>시작: 14:30</span>
        <span class="pb-cap">모집: <b class="pb-cur">2</b>/<b class="pb-max">4</b></span>
      </div>
      <div class="pb-actions">
        <button type="button" class="pb-btn pb-primary" data-action="apply">지원하기</button>
        <button type="button" class="pb-btn" data-action="applicants">신청자 관리</button>
      </div>
    </article>
  </div>

  <!-- 플로팅 -->
  <button class="pb-fab" id="pbOpenCreate">+ 모집하기</button>
</div>

<!-- 모달: 지원하기 -->
<div class="pb-modal-backdrop" id="pbApplyModal" aria-hidden="true">
  <section class="pb-modal" role="dialog" aria-modal="true" aria-labelledby="pbApplyTitle">
    <h4 id="pbApplyTitle">파티 지원하기</h4>
    <div class="pb-row">
      <input class="pb-input" id="pbNickname" placeholder="닉네임">
      <input class="pb-input" id="pbRole" placeholder="역할(탱/딜/힐)">
    </div>
    <div class="pb-row">
      <input class="pb-input" id="pbNote" placeholder="한마디(선택)">
    </div>
    <div class="pb-actions">
      <button class="pb-btn" data-close>취소</button>
      <button class="pb-btn pb-primary" id="pbApplySubmit">지원</button>
    </div>
  </section>
</div>

<!-- 모달: 신청자 관리 -->
<div class="pb-modal-backdrop" id="pbApplicantsModal" aria-hidden="true">
  <section class="pb-modal" role="dialog" aria-modal="true" aria-labelledby="pbApplicantsTitle">
    <h4 id="pbApplicantsTitle">신청자 관리</h4>
    <div id="pbApplicantsList" style="min-height:80px; padding:8px; border:1px dashed #2a2a2a; border-radius:8px;">
      <p style="opacity:.8; margin:0;">아직 신청자가 없습니다.</p>
    </div>
    <div class="pb-actions">
      <button class="pb-btn" data-close>닫기</button>
      <button class="pb-btn pb-primary" id="pbApproveAll">전체 수락</button>
    </div>
  </section>
</div>

<!-- 모달: 모집글 작성 -->
<div class="pb-modal-backdrop" id="pbCreateModal" aria-hidden="true">
  <section class="pb-modal" role="dialog" aria-modal="true" aria-labelledby="pbCreateTitle">
    <h4 id="pbCreateTitle">모집글 작성</h4>

    <div class="pb-row">
      <input class="pb-input" id="pbC_Title" placeholder="제목 (예: [레이드] 불의 사원 8인)">
    </div>

    <div class="pb-row">
      <select id="pbC_Type" class="pb-select" aria-label="종류">
        <option value="일반">일반</option>
        <option value="레이드">레이드</option>
        <option value="던전">던전</option>
      </select>
      <input id="pbC_Capacity" class="pb-input" type="number" min="1" step="1" placeholder="정원 (예: 8)">
    </div>

    <div class="pb-row">
      <input id="pbC_Date" type="date" class="pb-input">
      <select id="pbC_AmPm" class="pb-select">
        <option value="AM">오전</option>
        <option value="PM">오후</option>
      </select>
      <select id="pbC_Hour" class="pb-select" aria-label="시간(1~12)"></select>
      <select id="pbC_Min" class="pb-select" aria-label="분">
        <option value="00">00</option>
        <option value="30">30</option>
      </select>
    </div>

    <div class="pb-row">
      <input class="pb-input" id="pbC_Note" placeholder="메모/설명 (선택)">
    </div>

    <div class="pb-actions">
      <button class="pb-btn" data-close>취소</button>
      <button class="pb-btn pb-primary" id="pbCreateSubmit">등록</button>
    </div>
  </section>
</div>

<script>
  // ===== 컨텍스트 경로 =====
  var CTX = '<%= request.getContextPath() %>'; // 예: "/vampir"

  // ===== 유틸 =====
  var $ = function(sel, el){ return (el||document).querySelector(sel); };
  var $$ = function(sel, el){ return Array.prototype.slice.call((el||document).querySelectorAll(sel)); };
  var todayISO = function(){ return new Date().toISOString().slice(0,10); };

  // ===== 날짜/시간 초기화 =====
  var pbDate = $('#pbDate');
  var pbAmPm = $('#pbAmPm');
  var pbTime = $('#pbTime');

  function fillHours(){
    pbTime.innerHTML = '';
    for(var h=1; h<=12; h++){
      var opt = document.createElement('option');
      opt.value = h;
      opt.textContent = h + '시';
      pbTime.appendChild(opt);
    }
  }

  function initDateTime(){
    pbDate.value = todayISO();
    fillHours();
    pbAmPm.value = (new Date().getHours() < 12) ? 'AM' : 'PM';
  }

  // ===== 토글 공통 =====
  function initToggle(groupEl){
    groupEl.addEventListener('click', function(e){
      var btn = e.target.closest('button');
      if(!btn) return;
      if(btn.getAttribute('data-val') === 'all'){
        $$('.pb-btn', groupEl).forEach(function(b){ b.setAttribute('aria-pressed', b === btn ? 'true' : 'false'); });
      }else{
        btn.setAttribute('aria-pressed', btn.getAttribute('aria-pressed') === 'true' ? 'false' : 'true');
        var allBtn = $('.pb-btn[data-val="all"]', groupEl);
        if(allBtn) allBtn.setAttribute('aria-pressed', 'false');
        var anyOn = $$('.pb-btn', groupEl).some(function(b){ return b.getAttribute('data-val') !== 'all' && b.getAttribute('aria-pressed') === 'true'; });
        if(!anyOn && allBtn) allBtn.setAttribute('aria-pressed','true');
      }
      applyFilters();
    });
  }

  function getActiveValues(groupEl){
    var allOn = $('.pb-btn[data-val="all"][aria-pressed="true"]', groupEl);
    if(allOn) return ['all'];
    return $$('.pb-btn[aria-pressed="true"]', groupEl).map(function(b){ return b.getAttribute('data-val'); });
  }

  function to24h(amPm, hour12){
    var h = parseInt(hour12,10) % 12;
    if(amPm === 'PM') h += 12;
    return h;
  }

  function applyFilters(){
    var date = pbDate.value;
    var ampm = pbAmPm.value;
    var hour12 = pbTime.value || '1';
    var types = getActiveValues($('#pbType'));

    $$('#pbList .pb-card').forEach(function(card){
      var cDate = card.dataset.date || date;
      var cHour = parseInt(card.dataset.hour || '0', 10);
      var cType = card.dataset.type || '일반';

      var okDate = (cDate === date);
      var okHour = (ampm === 'AM') ? (cHour < 12) : (cHour >= 12);
      var okType = types.indexOf('all') > -1 || types.indexOf(cType) > -1;

      card.style.display = (okDate && okHour && okType) ? '' : 'none';
    });
  }

  // ===== 모달 제어 =====
  function openModal(id){ var el = $(id); if(el){ el.style.display='flex'; el.setAttribute('aria-hidden','false'); } }
  function closeModal(id){ var el = $(id); if(el){ el.style.display='none'; el.setAttribute('aria-hidden','true'); } }
  $$('#pbApplyModal [data-close], #pbApplicantsModal [data-close], #pbCreateModal [data-close]').forEach(function(btn){
    btn.addEventListener('click', function(){ closeModal('#'+btn.closest('.pb-modal-backdrop').id); });
  });
  ['pbApplyModal','pbApplicantsModal','pbCreateModal'].forEach(function(mid){
    var m = $('#'+mid);
    m.addEventListener('click', function(e){ if(e.target === m) closeModal('#'+mid); });
  });

  // ===== 상태: 현재 선택된 카드 =====
  var activeCard = null;

  // 리스트 내 버튼들 (지원/신청자 관리)
  $('#pbList').addEventListener('click', function(e){
    var btn = e.target.closest('button[data-action]');
    if(!btn) return;
    var card = btn.closest('.pb-card');
    if(!card) return;

    activeCard = card;

    var action = btn.getAttribute('data-action');
    if(action === 'apply') openModal('#pbApplyModal');
    if(action === 'applicants'){ renderApplicants(); openModal('#pbApplicantsModal'); }
  });

  // ===== 제목 클릭 → 상세 이동 (CTX 적용) =====
  document.getElementById('pbList').addEventListener('click', function(e){
    var h3 = e.target.closest('.pb-card h3');
    if(!h3) return;

    var card = h3.closest('.pb-card');
    var title = h3.textContent.trim();

    var spans = Array.prototype.slice.call(card.querySelectorAll('.pb-meta span'));
    var nonCap = spans.filter(function(s){ return !s.classList.contains('pb-cap'); });
    var startText = nonCap[0] ? nonCap[0].textContent.trim().replace(/^시작:\s*/, '') : '';
    var note = nonCap[1] ? nonCap[1].textContent.trim() : '';

    var cur = (card.querySelector('.pb-cur') || {}).textContent || (card.getAttribute('data-current') || '0');
    var max = (card.querySelector('.pb-max') || {}).textContent || (card.getAttribute('data-capacity') || '0');
    var date = card.getAttribute('data-date') || '';
    var type = card.getAttribute('data-type') || '';
    var hour24 = card.getAttribute('data-hour') || '';

    var params = new URLSearchParams({
      title: title,
      start: startText,
      cur: cur,
      max: max,
      note: note,
      date: date,
      type: type,
      h24: hour24
    });

    location.href = CTX + '/partyboard/view.do?' + params.toString();
  });

  // 지원 제출
  $('#pbApplySubmit').addEventListener('click', function(){
    var nick = $('#pbNickname').value.trim();
    var role = $('#pbRole').value.trim();
    var note = $('#pbNote').value.trim();
    if(!nick){ alert('닉네임을 입력하세요.'); return; }
    if(!activeCard){ alert('대상 카드가 없습니다.'); return; }

    if(!activeCard._applies) activeCard._applies = [];
    activeCard._applies.push({nick:nick, role:role, note:note, ts:Date.now()});

    var cur = parseInt(activeCard.getAttribute('data-current') || '0', 10) + 1;
    var max = parseInt(activeCard.getAttribute('data-capacity') || '0', 10);
    activeCard.setAttribute('data-current', String(cur));

    var curEl = activeCard.querySelector('.pb-cur');
    var maxEl = activeCard.querySelector('.pb-max');
    if(curEl) curEl.textContent = String(cur);
    if(maxEl) maxEl.textContent = String(max);

    $('#pbNickname').value = ''; $('#pbRole').value = ''; $('#pbNote').value = '';
    closeModal('#pbApplyModal');
  });

  // 전체 수락(데모)
  $('#pbApproveAll').addEventListener('click', function(){
    if(!activeCard || !activeCard._applies || activeCard._applies.length === 0){
      alert('신청자가 없습니다.'); return;
    }
    alert('모든 신청자를 수락했습니다. (데모)');
  });

  function renderApplicants(){
    var box = $('#pbApplicantsList');
    if(!activeCard || !activeCard._applies || activeCard._applies.length === 0){
      box.innerHTML = '<p style="opacity:.8; margin:0;">아직 신청자가 없습니다.</p>';
      return;
    }
    box.innerHTML = activeCard._applies.map(function(a){
      return '' +
        '<div class="pb-row" style="align-items:center;">' +
          '<div class="pb-input" style="flex:2; display:flex; align-items:center; gap:8px;">' +
            '<strong>' + a.nick + '</strong><span style="opacity:.8;">' + (a.role||'') + '</span>' +
          '</div>' +
          '<div class="pb-input" style="flex:3; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">' + (a.note||'') + '</div>' +
          '<button class="pb-btn pb-primary" style="flex:0 0 auto;">수락</button>' +
        '</div>';
    }).join('');
  }

  // ===== 모집글 작성 =====
  var pbC_Date = document.getElementById('pbC_Date');
  var pbC_AmPm = document.getElementById('pbC_AmPm');
  var pbC_Hour = document.getElementById('pbC_Hour');
  var pbC_Min  = document.getElementById('pbC_Min');
  var pbC_Title = document.getElementById('pbC_Title');
  var pbC_Type  = document.getElementById('pbC_Type');
  var pbC_Capacity = document.getElementById('pbC_Capacity');
  var pbC_Note  = document.getElementById('pbC_Note');
  var pbListEl = document.getElementById('pbList');

  function fillHoursSelect(el){
    el.innerHTML = '';
    for(var h=1; h<=12; h++){
      var opt = document.createElement('option');
      opt.value = h;
      opt.textContent = h + '시';
      el.appendChild(opt);
    }
  }

  function initCreateModal(){
    if(!pbC_Date) return;
    pbC_Date.value = todayISO();
    pbC_AmPm.value = (new Date().getHours() < 12) ? 'AM' : 'PM';
    fillHoursSelect(pbC_Hour);
    pbC_Min.value = '00';
    pbC_Title.value = '';
    pbC_Type.value = '일반';
    pbC_Capacity.value = '';
    pbC_Note.value = '';
  }

  document.getElementById('pbOpenCreate').addEventListener('click', function(){
    initCreateModal();
    openModal('#pbCreateModal');
  });

  document.getElementById('pbCreateSubmit').addEventListener('click', function(){
    var title = (pbC_Title.value||'').trim();
    var type  = pbC_Type.value;
    var date  = pbC_Date.value;
    var ampm  = pbC_AmPm.value;
    var hour12= pbC_Hour.value;
    var minute= pbC_Min.value;
    var cap   = parseInt(pbC_Capacity.value, 10) || 0;
    var note  = (pbC_Note.value||'').trim();

    if(!title){ alert('제목을 입력하세요.'); pbC_Title.focus(); return; }
    if(cap <= 0){ alert('정원을 1 이상으로 입력하세요.'); pbC_Capacity.focus(); return; }
    if(!date){ alert('날짜를 선택하세요.'); pbC_Date.focus(); return; }

    var hour24 = to24h(ampm, hour12);
    var startLabel = String(hour12).padStart(2,'0') + ':' + minute;
    var ampmLabel = (ampm === 'AM') ? '(오전)' : '(오후)';

    var card = document.createElement('article');
    card.className = 'pb-card';
    card.setAttribute('data-type', type);
    card.setAttribute('data-hour', String(hour24));
    card.setAttribute('data-date', date);
    card.setAttribute('data-capacity', String(cap));
    card.setAttribute('data-current', '0');

    var metaNote = note ? '<span style="opacity:.8;">' + note + '</span>' : '';
    card.innerHTML =
      '<h3>' + title + '</h3>' +
      '<div class="pb-meta">' +
        '<span>시작: ' + startLabel + ' ' + ampmLabel + '</span>' +
        '<span class="pb-cap">모집: <b class="pb-cur">0</b>/<b class="pb-max">' + cap + '</b></span>' +
        metaNote +
      '</div>' +
      '<div class="pb-actions">' +
        '<button type="button" class="pb-btn pb-primary" data-action="apply">지원하기</button>' +
        '<button type="button" class="pb-btn" data-action="applicants">신청자 관리</button>' +
      '</div>';

    pbListEl.prepend(card);
    applyFilters();
    closeModal('#pbCreateModal');
  });

  // ===== 초기화 =====
  initDateTime();
  initToggle($('#pbType'));
  applyFilters();
</script>
</body>
</html>
