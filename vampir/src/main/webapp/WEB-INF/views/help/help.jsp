<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageActive" value="support"/>
<%@ page session="false"%>
<%
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>고객센터</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <style>
    :root{ --bg:#121212; --ink:#eee; --muted:#9aa0a6; --card:#1f1f1f; --line:#2a2a2a; --accent:#bb0000;
           --ctl-h:40px; --ctl-form-h:42px; --header-h:64px; --center-nudge:-2vw; }
    body{ margin:0; background:var(--bg); color:var(--ink); font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    a{ color:inherit; text-decoration:none; }
    #support-content{ padding-top: calc(var(--header-h) + 12px); scroll-margin-top: calc(var(--header-h) + 12px); }
    .main-wrap{ max-width:1040px; margin:32px auto 72px; padding:0 12px; }
    @media (min-width:1100px){ .main-wrap{ transform: translateX(var(--center-nudge)); } }
    .title-row{ display:flex; align-items:flex-end; justify-content:space-between; gap:12px; margin-bottom:10px; }
    .title-row h1{ font-size:22px; margin:0; }
    .title-row .caption{ color:var(--muted); font-size:13px; }
    .grid{ display:grid; grid-template-columns:1fr 1fr; gap:16px; }
    @media (max-width:980px){ .grid{ grid-template-columns:1fr; } }
    .card{ background:var(--card); border:1px solid rgba(255,255,255,0.07); border-radius:14px; padding:14px; }
    .card h2{ font-size:18px; margin:2px 0 10px; padding-bottom:6px; border-bottom:2px solid rgba(255,0,0,.35); }
    .card .muted{ color:var(--muted); font-size:12px; }
    .grid > .card{ display:flex; flex-direction:column; }
    .grid > .card form{ flex:1; }
    .grid > .card .notice-list{ min-height:120px; }
    .notice-list{ list-style:none; margin:0; padding:0; }
    .notice-list li{ border-top:1px solid var(--line); }
    .notice-list li:first-child{ border-top:none; }
    .notice-item{ display:grid; grid-template-columns:56px 1fr auto; gap:12px; padding:10px 6px; align-items:center; }
    .notice-item .subject{ overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
    .notice-item .date{ color:var(--muted); font-size:12px; }
    .status{ font-size:12px; padding:4px 8px; border-radius:999px; border:1px solid var(--line); background:#191919; }
    .status.done{ color:#9cd89c; border-color:#1f3b1f; background:#0f2a0f; }
    .status.wait{ color:#ffd29c; border-color:#4d3a1f; background:#2a1e0f; }
    details.faq{ border-top:1px solid var(--line); padding:8px 0; }
    details.faq:first-of-type{ border-top:none; }
    details.faq summary{ cursor:pointer; font-weight:600; }
    details.faq .answer{ color:var(--muted); padding:8px 0 0 4px; line-height:1.7; font-size:12px; }
    .form-grid{ display:grid; grid-template-columns:96px 1fr; gap:12px; }
    .form-grid label{ align-self:center; color:#cfcfcf; }
    .form-grid > *:nth-child(2n){ min-width:0; }
    .form-grid input, .form-grid select{
      width:100%; box-sizing:border-box; height:var(--ctl-form-h); line-height:var(--ctl-form-h);
      padding:8px 10px; background:#181818; color:var(--ink); border:1px solid var(--line); border-radius:10px; font-size:14px;
    }
    .form-grid textarea{
      width:100%; min-height:160px; padding:10px 12px; background:#181818; color:#fff;
      border:1px solid var(--line); border-radius:10px; line-height:1.5; resize:vertical; font-size:14px;
    }
    .form-note{ grid-column:1 / -1; color:var(--muted); font-size:12px; margin:2px 0 4px; }
    .secret-inline{ display:flex; align-items:center; gap:8px; }
    .secret-inline input[type="checkbox"]{ width:16px; height:16px; margin:0; }
    .inline-alert{ grid-column:1 / -1; background:#2a1e1e; border:1px solid #6e2a2a; color:#ffb3b3; padding:10px 12px; border-radius:10px; font-size:13px; margin-bottom:4px; }
    .actions{ display:flex; gap:8px; justify-content:flex-end; margin-top:8px; }
    .btn{ padding:8px 12px; border-radius:10px; border:1px solid var(--line); background:#202020; color:#fff; cursor:pointer; }
    .btn.primary{ background:var(--accent); border-color:#700000; }
    table.tickets{ width:100%; border-collapse:collapse; }
    .tickets th, .tickets td{ border-top:1px solid var(--line); padding:10px; text-align:left; font-size:14px; }
    .tickets th{ color:var(--muted); font-weight:500; }
    .tickets .badge-cell{ width:72px; }
    .tickets .badge-cell .status{ display:inline-block; margin-top:2px; }
    .toolbar{
      display:grid; grid-template-columns:160px 1fr auto; gap:8px;
      width:100%; margin:20px 0 14px; padding:14px; background:var(--card); border:1px solid rgba(255,255,255,0.07);
      border-radius:12px; box-sizing:border-box;
    }
    .toolbar select, .toolbar input, .toolbar button{
      height:var(--ctl-h); line-height:var(--ctl-h); background:#181818; color:var(--ink);
      border:1px solid var(--line); border-radius:10px; box-sizing:border-box;
    }
    .toolbar select{ padding:0 12px; }
    .toolbar input{ padding:0 12px; width:100%; }
    .toolbar button{ width:100%; padding:0 12px; background:var(--accent); border:1px solid #700000; cursor:pointer; }
    .toolbar::before, .toolbar::after, .card::before, .card::after{ content:none !important; }
    @media (max-width: 600px){
      .form-grid{ grid-template-columns:1fr; }
      .form-grid label{ margin-top:6px; }
    }
  </style>
</head>
<body>
  <main class="main-wrap" id="support-content">
    <div class="title-row">
      <h1>고객센터</h1>
      <span class="caption">FAQ · QnA · 1:1 문의</span>
    </div>

    <section class="grid">
      <div class="card">
        <h2>내 문의 내역</h2>
        <ul class="notice-list">
          <c:forEach var="t" items="${ticketList}">
            <li>
              <a class="notice-item" href="${contextPath}/help/ticket/view.do?id=${t.id}">
                <span class="status ${t.status eq '완료' ? 'done' : 'wait'}"><c:out value="${t.status}" /></span>
                <span class="subject"><c:out value="${t.title}" /></span>
                <span class="date"><c:out value="${empty t.updatedAt ? t.createdAt : t.updatedAt}" /></span>
              </a>
            </li>
          </c:forEach>
          <c:if test="${empty ticketList}">
            <li class="muted" style="padding:12px 4px;">등록된 문의가 없습니다.</li>
          </c:if>
        </ul>
        <div class="actions" style="margin-top:10px;">
          <a class="btn" href="${contextPath}/help/ticket/list.do">내 문의 전체보기</a>
        </div>

        <h2 style="margin-top:18px;">자주 묻는 질문(FAQ)</h2>
        <div>
          <c:forEach var="f" items="${faqList}">
            <details class="faq">
              <summary>[<c:out value="${f.category}" />] <c:out value="${f.question}" /></summary>
              <div class="answer"><c:out value="${f.answer}" /></div>
            </details>
          </c:forEach>
          <c:if test="${empty faqList}">
            <p class="muted">FAQ가 없습니다. 검색을 이용해보세요.</p>
          </c:if>
        </div>
      </div>

      <div class="card">
        <h2>1:1 문의 보내기</h2>
        <form action="${contextPath}/help/ticket/create.do" method="post">
          <div class="form-grid">
            <c:if test="${not empty inlineError}">
              <div class="inline-alert">${inlineError}</div>
            </c:if>

            <div class="form-note">※ 개인정보(주민번호, 카드번호 등)는 작성하지 마세요.</div>

            <label for="tCat">분류</label>
            <select id="tCat" name="category" required>
              <option value="account" <c:if test="${formCategory eq 'account'}">selected</c:if>>계정/로그인</option>
              <option value="billing" <c:if test="${formCategory eq 'billing'}">selected</c:if>>결제/환불</option>
              <option value="bug"     <c:if test="${formCategory eq 'bug'}">selected</c:if>>버그 제보</option>
              <option value="etc"     <c:if test="${formCategory eq 'etc'}">selected</c:if>>기타</option>
            </select>

            <label for="tTitle">제목</label>
            <input id="tTitle" name="title" type="text" placeholder="문의 제목을 입력하세요"
                   maxlength="100" required value="${fn:escapeXml(formTitle)}"/>

            <label for="tBody">내용</label>
            <textarea id="tBody" name="content" rows="7"
                      placeholder="상세한 상황, 재현 방법, 첨부 필요 파일 등을 적어주세요." required>${fn:escapeXml(formContent)}</textarea>

            <label for="tSecret">비밀글</label>
            <div class="secret-inline">
              <input id="tSecret" type="checkbox" name="secret" value="1"
                     <c:if test="${formSecret eq '1' or formSecret eq 'true' or formSecret eq 'on'}">checked</c:if> />
            </div>
          </div>

          <div class="actions">
            <button type="submit" class="btn primary">문의 등록</button>
          </div>
        </form>
      </div>
    </section>

    <!-- 검색 툴바 -->
    <form class="toolbar" action="${contextPath}/help/search.do" method="get">
      <select name="category">
        <option value="">전체 분류</option>
        <option value="account" <c:if test="${searchCategory eq 'account'}">selected</c:if>>계정/로그인</option>
        <option value="billing" <c:if test="${searchCategory eq 'billing'}">selected</c:if>>결제/환불</option>
        <option value="bug"     <c:if test="${searchCategory eq 'bug'}">selected</c:if>>버그 제보</option>
        <option value="etc"     <c:if test="${searchCategory eq 'etc'}">selected</c:if>>기타</option>
      </select>
      <input type="text" name="q"
             placeholder="무엇을 도와드릴까요? (예: 비밀번호 재설정)"
             value="${empty searchQuery ? param.q : searchQuery}"/>
      <button type="submit">검색</button>
    </form>

    <section class="card">
      <h2>QnA 목록</h2>
      <table class="tickets">
        <thead>
          <tr>
            <th style="width:72px;">상태</th>
            <th>제목</th>
            <th style="width:160px;">등록일</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="q" items="${qnaList}">
            <tr>
              <td class="badge-cell">
                <span class="status ${q.status eq '완료' ? 'done' : 'wait'}">
                  <c:out value="${q.status}" />
                </span>
              </td>
              <td>
                <a href="${contextPath}/help/qna/view.do?id=${q.id}">
                  <!-- 카테고리 배지는 DB를 건드리지 않고 앞에만 붙여 보여줌 -->
                  <c:choose>
                    <c:when test="${q.category eq 'account'}">[계정/로그인] </c:when>
                    <c:when test="${q.category eq 'billing'}">[결제/환불] </c:when>
                    <c:when test="${q.category eq 'bug'}">[버그 제보] </c:when>
                    <c:when test="${q.category eq 'etc'}">[기타] </c:when>
                  </c:choose>
                  <c:out value="${q.title}" />
                </a>
                <c:if test="${not empty q.content}">
                  <div class="muted">
                    ${fn:length(q.content) > 60 ? fn:substring(q.content, 0, 60).concat('...') : q.content}
                  </div>
                </c:if>
              </td>
              <td><c:out value="${q.createdAt}" /></td>
            </tr>
          </c:forEach>
          <c:if test="${empty qnaList}">
            <tr><td colspan="3" class="muted">등록된 QnA가 없습니다.</td></tr>
          </c:if>
        </tbody>
      </table>
    </section>
  </main>
</body>
</html>
