<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageActive" value="etc"/>  <%-- 현재 페이지 활성 탭 표기 --%>
<%@ page session="false"%>
<%
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기타 아이템 DB</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />

<style>
/* ---------- 변수 ---------- */
:root{
  --topbar-h:64px;      /* 상단 고정 헤더 높이 */
  --subrow-base:84px;
  --boost:40px;
  --gap:12px;
  --row-h:44px;
}

/* ---------- 공통/테마 ---------- */
body{
  margin:0;
  padding-top:var(--topbar-h); /* 헤더와 겹침 방지 */
  font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background:#121212; color:#eee;
}
a{ text-decoration:none; color:inherit; }
.db-main{ max-width:1200px; margin:16px auto 24px; padding:0 16px; }
.card{ background:#1f1f1f; border:1px solid #333; border-radius:10px; }

/* 버튼 */
.btn-primary{ background:#bb0000; color:#fff; border:none; border-radius:8px; font-weight:700; cursor:pointer; padding:10px 12px; }
.btn-primary:hover{ background:#ff4444; }

/* ---------- 상단 DB 스위치 ---------- */
.db-switch{
  display:flex; justify-content:flex-start; gap:8px;
  padding-bottom:12px; border-bottom:2px solid #bb0000; margin:0 0 12px;
}
.vt-btn{ background:#222; border:1px solid #333; color:#eee; padding:6px 10px; border-radius:6px; cursor:pointer; }
.vt-btn.active{ background:#bb0000; border-color:#bb0000; color:#fff; } /* 활성 글자색 흰색 */
.db-switch .vt-btn{ line-height:1; transition:background .15s, border-color .15s, box-shadow .12s, transform .06s; }
.db-switch .vt-btn.active{ box-shadow: inset 0 2px 0 rgba(255,255,255,.08), inset 0 -2px 0 rgba(0,0,0,.25); transform: translateY(1px); }
.db-switch .vt-btn:active{ transform: translateY(1px); }

/* ---------- 필터 ---------- */
.filters{ padding:16px; }
.filters-grid{ display:grid; grid-template-columns:1fr; gap:16px; } /* 비교영역 없음 */
.fbox{ background:#181818; border:1px solid #333; border-radius:10px; overflow:hidden; display:grid; grid-template-rows:1fr 1fr 1fr auto; }
.subrow{ min-height:var(--subrow-base); display:grid; grid-template-columns:72px 1fr; align-items:center; gap:12px; padding:14px 16px; box-sizing:border-box; }
.fbox .subrow:nth-child(-n+3){ min-height:calc(var(--subrow-base) + var(--boost)); }
.subrow + .subrow{ border-top:1px solid #333; }
.label{ color:#bbb; font-size:13px; }
.checks{ display:flex; flex-wrap:wrap; gap:10px 16px; align-items:center; }
.searchline{ display:grid; grid-template-columns:1fr 120px; gap:10px; align-items:center; }
.searchline input[type="text"]{ padding:12px; border-radius:8px; border:1px solid #333; background:#181818; color:#eee; }

/* ---------- 결과바/정렬/뷰 토글 ---------- */
.result-bar{ display:flex; flex-wrap:wrap; align-items:center; justify-content:space-between; gap:10px; margin:14px 0 8px; }
.result-info{ color:#bbb; font-size:13px; }
.sort-group{ display:flex; gap:8px; align-items:center; }
.sort-group select, .page-size select{ background:#181818; color:#eee; border:1px solid #333; border-radius:8px; padding:8px; }
.right-controls{ display:flex; align-items:center; gap:12px; }
.label-inline{ color:#bbb; font-size:13px; margin-right:6px; }
.view-toggle{ display:flex; gap:6px; }

/* ---------- 리스트 뷰 ---------- */
.list{ overflow:hidden; }
.thead, .r{ display:grid; grid-template-columns:1fr 1.2fr; } /* +버튼 없는 2열 */
.thead{ background:#181818; color:#ddd; font-weight:700; user-select:none; }
.thead .c{ padding:10px 14px; border-bottom:1px solid #333; display:flex; align-items:center; gap:8px; min-height:var(--row-h); }
.r .c{ padding:10px 14px; border-bottom:1px solid #333; display:flex; align-items:center; min-height:var(--row-h); }
.r{ background:#151515; } .r:nth-child(even){ background:#171717; }
.name-cell{ display:flex; align-items:center; gap:10px; }
.thumb{ width:48px; height:48px; object-fit:contain; border-radius:6px; display:block; }
.thumb--placeholder{ width:48px; height:48px; display:grid; place-items:center; background:#222; border:1px solid #333; border-radius:6px; color:#777; font-weight:700; }
.name-text{ display:inline-block; line-height:1.2; }

/* 상세슬라이드 */
.detail{ grid-column:1 / -1; overflow:hidden; max-height:0; transition:max-height .25s ease; }
.detail-inner{ padding:12px 14px; border-top:1px dashed #333; display:grid; grid-template-columns:1fr 1fr; gap:14px; background:#151515; }
.subsec h4{ margin:0 0 6px; font-size:13px; color:#ffdddd; }
.meta{ color:#bbb; font-size:13px; }
.open .detail{ max-height:240px; }

/* ---------- 카드 뷰 ---------- */
.item-cards{ display:grid; grid-template-columns:repeat(3, 1fr); gap:12px; padding:12px; }
@media (max-width:1000px){ .item-cards{ grid-template-columns:repeat(2, 1fr); } }
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

/* ---------- 하단 페이징/검색 ---------- */
.footerbar{ padding:10px 12px; margin-top:10px; }
.footerline.footer-two{
  display:grid; grid-template-columns: 1fr max-content 1fr;
  align-items:center; column-gap:12px;
}
.pager-center{ grid-column:2; justify-self:center; display:flex; gap:8px; flex-wrap:wrap; padding:4px 0; }
.page-num{ background:#1b1b1b; border:1px solid #333; color:#eee; border-radius:8px; padding:6px 10px; min-width:36px; line-height:1; cursor:pointer; transition:background .12s, border-color .12s, transform .06s; }
.page-num:hover{ background:#242424; }
.page-num:active{ transform:translateY(1px); }
.page-num:focus-visible{ outline:2px solid #bb0000; outline-offset:2px; }
.page-num.active, .page-num[disabled]{ background:#bb0000; border-color:#bb0000; color:#fff; cursor:default; pointer-events:none; }
.page-ellipsis{ color:#888; padding:0 4px; user-select:none; }
.footerline.footer-two .searchline{ grid-column:3; justify-self:end; }

/* 반응형 */
@media (max-width:600px){
  .footerline.footer-two{ grid-template-columns:1fr; row-gap:8px; }
  .pager-center{ grid-column:1; justify-self:center; }
  .footerline.footer-two .searchline{ grid-column:1; justify-self:stretch; }
}

/* 버튼형 체크 */
.toggle-btn{ padding:8px 14px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:2px solid #555; background:#181818; color:#bbb; transition:.15s all; }
.toggle-btn.active{ border-color:#bb0000; color:#ff4444; }
.toggle-btn:not(.active):hover{ border-color:#777; color:#eee; }
</style>
</head>

<body>
<main class="db-main">
  <!-- 상단 스위치 -->
  <div class="db-switch">
    <a class="vt-btn ${pageActive eq 'item' ? 'active' : ''}"
       href="<c:url value='/itemDB.do'/>">장비DB</a>
    <a class="vt-btn ${pageActive eq 'etc' ? 'active' : ''}"
       href="<c:url value='/etcDB.do'/>">기타아이템DB</a>
  </div>

  <!-- 필터 -->
  <section class="card filters" aria-label="아이템 필터">
    <div class="filters-grid">
      <div class="fbox" id="filterBox">
        <!-- 직업 -->
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
        <!-- 분류 -->
        <div class="subrow">
          <div class="label">분류</div>
          <div class="checks" id="cats">
            <button type="button" class="toggle-btn" data-value="소모품">소모품</button>
            <button type="button" class="toggle-btn" data-value="스킬북">스킬북</button>
            <button type="button" class="toggle-btn" data-value="재료">재료</button>
          </div>
        </div>
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
            <input type="text" id="qTop" placeholder="아이템 이름으로 검색" />
            <button class="btn-primary" id="btnSearchTop">검색</button>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- 결과/정렬/뷰 토글 -->
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
          <option value="category">분류</option>
        </select>
      </div>
      <div class="view-toggle" role="tablist" aria-label="뷰 전환">
        <button id="btnViewList" class="vt-btn active" role="tab" aria-selected="true">리스트형</button>
        <button id="btnViewCard" class="vt-btn" role="tab" aria-selected="false">카드형</button>
      </div>
    </div>
  </div>

  <!-- 리스트 뷰 -->
  <section class="card list" id="listView" aria-label="아이템 목록">
    <div class="thead">
      <div class="c th" data-k="name">아이템 이름 <span class="arrow" id="ar-name">▲▼</span></div>
      <div class="c th" data-k="stats">아이템 능력치</div>
    </div>

    <div id="itemBody">
      <c:if test="${empty itemsList}">
        <div class="r"><div class="c" style="grid-column:1 / -1; color:#aaa;">데이터가 없습니다.</div></div>
      </c:if>

      <c:forEach var="item" items="${itemsList}">
        <%-- 이미지 폴더 결정 --%>
        <c:set var="imgBase" value="etc"/>
        <c:choose>
          <c:when test="${item.category eq '소모품'}"><c:set var="imgBase" value="consumable"/></c:when>
          <c:when test="${item.category eq '스킬북'}"><c:set var="imgBase" value="skillbook"/></c:when>
          <c:when test="${item.category eq '재료'}"><c:set var="imgBase" value="material"/></c:when>
        </c:choose>
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty item.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/${imgBase}/${fn:escapeXml(item.imgPath)}"/>
        </c:if>

        <div class="r" onclick="toggleDetail(this)"
             data-name="${fn:escapeXml(item.name)}"
             data-quality="${fn:escapeXml(item.quality)}"
             data-category="${fn:escapeXml(item.category)}" data-job="${fn:escapeXml(item.job)}"
             data-obtain="${fn:escapeXml(item.obtain_source)}" data-img="${fn:escapeXml(imgSrc)}">

          <div class="c name-cell">
            <c:choose>
              <c:when test="${not empty imgSrc}">
                <img class="thumb" src="${imgSrc}" alt="${fn:escapeXml(item.name)}" />
              </c:when>
              <c:otherwise><div class="thumb--placeholder">?</div></c:otherwise>
            </c:choose>
            <span class="name-text">${fn:escapeXml(item.name)}</span>
          </div>

          <div class="c">-</div> <!-- 기타는 기본값 -->
        </div>

        <div class="detail">
          <div class="detail-inner">
            <c:if test="${not empty item.quality}">
              <div class="subsec line"><h4>등급</h4><div class="meta">${fn:escapeXml(item.quality)}</div></div>
            </c:if>
            <c:if test="${not empty item.category}">
              <div class="subsec line"><h4>분류</h4><div class="meta">${fn:escapeXml(item.category)}</div></div>
            </c:if>
            <c:if test="${not empty item.job}">
              <div class="subsec line"><h4>직업</h4><div class="meta">${fn:escapeXml(item.job)}</div></div>
            </c:if>
            <c:if test="${not empty item.obtain_source}">
              <div class="subsec line"><h4>획득처</h4><div class="meta">${fn:escapeXml(item.obtain_source)}</div></div>
            </c:if>
          </div>
        </div>

      </c:forEach>
    </div>
  </section>

  <!-- 카드 뷰 -->
  <section class="card" id="cardView" aria-label="아이템 카드 목록" style="display:none;">
    <div id="cardGrid" class="item-cards">
      <c:forEach var="item" items="${itemsList}">
        <c:set var="imgBase" value="etc"/>
        <c:choose>
          <c:when test="${item.category eq '소모품'}"><c:set var="imgBase" value="consumable"/></c:when>
          <c:when test="${item.category eq '스킬북'}"><c:set var="imgBase" value="skillbook"/></c:when>
          <c:when test="${item.category eq '재료'}"><c:set var="imgBase" value="material"/></c:when>
        </c:choose>
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty item.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/${imgBase}/${fn:escapeXml(item.imgPath)}"/>
        </c:if>

        <div class="item-card"
             data-name="${fn:escapeXml(item.name)}"
             data-quality="${fn:escapeXml(item.quality)}"
             data-category="${fn:escapeXml(item.category)}" data-job="${fn:escapeXml(item.job)}"
             data-obtain="${fn:escapeXml(item.obtain_source)}" data-img="${fn:escapeXml(imgSrc)}">
          <div class="ic-head">
            <div class="ic-name">
              <c:choose>
                <c:when test="${not empty imgSrc}">
                  <img class="ic-thumb" src="${imgSrc}" alt="${fn:escapeXml(item.name)}" />
                </c:when>
                <c:otherwise><div class="ic-thumb ic-thumb--ph">?</div></c:otherwise>
              </c:choose>
              <div>
                <div class="ic-title">${fn:escapeXml(item.name)}</div>
                <div class="ic-meta">
                  <c:if test="${not empty item.quality}"><span class="chip">${fn:escapeXml(item.quality)}</span></c:if>
                  <c:if test="${not empty item.category}"><span class="chip">${fn:escapeXml(item.category)}</span></c:if>
                  <c:if test="${not empty item.job}"><span class="chip">${fn:escapeXml(item.job)}</span></c:if>
                </div>
              </div>
            </div>
          </div>

          <div class="ic-body">
            <c:if test="${not empty item.obtain_source}">
              <div class="stat"><b>획득처</b> ${fn:escapeXml(item.obtain_source)}</div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- 하단: 숫자 페이징 + 검색 -->
  <section class="card footerbar" aria-label="페이징/검색">
    <div class="footerline.footer-two">
      <div id="pageNums" class="pager-center"></div>
      <div class="searchline">
        <input type="text" id="qBottom" placeholder="아이템 이름으로 검색" />
        <button class="btn-primary" id="btnSearchBottom">검색</button>
      </div>
    </div>
  </section>
</main>

<!-- 공용 스크립트 (토글/페이징 등) -->
<script src="${contextPath}/resources/js/itemDB.js?v=20250212"></script>
</body>
</html>
