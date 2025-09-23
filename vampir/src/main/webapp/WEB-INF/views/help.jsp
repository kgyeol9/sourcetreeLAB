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
    :root{
      --bg:#121212; --ink:#eee; --muted:#aaa;
      --card:#1f1f1f; --line:#2a2a2a; --accent:#bb0000;
      --ctl-h:40px;          /* 툴바 높이 통일 */
      --header-h:64px;       /* 헤더 실제 높이에 맞게 조정 */
      --center-nudge:-2vw;   /* 헤더 기준 중앙 보정(원하면 0~ -3vw) */
    }

    body{ margin:0; background:var(--bg); color:var(--ink);
          font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    a{ color:inherit; text-decoration:none; }

    /* 헤더에 가리지 않도록 상단 패딩 확보 */
    #support-content{
      padding-top: calc(var(--header-h) + 12px);
      scroll-margin-top: calc(var(--header-h) + 12px);
    }

    .main-wrap{
      max-width:1040px;
      margin:32px auto 72px;    /* 헤더-메인 간격 */
      padding:0 12px;
    }
    @media (min-width:1100px){
      .main-wrap{ transform: translateX(var(--center-nudge)); }
    }

    .title-row{ display:flex; align-items:flex-end; justify-content:space-between; gap:12px; margin-bottom:10px; }
    .title-row h1{ font-size:22px; margin:0; }
    .title-row .caption{ color:var(--muted); font-size:14px; }

    /* Toolbar */
    .toolbar{
      display:grid; grid-template-columns:160px 1fr 92px; gap:8px;
      background:var(--card);
      border:1px solid rgba(255,255,255,0.07);   /* 이중 테두리 방지 */
      border-radius:12px; padding:14px;
      margin:6px auto 16px; max-width:980px;
      box-shadow:none; outline:none;
    }
    .toolbar select, .toolbar input, .toolbar button{
      height:var(--ctl-h); line-height:var(--ctl-h); padding:0 12px;
      background:#181818; color:var(--ink);
      border:1px solid var(--line); border-radius:10px; box-sizing:border-box;
    }
    .toolbar button{ cursor:pointer; background:var(--accent); border-color:#700000; padding:0 16px; }

    /* Grid */
    .grid{ display:grid; grid-template-columns:1.35fr 0.95fr; gap:16px; }
    @media (max-width:980px){ .grid{ grid-template-columns:1fr; } }

    /* Cards */
    .card{
      background:var(--card);
      border:1px solid rgba(255,255,255,0.07);   /* 한 겹만 */
      border-radius:14px; padding:14px;
      box-shadow:none; outline:none;
    }
    .card h2{ font-size:18px; margin:2px 0 10px; padding-bottom:6px; border-bottom:2px solid rgba(255,0,0,.35); }
    .card .muted{ color:var(--muted); font-size:13px; }

    /* 좌우 카드 하단선 맞춤 */
    .grid > .card{ display:flex; flex-direction:column; }
    .grid > .card form{ flex:1; }
    .grid > .card .notice-list{ min-height:120px; }

    /* Notice list */
    .notice-list{ list-style:none; margin:0; padding:0; }
    .notice-list li{ border-top:1px solid var(--line); }
    .notice-list li:first-child{ border-top:none; }
    .notice-item{
      display:grid; grid-template-columns:56px 1fr auto; gap:12px;
      padding:10px 6px; align-items:center;
    }
    .notice-item .tag{ font-size:12px; color:#ffcccc; border:1px solid #5a0000; background:#2a0000; padding:4px 8px; border-radius:999px; text-align:center; }
    .notice-item .subject{ overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
    .notice-item .date{ color:var(--muted); font-size:12px; }

    /* FAQ */
    details.faq{ border-top:1px solid var(--line); padding:8px 0; }
    details.faq:first-of-type{ border-top:none; }
    details.faq summary{ cursor:pointer; font-weight:600; }
    details.faq .answer{ color:var(--muted); padding:8px 0 0 4px; line-height:1.7; }

    /* Form */
    .form-grid{ display:grid; grid-template-columns:120px 1fr; gap:10px; }
    .form-grid label{ align-self:center; color:#cfcfcf; }

    /* 입력 폭 넘침 방지 */
    .form-grid > *:nth-child(2n){ min-width:0; }
    .form-grid input, .form-grid select{
      width:100%; max-width:100%; box-sizing:border-box; display:block;
      height:38px; padding:8px 10px; background:#181818; color:var(--ink);
      border:1px solid var(--line); border-radius:10px;
    }
    .form-grid textarea{
      width:100%; max-width:100%; box-sizing:border-box; display:block;
      min-height:140px; padding:10px 12px; background:#181818; color:var(--ink);
      border:1px solid var(--line); border-radius:10px; line-height:1.5; resize:vertical;
    }

    .actions{ display:flex; gap:8px; justify-content:flex-end; margin-top:8px; }
    .btn{ padding:8px 12px; border-radius:10px; border:1px solid var(--line); background:#202020; color:#fff; cursor:pointer; }
    .btn.primary{ background:var(--accent); border-color:#700000; }

    /* Tickets */
    table.tickets{ width:100%; border-collapse:collapse; }
    .tickets th, .tickets td{ border-top:1px solid var(--line); padding:10px; text-align:left; font-size:14px; }
    .tickets th{ color:var(--muted); font-weight:500; }
    .status{ font-size:12px; padding:4px 8px; border-radius:999px; border:1px solid var(--line); background:#191919; }
    .status.done{ color:#9cd89c; border-color:#1f3b1f; background:#0f2a0f; }
    .status.wait{ color:#ffd29c; border-color:#4d3a1f; background:#2a1e0f; }

    .help{ color:var(--muted); font-size:12px; margin-top:6px; }

    /* 혹시 테마에서 ::before/::after로 윤곽 또 그리면 무력화 */
    .toolbar::before, .toolbar::after,
    .card::before, .card::after{ content:none !important; }
  </style>
</head>
<body>
  <!-- 레이아웃의 #content와 id 충돌 방지 -->
  <main class="main-wrap" id="support-content">
    <div class="title-row">
      <h1>고객센터</h1>
      <span class="caption">FAQ · 공지사항 · 1:1 문의</span>
    </div>

    <!-- 상단 툴바 -->
    <form class="toolbar" action="${contextPath}/support/search.do" method="get">
      <select name="category">
        <option value="">전체 카테고리</option>
        <option value="account">계정/로그인</option>
        <option value="billing">결제/환불</option>
        <option value="bug">버그 제보</option>
        <option value="etc">기타</option>
      </select>
      <input type="text" name="q" placeholder="무엇을 도와드릴까요? (예: 비밀번호 재설정)" value="${param.q}"/>
      <button type="submit">검색</button>
    </form>

    <section class="grid">
      <!-- 좌측: 공지 + FAQ -->
      <div class="card">
        <h2>공지사항</h2>
        <ul class="notice-list">
          <c:forEach var="n" items="${noticeList}">
            <li>
              <a class="notice-item" href="${contextPath}/notice/view.do?id=${n.id}">
                <span class="tag"><c:out value="${n.category}" /></span>
                <span class="subject"><c:out value="${n.title}" /></span>
                <span class="date"><c:out value="${n.createdAt}" /></span>
              </a>
            </li>
          </c:forEach>
          <c:if test="${empty noticeList}">
            <li class="muted" style="padding:12px 4px;">등록된 공지가 없습니다.</li>
          </c:if>
        </ul>
        <div class="actions" style="margin-top:10px;">
          <a class="btn" href="${contextPath}/notice/list.do">공지 더보기</a>
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

      <!-- 우측: 1:1 문의 -->
      <div class="card">
        <h2>1:1 문의 보내기</h2>
        <form action="${contextPath}/support/ticket/create.do" method="post">
          <div class="form-grid">
            <label for="tCat">카테고리</label>
            <select id="tCat" name="category" required>
              <option value="account">계정/로그인</option>
              <option value="billing">결제/환불</option>
              <option value="bug">버그 제보</option>
              <option value="etc">기타</option>
            </select>

            <label for="tEmail">회신 이메일</label>
            <input id="tEmail" name="email" type="email" placeholder="example@domain.com" required />

            <label for="tTitle">제목</label>
            <input id="tTitle" name="title" type="text" placeholder="문의 제목을 입력하세요" maxlength="100" required />

            <label for="tBody">내용</label>
            <textarea id="tBody" name="content" rows="7" placeholder="상세한 상황, 재현 방법, 첨부 필요 파일 등을 적어주세요." required></textarea>
          </div>
          <div class="help">※ 개인정보(주민번호, 카드번호 등)는 작성하지 마세요.</div>
          <div class="actions">
            <button type="reset" class="btn">초기화</button>
            <button type="submit" class="btn primary">문의 등록</button>
          </div>
        </form>
      </div>
    </section>

    <!-- 하단: 내 문의 내역 -->
    <section class="card" style="margin-top:16px;">
      <h2>내 문의 내역</h2>
      <table class="tickets">
        <thead>
          <tr>
            <th style="width:88px;">상태</th>
            <th>제목</th>
            <th style="width:160px;">등록일</th>
            <th style="width:160px;">최종 업데이트</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="t" items="${ticketList}">
            <tr>
              <td>
                <span class="status ${t.status == '답변완료' ? 'done' : 'wait'}">
                  <c:out value="${t.status}" />
                </span>
              </td>
              <td>
                <a href="${contextPath}/support/ticket/view.do?id=${t.id}">
                  <c:out value="${t.title}" />
                </a>
                <div class="muted">${fn:length(t.content) > 60 ? fn:substring(t.content, 0, 60).concat('...') : t.content}</div>
              </td>
              <td><c:out value="${t.createdAt}" /></td>
              <td><c:out value="${t.updatedAt}" /></td>
            </tr>
          </c:forEach>
          <c:if test="${empty ticketList}">
            <tr><td colspan="4" class="muted">등록된 문의가 없습니다.</td></tr>
          </c:if>
        </tbody>
      </table>
    </section>
  </main>
</body>
</html>
