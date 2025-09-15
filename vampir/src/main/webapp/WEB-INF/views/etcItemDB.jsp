<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
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
<link rel="stylesheet" href="${contextPath}/resources/css/itemDB.css?v=20250212">
</head>
<body>
<main class="db-main">
  <h2 class="page-title">기타 아이템 DB</h2>

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
      <!-- 오른쪽: 비교 영역 제거 -->
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
      <div class="c th" data-k="stats">아이템 설명</div>
      <div class="c no-sort"></div>
    </div>
    <div id="itemBody">
      <c:if test="${empty itemsList}">
        <div class="r"><div class="c" style="grid-column:1 / -1; color:#aaa;">데이터가 없습니다.</div></div>
      </c:if>

      <c:forEach var="item" items="${itemsList}">
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty item.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/etc/${fn:escapeXml(item.imgPath)}"/>
        </c:if>

        <div class="r" onclick="toggleDetail(this)"
             data-name="${fn:escapeXml(item.name)}"
             data-category="${fn:escapeXml(item.category)}"
             data-quality="${fn:escapeXml(item.quality)}"
             data-obtain="${fn:escapeXml(item.obtain_source)}"
             data-img="${fn:escapeXml(imgSrc)}">
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
          <!-- 설명 -->
          <div class="c">
            <c:out value="${fn:escapeXml(item.description)}"/>
          </div>
          <!-- placeholder -->
          <div class="c"></div>
        </div>

        <!-- 상세 -->
        <div class="detail">
          <div class="detail-inner">
            <c:if test="${not empty item.quality}">
              <div class="subsec line"><h4>등급</h4><div class="meta">${fn:escapeXml(item.quality)}</div></div>
            </c:if>
            <c:if test="${not empty item.category}">
              <div class="subsec line"><h4>분류</h4><div class="meta">${fn:escapeXml(item.category)}</div></div>
            </c:if>
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
        <c:set var="imgSrc" value=""/>
        <c:if test="${not empty item.imgPath}">
          <c:set var="imgSrc" value="${contextPath}/resources/image/etc/${fn:escapeXml(item.imgPath)}"/>
        </c:if>

        <div class="item-card"
             data-name="${fn:escapeXml(item.name)}"
             data-category="${fn:escapeXml(item.category)}"
             data-quality="${fn:escapeXml(item.quality)}"
             data-obtain="${fn:escapeXml(item.obtain_source)}"
             data-img="${fn:escapeXml(imgSrc)}">
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
                </div>
              </div>
            </div>
          </div>

          <div class="ic-body">
            <c:if test="${not empty item.description}">
              <div class="stat"><b>설명</b> ${fn:escapeXml(item.description)}</div>
            </c:if>
            <c:if test="${not empty item.obtain_source}">
              <div class="stat"><b>획득처</b> ${fn:escapeXml(item.obtain_source)}</div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- ===== 하단: 페이징 + 검색 ===== -->
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

<!-- 외부 JS -->
<script src="${contextPath}/resources/js/itemDB.js?v=20250212"></script>
</body>
</html>
