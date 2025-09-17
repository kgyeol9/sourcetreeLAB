<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageActive" value="${empty pageActive ? 'collection' : pageActive}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>컬렉션 DB</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  body{ margin:0; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background:#121212; color:#eee; }
  a{ text-decoration:none; color:inherit; }
  .db-main{ max-width:1200px; margin:16px auto 24px; padding:0 16px; }
  .card{ background:#1f1f1f; border:1px solid #333; border-radius:10px; }

  /* 상단 로컬 스위치(6개 전용) */
  .db-switch{ display:flex; gap:8px; padding-bottom:12px; border-bottom:2px solid #bb0000; margin:0 0 12px; }
  .vt-btn{ background:#222; border:1px solid #333; color:#eee; padding:6px 10px; border-radius:6px; cursor:pointer; }
  .vt-btn:hover{ background:#2b2b2b; }
  .vt-btn.active{
    background:#bb0000; border-color:#bb0000; color:#fff;
    box-shadow: inset 0 2px 0 rgba(255,255,255,.08), inset 0 -2px 0 rgba(0,0,0,.25);
    transform: translateY(1px);
  }
</style>
</head>
<body>
<main class="db-main">
  <!-- 이 페이지 묶음 전용 스위치 -->
  <div class="db-switch">
    <a class="vt-btn ${pageActive eq 'collection' ? 'active' : ''}" href="<c:url value='/DB/listCollection.do'/>">컬렉션DB</a>
    <a class="vt-btn ${pageActive eq 'portrait'   ? 'active' : ''}" href="<c:url value='/DB/listPortrait.do'/>">초상화DB</a>
    <a class="vt-btn ${pageActive eq 'discipline' ? 'active' : ''}" href="<c:url value='/DB/listDiscipline.do'/>">규율DB</a>
    <a class="vt-btn ${pageActive eq 'magic'      ? 'active' : ''}" href="<c:url value='/DB/listMagicResearch.do'/>">마력연구DB</a>
    <a class="vt-btn ${pageActive eq 'artifact'   ? 'active' : ''}" href="<c:url value='/DB/listArtifact.do'/>">아티팩트DB</a>
    <a class="vt-btn ${pageActive eq 'sephira'    ? 'active' : ''}" href="<c:url value='/DB/listSephira.do'/>">세피라DB</a>
  </div>

  <!-- 본문(임시) -->
  <section class="card" style="padding:16px;">
    <h3 style="margin:0 0 8px;">컬렉션 DB</h3>
    <div style="color:#bbb;">데이터 준비중입니다.</div>
  </section>
</main>
</body>
</html>
