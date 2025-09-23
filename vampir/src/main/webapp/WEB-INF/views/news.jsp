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
  <title>새소식</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{
      --bg:#121212; --ink:#eee; --muted:#aaa; --card:#1f1f1f; --line:#2a2a2a; --accent:#bb0000;
      --ctl-h:40px;         /* 툴바 높이 */
      --header-h:64px;      /* 고정 헤더 높이에 맞게 조정 */
    }
    body{ margin:0; background:var(--bg); color:var(--ink); font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    a{ color:inherit; text-decoration:none; }

    /* 메인(헤더 가림 방지 패딩) */
    .main-wrap{ max-width:1040px; margin:32px auto 72px; padding:0 12px; }
    #news-content{ padding-top: calc(var(--header-h) + 12px); }

    .title-row{ display:flex; align-items:flex-end; justify-content:space-between; gap:12px; margin-bottom:10px; }
    .title-row h1{ font-size:22px; margin:0; }
    .breadcrumbs{ color:var(--muted); font-size:14px; }

    /* 툴바 */
    .toolbar{
      display:grid; grid-template-columns:160px 160px 1fr 92px; gap:8px;
      background:var(--card);
      border:1px solid rgba(255,255,255,0.07); border-radius:12px;
      padding:14px; margin:6px auto 16px; max-width:980px;
      box-shadow:none; outline:none;
    }
    .toolbar select, .toolbar input, .toolbar button{
      height:var(--ctl-h); line-height:var(--ctl-h); padding:0 12px;
      background:#181818; color:var(--ink);
      border:1px solid var(--line); border-radius:10px; box-sizing:border-box;
    }
    .toolbar button{ cursor:pointer; background:var(--accent); border-color:#700000; padding:0 16px; }

    /* 탭 */
    .tabs{ display:flex; gap:8px; margin:10px 0 14px; }
    .tab{ padding:8px 12px; border-radius:999px; border:1px solid var(--line); background:#1a1a1a; font-size:14px; color:var(--muted); }
    .tab.active{ background:#2a0000; border-color:#5a0000; color:#ffd6d6; }

    /* 리스트 */
    .list{ display:grid; grid-template-columns:1fr; gap:12px; }
    .item{
      display:grid; grid-template-columns:84px 1fr auto; gap:12px; align-items:center;
      background:var(--card); border:1px solid rgba(255,255,255,0.07); border-radius:12px; padding:14px;
    }
    .item .badge{ font-size:12px; padding:6px 10px; border-radius:999px; background:#2a0000; border:1px solid #5a0000; color:#ffcccc; text-align:center; }
    .item .title{ font-weight:700; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
    .item .meta{ color:var(--muted); font-size:12px; }
    .item .btn{ padding:8px 12px; border-radius:10px; border:1px solid var(--line); background:#202020; color:var(--ink); }
    .item .btn.primary{ background:var(--accent); border-color:#700000; }

    /* empty */
    .empty{ color:var(--muted); background:var(--card); border:1px solid rgba(255,255,255,0.07); border-radius:12px; padding:24px; text-align:center; }

    /* 하이라이트(최신) */
    .highlight{ background:linear-gradient(180deg, rgba(255,0,0,0.06), transparent), var(--card);
                border:1px solid rgba(255,255,255,0.09); border-radius:14px; padding:16px; margin:10px 0 16px; }
    .highlight h2{ font-size:18px; margin:0 0 6px; }
    .highlight .desc{ color:var(--muted); font-size:14px; }

    /* 페이지네이션 */
    .pager{ display:flex; justify-content:center; align-items:center; gap:6px; margin-top:16px; }
    .pager a, .pager span{
      min-width:34px; height:34px; display:flex; align-items:center; justify-content:center;
      border-radius:8px; border:1px solid var(--line); background:#181818; color:var(--ink); padding:0 8px;
    }
    .pager .active{ background:var(--accent); border-color:#700000; }
  </style>
</head>
<body>
  <main class="main-wrap" id="news-content">
    <div class="title-row">
      <h1>새소식</h1>
      <span class="breadcrumbs">공지사항 · 업데이트 · 개발자노트</span>
    </div>

    <!-- 상단 툴바: 유형/정렬 + 검색 -->
    <form class="toolbar" action="${contextPath}/news/list.do" method="get">
      <select name="type" aria-label="유형">
        <option value="">전체 유형</option>
        <option value="notice" ${param.type == 'notice' ? 'selected' : ''}>공지사항</option>
        <option value="update" ${param.type == 'update' ? 'selected' : ''}>업데이트</option>
        <option value="devnote" ${param.type == 'devnote' ? 'selected' : ''}>개발자노트</option>
      </select>

      <select name="sort" aria-label="정렬">
        <option value="recent" ${param.sort == 'recent' ? 'selected' : ''}>최신순</option>
        <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>인기순</option>
        <option value="comment" ${param.sort == 'comment' ? 'selected' : ''}>댓글많은순</option>
      </select>

      <input type="text" name="q" placeholder="키워드로 검색 (예: 점검, 이벤트, 패치)" value="${fn:escapeXml(param.q)}" />
      <button type="submit">검색</button>
    </form>

    <!-- 최신 하이라이트(선택) -->
    <c:if test="${not empty latest}">
      <section class="highlight">
        <h2>[<c:out value="${latest.typeLabel}" />]
          <a href="${contextPath}/news/view.do?id=${latest.id}"><c:out value="${latest.title}" /></a>
        </h2>
        <div class="desc">
          <span class="meta">게시일: <c:out value="${latest.createdAt}" /></span>
          <c:if test="${not empty latest.summary}"> · <c:out value="${latest.summary}" /></c:if>
        </div>
      </section>
    </c:if>

    <!-- 카테고리 탭 -->
    <nav class="tabs" aria-label="카테고리">
      <a class="tab ${empty param.type ? 'active' : ''}" href="${contextPath}/news/list.do">전체</a>
      <a class="tab ${param.type == 'notice' ? 'active' : ''}" href="${contextPath}/news/list.do?type=notice">공지사항</a>
      <a class="tab ${param.type == 'update' ? 'active' : ''}" href="${contextPath}/news/list.do?type=update">업데이트</a>
      <a class="tab ${param.type == 'devnote' ? 'active' : ''}" href="${contextPath}/news/list.do?type=devnote">개발자노트</a>
    </nav>

    <!-- 리스트 -->
    <c:choose>
      <c:when test="${not empty newsList}">
        <section class="list">
          <c:forEach var="n" items="${newsList}">
            <article class="item">
              <span class="badge"><c:out value="${n.typeLabel}" /></span>
              <div>
                <div class="title">
                  <a href="${contextPath}/news/view.do?id=${n.id}"><c:out value="${n.title}" /></a>
                </div>
                <div class="meta">
                  <span>게시일 <c:out value="${n.createdAt}" /></span>
                  <c:if test="${not empty n.author}"> · <span>작성 <c:out value="${n.author}" /></span></c:if>
                  <c:if test="${not empty n.views}"> · <span>조회 <c:out value="${n.views}" /></span></c:if>
                </div>
              </div>
              <a class="btn" href="${contextPath}/news/view.do?id=${n.id}">자세히</a>
            </article>
          </c:forEach>
        </section>

        <!-- 페이징 -->
        <c:if test="${not empty page}">
          <div class="pager">
            <c:if test="${page.hasPrev}">
              <a href="${contextPath}/news/list.do?page=${page.prev}&#38;type=${param.type}&#38;q=${fn:escapeXml(param.q)}&#38;sort=${param.sort}">이전</a>
            </c:if>
            <c:forEach var="p" begin="${page.start}" end="${page.end}">
              <a class="${p == page.current ? 'active' : ''}" href="${contextPath}/news/list.do?page=${p}&#38;type=${param.type}&#38;q=${fn:escapeXml(param.q)}&#38;sort=${param.sort}">${p}</a>
            </c:forEach>
            <c:if test="${page.hasNext}">
              <a href="${contextPath}/news/list.do?page=${page.next}&#38;type=${param.type}&#38;q=${fn:escapeXml(param.q)}&#38;sort=${param.sort}">다음</a>
            </c:if>
          </div>
        </c:if>
      </c:when>
      <c:otherwise>
        <div class="empty">등록된 새소식이 없습니다.</div>
      </c:otherwise>
    </c:choose>
  </main>
</body>
</html>
