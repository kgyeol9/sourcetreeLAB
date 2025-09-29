<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  request.setCharacterEncoding("UTF-8");
  String ctx = request.getContextPath(); // 예: /vampir
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 게시판</title>
<style>
  body{background:#111;color:#eee;font-family:system-ui,-apple-system,Segoe UI,Roboto;margin:0}
  .wrap{max-width:960px;margin:32px auto;padding:16px}
  .toolbar{display:flex;gap:8px;align-items:center;margin:0 0 12px 0;flex-wrap:wrap}
  .select, .btn{
    height:36px;padding:0 10px;border-radius:8px;border:1px solid #2a2a2a;background:#202020;color:#fff
  }
  .spacer{flex:1}
  .crumb{opacity:.9}
  .muted{opacity:.8}
</style>
</head>
<body>
<div class="wrap">

  <!-- 상단 선택 툴바 -->
  <div class="toolbar">
    <label class="muted">월드</label>
    <select id="sbWorld" class="select"></select>

    <label class="muted" style="margin-left:10px;">서버</label>
    <select id="sbServer" class="select"></select>

    <span class="spacer"></span>
    <div class="crumb">
      서버 게시판 › <strong id="crumbWorld"></strong> › <strong id="crumbServer"></strong>
    </div>
  </div>

  <h2 style="margin-top:0;"><span id="titleWorld"></span> 월드 / <span id="titleServer"></span> 서버 게시판</h2>
  <p class="muted">
    선택한 범위의 글이 표시됩니다. (월드=전체 ⇒ 모든 월드/서버, 특정 월드+서버=전체 ⇒ 해당 월드의 모든 서버)
  </p>

  <!-- 실제 목록은 여기 렌더링 (기존 로직 그대로) -->
  <div id="boardListArea" style="margin-top:12px;">
    <p>여기에 <strong>${world}</strong> / <strong>${server}</strong> 범위의 게시글 목록을 렌더링하세요.</p>
  </div>

  <p style="margin-top:18px;"><a href="<%=ctx%>/serverboard.do" style="color:#fff;">← 월드/서버 선택 화면으로</a></p>
</div>

<script>
(function(){
  var ctx = '<%=ctx%>';

  // 월드 코드 ↔ 한글명
  var WORLDS = [
    ['all','전체'],
    ['kapf','카프'],['olga','올가'],['shima','쉬마'],['oscar','오스카'],['damir','다미르'],
    ['moarte','모아르테'],['razvi','라즈비'],['foam','포아메'],['dorlingen','돌링엔'],
    ['kizaiya','키자이아'],['nel','넬'],['mila','밀라'],['lilith','릴리스'],['kain','카인'],['ridel','리델']
  ];
  var SERVERS_ALL = ['all','1','2','3']; // 'all'은 "전체" 의미

  // 현재 값 (컨트롤러에서 내려줌)
  var worldNow  = ('${world}'  || '').trim() || 'all';
  var serverNow = ('${server}' || '').trim() || 'all';

  // 엘리먼트
  var wSel = document.getElementById('sbWorld');
  var sSel = document.getElementById('sbServer');
  var crumbWorld = document.getElementById('crumbWorld');
  var crumbServer = document.getElementById('crumbServer');
  var titleWorld = document.getElementById('titleWorld');
  var titleServer = document.getElementById('titleServer');

  // 한글명 찾기
  function worldName(code){
    var f = WORLDS.find(function(w){ return w[0] === code; });
    return f ? f[1] : code;
  }
  function serverName(code){
    if(code === 'all') return '전체';
    return code + '';
  }

  // 월드 채우기
  function fillWorlds(){
    wSel.innerHTML = '';
    WORLDS.forEach(function(pair){
      var o = document.createElement('option');
      o.value = pair[0];
      o.textContent = pair[1];
      if(pair[0] === worldNow) o.selected = true;
      wSel.appendChild(o);
    });
  }

  // 서버 채우기: 월드가 all이면 서버는 '전체'만 의미 있게 쓰도록 해도 되지만,
  // 여기서는 ['전체','1','2','3'] 그대로 두되 '전체'가 기본 선택이 되도록 처리.
  function fillServers(){
    sSel.innerHTML = '';
    SERVERS_ALL.forEach(function(sv){
      var o = document.createElement('option');
      o.value = sv;
      o.textContent = (sv === 'all') ? '전체' : (sv + ' 서버');
      sSel.appendChild(o);
    });
    // 현재 world가 all일 땐 server도 all로 고정하는 게 직관적
    if(wSel.value === 'all'){
      serverNow = 'all';
      sSel.value = 'all';
      sSel.disabled = true;   // 서버 선택 비활성 (월드=전체일 때는 의미 없음)
    }else{
      sSel.disabled = false;
      sSel.value = serverNow || 'all';
    }
  }

  function updateCrumbs(){
    crumbWorld.textContent = (wSel.value === 'all') ? '전체 월드' : worldName(wSel.value) + ' 월드';
    crumbServer.textContent = (sSel.value === 'all') ? '전체 서버' : (sSel.value + ' 서버');

    titleWorld.textContent  = (wSel.value === 'all') ? '전체' : worldName(wSel.value);
    titleServer.textContent = (sSel.value === 'all') ? '전체' : sSel.value;
  }

  function go(){
    var w = wSel.value || 'all';
    var s = sSel.value || 'all';
    // 이동
    location.href = ctx + '/serverboard/' + w + '/' + s;
  }

  // 초기화
  fillWorlds();
  fillServers();
  updateCrumbs();

  // 이벤트
  wSel.addEventListener('change', function(){
    worldNow = wSel.value;
    // 월드 바뀌면 서버 옵션/상태 재구성
    if(worldNow === 'all'){
      serverNow = 'all';
    }
    fillServers();
    updateCrumbs();
    go();
  });
  sSel.addEventListener('change', function(){
    serverNow = sSel.value;
    updateCrumbs();
    go();
  });
})();
</script>
</body>
</html>
