<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  request.setCharacterEncoding("UTF-8");
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 게시판</title>
<style>
  :root{--bg:#111;--panel:#1a1a1a;--line:#2a2a2a;--muted:#9aa0a6;--ink:#eee;--accent:#bb0000;}
  body{background:var(--bg);color:var(--ink);font-family:system-ui,-apple-system,Segoe UI,Roboto;margin:0}
  .wrap{max-width:1100px;margin:32px auto;padding:0 12px}

  /* 상단 선택바 */
  .toolbar{display:flex;gap:8px;align-items:center;margin-bottom:14px}
  .sel,.btn,.input{height:38px;border-radius:10px;border:1px solid var(--line);background:#202020;color:#fff;padding:0 12px}
  .sel{min-width:120px}
  .btn{cursor:pointer;font-weight:700}
  .btn.primary{background:var(--accent);border-color:var(--accent)}
  .toolbar .spacer{flex:1}

  /* 표 */
  .board{width:100%;border-collapse:separate;border-spacing:0;border:1px solid var(--line);border-radius:12px;overflow:hidden;background:var(--panel)}
  .board th,.board td{padding:12px 14px;border-bottom:1px solid var(--line)}
  .board th{background:#1f1f1f;text-align:center;font-weight:700}
  .board td{vertical-align:middle}
  .board tr:last-child td{border-bottom:0}
  .num, .hits, .date {text-align:center;white-space:nowrap;color:#ddd}
  .title a{color:#fff;text-decoration:none}
  .title a:hover{color:#ffdddd}
  .empty{padding:48px 0;text-align:center;color:var(--muted)}

  /* 페이지네이션(간단) */
  .pager{display:flex;justify-content:center;gap:6px;margin:14px 0}
  .pager a{display:inline-block;min-width:34px;text-align:center;border:1px solid var(--line);padding:6px 10px;border-radius:8px;background:#202020;color:#fff;text-decoration:none}
  .pager a.on,.pager a:hover{background:var(--accent);border-color:var(--accent)}

  /* 배지 */
  .badge{display:inline-block;padding:3px 8px;border:1px solid #333;border-radius:999px;background:#191919;color:#dcdcdc;font-size:.85rem}
  .muted{color:var(--muted)}
</style>
</head>
<body>
<div class="wrap">

  <!-- 상단 선택 / 액션 -->
  <div class="toolbar">
    <span class="muted">월드</span>
    <select id="world" class="sel">
      <option value="ALL" <c:if test="${world eq 'ALL'}">selected</c:if>>전체</option>
      <option value="kapf"   <c:if test="${world eq 'kapf'}">selected</c:if>>카프</option>
      <option value="olga"   <c:if test="${world eq 'olga'}">selected</c:if>>올가</option>
      <option value="shima"  <c:if test="${world eq 'shima'}">selected</c:if>>쉬마</option>
      <option value="oscar"  <c:if test="${world eq 'oscar'}">selected</c:if>>오스카</option>
      <option value="damir"  <c:if test="${world eq 'damir'}">selected</c:if>>다미르</option>
      <option value="moarte" <c:if test="${world eq 'moarte'}">selected</c:if>>모아르테</option>
      <option value="razvi"  <c:if test="${world eq 'razvi'}">selected</c:if>>라즈비</option>
      <option value="foam"   <c:if test="${world eq 'foam'}">selected</c:if>>포아메</option>
      <option value="dorlingen" <c:if test="${world eq 'dorlingen'}">selected</c:if>>돌링엔</option>
      <option value="kizaiya"   <c:if test="${world eq 'kizaiya'}">selected</c:if>>키자이아</option>
      <option value="nel"    <c:if test="${world eq 'nel'}">selected</c:if>>넬</option>
      <option value="mila"   <c:if test="${world eq 'mila'}">selected</c:if>>밀라</option>
      <option value="lilith" <c:if test="${world eq 'lilith'}">selected</c:if>>릴리스</option>
      <option value="kain"   <c:if test="${world eq 'kain'}">selected</c:if>>카인</option>
      <option value="ridel"  <c:if test="${world eq 'ridel'}">selected</c:if>>리델</option>
    </select>

    <span class="muted">서버</span>
    <select id="server" class="sel">
      <option value="ALL" <c:if test="${server eq 'ALL'}">selected</c:if>>전체</option>
      <option value="1" <c:if test="${server eq '1'}">selected</c:if>>1 서버</option>
      <option value="2" <c:if test="${server eq '2'}">selected</c:if>>2 서버</option>
      <option value="3" <c:if test="${server eq '3'}">selected</c:if>>3 서버</option>
    </select>

    <button id="moveBtn" class="btn primary">이동</button>
    <span class="spacer"></span>

    <button id="writeBtn" class="btn">글쓰기</button>
  </div>

  <!-- 현재 선택 표시 -->
  <div style="margin:8px 0 14px 0">
    <span class="badge">월드: <strong>${world}</strong></span>
    <span class="badge">서버: <strong>${server}</strong></span>
  </div>

  <!-- 일반 게시판 테이블 -->
  <table class="board">
    <colgroup>
      <col style="width:80px"><!-- 번호 -->
      <col><!-- 제목 -->
      <col style="width:140px"><!-- 작성자 -->
      <col style="width:140px"><!-- 날짜 -->
      <col style="width:90px"><!-- 조회 -->
    </colgroup>
    <thead>
      <tr>
        <th>번호</th>
        <th style="text-align:left">제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>조회</th>
      </tr>
    </thead>
    <tbody>
      <!-- 서버에서 articles(목록) 넣어주면 렌더링 -->
      <c:choose>
        <c:when test="${not empty articles}">
          <c:forEach var="a" items="${articles}">
            <tr>
              <td class="num">${a.no}</td>
              <td class="title">
                <a href="${pageContext.request.contextPath}/serverboard/${world}/${server}/view.do?id=${a.no}">
                  ${a.title}
                </a>
                <c:if test="${a.commentCnt gt 0}">
                  <span class="muted">[${a.commentCnt}]</span>
                </c:if>
              </td>
              <td class="num">${a.writer}</td>
              <td class="date">${a.regDate}</td>
              <td class="hits">${a.views}</td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr><td colspan="5" class="empty">표시할 게시글이 없습니다.</td></tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>

  <!-- 페이지네이션 샘플(원하면 서버값으로 교체) -->
  <div class="pager">
    <a href="#" class="on">1</a>
    <a href="#">2</a>
    <a href="#">3</a>
    <a href="#">›</a>
  </div>

  <!-- 선택 화면 이동 링크 -->
  <p style="margin-top:12px">
    <a href="<%=ctx%>/serverboard.do" style="color:#fff">← 월드/서버 다시 선택</a>
  </p>
</div>

<script>
  (function(){
    var ctx = '<%=ctx%>';
    var worldSel = document.getElementById('world');
    var serverSel = document.getElementById('server');
    var moveBtn  = document.getElementById('moveBtn');
    var writeBtn = document.getElementById('writeBtn');

    function applyWorldRules(){
      // 월드=전체면 서버=전체로 고정 & 비활성화
      if(worldSel.value === 'ALL'){
        serverSel.value = 'ALL';
        serverSel.disabled = true;
      }else{
        serverSel.disabled = false;
      }
    }
    applyWorldRules();
    worldSel.addEventListener('change', applyWorldRules);

    moveBtn.addEventListener('click', function(){
      var w = worldSel.value || 'ALL';
      var s = serverSel.value || 'ALL';
      // 목록 라우팅 규칙: /serverboard/{world}/{server}
      location.href = ctx + '/serverboard/' + w + '/' + s;
    });

    writeBtn.addEventListener('click', function(){
      var w = worldSel.value || 'ALL';
      var s = serverSel.value || 'ALL';
      // 글쓰기 경로는 프로젝트에 맞춰 바꿔줘.
      // 예시: /serverboard/write.do?world=...&server=...
      location.href = ctx + '/serverboard/write.do?world=' + w + '&server=' + s;
    });
  })();
</script>
</body>
</html>
