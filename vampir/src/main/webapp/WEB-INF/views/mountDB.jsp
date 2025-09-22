<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageActive" value="mount"/> <%-- 활성 탭 --%>
<%@ page session="false"%>
<%
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>탈 것 DB</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
:root { --subrow-base:84px; --boost:40px; --gap:12px; --row-h:44px; }

body{ margin:0; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background:#121212; color:#eee; }
a{ text-decoration:none; color:inherit; }
.db-main{ max-width:1200px; margin:16px auto 24px; padding:0 16px; }
.card{ background:#1f1f1f; border:1px solid #333; border-radius:10px; }

.btn-primary{ background:#bb0000; color:#fff; border:none; border-radius:8px; font-weight:700; cursor:pointer; padding:10px 12px; }
.btn-primary:hover{ background:#ff4444; }

.vt-btn{ background:#222; border:1px solid #333; color:#eee; padding:6px 10px; border-radius:6px; cursor:pointer; }
.vt-btn.active{ background:#bb0000; border-color:#bb0000; color:#fff; }
.db-switch{ display:flex; justify-content:flex-start; gap:8px; padding-bottom:12px; border-bottom:2px solid #bb0000; margin:0 0 12px; }
.db-switch .vt-btn{ line-height:1; transition:background .15s, border-color .15s, box-shadow .12s, transform .06s; }
.db-switch .vt-btn.active{ box-shadow: inset 0 2px 0 rgba(255,255,255,.08), inset 0 -2px 0 rgba(0,0,0,.25); transform: translateY(1px); }

/* 필터: 직업 없음 → 등급/검색만 */
.filters{ padding:16px; }
.filters-grid{ display:grid; grid-template-columns:1fr; gap:16px; }
.fbox{ background:#181818; border:1px solid #333; border-radius:10px; padding:0; overflow:hidden; display:grid; grid-template-rows:1fr auto; gap:0; }
.subrow{ min-height:var(--subrow-base); display:grid; grid-template-columns:72px 1fr; align-items:center; gap:12px; padding:14px 16px; box-sizing:border-box; }
.subrow + .subrow{ border-top:1px solid #333; }
.label{ color:#bbb; font-size:13px; }
.checks{ display:flex; flex-wrap:wrap; gap:10px 16px; align-items:center; align-content:center; min-height:100%; }
.toggle-btn{ padding:8px 14px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:2px solid #555; background:#181818; color:#bbb; transition:.15s all; }
.toggle-btn.active{ border-color:#bb0000; color:#ff4444; }
.toggle-btn:not(.active):hover{ border-color:#777; color:#eee; }
.searchline{ display:grid; grid-template-columns:1fr 120px; gap:10px; align-items:center; }
.searchline input[type="text"]{ padding:12px; border-radius:8px; border:1px solid #333; background:#181818; color:#eee; }

/* 결과/정렬 */
.result-bar{ display:flex; flex-wrap:wrap; align-items:center; justify-content:space-between; gap:10px; margin:14px 0 8px; }
.result-info{ color:#bbb; font-size:13px; }
.sort-group{ display:flex; gap:8px; align-items:center; }
.sort-group select, .page-size select{ background:#181818; color:#eee; border:1px solid #333; border-radius:8px; padding:6px 10px; }
.view-toggle{ display:flex; gap:6px; }

/* 리스트뷰: 이름 / 보유 / 연결 / 초월 */
.list{ overflow:hidden; }
.thead, .r{ display:grid; grid-template-columns:1.1fr 1fr 1fr 1fr; }
.thead{ background:#181818; color:#ddd; font-weight:700; user-select:none; }
.thead .c, .r .c{ padding:10px 14px; border-bottom:1px solid #333; display:flex; align-items:center; min-height:var(--row-h); }
.r{ background:#151515; } .r:nth-child(even){ background:#171717; }
.name-cell{ display:flex; align-items:center; gap:10px; }
.thumb{ width:48px; height:48px; object-fit:contain; border-radius:6px; display:block; }
.thumb--placeholder{ width:48px; height:48px; display:grid; place-items:center; background:#222; border:1px solid #333; border-radius:6px; color:#777; font-weight:700; }
.name-text{ display:inline-block; line-height:1.2; }

/* 상세 */
.detail{ grid-column:1 / -1; overflow:hidden; max-height:0; transition:max-height .25s ease; }
.detail-inner{ padding:12px 14px; border-top:1px dashed #333; display:grid; grid-template-columns:1fr 1fr; gap:14px; background:#151515; }
.subsec h4{ margin:0 0 6px; font-size:13px; color:#ffdddd; }
.meta{ color:#bbb; font-size:13px; }
.open .detail{ max-height:260px; }

/* 카드 */
.item-cards{ display:grid; grid-template-columns:repeat(3, 1fr); gap:12px; padding:12px; }
@media (max-width:1000px){ .item-cards{ grid-template-columns:repeat(2, 1fr);} }
@media (max-width:600px){ .item-cards{ grid-template-columns:1fr; } }
.item-card{ background:#181818; border:1px solid #2a2a2a; border-radius:10px; padding:12px; display:flex; flex-direction:column; gap:10px; }
.ic-head{ display:flex; align-items:center; justify-content:space-between; gap:10px; }
.ic-name{ display:flex; align-items:center; gap:10px; }
.ic-thumb{ width:48px; height:48px; object-fit:contain; border-radius:6px; display:block; }
.ic-thumb.ic-thumb--ph{ display:grid; place-items:center; background:#222; border:1px solid #333; color:#777; font-weight:700; }
.ic-title{ font-weight:700; }
.ic-meta{ display:flex; gap:6px; flex-wrap:wrap; color:#bbb; font-size:12px; }
.ic-body{ display:grid; gap:6px; }
.stat{ color:#ccc; font-size:13px; display:flex; gap:8px; align-items:center; }

/* 하단 */
.footerbar{ padding:10px 12px; margin-top:10px; }
.footerline.footer-two{ display:grid; grid-template-columns: 1fr max-content 1fr; align-items:center; column-gap:12px; }
.pager-center{ grid-column: 2; justify-self:center; display:flex; gap:8px; flex-wrap:wrap; padding:4px 0; }
.page-num{ background:#1b1b1b; border:1px solid #333; color:#eee; border-radius:8px; padding:6px 10px; min-width:36px; line-height:1; cursor:pointer; transition:background .12s, border-color .12s, transform .06s; }
.page-num:hover{ background:#242424; }
.page-num:active{ transform:translateY(1px); }
.page-num.active, .page-num[disabled]{ background:#bb0000; border-color:#bb0000; color:#fff; cursor:default; pointer-events:none; }

@media (max-width:900px){ .detail-inner{ grid-template-columns:1fr; } }
</style>
</head>
<body>
<main class="db-main">

  <!-- 상단 스위치 -->
  <div class="db-switch">
  <a class="vt-btn ${pageActive eq 'form' ? 'active' : ''}"
     href="<c:url value='/DB/listForm.do'/>">피의 형상DB</a>

  <a class="vt-btn ${pageActive eq 'mount' ? 'active' : ''}"
     href="<c:url value='/DB/listMount.do'/>">탈 것DB</a>
</div>

  <!-- 필터 (등급/검색만) -->
  <section class="card filters" aria-label="탈 것 필터">
    <div class="filters-grid">
      <div class="fbox" id="filterBox">
        <!-- 등급 -->
        <div class="subrow">
          <div class="label">등급</div>
          <div class="checks" id="grades">
            <button type="button" class="toggle-btn active" data-value="전체">전체</button>
            <button type="button" class="toggle-btn" data-value="일반">일반</button>
            <button type="button" class="toggle-btn" data-value="고급">고급</button>
            <button type="button" class="toggle-btn" data-value="희귀">희귀</button>
            <button type="button" class="toggle-btn" data-value="영웅">영웅</button>
            <button type="button" class="toggle-btn" data-value="전설">전설</button>
            <button type="button" class="toggle-btn" data-value="신화">신화</button>
          </div>
        </div>
        <!-- 검색 -->
        <div class="subrow">
          <div class="label">검색</div>
          <div class="searchline">
            <input type="text" id="qTop" placeholder="탈 것 이름으로 검색" />
            <button class="btn-primary" id="btnSearchTop">검색</button>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- 결과/정렬 + 뷰 토글 -->
  <div class="result-bar">
    <div class="result-info" id="resultInfo">총 0개</div>
    <div class="right-controls">
      <div class="page-size">
        <label for="pageSize" class="label-inline">표시</label>
        <select id="pageSize">
          <option value="5">5개</option>
          <option value="10" selected>10개</option>
          <option value="30">30개</option>
        </select>
      </div>
      <div class="sort-group">
        <span style="color:#bbb; font-size:13px">정렬:</span>
        <select id="sortKey">
          <option value="id">번호</option>
          <option value="name">이름</option>
          <option value="grade">등급</option>
        </select>
      </div>
      <div class="view-toggle" role="tablist" aria-label="뷰 전환">
        <button id="btnViewList" class="vt-btn active" role="tab" aria-selected="true">리스트형</button>
        <button id="btnViewCard" class="vt-btn" role="tab" aria-selected="false">카드형</button>
      </div>
    </div>
  </div>

  <!-- 리스트 뷰 -->
  <section class="card list" id="listView" aria-label="탈 것 목록">
    <div class="thead">
      <div class="c th" data-k="name">이름</div>
      <div class="c th" data-k="own">보유 효과</div>
      <div class="c th" data-k="link">연결 효과</div>
      <div class="c th" data-k="trans">초월 효과</div>
    </div>

    <div id="itemBody">
      <c:if test="${empty mountList}">
        <div class="r"><div class="c" style="grid-column:1 / -1; color:#aaa;">데이터가 없습니다.</div></div>
      </c:if>

      <c:forEach var="item" items="${mountList}">
        <c:set var="imgBase" value="mount"/>
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty item.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/${imgBase}/${fn:escapeXml(item.imgPath)}"/>
        </c:if>

        <div class="r" onclick="this.classList.toggle('open')">
          <div class="c name-cell">
            <c:choose>
              <c:when test="${not empty imgSrc}"><img class="thumb" src="${imgSrc}" alt="${fn:escapeXml(item.name)}" /></c:when>
              <c:otherwise><div class="thumb--placeholder">?</div></c:otherwise>
            </c:choose>
            <span class="name-text">${fn:escapeXml(item.name)}</span>
          </div>
          <div class="c">${fn:escapeXml(item.own_effect)}</div>
          <div class="c">${fn:escapeXml(item.link_effect)}</div>
          <div class="c">${fn:escapeXml(item.transcend_effect)}</div>
        </div>

        <div class="detail">
          <div class="detail-inner">
            <c:if test="${not empty item.grade}">
              <div class="subsec"><h4>등급</h4><div class="meta">${fn:escapeXml(item.grade)}</div></div>
            </c:if>
            <c:if test="${not empty item.obtain_source}">
              <div class="subsec"><h4>획득처</h4><div class="meta">${fn:escapeXml(item.obtain_source)}</div></div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- 카드 뷰 -->
  <section class="card" id="cardView" aria-label="탈 것 카드 목록" style="display:none;">
    <div id="cardGrid" class="item-cards">
      <c:forEach var="item" items="${mountList}">
        <c:set var="imgBase" value="mount"/>
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty item.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/${imgBase}/${fn:escapeXml(item.imgPath)}"/>
        </c:if>

        <div class="item-card">
          <div class="ic-head">
            <div class="ic-name">
              <c:choose>
                <c:when test="${not empty imgSrc}"><img class="ic-thumb" src="${imgSrc}" alt="${fn:escapeXml(item.name)}" /></c:when>
                <c:otherwise><div class="ic-thumb ic-thumb--ph">?</div></c:otherwise>
              </c:choose>
              <div>
                <div class="ic-title">${fn:escapeXml(item.name)}</div>
                <div class="ic-meta">
                  <c:if test="${not empty item.grade}"><span class="chip">${fn:escapeXml(item.grade)}</span></c:if>
                </div>
              </div>
            </div>
          </div>
          <div class="ic-body">
            <c:if test="${not empty item.own_effect}"><div class="stat"><b>보유</b> ${fn:escapeXml(item.own_effect)}</div></c:if>
            <c:if test="${not empty item.link_effect}"><div class="stat"><b>연결</b> ${fn:escapeXml(item.link_effect)}</div></c:if>
            <c:if test="${not empty item.transcend_effect}"><div class="stat"><b>초월</b> ${fn:escapeXml(item.transcend_effect)}</div></c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- 하단 -->
  <section class="card footerbar" aria-label="페이징/검색">
    <div class="footerline footer-two">
      <div id="pageNums" class="pager-center"></div>
      <div class="searchline">
        <input type="text" id="qBottom" placeholder="탈 것 이름으로 검색" />
        <button class="btn-primary" id="btnSearchBottom">검색</button>
      </div>
    </div>
  </section>

</main>

<script src="${contextPath}/resources/js/itemDB.js?v=20250212"></script>
</body>
</html>
