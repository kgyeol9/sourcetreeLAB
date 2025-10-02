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
  .field{display:flex; flex-direction:column; gap:6px; margin:8px 0;}
  .input, .file{height:36px; border:1px solid var(--line); background:#111; color:#fff; border-radius:8px; padding:0 10px;}
  .textarea{min-height:110px; border:1px solid var(--line); background:#111; color:#fff; border-radius:8px; padding:8px 10px; resize:vertical;}
  .label{font-size:12px; color:var(--muted);}
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

<!-- 지원하기 모달 -->
<div id="applyModal" class="modal-backdrop" aria-hidden="true">
  <section class="pb-modal" role="dialog" aria-modal="true" aria-labelledby="applyLabel">
    <h3 id="applyLabel">지원하기</h3>

    <div class="field">
      <label class="label" for="apTitle">제목 (선택)</label>
      <input id="apTitle" class="input" placeholder="예: 불의 사원 레이드 지원"/>
    </div>

    <div class="field">
      <label class="label" for="apIgNick">인게임 닉네임 (필수)</label>
      <input id="apIgNick" class="input" placeholder="캐릭터명"/>
    </div>

    <div class="field">
      <label class="label" for="apMemo">간단 내용 (선택)</label>
      <textarea id="apMemo" class="textarea" placeholder="역할/스펙/가능시간 등"></textarea>
    </div>

    <div class="field">
      <label class="label" for="apImage">이미지 (선택, 최대 5MB)</label>
      <input id="apImage" class="file" type="file" accept="image/*"/>
    </div>

    <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:12px;">
      <button class="btn" id="applyCancel">취소</button>
      <button class="btn primary" id="applySubmit">지원</button>
    </div>
  </section>
</div>

<script>
  var CTX='${ctx}', POST_ID='${postId}';
  function $(s,el){return (el||document).querySelector(s);}

  // 카운트다운
  (function(){
    var startStr=($('#pbStart').textContent||'').trim(), dateStr=($('#pbDate').textContent||'').trim();
    var m=startStr.match(/(\d{1,2}):(\d{2})/);
    var h24=m?parseInt(m[1],10):0, min=m?parseInt(m[2],10):0;
    if(!/^\d{4}-\d{2}-\d{2}$/.test(dateStr)){ var d=new Date(); dateStr=d.toISOString().slice(0,10); $('#pbDate').textContent=dateStr; }
    var target=new Date(dateStr+'T00:00:00'); target.setHours(h24,min,0,0);
    function fmt(ms){ if(ms<=0) return {dead:true,text:'마감'}; var s=Math.floor(ms/1000), h=Math.floor(s/3600); s%=3600; var m=Math.floor(s/60); return {dead:false,text:(h>0?(h+'시간 '):'')+(m+'분 남음')}; }
    function tick(){ var out=fmt(target.getTime()-Date.now()); var b=$('#pbCountdown'); b.textContent=out.text; b.className='badge '+(out.dead?'dead':'live'); }
    tick(); setInterval(tick, 30000);
  })();

  // 모달 열고 닫기
  function openModal(id){ var m=$(id); m.classList.add('show'); m.setAttribute('aria-hidden','false'); }
  function closeModal(id){ var m=$(id); m.classList.remove('show'); m.setAttribute('aria-hidden','true'); }

  // === 지원하기 모달 ===
  $('#btnApply').addEventListener('click', function(){
    // 기본값 채워주고 오픈
    openModal('#applyModal');
  });
  $('#applyCancel').addEventListener('click', function(){ closeModal('#applyModal'); });
  $('#applyModal').addEventListener('click', function(e){ if(e.target===this) closeModal('#applyModal'); });

  // ★ 지원 제출: FormData로 멀티파트 전송 (Content-Type 수동 세팅 금지!)
  $('#applySubmit').addEventListener('click', function(){
    var title = ($('#apTitle')?.value||'').trim();
    var ig    = ($('#apIgNick')?.value||'').trim();
    var memo  = ($('#apMemo')?.value||'').trim();
    if(!ig){ alert('인게임 닉네임은 필수입니다.'); return; }

    var fd = new FormData();
    fd.append('applyTitle', title);
    fd.append('igNick', ig);
    fd.append('memo', memo);
    var file = $('#apImage') && $('#apImage').files ? $('#apImage').files[0] : null;
    if (file) fd.append('image', file);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', CTX+'/partyboard/'+encodeURIComponent(POST_ID)+'/apply.do');
    xhr.onload = function(){
      var text = xhr.responseText || '';
      try{
        var res = JSON.parse(text);
        if(res.ok){ alert('지원 완료!'); closeModal('#applyModal'); }
        else{
          if(res.error==='LOGIN_REQUIRED') alert('로그인이 필요합니다.');
          else if(res.error==='ALREADY_APPLIED') alert('이미 지원했습니다.');
          else if(res.error==='FILE_TOO_LARGE') alert('이미지는 5MB 이하만 업로드 가능합니다.');
          else alert('실패: '+(res.message||res.error||'UNKNOWN'));
        }
      }catch(e){
        alert('응답 파싱 실패\n\n'+text.slice(0,200));
      }
    };
    xhr.onerror = function(){ alert('네트워크 오류'); };
    xhr.send(fd);
  });

  // === 신청자 목록 열기 ===
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
            var title = it.applyTitle||'(제목 없음)';
            var name  = it.nick || it.userId;
            var status= it.status || 'APPLIED';
            li.innerHTML=
              '<div style="min-width:0;">' +
                '<div><a href="#" class="ap-title" data-uid="'+(it.userId||'')+'" data-title="'+(title||'')+'" '+
                'data-ign="'+(it.igNick||'')+'" data-memo="'+(it.memo||'')+'" data-img="'+(it.imagePath||'')+'"><b>'+title+
                '</b></a></div>' +
                '<div class="muted" style="font-size:12px; margin-top:2px;">사이트 닉네임: <b>'+name+
                '</b> <span class="chip">'+status+'</span></div>' +
              '</div>' +
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

  // === 신청자 모달 내부: 수락/거절 + 제목 클릭 상세보기 ===
  $('#applicantList').addEventListener('click', function(e){
    var a = e.target.closest('a.ap-title');
    if(a){
      e.preventDefault();
      var t=a.getAttribute('data-title')||'(제목 없음)';
      var ign=a.getAttribute('data-ign')||'-';
      var memo=a.getAttribute('data-memo')||'-';
      var img=a.getAttribute('data-img');
      var html='제목: '+t+'\n인게임 닉네임: '+ign+'\n\n내용:\n'+memo;
      if(img){ html += '\n\n이미지: '+img; }
      alert(html);
      return;
    }
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
