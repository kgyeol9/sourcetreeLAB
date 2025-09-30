<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currWorld" value="${empty world  ? 'ALL' : world}" />
<c:set var="currServer" value="${empty server ? 'ALL' : server}" />
<fmt:setTimeZone value="Asia/Seoul"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 게시판</title>
<style>
  :root{--bg:#111;--panel:#1a1a1a;--line:#2a2a2a;--muted:#9aa0a6;--ink:#eee;--accent:#bb0000;}
  body{background:var(--bg);color:var(--ink);font-family:system-ui,-apple-system,Segoe UI,Roboto;margin:0}
  .wrap{max-width:1100px;margin:32px auto;padding:0 12px}

  .toolbar{display:flex;gap:8px;align-items:center;margin-bottom:14px}
  .sel,.btn,.input{height:38px;border-radius:10px;border:1px solid var(--line);background:#202020;color:#fff;padding:0 12px}
  .sel{min-width:120px}
  .btn{cursor:pointer;font-weight:700}
  .btn.primary{background:var(--accent);border-color:var(--accent)}
  .toolbar .spacer{flex:1}
  .muted{color:var(--muted)}

  .board{width:100%;border-collapse:separate;border-spacing:0;border:1px solid var(--line);border-radius:12px;overflow:hidden;background:var(--panel)}
  .board th,.board td{padding:12px 14px;border-bottom:1px solid var(--line)}
  .board th{background:#1f1f1f;text-align:center;font-weight:700}
  .board td{vertical-align:middle}
  .board tr:last-child td{border-bottom:0}
  .wsv, .writer, .date, .hits {text-align:center;white-space:nowrap;color:#ddd}
  .title a{color:#fff;text-decoration:none}
  .title a:hover{color:#ffdddd}
  .empty{padding:48px 0;text-align:center;color:var(--muted)}

  .pager{display:flex;justify-content:center;gap:6px;margin:14px 0}
  .pager a{display:inline-block;min-width:34px;text-align:center;border:1px solid var(--line);padding:6px 10px;border-radius:8px;background:#202020;color:#fff;text-decoration:none}
  .pager a.on,.pager a:hover{background:var(--accent);border-color:var(--accent)}

  .badge{display:inline-block;padding:3px 8px;border:1px solid #333;border-radius:999px;background:#191919;color:#dcdcdc;font-size:.85rem}
</style>
</head>
<body>
<div class="wrap">

  <!-- 상단 선택 / 액션 -->
  <div class="toolbar">
    <span class="muted">월드</span>
    <select id="world" class="sel">
      <option value="ALL"   ${currWorld eq 'ALL'   ? 'selected' : ''}>전체</option>
      <option value="kapf"  ${currWorld eq 'kapf'  ? 'selected' : ''}>카프</option>
      <option value="olga"  ${currWorld eq 'olga'  ? 'selected' : ''}>올가</option>
      <option value="shima" ${currWorld eq 'shima' ? 'selected' : ''}>쉬마</option>
      <option value="oscar" ${currWorld eq 'oscar' ? 'selected' : ''}>오스카</option>
      <option value="damir" ${currWorld eq 'damir' ? 'selected' : ''}>다미르</option>
      <option value="moarte" ${currWorld eq 'moarte' ? 'selected' : ''}>모아르테</option>
      <option value="razvi" ${currWorld eq 'razvi' ? 'selected' : ''}>라즈비</option>
      <option value="foam"  ${currWorld eq 'foam'  ? 'selected' : ''}>포아메</option>
      <option value="dorlingen" ${currWorld eq 'dorlingen' ? 'selected' : ''}>돌링엔</option>
      <option value="kizaiya"   ${currWorld eq 'kizaiya' ? 'selected' : ''}>키자이아</option>
      <option value="nel"   ${currWorld eq 'nel'   ? 'selected' : ''}>넬</option>
      <option value="mila"  ${currWorld eq 'mila'  ? 'selected' : ''}>밀라</option>
      <option value="lilith"${currWorld eq 'lilith'? 'selected' : ''}>릴리스</option>
      <option value="kain"  ${currWorld eq 'kain'  ? 'selected' : ''}>카인</option>
      <option value="ridel" ${currWorld eq 'ridel' ? 'selected' : ''}>리델</option>
    </select>

    <span class="muted">서버</span>
    <select id="server" class="sel">
      <option value="ALL" ${currServer eq 'ALL' ? 'selected' : ''}>전체</option>
      <option value="1" ${currServer eq '1' ? 'selected' : ''}>1 서버</option>
      <option value="2" ${currServer eq '2' ? 'selected' : ''}>2 서버</option>
      <option value="3" ${currServer eq '3' ? 'selected' : ''}>3 서버</option>
    </select>

    <button id="moveBtn" class="btn primary">이동</button>
    <span class="spacer"></span>
    <button id="writeBtn" class="btn">글쓰기</button>
  </div>

  <!-- 현재 선택 표시 -->
  <div style="margin:8px 0 14px 0">
    <span class="badge">월드: <strong>${currWorld}</strong></span>
    <span class="badge">서버: <strong>${currServer}</strong></span>
  </div>

  <!-- 일반 게시판 테이블 -->
  <table class="board">
    <colgroup>
      <col style="width:140px"><!-- 월드/서버 -->
      <col><!-- 제목 -->
      <col style="width:140px"><!-- 작성자 -->
      <col style="width:160px"><!-- 날짜 -->
      <col style="width:90px"><!-- 조회 -->
    </colgroup>
    <thead>
      <tr>
        <th>월드/서버</th>
        <th style="text-align:left">제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>조회</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${not empty articles}">
          <c:forEach var="a" items="${articles}">
            <tr>
              <td class="wsv">
                <span class="badge">${a.world}</span>
                <span class="badge">${a.server}서버</span>
              </td>
              <td class="title">
                <a href="${ctx}/serverboard/${currWorld}/${currServer}/view.do?id=${a.id}">
                  <c:out value="${a.title}"/>
                </a>
              </td>
              <td class="writer"><c:out value="${a.writer}"/></td>
              <td class="date">
                <fmt:formatDate value="${a.regDate}" pattern="yyyy-MM-dd HH:mm"/>
              </td>
              <td class="hits"><c:out value="${a.views}"/></td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr><td colspan="5" class="empty">표시할 게시글이 없습니다.</td></tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>

  <!-- (예시) 페이지네이션 -->
  <div class="pager">
    <a href="#" class="on">1</a>
    <a href="#">2</a>
    <a href="#">3</a>
    <a href="#">›</a>
  </div>

  <p style="margin-top:12px">
    <a href="${ctx}/serverboard.do" style="color:#fff">← 월드/서버 다시 선택</a>
  </p>
</div>

<script>
  (function(){
    var ctx = '${ctx}';
    var worldSel = document.getElementById('world');
    var serverSel = document.getElementById('server');
    var moveBtn  = document.getElementById('moveBtn');
    var writeBtn = document.getElementById('writeBtn');

    function applyWorldRules(){
      if(worldSel.value === 'ALL'){
        serverSel.value = 'ALL';
        serverSel.disabled = true;
      } else {
        serverSel.disabled = false;
      }
    }
    applyWorldRules();
    worldSel.addEventListener('change', applyWorldRules);

    moveBtn.addEventListener('click', function(){
      var w = worldSel.value || 'ALL';
      var s = serverSel.value || 'ALL';
      location.href = ctx + '/serverboard/' + w + '/' + s;
    });

    writeBtn.addEventListener('click', function(){
      var w = worldSel.value || 'ALL';
      var s = serverSel.value || 'ALL';
      location.href = ctx + '/serverboard/write.do?world=' + w + '&server=' + s;
    });
  })();
</script>
</body>
</html>
