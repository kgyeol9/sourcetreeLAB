<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 게시판 선택</title>
<style>
  :root{--bg:#111;--panel:#1a1a1a;--line:#2a2a2a;--muted:#9aa0a6;--ink:#eee;--accent:#bb0000;}
  body{background:var(--bg);color:var(--ink);font-family:system-ui,-apple-system,Segoe UI,Roboto;margin:0}
  .wrap{max-width:720px;margin:48px auto;padding:0 12px}
  h2{margin:0 0 16px}
  .card{background:var(--panel);border:1px solid var(--line);border-radius:12px;padding:16px}
  .row{display:flex;gap:10px;margin-top:12px}
  .sel,.btn{height:42px;border-radius:10px;border:1px solid var(--line);background:#202020;color:#fff;padding:0 12px}
  .sel{flex:1}
  .btn{min-width:120px;cursor:pointer;font-weight:700}
  .btn.primary{background:var(--accent);border-color:var(--accent)}
  .muted{color:var(--muted);font-size:14px}
</style>
</head>
<body>
<div class="wrap">
  <h2>서버 게시판 선택</h2>
  <div class="card">
    <div class="muted">월드와 서버를 선택하세요.</div>

    <div class="row" style="margin-top:10px">
      <select id="world" class="sel">
        <option value="kapf">카프</option>
        <option value="olga">올가</option>
        <option value="shima">쉬마</option>
        <option value="oscar">오스카</option>
        <option value="damir">다미르</option>
        <option value="moarte">모아르테</option>
        <option value="razvi">라즈비</option>
        <option value="foam">포아메</option>
        <option value="dorlingen">돌링엔</option>
        <option value="kizaiya">키자이아</option>
        <option value="nel">넬</option>
        <option value="mila">밀라</option>
        <option value="lilith">릴리스</option>
        <option value="kain">카인</option>
        <option value="ridel">리델</option>
      </select>

      <select id="server" class="sel" style="max-width:180px">
        <option value="1">1 서버</option>
        <option value="2">2 서버</option>
        <option value="3">3 서버</option>
      </select>

      <button id="go" class="btn primary">이동</button>
    </div>
  </div>
</div>

<script>
  (function(){
    var ctx = '${ctx}';
    document.getElementById('go').addEventListener('click', function(){
      var w = document.getElementById('world').value;
      var s = document.getElementById('server').value;
      location.href = ctx + '/serverboard/' + w + '/' + s;
    });
  })();
</script>
</body>
</html>
