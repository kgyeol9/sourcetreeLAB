<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
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
      --ctl-h:40px; --header-h:64px;
    }
    body{ margin:0; background:var(--bg); color:var(--ink); font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    a{ color:inherit; text-decoration:none; }

    .main-wrap{ max-width:1040px; margin:32px auto 72px; padding:0 12px; }
    #news-content{ padding-top: calc(var(--header-h) + 12px); }

    .title-row{ display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:10px; }
    .title-row h1{ font-size:22px; margin:0; }
    .breadcrumbs{ color:var(--muted); font-size:14px; }

    .btn{
      display:inline-flex; align-items:center; justify-content:center;
      height:36px; padding:0 12px; border-radius:10px; border:1px solid var(--line);
      background:#202020; color:var(--ink); cursor:pointer; text-decoration:none;
    }
    .btn.primary{ background:var(--accent); border-color:#700000; color:#fff; }
    .btn.danger{ background:#2a0000; border-color:#5a0000; }

    .toolbar{
      display:grid; grid-template-columns:1fr 92px; gap:8px;
      background:var(--card);
      border:1px solid rgba(255,255,255,0.07); border-radius:12px;
      padding:14px; margin:6px auto 12px; max-width:980px;
    }
    .toolbar input, .toolbar button{
      height:var(--ctl-h); line-height:var(--ctl-h); padding:0 12px;
      background:#181818; color:var(--ink);
      border:1px solid var(--line); border-radius:10px; box-sizing:border-box;
    }
    .toolbar button{ cursor:pointer; background:var(--accent); border-color:#700000; padding:0 16px; color:#fff; }

    .tabs{ display:flex; gap:8px; margin:10px 0 16px; overflow:auto; }
    .tab{
      padding:8px 12px; border-radius:999px; border:1px solid var(--line);
      background:#1a1a1a; font-size:14px; color:#aaa; white-space:nowrap; text-decoration:none;
    }
    .tab.active{ background:#2a0000; border-color:#5a0000; color:#ffd6d6; }

    .list{ display:grid; grid-template-columns:1fr; gap:12px; }
    .item{
      display:grid; grid-template-columns:1fr auto; gap:12px; align-items:center;
      background:var(--card); border:1px solid rgba(255,255,255,0.07); border-radius:12px; padding:14px;
    }
    .item .title{ font-weight:700; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
    .item .meta{ color:var(--muted); font-size:12px; margin-top:4px; }
    .actions{ display:flex; gap:8px; }
    .actions form{ display:inline; margin:0; }

    .empty{ color:var(--muted); background:var(--card); border:1px solid rgba(255,255,255,0.07); border-radius:12px; padding:24px; text-align:center; }

    .pager{ display:flex; justify-content:center; align-items:center; gap:6px; margin-top:16px; }
    .pager a, .pager span{
      min-width:34px; height:34px; display:flex; align-items:center; justify-content:center;
      border-radius:8px; border:1px solid var(--line); background:#181818; color:#fff; padding:0 8px;
      text-decoration:none;
    }
    .pager .active{ background:var(--accent); border-color:#700000; }
  </style>
</head>
<body>
  <main class="main-wrap" id="news-content">
    <div class="title-row">
      <div>
        <h1>새소식</h1>
        <span class="breadcrumbs">공지 · 업데이트 · 개발자 노트</span>
      </div>
      <div>
        <a href="${contextPath}/news/writeForm.do" class="btn primary">작성하기</a>
      </div>
    </div>

    <!-- 탭 -->
    <c:set var="t" value="${empty param.type ? type : param.type}" />
    <nav class="tabs" aria-label="카테고리" role="tablist">
      <a class="tab ${empty t ? 'active' : ''}" href="${contextPath}/news/list.do?q=${fn:escapeXml(param.q)}">전체</a>
      <a class="tab ${t == 'notice' ? 'active' : ''}" href="${contextPath}/news/list.do?type=notice&q=${fn:escapeXml(param.q)}">공지사항</a>
      <a class="tab ${t == 'update' ? 'active' : ''}" href="${contextPath}/news/list.do?type=update&q=${fn:escapeXml(param.q)}">업데이트</a>
      <a class="tab ${t == 'devnote' ? 'active' : ''}" href="${contextPath}/news/list.do?type=devnote&q=${fn:escapeXml(param.q)}">개발자노트</a>
    </nav>

    <!-- 검색 -->
    <form class="toolbar" action="${contextPath}/news/list.do" method="get">
      <input type="hidden" name="type" value="${fn:escapeXml(t)}" />
      <input type="text" name="q" placeholder="제목에 포함된 키워드로 검색" value="${fn:escapeXml(param.q)}" />
      <button type="submit">검색</button>
    </form>

    <!-- 목록 -->
    <section class="list">
      <c:forEach var="n" items="${newsList}">
        <article class="item">
          <div>
            <div class="title">
              <a href="${contextPath}/news/view.do?articleNO=${n.articleNO}">
                <c:out value="${n.title}" />
              </a>
            </div>
            <div class="meta">
              <span>작성일 <fmt:formatDate value="${n.writedate}" pattern="yyyy-MM-dd HH:mm" /></span>
              <c:if test="${not empty n.id}"> · <span>작성자 <c:out value="${n.id}" /></span></c:if>
            </div>
          </div>
          <div class="actions">
            <a class="btn" href="${contextPath}/news/view.do?articleNO=${n.articleNO}">자세히</a>
            <a class="btn" href="${contextPath}/news/editForm.do?articleNO=${n.articleNO}">수정</a>
            <form action="${contextPath}/news/delete.do" method="post" onsubmit="return confirm('삭제할까요?');">
              <input type="hidden" name="articleNO" value="${n.articleNO}">
              <button type="submit" class="btn danger">삭제</button>
            </form>
          </div>
        </article>
      </c:forEach>

      <c:if test="${empty newsList}">
        <div class="empty">등록된 새소식이 없습니다.</div>
      </c:if>
    </section>

    <!-- 페이징 -->
    <c:if test="${totalPages > 0}">
      <div class="pager">
        <c:set var="prev" value="${page-1}" />
        <c:set var="next" value="${page+1}" />
        <c:if test="${page > 1}">
          <a href="${contextPath}/news/list.do?page=${prev}&size=${size}&type=${fn:escapeXml(t)}&q=${fn:escapeXml(param.q)}">이전</a>
        </c:if>
        <c:forEach var="p" begin="1" end="${totalPages}">
          <c:choose>
            <c:when test="${p == page}"><span class="active">${p}</span></c:when>
            <c:otherwise>
              <a href="${contextPath}/news/list.do?page=${p}&size=${size}&type=${fn:escapeXml(t)}&q=${fn:escapeXml(param.q)}">${p}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>
        <c:if test="${page < totalPages}">
          <a href="${contextPath}/news/list.do?page=${next}&size=${size}&type=${fn:escapeXml(t)}&q=${fn:escapeXml(param.q)}">다음</a>
        </c:if>
      </div>
    </c:if>
  </main>
</body>
</html>
