<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 게시판 선택</title>
<link rel="stylesheet" href="${ctx}/resources/css/serverboard-select.css">
</head>
<body>
<div class="sbsel-wrap">
  <h2 class="sbsel-title"><span class="accent">서버 게시판</span> 선택</h2>

  <div class="sbsel-card">
    <p class="sbsel-muted">월드와 서버를 선택하세요.</p>

    <div class="sbsel-row">
      <label class="sr-only" for="world">월드 선택</label>
      <select id="world" class="sbsel-sel">
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

      <label class="sr-only" for="server">서버 선택</label>
      <select id="server" class="sbsel-sel sbsel-sel--narrow">
        <option value="1">1 서버</option>
        <option value="2">2 서버</option>
        <option value="3">3 서버</option>
      </select>

      <button id="go" class="sbsel-btn sbsel-btn--primary" type="button">이동</button>
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
