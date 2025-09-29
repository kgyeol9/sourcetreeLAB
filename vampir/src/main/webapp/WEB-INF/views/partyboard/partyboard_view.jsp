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
  .meta{opacity:.9}
  .meta b{color:#fff}
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
  .h2{margin:0 0 6px 0;line-height:1.3;word-break:break-word}
  .hr{height:1px;background:var(--line);border:0;margin:12px 0}
  .note{white-space:pre-wrap;line-height:1.6}
</style>
</head>
<body>
<div class="wrap">

  <!-- 제목 + 남은시간 -->
  <div class="card">
    <div class="row" style="justify-content:space-between">
      <h2 class="h2" id="pbTitle">${fn:escapeXml(param.title)}</h2>
      <span id="pbCountdown" class="badge">계산중…</span>
    </div>

    <!-- 주요 메타 -->
    <div class="meta" style="margin-top:6px">
      <div class="row">
        <!-- 분류: 값이 있을 때만 노출 -->
        <span class="muted" id="lblType" style="display:none;">분류</span>
        <b id="pbType" style="display:none;"></b>

        <span class="muted">· 시작</span>
        <b id="pbStart">
          ${fn:escapeXml(param.start)}
          <c:choose>
            <c:when test="${not empty param.ampm}">
              <c:choose>
                <c:when test="${param.ampm eq 'AM'}">(오전)</c:when>
                <c:otherwise>(오후)</c:otherwise>
              </c:choose>
            </c:when>
            <c:otherwise>
              <c:choose>
                <c:when test="${not empty param.h24 and param.h24 lt 12}">(오전)</c:when>
                <c:otherwise>(오후)</c:otherwise>
              </c:choose>
            </c:otherwise>
          </c:choose>
        </b>

        <span class="muted">· 인원</span>
        <b><span id="pbCur">${fn:escapeXml(param.cur)}</span>/<span id="pbMax">${fn:escapeXml(param.max)}</span></b>
      </div>
      <div class="row" style="margin-top:4px">
        <span class="muted">날짜</span>
        <b id="pbDate">${fn:escapeXml(param.date)}</b>
      </div>
    </div>

    <div class="hr"></div>

    <!-- 내용/메모 -->
    <div class="note" id="pbNote">${fn:escapeXml(param.note)}</div>

    <!-- 하단 액션 -->
    <div class="actions">
      <div class="leftActions">
        <a class="btn ghost" id="btnBack" href="${pageContext.request.contextPath}/partyboard.do">← 목록</a>
      </div>
      <div class="rightActions">
        <button class="btn primary" id="btnApply">지원하기</button>
        <button class="btn" id="btnApplicants">신청자 확인</button>
      </div>
    </div>
  </div>
</div>

<script>
  (function(){
    var qs = new URLSearchParams(location.search);
    var title = (document.getElementById('pbTitle').textContent || '').trim();

    // ---- 분류 보이기(있을 때만) ----
    var typeFromParam = qs.get('type');
    var type = (typeFromParam && typeFromParam.trim()) ? typeFromParam.trim() : null;
    if(!type){
      // 제목의 [대괄호]에서 시도
      var m = title.match(/\[([^\[\]]+)\]/);
      if(m) type = m[1];
    }
    if(type){
      var lbl = document.getElementById('lblType');
      var el  = document.getElementById('pbType');
      el.textContent = type;
      lbl.style.display = '';
      el.style.display  = '';
    }
    // type이 없으면 아무 것도 표시하지 않음(“분류없음” 자체 미노출)

    // ---- 카운트다운 ----
    var dateStr  = document.getElementById('pbDate').textContent.trim();
    var startStr = (document.getElementById('pbStart').textContent || '').trim();
    var h24Param = qs.get('h24');

    var hour = 0, minute = 0;
    if(h24Param && /^\d+$/.test(h24Param)){
      hour = parseInt(h24Param, 10);
      var sm = startStr.match(/(\d{1,2}):(\d{2})/);
      minute = sm ? parseInt(sm[2],10) : 0;
    }else{
      var m2 = startStr.match(/(\d{1,2}):(\d{2})/);
      if(m2){ hour = parseInt(m2[1],10); minute = parseInt(m2[2],10); }
      if(/\(오후\)/.test(startStr) && hour < 12) hour += 12;
      if(/\(오전\)/.test(startStr) && hour === 12) hour = 0;
    }

    if(!/^\d{4}-\d{2}-\d{2}$/.test(dateStr)){
      var d = new Date(); dateStr = d.toISOString().slice(0,10);
      document.getElementById('pbDate').textContent = dateStr;
    }

    var target = new Date(dateStr + 'T00:00:00'); target.setHours(hour, minute, 0, 0);

    var badge = document.getElementById('pbCountdown');
    function fmt(ms){
      if(ms <= 0) return {dead:true, text:'마감'};
      var s = Math.floor(ms/1000);
      var h = Math.floor(s/3600); s%=3600;
      var m = Math.floor(s/60);
      return {dead:false, text:(h>0? (h+'시간 '):'') + (m+'분 남음')};
    }
    function tick(){
      var out = fmt(target.getTime() - Date.now());
      badge.textContent = out.text;
      badge.className = 'badge ' + (out.dead ? 'dead' : 'live');
    }
    tick();
    setInterval(tick, 30*1000);

    // ---- 버튼 자리(연동 포인트) ----
    document.getElementById('btnApply').addEventListener('click', function(){
      alert('지원하기 모달 오픈 지점');
    });
    document.getElementById('btnApplicants').addEventListener('click', function(){
      alert('신청자 확인 모달 오픈 지점');
    });
  })();
</script>
</body>
</html>
