<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currWorld" value="${empty world  ? 'ALL' : world}" />
<c:set var="currServer" value="${empty server ? 'ALL' : server}" />
<fmt:setTimeZone value="Asia/Seoul"/>

<c:choose>
  <c:when test="${currWorld eq 'kapf'}"><c:set var="currWorldKo" value="카프"/></c:when>
  <c:when test="${currWorld eq 'olga'}"><c:set var="currWorldKo" value="올가"/></c:when>
  <c:when test="${currWorld eq 'shima'}"><c:set var="currWorldKo" value="쉬마"/></c:when>
  <c:when test="${currWorld eq 'oscar'}"><c:set var="currWorldKo" value="오스카"/></c:when>
  <c:when test="${currWorld eq 'damir'}"><c:set var="currWorldKo" value="다미르"/></c:when>
  <c:when test="${currWorld eq 'moarte'}"><c:set var="currWorldKo" value="모아르테"/></c:when>
  <c:when test="${currWorld eq 'razvi'}"><c:set var="currWorldKo" value="라즈비"/></c:when>
  <c:when test="${currWorld eq 'foam'}"><c:set var="currWorldKo" value="포아메"/></c:when>
  <c:when test="${currWorld eq 'dorlingen'}"><c:set var="currWorldKo" value="돌링엔"/></c:when>
  <c:when test="${currWorld eq 'kizaiya'}"><c:set var="currWorldKo" value="키자이아"/></c:when>
  <c:when test="${currWorld eq 'nel'}"><c:set var="currWorldKo" value="넬"/></c:when>
  <c:when test="${currWorld eq 'mila'}"><c:set var="currWorldKo" value="밀라"/></c:when>
  <c:when test="${currWorld eq 'lilith'}"><c:set var="currWorldKo" value="릴리스"/></c:when>
  <c:when test="${currWorld eq 'kain'}"><c:set var="currWorldKo" value="카인"/></c:when>
  <c:when test="${currWorld eq 'ridel'}"><c:set var="currWorldKo" value="리델"/></c:when>
  <c:when test="${currWorld eq 'ALL'}"><c:set var="currWorldKo" value="전체"/></c:when>
  <c:otherwise><c:set var="currWorldKo" value="${currWorld}"/></c:otherwise>
</c:choose>
<c:set var="currServerKo" value="${currServer eq 'ALL' ? '전체' : currServer += ' 서버'}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 게시판</title>
<link rel="stylesheet" href="${ctx}/resources/css/serverboard-list.css">
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

    <button id="moveBtn" class="btn primary" type="button">이동</button>
    <span class="spacer"></span>

    <!-- ★ 로그인 시에만 글쓰기 버튼 노출 -->
    <c:if test="${login}">
      <button id="writeBtn" class="btn primary" type="button">글쓰기</button>
    </c:if>
    <c:if test="${not login}">
      <span class="muted">로그인 후 글쓰기 가능</span>
    </c:if>
  </div>

  <!-- 일반 게시판 테이블 -->
  <table class="board">
    <colgroup>
      <col style="width:160px">
      <col>
      <col style="width:160px">
      <col style="width:160px">
      <col style="width:90px">
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
            <c:choose>
              <c:when test="${a.world eq 'kapf'}"><c:set var="rowWorldKo" value="카프"/></c:when>
              <c:when test="${a.world eq 'olga'}"><c:set var="rowWorldKo" value="올가"/></c:when>
              <c:when test="${a.world eq 'shima'}"><c:set var="rowWorldKo" value="쉬마"/></c:when>
              <c:when test="${a.world eq 'oscar'}"><c:set var="rowWorldKo" value="오스카"/></c:when>
              <c:when test="${a.world eq 'damir'}"><c:set var="rowWorldKo" value="다미르"/></c:when>
              <c:when test="${a.world eq 'moarte'}"><c:set var="rowWorldKo" value="모아르테"/></c:when>
              <c:when test="${a.world eq 'razvi'}"><c:set var="rowWorldKo" value="라즈비"/></c:when>
              <c:when test="${a.world eq 'foam'}"><c:set var="rowWorldKo" value="포아메"/></c:when>
              <c:when test="${a.world eq 'dorlingen'}"><c:set var="rowWorldKo" value="돌링엔"/></c:when>
              <c:when test="${a.world eq 'kizaiya'}"><c:set var="rowWorldKo" value="키자이아"/></c:when>
              <c:when test="${a.world eq 'nel'}"><c:set var="rowWorldKo" value="넬"/></c:when>
              <c:when test="${a.world eq 'mila'}"><c:set var="rowWorldKo" value="밀라"/></c:when>
              <c:when test="${a.world eq 'lilith'}"><c:set var="rowWorldKo" value="릴리스"/></c:when>
              <c:when test="${a.world eq 'kain'}"><c:set var="rowWorldKo" value="카인"/></c:when>
              <c:when test="${a.world eq 'ridel'}"><c:set var="rowWorldKo" value="리델"/></c:when>
              <c:otherwise><c:set var="rowWorldKo" value="${a.world}"/></c:otherwise>
            </c:choose>

            <tr>
              <td class="wsv">
                <span class="badge">${rowWorldKo}</span>
                <span class="badge"><c:out value="${a.server}"/> 서버</span>
              </td>
              <td class="title">
                <a href="${ctx}/serverboard/${currWorld}/${currServer}/view.do?id=${a.id}">
                  <c:out value="${a.title}"/>
                </a>
              </td>
              <td class="writer"><c:out value="${a.writer}"/></td>
              <td class="date"><fmt:formatDate value="${a.regDate}" pattern="yyyy-MM-dd HH:mm"/></td>
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

  <div class="pager">
    <a href="#" class="on">1</a><a href="#">2</a><a href="#">3</a><a href="#">›</a>
  </div>

  <p class="backlink"><a href="${ctx}/serverboard.do">← 월드/서버 다시 선택</a></p>
</div>

<script>
  (function(){
    var ctx='${ctx}', worldSel=document.getElementById('world'), serverSel=document.getElementById('server');
    document.getElementById('moveBtn').addEventListener('click',function(){
      location.href = ctx + '/serverboard/' + (worldSel.value||'ALL') + '/' + (serverSel.value||'ALL');
    });
    var writeBtn = document.getElementById('writeBtn');
    if (writeBtn) {
      writeBtn.addEventListener('click',function(){
        location.href = ctx + '/serverboard/write.do?world=' + (worldSel.value||'ALL') + '&server=' + (serverSel.value||'ALL');
      });
    }
    function applyWorldRules(){
      if(worldSel.value==='ALL'){ serverSel.value='ALL'; serverSel.disabled=true; }
      else { serverSel.disabled=false; }
    }
    applyWorldRules(); worldSel.addEventListener('change',applyWorldRules);
  })();
</script>
</body>
</html>
