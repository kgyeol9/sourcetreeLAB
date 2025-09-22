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
<title>아이템 DB</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/itemDB.css">
<style>


</style>
</head>
<body>
<main class="db-main">
  <h2 class="page-title">아이템 DB</h2>

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
            <c:if test="${not empty item.obtain_source}}">
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
