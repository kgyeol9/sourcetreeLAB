<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
  request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>파티 상세</title>
<style>
  :root{ --bg:#111; --panel:#1a1a1a; --line:#2a2a2a; --muted:#9aa0a6; --txt:#eee; --accent:#bb0000; }
  html,body{background:var(--bg);color:var(--txt);margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto}
  .wrap{max-width:920px;margin:24px auto;padding:0 12px}
  .card{background:var(--panel);border:1px solid var(--line);border-radius:12px;padding:16px}
  .meta{opacity:.9}.meta b{color:#fff}
  .row{display:flex;gap:10px;flex-wrap:wrap;align-items:center}
  .badge{display:inline-block;font-size:12px;font-weight:700;padding:4px 8px;border-radius:8px;border:1px solid transparent;white-space:nowrap}
  .live{color:#eaffea;background:#2a402a;border-color:#365a36}
  .dead{color:#eee;background:#333;border-color:#444}
  .muted{color:var(--muted)}
  .actions{display:flex;justify-content:space-between;align-items:center;margin-top:14px;gap:8px;flex-wrap:wrap}
  .leftActions{display:flex;gap:8px;align-items:center}
  .rightActions{display:flex;gap:8px;align-items:center;margin-left:auto}
  .btn{display:inline-block;padding:8px 12px;border-radius:8px;border:1px solid #444;background:#222;color:#fff;text-decoration:none;cursor:pointer}
  .btn.primary{background:var(--accent);border-color:var(--accent)}
  .btn.ghost{background:#1f1f1f}
  .hr{height:1px;background:var(--line);border:0;margin:12px 0}
  .note{white-space:pre-wrap;line-height:1.6}

  /* 모달 공통 */
  .modal-backdrop{position:fixed; inset:0; background:rgba(0,0,0,.58); display:none; align-items:center; justify-content:center; z-index:9999;}
  .modal-backdrop.show{display:flex;}
  .pb-modal{width:min(560px,96vw); background:#1b1b1b; border:1px solid #2a2a2a; border-radius:14px; padding:16px; box-shadow:0 20px 40px rgba(0,0,0,.5);}
  .pb-modal h3{margin:0 0 10px 0;}
  .list{margin:6px 0 0 0; padding:0; list-style:none}
  .list li{display:flex; justify-content:space-between; align-items:center; gap:8px; padding:8px 0; border-bottom:1px solid #2a2a2a;}
  .list li:last-child{border-bottom:0;}
  .chip{display:inline-block; padding:2px 8px; border:1px solid #444; border-radius:999px; font-size:12px;}
</style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="postId" value="${param.postId}" />
<div class="wrap">

  <div class="card">
    <div class="row" style="justify-content:space-between">
      <h2 class="h2" id="pbTitle">${fn:escapeXml(param.title)}</h2>
      <span id="pbCountdown" class="badge">계산중…</span>
    </div>

    <div class="meta" style="margin-top:6px">
      <div class="row">
        <span class="muted">시작</span>
        <b id="pbStart">${fn:escapeXml(param.start)}</b>
        <span class="muted">· 인원</span>
        <b><span id="pbCur">${fn:escapeXml(param.cur)}</span>/<span id="pbMax">${fn:escapeXml(param.max)}</span></b>
      </div>
      <div class="row" style="margin-top:4px">
        <span class="muted">날짜</span>
        <b id="pbDate">${fn:escapeXml(param.date)}</b>
      </div>
    </div>

    <div class="hr"></div>
    <div class="note" id="pbNote">${fn:escapeXml(param.note)}</div>

    <div class="actions">
      <div class="leftActions">
        <a class="btn ghost" id="btnBack" href="${ctx}/partyboard.do">← 목록</a>
      </div>
      <div class="rightActions">
        <button class="btn primary" id="btnApply">지원하기</button>
        <button class="btn" id="btnApplicants">신청자 확인</button>
      </div>
    </div>
  </div>
</div>

<!-- 신청자 모달 -->
<div id="applicantsModal" class="modal-backdrop" aria-hidden="true">
  <section class="pb-modal" role="dialog" aria-modal="true" aria-labelledby="aTitleLabel">
    <h3 id="aTitleLabel">신청자 목록</h3>
    <ul class="list" id="applicantList"></ul>
    <div style="text-align:right; margin-top:10px;">
      <button class="btn" id="aClose">닫기</button>
    </div>
  </section>
</div>

<script>
  var CTX='${ctx}', POST_ID='${postId}';
  function $(s,el){return (el||document).querySelector(s);}

  // 카운트다운
  (function(){
    var startStr=($('#pbStart').textContent||'').trim(), dateStr=($('#pbDate').textContent||'').trim();
    var h24=(function(){
      var m=startStr.match(/(\d{1,2}):(\d{2})/); if(!m) return 0;
      return parseInt(m[1],10);
    })(), min=(function(){var m=startStr.match(/(\d{1,2}):(\d{2})/); return m?parseInt(m[2],10):0; })();
    if(!/^\d{4}-\d{2}-\d{2}$/.test(dateStr)){ var d=new Date(); dateStr=d.toISOString().slice(0,10); $('#pbDate').textContent=dateStr; }
    var target=new Date(dateStr+'T00:00:00'); target.setHours(h24,min,0,0);
    function fmt(ms){ if(ms<=0) return {dead:true,text:'마감'}; var s=Math.floor(ms/1000), h=Math.floor(s/3600); s%=3600; var m=Math.floor(s/60); return {dead:false,text:(h>0?(h+'시간 '):'')+(m+'분 남음')}; }
    function tick(){ var out=fmt(target.getTime()-Date.now()); var b=$('#pbCountdown'); b.textContent=out.text; b.className='badge '+(out.dead?'dead':'live'); }
    tick(); setInterval(tick, 30000);
  })();

  // 모달 열고 닫기
  function openModal(id){ var m=$(id); m.classList.add('show'); m.setAttribute('aria-hidden','false'); }
  function closeModal(id){ var m=$(id); m.classList.remove('show'); m.setAttribute('aria-hidden','true'); }

  // 지원하기 호출
  $('#btnApply').addEventListener('click', function(){
    var xhr=new XMLHttpRequest();
    xhr.open('POST', CTX+'/partyboard/'+encodeURIComponent(POST_ID)+'/apply.do');
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded; charset=UTF-8');
    xhr.onload=function(){
      try{
        var res=JSON.parse(xhr.responseText||'{}');
        if(res.ok){ alert('지원 완료!'); }
        else{
          if(res.error==='LOGIN_REQUIRED'){ alert('로그인이 필요합니다.'); }
          else{ alert('실패: '+(res.error||'UNKNOWN')); }
        }
      }catch(e){ alert('알 수 없는 응답'); }
    };
    xhr.onerror=function(){ alert('네트워크 오류'); };
    xhr.send('x=1'); // dummy body
  });

  // 신청자 목록 열기
  $('#btnApplicants').addEventListener('click', function(){
    var xhr=new XMLHttpRequest();
    xhr.open('GET', CTX+'/partyboard/'+encodeURIComponent(POST_ID)+'/applicants.json');
    xhr.onload=function(){
      var listEl=$('#applicantList'); listEl.innerHTML='';
      try{
        var res=JSON.parse(xhr.responseText||'{}');
        if(res.ok && res.items){
          res.items.forEach(function(it){
            var li=document.createElement('li');
            li.innerHTML='<span><b>'+ (it.nick||it.userId) +'</b> <span class="chip">'+(it.status||'APPLIED')+'</span></span>' +
                         '<span style="display:flex; gap:8px;">' +
                         '<button class="btn" data-act="accept" data-uid="'+it.userId+'">수락</button>' +
                         '<button class="btn" data-act="reject" data-uid="'+it.userId+'">거절</button>' +
                         '</span>';
            listEl.appendChild(li);
          });
          openModal('#applicantsModal');
        }else{
          alert('목록을 불러오지 못했습니다.');
        }
      }catch(e){ alert('응답 파싱 실패'); }
    };
    xhr.onerror=function(){ alert('네트워크 오류'); };
    xhr.send();
  });

  // 모달 내부 버튼(수락/거절)
  $('#applicantList').addEventListener('click', function(e){
    var btn=e.target.closest('button'); if(!btn) return;
    var act=btn.getAttribute('data-act'), uid=btn.getAttribute('data-uid');
    if(!act||!uid) return;
    var xhr=new XMLHttpRequest();
    xhr.open('POST', CTX+'/partyboard/'+encodeURIComponent(POST_ID)+'/'+act+'.do');
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded; charset=UTF-8');
    xhr.onload=function(){
      try{
        var res=JSON.parse(xhr.responseText||'{}');
        if(res.ok){
          alert((act==='accept'?'수락':'거절')+' 완료');
          // 새로고침 없이 다시 목록 갱신
          $('#btnApplicants').click();
        }else{
          if(res.error==='LOGIN_REQUIRED'){ alert('로그인이 필요합니다.'); }
          else{ alert('실패: '+(res.error||'UNKNOWN')); }
        }
      }catch(e){ alert('응답 파싱 실패'); }
    };
    xhr.onerror=function(){ alert('네트워크 오류'); };
    xhr.send('userId='+encodeURIComponent(uid));
  });

  // 닫기 액션
  $('#aClose').addEventListener('click', function(){ closeModal('#applicantsModal'); });
  $('#applicantsModal').addEventListener('click', function(e){ if(e.target===this) closeModal('#applicantsModal'); });
</script>
</body>
</html>
