<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title><c:out value="${empty news ? '새소식' : news.title}" /> | 새소식</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    :root{ --bg:#0e0e0f; --surface:#161618; --ink:#e9e9ea; --muted:#9a9aa0; --line:#26262a;
           --accent:#bb0000; --accent-2:#5a0000; --radius:14px; --header-h:64px; --maxw:980px;}
    body{background:var(--bg);color:var(--ink);margin:0;}
    .wrap{max-width:var(--maxw);margin:0 auto 72px;padding:calc(var(--header-h) + 18px) 16px 24px;}
    .article{background:var(--surface);border:1px solid var(--line);border-radius:var(--radius);padding:24px;}
    .title{font-size:28px;line-height:1.3;margin:0 0 10px;font-weight:800;word-break:keep-all;}
    .meta{color:var(--muted);font-size:14px;display:flex;gap:10px;flex-wrap:wrap;margin-bottom:18px;}
    .meta .dot{width:4px;height:4px;border-radius:999px;background:#444;display:inline-block;}
    .content{line-height:1.75;font-size:16px;word-wrap:break-word;overflow-wrap:anywhere;}
    .content pre{white-space:pre-wrap;background:none;border:none;padding:0;margin:0;font:inherit;color:inherit;}
    .hr{margin:18px 0;height:1px;background:linear-gradient(90deg,transparent,#2a2a2e,transparent);border:0;}
    .actions{display:flex;gap:10px;margin-top:20px;flex-wrap:wrap;}
    .btn{display:inline-flex;align-items:center;justify-content:center;height:38px;padding:0 14px;border-radius:10px;
         border:1px solid var(--line);background:#1b1b1f;color:#fff;text-decoration:none;cursor:pointer;}
    .btn.primary{background:var(--accent);border-color:var(--accent-2);}
    .btn.danger{background:#2a0000;border-color:#520000;}
    .btn.ghost{background:transparent;}
    @media (max-width:560px){.wrap{padding:calc(var(--header-h) + 12px) 12px 24px;}.title{font-size:22px;}}
  </style>
</head>
<body>
  <main class="wrap">
    <article class="article">
      <c:choose>
        <c:when test="${empty news}">
          <h1 class="title">게시글을 찾을 수 없습니다.</h1>
          <div class="actions"><a class="btn ghost" href="${ctx}/news/list.do">목록</a></div>
        </c:when>
        <c:otherwise>
          <h1 class="title"><c:out value="${news.title}" /></h1>
          <div class="meta">
            <span>글번호 <strong><c:out value="${news.articleNO}" /></strong></span>
            <span class="dot"></span>
            <span>작성일
              <strong>
                <c:choose>
                  <c:when test="${not empty news.writedate}">
                    <fmt:formatDate value="${news.writedate}" pattern="yyyy-MM-dd HH:mm"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </strong>
            </span>
            <c:if test="${not empty news.id}">
              <span class="dot"></span>
              <span>작성자 <strong><c:out value="${news.id}" /></strong></span>
            </c:if>
          </div>

          <hr class="hr"/>

          <div class="content">
            <c:if test="${empty news.content}">
              <p style="color:var(--muted)">작성된 내용이 없습니다.</p>
            </c:if>
            <c:if test="${not empty news.content}">
              <pre>${news.content}</pre>
            </c:if>
          </div>

          <div class="actions">
            <a class="btn primary" href="${ctx}/news/editForm.do?articleNO=${news.articleNO}">수정</a>
            <form action="${ctx}/news/delete.do" method="post"
                  onsubmit="return confirm('삭제할까요?');" style="display:inline;">
              <input type="hidden" name="articleNO" value="${news.articleNO}">
              <button type="submit" class="btn danger">삭제</button>
            </form>
            <a class="btn ghost" href="${ctx}/news/list.do">목록</a>
          </div>
        </c:otherwise>
      </c:choose>
    </article>
  </main>
</body>
</html>
