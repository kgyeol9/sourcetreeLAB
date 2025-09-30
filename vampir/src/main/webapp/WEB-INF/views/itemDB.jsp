<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageActive" value="item"/> <%-- 현재 페이지 활성 탭 --%>
<%@ page session="false"%>
<%
  request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>아이템 DB</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/itemDB.css">

<style>
/* ===== 공통 상단 오프셋을 '컨텐츠 컨테이너'에서만 처리 ===== */
/* (외부 CSS보다 뒤에 위치 + !important 로 최종 우선) */
:root{
  --topbar-h: 64px;           /* 실제 고정 헤더 높이 */
  --page-offset-extra: 10px;  /* 추가 여백(두 페이지 동일) */
  /* 페이지 내에서 사용하는 CSS 변수 기본값 */
  --subrow-base:84px;
  --boost:40px;
  --gap:12px;
  --row-h:44px;
}
/* body에는 상단 패딩을 주지 않음(겹침/중첩 회피) */
body{
  margin:0;
  padding-top:0 !important;
  font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background:#121212; color:#eee;
}
/* 컨텐츠 컨테이너에서만 헤더 오프셋 확보 */
main.db-main{
  max-width:1200px;
  margin:16px auto 24px !important;
  padding:calc(var(--topbar-h) + var(--page-offset-extra)) 16px 0 !important; /* top,left/right,bottom */
}
/* 첫 요소 마진 겹침 방지 */
main.db-main > *:first-child{ margin-top:0 !important; }

/* ===== 공통 ===== */
a{ text-decoration:none; color:inherit; }
.card{ background:#1f1f1f; border:1px solid #333; border-radius:10px; }

/* 버튼 */
.btn-primary{ background:#bb0000; color:#fff; border:none; border-radius:8px; font-weight:700; cursor:pointer; padding:10px 12px; }
.btn-primary:hover{ background:#ff4444; }

/* ===== 상단 DB 스위치 ===== */
.db-switch{
  display:flex; justify-content:flex-start; gap:8px;
  padding-bottom:12px; border-bottom:2px solid #bb0000; margin:0 0 12px; background:transparent;
}
.vt-btn{ background:#222; border:1px solid #333; color:#eee; padding:6px 10px; border-radius:6px; cursor:pointer; }
.vt-btn.active{ background:#bb0000; border-color:#bb0000; color:#fff; }
.db-switch .vt-btn{ line-height:1; transition:background .15s, border-color .15s, box-shadow .12s, transform .06s; }
.db-switch .vt-btn.active{ box-shadow: inset 0 2px 0 rgba(255,255,255,.08), inset 0 -2px 0 rgba(0,0,0,.25); transform: translateY(1px); }
.db-switch .vt-btn:active{ transform: translateY(1px); }

/* ===== 필터 ===== */
.filters{ padding:16px; }
.filters-grid{ display:grid; grid-template-columns:1fr 1fr; gap:16px; align-items:stretch; }
.filter-left{ display:block; }
.fbox{ background:#181818; border:1px solid #333; border-radius:10px; padding:0; overflow:hidden; display:grid; grid-template-rows:1fr 1fr 1fr auto; gap:0; }
.subrow{ min-height:var(--subrow-base); display:grid; grid-template-columns:72px 1fr; align-items:center; gap:12px; padding:14px 16px; box-sizing:border-box; }
.fbox .subrow:nth-child(-n+3){ min-height:calc(var(--subrow-base) + var(--boost)); }
.subrow + .subrow{ border-top:1px solid #333; }
.label{ color:#bbb; font-size:13px; }
.checks{ display:flex; flex-wrap:wrap; gap:10px 16px; align-items:center; align-content:center; min-height:100%; }
.checks .chk{ display:flex; align-items:center; gap:6px; font-size:14px; }
.checks input[type="checkbox"]{ width:16px; height:16px; }
.searchline{ display:grid; grid-template-columns:1fr 120px; gap:10px; align-items:center; }
.searchline input[type="text"]{ padding:12px; border-radius:8px; border:1px solid #333; background:#181818; color:#eee; }

/* 오른쪽 비교영역 */
.filter-right{ display:flex; flex-direction:column; gap:var(--gap); }
.sidebox-row{ display:grid; grid-template-columns:1fr 1fr; gap:var(--gap); }
.sidebox{ background:#181818; border:1px solid #333; border-radius:10px; padding:14px 16px; overflow:auto; box-sizing:border-box; min-height:60px; height:100%; transition:.15s border-color,.15s box-shadow; }
.sidebox.selectable{ cursor:pointer; }
.sidebox.selected{ border-color:#bb0000; box-shadow:0 0 0 1px #bb0000 inset; }
.sidebox .slot-head{ font-size:12px; color:#bbb; margin:-4px 0 8px; display:flex; align-items:center; gap:8px; }
.chip{ font-size:11px; padding:2px 8px; border:1px solid #444; border-radius:999px; color:#ccc; }

/* ===== 결과/정렬/뷰 토글 ===== */
.result-bar{ display:flex; flex-wrap:wrap; align-items:center; justify-content:space-between; gap:10px; margin:14px 0 8px; }
.result-info{ color:#bbb; font-size:13px; }
.sort-group{ display:flex; gap:8px; align-items:center; }
.sort-group select{ background:#181818; color:#eee; border:1px solid #333; border-radius:8px; padding:8px; }
.right-controls{ display:flex; align-items:center; gap:12px; }
.page-size select{ background:#181818; color:#eee; border:1px solid #333; border-radius:8px; padding:6px 10px; }
.label-inline{ color:#bbb; font-size:13px; margin-right:6px; }
.view-toggle{ display:flex; gap:6px; }

/* ===== 리스트 뷰 ===== */
.list{ overflow:hidden; }
.thead, .r{ display:grid; grid-template-columns:1fr 1.2fr 44px; }
.thead{ background:#181818; color:#ddd; font-weight:700; user-select:none; }
.thead .c{ padding:10px 14px; border-bottom:1px solid #333; display:flex; align-items:center; gap:8px; min-height:var(--row-h); cursor:pointer; }
.thead .c.no-sort{ cursor:default; }
.r .c{ padding:10px 14px; border-bottom:1px solid #333; display:flex; align-items:center; min-height:var(--row-h); }
.r{ background:#151515; } .r:nth-child(even){ background:#171717; }
.thead .c .arrow{ font-size:11px; color:#aaa; opacity:.6; }
.name-cell{ display:flex; align-items:center; gap:10px; }
.thumb{ width:48px; height:48px; object-fit:contain; border-radius:6px; display:block; }
.thumb--placeholder{ width:48px; height:48px; display:grid; place-items:center; background:#222; border:1px solid #333; border-radius:6px; color:#777; font-weight:700; }
.name-text{ display:inline-block; line-height:1.2; }
.plus-btn{ width:28px; height:28px; border-radius:6px; border:1px solid #444; background:#222; color:#fff; font-size:18px; line-height:26px; text-align:center; cursor:pointer; margin-left:auto; }
.plus-btn:hover{ background:#333; }

/* 상세슬라이드 */
.detail{ grid-column:1 / -1; overflow:hidden; max-height:0; transition:max-height .25s ease; }
.detail-inner{ padding:12px 14px; border-top:1px dashed #333; display:grid; grid-template-columns:1fr 1fr; gap:14px; background:#151515; }
.subsec h4{ margin:0 0 6px; font-size:13px; color:#ffdddd; }
.meta{ color:#bbb; font-size:13px; }
.open .detail{ max-height:240px; }

/* ===== 카드 뷰 ===== */
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

/* ===== 페이징/검색 ===== */
.footerbar{ padding:10px 12px; margin-top:10px; }
.footerline.footer-two{
  display:grid; grid-template-columns: 1fr max-content 1fr;
  align-items:center; column-gap:12px;
}
.pager-center{ grid-column: 2; justify-self: center; display:flex; gap:8px; flex-wrap:wrap; padding:4px 0; }
.page-num{ background:#1b1b1b; border:1px solid #333; color:#eee; border-radius:8px; padding:6px 10px; min-width:36px; line-height:1; cursor:pointer; transition:background .12s, border-color .12s, transform .06s; }
.page-num:hover{ background:#242424; }
.page-num:active{ transform:translateY(1px); }
.page-num:focus-visible{ outline:2px solid #bb0000; outline-offset:2px; }
.page-num.active, .page-num[disabled]{ background:#bb0000; border-color:#bb0000; color:#fff; cursor:default; pointer-events:none; }
.page-ellipsis{ color:#888; padding:0 4px; user-select:none; }
.footerline.footer-two .searchline{ grid-column: 3; justify-self:end; }

/* 반응형 */
@media (max-width:900px){
  .filters-grid{ grid-template-columns:1fr; }
  .sidebox-row{ height:auto!important; }
  .sidebox{ height:auto!important; }
}
.searchline.compact{ display:grid; grid-template-columns: 220px max-content; gap:8px; align-items:center; }
@media (max-width:600px){
  .searchline.compact{ grid-template-columns: 1fr max-content; }
  .footerline.footer-two{ grid-template-columns: 1fr; row-gap:8px; }
  .pager-center{ grid-column:1; justify-self:center; }
  .footerline.footer-two .searchline{ grid-column:1; justify-self:stretch; }
}

/* 비교 슬롯 카드 */
.slot-item { display:flex; gap:10px; align-items:flex-start; }
.side-thumb{ width:40px; height:40px; object-fit:contain; border-radius:6px; background:#222; border:1px solid #333; }
.slot-main{ display:grid; gap:4px; }
.slot-title{ font-weight:800; }
.slot-chips{ display:flex; gap:6px; flex-wrap:wrap; color:#bbb; font-size:12px; }
.slot-spec{ color:#ccc; font-size:13px; line-height:1.4; }
.slot-spec .row{ display:flex; gap:6px; }

/* 상세행 한 줄형 */
.subsec.line{ display:flex; align-items:center; gap:8px; }
.subsec.line h4{ margin:0; font-size:13px; color:#ffdddd; min-width:max-content; }
.subsec.line .meta{ color:#bbb; font-size:13px; }

/* 버튼형 체크 */
.toggle-btn{ padding:8px 14px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:2px solid #555; background:#181818; color:#bbb; transition:.15s all; }
.toggle-btn.active{ border-color:#bb0000; color:#ff4444; }
.toggle-btn:not(.active):hover{ border-color:#777; color:#eee; }
</style>
</head>

<body>
<main class="db-main">
  <!-- 상단 DB 스위치 -->
  <div class="db-switch">
    <a class="vt-btn ${pageActive eq 'item' ? 'active' : ''}"
       href="<c:url value='/itemDB.do'/>" aria-current="${pageActive eq 'item' ? 'page' : ''}">장비DB</a>
    <a class="vt-btn ${pageActive eq 'etc' ? 'active' : ''}"
       href="<c:url value='/etcDB.do'/>" aria-current="${pageActive eq 'etc' ? 'page' : ''}">기타아이템DB</a>
  </div>

  <!-- ===== 필터 ===== -->
  <section class="card filters" aria-label="아이템 필터">
    <div class="filters-grid">
      <!-- 왼쪽: 필터 박스 -->
      <div class="filter-left">
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
              <button type="button" class="toggle-btn" data-value="무기">무기</button>
              <button type="button" class="toggle-btn" data-value="방어구">방어구</button>
              <button type="button" class="toggle-btn" data-value="장신구">장신구</button>
              <button type="button" class="toggle-btn" data-value="부장품">부장품</button>
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

      <!-- 오른쪽: 선택/비교 -->
      <div class="filter-right" id="filterRight">
        <div class="sidebox-row" id="sideTopRow">
          <div class="sidebox selectable selected" id="sideTopA" data-slot="A" title="담을 위치 선택(A)">
            <div class="slot-head">
              <span class="chip">비교 A (기준)</span><span id="slotALabel" style="color:#aaa">비어 있음</span>
            </div>
            <div id="slotA"></div>
          </div>
          <div class="sidebox selectable" id="sideTopB" data-slot="B" title="담을 위치 선택(B)">
            <div class="slot-head">
              <span class="chip">비교 B</span><span id="slotBLabel" style="color:#aaa">비어 있음</span>
            </div>
            <div id="slotB"></div>
          </div>
        </div>
        <div class="sidebox" id="sideBottom" aria-label="스펙 비교 영역">
          <div class="slot-head"><span class="chip">스펙 비교 (A 기준)</span></div>
          <div id="cmpBox" style="color:#aaa; font-size:13px;">A와 B에 아이템을 담으면 비교가 표시됩니다.</div>
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
      <!-- 뷰 토글 -->
      <div class="view-toggle" role="tablist" aria-label="뷰 전환">
        <button id="btnViewList" class="vt-btn active" role="tab" aria-selected="true">리스트형</button>
        <button id="btnViewCard" class="vt-btn" role="tab" aria-selected="false">카드형</button>
      </div>
    </div>
  </div>

  <!-- ===== 리스트 뷰 ===== -->
  <section class="card list" id="listView" aria-label="아이템 목록">
    <div class="thead">
      <div class="c th" data-k="name">아이템 이름 <span class="arrow" id="ar-name">▲▼</span></div>
      <div class="c th" data-k="stats">아이템 능력치</div>
      <div class="c no-sort"></div>
    </div>
    <div id="itemBody">
      <c:if test="${empty itemsList}">
        <div class="r"><div class="c" style="grid-column:1 / -1; color:#aaa;">데이터가 없습니다.</div></div>
      </c:if>

      <c:forEach var="item" items="${itemsList}">
        <%-- 이미지 폴더 결정 --%>
        <c:set var="imgBase" value="weapon"/>
        <c:choose>
          <c:when test="${item.category eq '방어구'}"><c:set var="imgBase" value="armor"/></c:when>
          <c:when test="${item.category eq '장신구'}"><c:set var="imgBase" value="accessory"/></c:when>
          <c:when test="${item.category eq '부장품'}"><c:set var="imgBase" value="subequip"/></c:when>
        </c:choose>
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty item.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/${imgBase}/${fn:escapeXml(item.imgPath)}"/>
        </c:if>

        <div class="r" onclick="toggleDetail(this)"
             data-name="${fn:escapeXml(item.name)}"
             data-minatk="${item.min_ATK}" data-maxatk="${item.max_ATK}"
             data-addatk="${item.add_ATK}" data-accuracy="${item.accuracy}"
             data-critical="${item.critical}" data-quality="${fn:escapeXml(item.quality)}"
             data-category="${fn:escapeXml(item.category)}" data-job="${fn:escapeXml(item.job)}"
             data-obtain="${fn:escapeXml(item.obtain_source)}" data-img="${fn:escapeXml(imgSrc)}">
          <!-- 이름 -->
          <div class="c name-cell">
            <c:choose>
              <c:when test="${not empty imgSrc}">
                <img class="thumb" src="${imgSrc}" alt="${fn:escapeXml(item.name)}" />
              </c:when>
              <c:otherwise><div class="thumb--placeholder">?</div></c:otherwise>
            </c:choose>
            <span class="name-text">${fn:escapeXml(item.name)}</span>
          </div>
          <!-- 능력치 -->
          <div class="c">
            <c:choose>
              <c:when test="${item.min_ATK != 0 || item.max_ATK != 0}">
                ATK ${item.min_ATK} ~ ${item.max_ATK}
                <c:if test="${item.add_ATK != 0}"> / +${item.add_ATK}</c:if>
              </c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </div>
          <!-- + 버튼 -->
          <div class="c">
            <button class="plus-btn" onclick="addToCompare(event, this)">+</button>
          </div>
        </div>

        <!-- 상세 -->
        <div class="detail">
          <div class="detail-inner">
            <%-- 공통 메타 --%>
            <c:if test="${not empty item.quality}">
              <div class="subsec line"><h4>등급</h4><div class="meta">${fn:escapeXml(item.quality)}</div></div>
            </c:if>
            <c:if test="${not empty item.category}">
              <div class="subsec line"><h4>분류</h4><div class="meta">${fn:escapeXml(item.category)}</div></div>
            </c:if>
            <c:if test="${not empty item.job}">
              <div class="subsec line"><h4>직업</h4><div class="meta">${fn:escapeXml(item.job)}</div></div>
            </c:if>
            <c:if test="${not empty item.slot}">
              <div class="subsec line"><h4>장착부위</h4><div class="meta">${fn:escapeXml(item.slot)}</div></div>
            </c:if>
            <c:if test="${not empty item.upgrade and item.upgrade ne 0}">
              <div class="subsec line"><h4>강화</h4><div class="meta">${item.upgrade}</div></div>
            </c:if>

            <%-- 무기 전용 스펙 --%>
            <c:if test="${item.category eq '무기'}">
              <c:if test="${
                  (not empty item.min_ATK and item.min_ATK ne 0) or
                  (not empty item.max_ATK and item.max_ATK ne 0)
                }">
                <div class="subsec line">
                  <h4>공격력</h4>
                  <div class="meta">
                    ${empty item.min_ATK ? 0 : item.min_ATK} ~ ${empty item.max_ATK ? 0 : item.max_ATK}
                    <c:if test="${not empty item.add_ATK and item.add_ATK ne 0}"> / +${item.add_ATK}</c:if>
                  </div>
                </div>
              </c:if>

              <c:if test="${not empty item.accuracy and item.accuracy ne 0}">
                <div class="subsec line"><h4>명중률</h4><div class="meta">${item.accuracy}</div></div>
              </c:if>
              <c:if test="${not empty item.critical and item.critical ne 0}">
                <div class="subsec line"><h4>치명타</h4><div class="meta">${item.critical}</div></div>
              </c:if>

              <c:if test="${
                  (not empty item.job_ATK and item.job_ATK ne 0) or
                  (not empty item.job_ACR and item.job_ACR ne 0) or
                  (not empty item.job_amp and item.job_amp ne 0)
                }">
                <div class="subsec line">
                  <h4>직업 보정</h4>
                  <div class="meta">
                    <c:if test="${not empty item.job_ATK and item.job_ATK ne 0}">ATK ${item.job_ATK}&nbsp;</c:if>
                    <c:if test="${not empty item.job_ACR and item.job_ACR ne 0}">ACR ${item.job_ACR}&nbsp;</c:if>
                    <c:if test="${not empty item.job_amp and item.job_amp ne 0}">증폭 ${item.job_amp}</c:if>
                  </div>
                </div>
              </c:if>

              <c:if test="${
                  (not empty item.skill_ATK and item.skill_ATK ne 0) or
                  (not empty item.skill_ACR and item.skill_ACR ne 0) or
                  (not empty item.skill_amp and item.skill_amp ne 0)
                }">
                <div class="subsec line">
                  <h4>스킬 보정</h4>
                  <div class="meta">
                    <c:if test="${not empty item.skill_ATK and item.skill_ATK ne 0}">ATK ${item.skill_ATK}&nbsp;</c:if>
                    <c:if test="${not empty item.skill_ACR and item.skill_ACR ne 0}">ACR ${item.skill_ACR}&nbsp;</c:if>
                    <c:if test="${not empty item.skill_amp and item.skill_amp ne 0}">증폭 ${item.skill_amp}</c:if>
                  </div>
                </div>
              </c:if>

              <c:if test="${
                  (not empty item.engraveOP1 and not empty item.engravePT1 and item.engravePT1 ne 0) or
                  (not empty item.engraveOP2 and not empty item.engravePT2 and item.engravePT2 ne 0) or
                  (not empty item.engraveOP3 and not empty item.engravePT3 and item.engravePT3 ne 0)
                }">
                <div class="subsec line">
                  <h4>각인 옵션</h4>
                  <div class="meta">
                    <c:if test="${not empty item.engraveOP1 and not empty item.engravePT1 and item.engravePT1 ne 0}">
                      ${fn:escapeXml(item.engraveOP1)} ${item.engravePT1}%&nbsp;
                    </c:if>
                    <c:if test="${not empty item.engraveOP2 and not empty item.engravePT2 and item.engravePT2 ne 0}">
                      ${fn:escapeXml(item.engraveOP2)} ${item.engravePT2}%&nbsp;
                    </c:if>
                    <c:if test="${not empty item.engraveOP3 and not empty item.engravePT3 and item.engravePT3 ne 0}">
                      ${fn:escapeXml(item.engraveOP3)} ${item.engravePT3}%
                    </c:if>
                  </div>
                </div>
              </c:if>

              <c:if test="${not empty item.skill_name}">
                <div class="subsec line"><h4>무기 스킬</h4><div class="meta">${fn:escapeXml(item.skill_name)}</div></div>
              </c:if>
              <c:if test="${not empty item.skill_comment}">
                <div class="subsec line"><h4>스킬 설명</h4><div class="meta">${fn:escapeXml(item.skill_comment)}</div></div>
              </c:if>
            </c:if>

            <%-- 획득처(공통) --%>
            <c:if test="${not empty item.obtain_source}">
              <div class="subsec line"><h4>획득처</h4><div class="meta">${fn:escapeXml(item.obtain_source)}</div></div>
            </c:if>
          </div>
        </div>

      </c:forEach>
    </div>
  </section>

  <!-- ===== 카드 뷰 ===== -->
  <section class="card" id="cardView" aria-label="아이템 카드 목록" style="display:none;">
    <div id="cardGrid" class="item-cards">
      <c:forEach var="item" items="${itemsList}">
        <%-- 이미지 폴더/경로 재사용 --%>
        <c:set var="imgBase" value="weapon"/>
        <c:choose>
          <c:when test="${item.category eq '방어구'}"><c:set var="imgBase" value="armor"/></c:when>
          <c:when test="${item.category eq '장신구'}"><c:set var="imgBase" value="accessory"/></c:when>
          <c:when test="${item.category eq '부장품'}"><c:set var="imgBase" value="subequip"/></c:when>
        </c:choose>
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty item.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/${imgBase}/${fn:escapeXml(item.imgPath)}"/>
        </c:if>

        <div class="item-card"
             data-name="${fn:escapeXml(item.name)}"
             data-minatk="${item.min_ATK}" data-maxatk="${item.max_ATK}"
             data-addatk="${item.add_ATK}" data-accuracy="${item.accuracy}"
             data-critical="${item.critical}" data-quality="${fn:escapeXml(item.quality)}"
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
                  <c:if test="${not empty item.quality}">
                    <span class="chip">${fn:escapeXml(item.quality)}</span>
                  </c:if>
                  <c:if test="${not empty item.category}">
                    <span class="chip">${fn:escapeXml(item.category)}</span>
                  </c:if>
                  <c:if test="${not empty item.job}">
                    <span class="chip">${fn:escapeXml(item.job)}</span>
                  </c:if>
                </div>
              </div>
            </div>
            <button class="plus-btn" onclick="addToCompare(event, this)">+</button>
          </div>

          <div class="ic-body">
            <div class="stat">
              <b>ATK</b>
              <c:choose>
                <c:when test="${item.min_ATK != 0 || item.max_ATK != 0}">
                  ${item.min_ATK} ~ ${item.max_ATK}<c:if test="${item.add_ATK != 0}"> / +${item.add_ATK}</c:if>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </div>
            <c:if test="${item.accuracy != 0}">
              <div class="stat"><b>명중률</b> ${item.accuracy}</div>
            </c:if>
            <c:if test="${item.critical != 0}">
              <div class="stat"><b>치명타</b> ${item.critical}</div>
            </c:if>
            <c:if test="${not empty item.obtain_source}">
              <div class="stat"><b>획득처</b> ${fn:escapeXml(item.obtain_source)}</div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- ===== 하단: 숫자 페이징 + 검색 ===== -->
  <section class="card footerbar" aria-label="페이징/검색">
    <div class="footerline footer-two">
      <div id="pageNums" class="pager-center"></div>
      <div class="searchline compact">
        <input type="text" id="qBottom" placeholder="아이템 이름으로 검색" />
        <button class="btn-primary" id="btnSearchBottom">검색</button>
      </div>
    </div>
  </section>
</main>

<!-- 외부 JS (캐시 버스터 추가) -->
<script src="${contextPath}/resources/js/itemDB.js?v=20250212"></script>
</body>
</html>
