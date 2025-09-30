<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>새소식</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{--bg:#0e0e0f;--ink:#e9e9ea;--muted:#9a9aa0;--card:#161618;--line:#26262a;--accent:#bb0000;--header-h:64px;--maxw:980px;}
    body{margin:0;background:var(--bg);color:var(--ink);}
    /* ▲ 10px 위로: 58px → 48px */
    .main{max-width:var(--maxw);margin:0 auto 72px;padding:calc(var(--header-h) + 48px) 16px 24px;}
    .row{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;}
    .btn{display:inline-flex;align-items:center;justify-content:center;height:36px;padding:0 12px;border-radius:10px;border:1px solid var(--line);background:#1b1b1f;color:#fff;text-decoration:none}
    .btn.primary{background:var(--accent);border-color:#5a0000}
    .tabs{display:flex;gap:8px;margin:10px 0 12px}
    .tab{padding:8px 12px;border-radius:999px;border:1px solid var(--line);background:#1a1a1a;color:#9a9aa0;text-decoration:none}
    .tab.active{background:#2a0000;border-color:#5a0000;color:#ffd6d6}
    .toolbar{display:grid;grid-template-columns:1fr 92px;gap:8px;background:var(--card);border:1px solid var(--line);border-radius:12px;padding:12px;margin-bottom:12px}
    .toolbar input,.toolbar button{height:40px;padding:0 12px;border-radius:10px;border:1px solid var(--line);background:#181818;color:#fff}
    .toolbar button{background:var(--accent);border-color:#5a0000}
    .list{display:grid;gap:10px}
    .item{display:grid;grid-template-columns:1fr auto;gap:12px;align-items:center;background:var(--card);border:1px solid var(--line);border-radius:12px;padding:14px}
    .title{font-weight:800;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
    .meta{color:var(--muted);font-size:12px;margin-top:4px}
    .actions{display:flex;gap:8px}
  </style>
</head>
<body>
  <main class="main">
    <div class="row">
      <h2 style="margin:0">새소식</h2>
      <a class="btn primary" href="${ctx}/news/writeForm.do">작성하기</a>
    </div>

    <!-- 탭 -->
    <c:set var="t" value="${empty param.type ? type : param.type}" />
    <nav class="tabs">
      <a class="tab ${empty t ? 'active' : ''}" href="${ctx}/news/list.do?q=${fn:escapeXml(param.q)}">전체</a>
      <a class="tab ${t=='notice'?'active':''}" href="${ctx}/news/list.do?type=notice&q=${fn:escapeXml(param.q)}">공지사항</a>
      <a class="tab ${t=='update'?'active':''}" href="${ctx}/news/list.do?type=update&q=${fn:escapeXml(param.q)}">업데이트</a>
      <a class="tab ${t=='devnote'?'active':''}" href="${ctx}/news/list.do?type=devnote&q=${fn:escapeXml(param.q)}">개발자노트</a>
    </nav>

    <!-- 검색 -->
    <form class="toolbar" action="${ctx}/news/list.do" method="get">
      <input type="hidden" name="type" value="${fn:escapeXml(t)}" />
      <input type="text" name="q" placeholder="제목으로 검색" value="${fn:escapeXml(param.q)}" />
      <button type="submit">검색</button>
    </form>

    <!-- 목록 -->
    <section class="list">
      <c:forEach var="n" items="${newsList}">
        <article class="item">
          <div>
            <div class="title"><a href="${ctx}/news/view.do?articleNO=${n.articleNO}" style="color:#fff;text-decoration:none"><c:out value="${n.title}" /></a></div>
            <div class="meta">
              <span>
                <c:choose>
                  <c:when test="${not empty n.writedate}">
                    <fmt:formatDate value="${n.writedate}" pattern="yyyy-MM-dd HH:mm"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </span>
              <c:if test="${not empty n.id}"> · <span>작성자 <c:out value="${n.id}" /></span></c:if>
            </div>
          </div>
          <div class="actions">
            <a class="btn" href="${ctx}/news/view.do?articleNO=${n.articleNO}">자세히</a>
            <a class="btn" href="${ctx}/news/editForm.do?articleNO=${n.articleNO}">수정</a>
            <form action="${ctx}/news/delete.do" method="post" onsubmit="return confirm('삭제할까요?');" style="display:inline">
              <input type="hidden" name="articleNO" value="${n.articleNO}">
              <button type="submit" class="btn" style="background:#2a0000;border-color:#5a0000">삭제</button>
            </form>
          </div>
        </article>
      </c:forEach>

      <c:if test="${empty newsList}">
        <div style="color:#9a9aa0;background:#161618;border:1px solid #26262a;border-radius:12px;padding:24px;text-align:center">
          등록된 새소식이 없습니다.
        </div>
      </c:if>
    </section>

    <!-- 페이징 -->
    <c:if test="${totalPages > 0}">
      <div style="display:flex;justify-content:center;gap:6px;margin-top:16px">
        <c:set var="prev" value="${page-1}" />
        <c:set var="next" value="${page+1}" />
        <c:if test="${page > 1}">
          <a class="btn" href="${ctx}/news/list.do?page=${prev}&size=${size}&type=${fn:escapeXml(t)}&q=${fn:escapeXml(param.q)}">이전</a>
        </c:if>
        <c:forEach var="p" begin="1" end="${totalPages}">
          <c:choose>
            <c:when test="${p == page}">
              <span class="btn" style="background:var(--accent);border-color:#5a0000">${p}</span>
            </c:when>
            <c:otherwise>
              <a class="btn" href="${ctx}/news/list.do?page=${p}&size=${size}&type=${fn:escapeXml(t)}&q=${fn:escapeXml(param.q)}">${p}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>
        <c:if test="${page < totalPages}">
          <a class="btn" href="${ctx}/news/list.do?page=${next}&size=${size}&type=${fn:escapeXml(t)}&q=${fn:escapeXml(param.q)}">다음</a>
        </c:if>
      </div>
    </c:if>
  </main>
</body>
</html>
