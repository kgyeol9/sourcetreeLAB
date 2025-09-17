<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageActive" value="sm"/> <%-- DB 스위치 활성 표기: sm = shape/mount --%>
<%@ page session="false"%>
<%
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>피의 형상 / 탈 것 DB</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
:root { --subrow-base:84px; --boost:40px; --gap:12px; --row-h:44px; }

/* ===== 공통/테마 ===== */
body{ margin:0; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background:#121212; color:#eee; }
a{ text-decoration:none; color:inherit; }
.db-main{ max-width:1200px; margin:16px auto 24px; padding:0 16px; }
.card{ background:#1f1f1f; border:1px solid #333; border-radius:10px; }

/* 기본 버튼 */
.btn-primary{ background:#bb0000; color:#fff; border:none; border-radius:8px; font-weight:700; cursor:pointer; padding:10px 12px; }
.btn-primary:hover{ background:#ff4444; }

/* ===== 상단 DB 스위치 (장비/기타/형상·탈것) ===== */
.db-switch{
  display:flex; justify-content:flex-start; gap:8px;
  padding-bottom:12px; border-bottom:2px solid #bb0000; margin:0 0 12px;
}
.vt-btn{ background:#222; border:1px solid #333; color:#eee; padding:6px 10px; border-radius:6px; cursor:pointer; }
.vt-btn.active{ background:#bb0000; border-color:#bb0000; }
.db-switch .vt-btn{ line-height:1; transition:background .15s, border-color .15s, box-shadow .12s, transform .06s; }
.db-switch .vt-btn.active{ box-shadow: inset 0 2px 0 rgba(255,255,255,.08), inset 0 -2px 0 rgba(0,0,0,.25); transform:translateY(1px); color:#fff; }
.db-switch .vt-btn:active{ transform:translateY(1px); }

/* ===== 페이지 내부 탭(피의 형상 / 탈 것) ===== */
.type-tabs{ display:flex; gap:8px; padding:12px 0; margin-bottom:8px; }

/* ===== 필터 ===== */
.filters{ padding:16px; }
.filters-grid{ display:grid; grid-template-columns:1fr; gap:16px; }
.fbox{ background:#181818; border:1px solid #333; border-radius:10px; padding:0; overflow:hidden; display:grid; gap:0; }
.subrow{ min-height:var(--subrow-base); display:grid; grid-template-columns:72px 1fr; align-items:center; gap:12px; padding:14px 16px; box-sizing:border-box; }
.fbox .subrow:nth-child(-n+3){ min-height:calc(var(--subrow-base) + var(--boost)); }
.subrow + .subrow{ border-top:1px solid #333; }
.label{ color:#bbb; font-size:13px; }
.checks{ display:flex; flex-wrap:wrap; gap:10px 16px; align-items:center; align-content:center; min-height:100%; }
.toggle-btn{ padding:8px 14px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:2px solid #555; background:#181818; color:#bbb; transition:.15s all; }
.toggle-btn.active{ border-color:#bb0000; color:#ff4444; }
.toggle-btn:not(.active):hover{ border-color:#777; color:#eee; }
.searchline{ display:grid; grid-template-columns:1fr 120px; gap:10px; align-items:center; }
.searchline input[type="text"]{ padding:12px; border-radius:8px; border:1px solid #333; background:#181818; color:#eee; }

/* ===== 결과바/뷰 토글 ===== */
.result-bar{ display:flex; flex-wrap:wrap; align-items:center; justify-content:space-between; gap:10px; margin:14px 0 8px; }
.result-info{ color:#bbb; font-size:13px; }
.right-controls{ display:flex; align-items:center; gap:12px; }
.page-size select,.sort-group select{ background:#181818; color:#eee; border:1px solid #333; border-radius:8px; padding:6px 10px; }
.view-toggle{ display:flex; gap:6px; }

/* ===== 리스트 ===== */
.list{ overflow:hidden; }
.thead,.r{ display:grid; grid-template-columns:1.1fr 1.6fr; }
.thead{ background:#181818; color:#ddd; font-weight:700; user-select:none; }
.thead .c{ padding:10px 14px; border-bottom:1px solid #333; display:flex; align-items:center; gap:8px; min-height:var(--row-h); }
.r .c{ padding:10px 14px; border-bottom:1px solid #333; display:flex; align-items:center; min-height:var(--row-h); }
.r{ background:#151515; } .r:nth-child(even){ background:#171717; }
.name-cell{ display:flex; align-items:center; gap:10px; }
.thumb{ width:48px; height:48px; object-fit:contain; border-radius:6px; display:block; }
.thumb--placeholder{ width:48px; height:48px; display:grid; place-items:center; background:#222; border:1px solid #333; border-radius:6px; color:#777; font-weight:700; }

/* 상세 */
.detail{ grid-column:1 / -1; overflow:hidden; max-height:0; transition:max-height .25s ease; }
.detail-inner{ padding:12px 14px; border-top:1px dashed #333; display:grid; grid-template-columns:1fr 1fr; gap:14px; background:#151515; }
.subsec h4{ margin:0 0 6px; font-size:13px; color:#ffdddd; }
.meta{ color:#bbb; font-size:13px; white-space:pre-wrap; }
.open .detail{ max-height:260px; }

/* ===== 카드 ===== */
.item-cards{ display:grid; grid-template-columns:repeat(3,1fr); gap:12px; padding:12px; }
@media (max-width:1000px){ .item-cards{ grid-template-columns:repeat(2,1fr);} }
@media (max-width:600px){ .item-cards{ grid-template-columns:1fr; } }
.item-card{ background:#181818; border:1px solid #2a2a2a; border-radius:10px; padding:12px; display:flex; flex-direction:column; gap:10px; }
.ic-head{ display:flex; align-items:center; justify-content:space-between; gap:10px; }
.ic-name{ display:flex; align-items:center; gap:10px; }
.ic-thumb{ width:48px; height:48px; object-fit:contain; border-radius:6px; display:block; }
.ic-thumb.ic-thumb--ph{ display:grid; place-items:center; background:#222; border:1px solid #333; color:#777; font-weight:700; }
.ic-title{ font-weight:700; }
.ic-meta{ display:flex; gap:6px; flex-wrap:wrap; color:#bbb; font-size:12px; }
.ic-body{ display:grid; gap:6px; }
.chip{ font-size:11px; padding:2px 8px; border:1px solid #444; border-radius:999px; color:#ccc; }

/* ===== 페이징/검색(하단) ===== */
.footerbar{ padding:10px 12px; margin-top:10px; }
.footerline.footer-two{ display:grid; grid-template-columns:1fr max-content 1fr; align-items:center; column-gap:12px; }
.pager-center{ grid-column:2; justify-self:center; display:flex; gap:8px; flex-wrap:wrap; padding:4px 0; }
.page-num{ background:#1b1b1b; border:1px solid #333; color:#eee; border-radius:8px; padding:6px 10px; min-width:36px; line-height:1; cursor:pointer; transition:background .12s, border-color .12s, transform .06s; }
.page-num:hover{ background:#242424; }
.page-num:active{ transform:translateY(1px); }
.page-num.active,.page-num[disabled]{ background:#bb0000; border-color:#bb0000; color:#fff; cursor:default; pointer-events:none; }
.page-ellipsis{ color:#888; padding:0 4px; user-select:none; }

/* 반응형 */
@media (max-width:600px){
  .footerline.footer-two{ grid-template-columns:1fr; row-gap:8px; }
  .pager-center{ grid-column:1; justify-self:center; }
}
</style>
</head>
<body>

<%-- 내부 탭 상태: 기본 shape --%>
<c:set var="t" value="${empty param.t ? 'shape' : param.t}"/>
<c:set var="isShape" value="${t eq 'shape'}"/>
<c:set var="dataList" value="${isShape ? shapeList : mountList}"/>

<main class="db-main">
  <!-- 상단 DB 스위치 -->
  <div class="db-switch">
    <a class="vt-btn ${pageActive eq 'item' ? 'active' : ''}" href="<c:url value='/itemDB.do'/>">장비DB</a>
    <a class="vt-btn ${pageActive eq 'etc' ? 'active' : ''}"  href="<c:url value='/etcDB.do'/>">기타아이템DB</a>
    <a class="vt-btn ${pageActive eq 'sm' ? 'active' : ''}"    href="<c:url value='/shapeMountDB.do'/>">피의형상·탈것DB</a>
  </div>

  <!-- 페이지 내부 탭 -->
  <div class="type-tabs">
    <a class="vt-btn ${isShape ? 'active' : ''}" href="<c:url value='/shapeMountDB.do?t=shape'/>">피의 형상</a>
    <a class="vt-btn ${!isShape ? 'active' : ''}" href="<c:url value='/shapeMountDB.do?t=mount'/>">탈 것</a>
  </div>

  <!-- ===== 필터 ===== -->
  <section class="card filters" aria-label="필터">
    <div class="filters-grid">
      <div class="fbox">
        <c:if test="${isShape}">
          <!-- 직업 (형상 전용) -->
          <div class="subrow">
            <div class="label">직업</div>
            <div class="checks" id="jobs">
              <button type="button" class="toggle-btn active" data-value="전체">전체</button>
              <button type="button" class="toggle-btn" data-value="바이퍼">바이퍼</button>
              <button type="button" class="toggle-btn" data-value="그림리퍼">그림리퍼</button>
              <button type="button" class="toggle-btn" data-value="카니지">카니지</button>
              <button type="button" class="toggle-btn" data-value="블러드스테인">블러드스테인</button>
            </div>
          </div>
        </c:if>

        <!-- 등급 (공통) -->
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

        <!-- 검색 (공통) -->
        <div class="subrow">
          <div class="label">검색</div>
          <div class="searchline">
            <input type="text" id="qTop" placeholder="${isShape ? '형상 이름으로 검색' : '탈 것 이름으로 검색'}" />
            <button class="btn-primary" id="btnSearchTop">검색</button>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== 결과/정렬 + 뷰 토글 ===== -->
  <div class="result-bar">
    <div class="result-info" id="resultInfo">총 0개</div>
    <div class="right-controls">
      <div class="page-size">
        <label for="pageSize" class="label-inline">표시</label>
        <select id="pageSize"><option value="5">5개</option><option value="10" selected>10개</option><option value="30">30개</option></select>
      </div>
      <div class="sort-group">
        <span style="color:#bbb; font-size:13px">정렬:</span>
        <select id="sortKey">
          <option value="name">이름</option>
          <option value="grade">등급</option>
          <c:if test="${isShape}"><option value="job">직업</option></c:if>
        </select>
      </div>
      <div class="view-toggle" role="tablist" aria-label="뷰 전환">
        <button id="btnViewList" class="vt-btn active" role="tab" aria-selected="true">리스트형</button>
        <button id="btnViewCard" class="vt-btn" role="tab" aria-selected="false">카드형</button>
      </div>
    </div>
  </div>

  <!-- ===== 리스트 ===== -->
  <section class="card list" id="listView" aria-label="목록">
    <div class="thead">
      <div class="c th">이름</div>
      <div class="c th">효과</div>
    </div>

    <div id="itemBody">
      <c:if test="${empty dataList}">
        <div class="r"><div class="c" style="grid-column:1 / -1; color:#aaa;">데이터가 없습니다.</div></div>
      </c:if>

      <c:forEach var="it" items="${dataList}">
        <%-- 이미지 폴더 결정 --%>
        <c:set var="imgBase" value="${isShape ? 'shape' : 'mount'}"/>
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty it.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/${imgBase}/${fn:escapeXml(it.imgPath)}"/>
        </c:if>

        <div class="r" onclick="toggleDetail(this)"
             data-name="${fn:escapeXml(it.name)}"
             data-grade="${fn:escapeXml(it.grade)}"
             data-job="${isShape ? fn:escapeXml(it.job) : ''}"
             data-own="${fn:escapeXml(it.own_effect)}"
             data-link="${fn:escapeXml(it.link_effect)}"
             data-trans="${fn:escapeXml(it.transcend_effect)}"
             data-img="${fn:escapeXml(imgSrc)}">
          <!-- 이름 -->
          <div class="c name-cell">
            <c:choose>
              <c:when test="${not empty imgSrc}"><img class="thumb" src="${imgSrc}" alt="${fn:escapeXml(it.name)}" /></c:when>
              <c:otherwise><div class="thumb--placeholder">?</div></c:otherwise>
            </c:choose>
            <div>
              <div>${fn:escapeXml(it.name)}</div>
              <div class="ic-meta" style="gap:6px;">
                <span class="chip">${fn:escapeXml(it.grade)}</span>
                <c:if test="${isShape && not empty it.job}">
                  <span class="chip">${fn:escapeXml(it.job)}</span>
                </c:if>
              </div>
            </div>
          </div>

          <!-- 효과 요약 -->
          <div class="c">
            <div class="meta"><b>보유</b> ${fn:escapeXml(it.own_effect)}</div>
            <div class="meta"><b>연결</b> ${fn:escapeXml(it.link_effect)}</div>
            <div class="meta"><b>초월</b> ${fn:escapeXml(it.transcend_effect)}</div>
          </div>
        </div>

        <!-- 상세 -->
        <div class="detail">
          <div class="detail-inner">
            <div class="subsec"><h4>보유 효과</h4><div class="meta">${fn:escapeXml(it.own_effect)}</div></div>
            <div class="subsec"><h4>연결 효과</h4><div class="meta">${fn:escapeXml(it.link_effect)}</div></div>
            <div class="subsec"><h4>초월 효과</h4><div class="meta">${fn:escapeXml(it.transcend_effect)}</div></div>
            <div class="subsec"><h4>등급</h4><div class="meta">${fn:escapeXml(it.grade)}</div></div>
            <c:if test="${isShape && not empty it.job}">
              <div class="subsec"><h4>직업</h4><div class="meta">${fn:escapeXml(it.job)}</div></div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- ===== 카드 ===== -->
  <section class="card" id="cardView" aria-label="카드 목록" style="display:none;">
    <div id="cardGrid" class="item-cards">
      <c:forEach var="it" items="${dataList}">
        <c:set var="imgBase" value="${isShape ? 'shape' : 'mount'}"/>
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty it.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/${imgBase}/${fn:escapeXml(it.imgPath)}"/>
        </c:if>

        <div class="item-card">
          <div class="ic-head">
            <div class="ic-name">
              <c:choose>
                <c:when test="${not empty imgSrc}"><img class="ic-thumb" src="${imgSrc}" alt="${fn:escapeXml(it.name)}" /></c:when>
                <c:otherwise><div class="ic-thumb ic-thumb--ph">?</div></c:otherwise>
              </c:choose>
              <div>
                <div class="ic-title">${fn:escapeXml(it.name)}</div>
                <div class="ic-meta">
                  <span class="chip">${fn:escapeXml(it.grade)}</span>
                  <c:if test="${isShape && not empty it.job}">
                    <span class="chip">${fn:escapeXml(it.job)}</span>
                  </c:if>
                </div>
              </div>
            </div>
          </div>

          <div class="ic-body">
            <div class="meta"><b>보유</b> ${fn:escapeXml(it.own_effect)}</div>
            <div class="meta"><b>연결</b> ${fn:escapeXml(it.link_effect)}</div>
            <div class="meta"><b>초월</b> ${fn:escapeXml(it.transcend_effect)}</div>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- ===== 하단: 숫자 페이징 + 검색 ===== -->
  <section class="card footerbar" aria-label="페이징/검색">
    <div class="footerline footer-two">
      <div id="pageNums" class="pager-center"></div>
      <div class="searchline">
        <input type="text" id="qBottom" placeholder="${isShape ? '형상 이름으로 검색' : '탈 것 이름으로 검색'}" />
        <button class="btn-primary" id="btnSearchBottom">검색</button>
      </div>
    </div>
  </section>
</main>

<!-- 전용 JS (필터/정렬/탭/뷰전환) -->
<script src="${contextPath}/resources/js/shapeMountDB.js?v=20250212"></script>
</body>
</html>
