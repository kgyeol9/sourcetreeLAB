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
      --ctl-h:40px; --header-h:64px;
    }
    body{ margin:0; background:var(--bg); color:var(--ink); font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    a{ color:inherit; text-decoration:none; }

    .main-wrap{ max-width:1040px; margin:32px auto 72px; padding:0 12px; }
    #news-content{ padding-top: calc(var(--header-h) + 12px); }

    .title-row{ display:flex; align-items:flex-end; justify-content:space-between; gap:12px; margin-bottom:10px; }
    .title-row h1{ font-size:22px; margin:0; }
    .breadcrumbs{ color:var(--muted); font-size:14px; }

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

    .tabs{ display:flex; gap:8px; margin:10px 0 14px; overflow:auto; }
    .tab{ padding:8px 12px; border-radius:999px; border:1px solid var(--line); background:#1a1a1a; font-size:14px; color:var(--muted); white-space:nowrap; }
    .tab.active{ background:#2a0000; border-color:#5a0000; color:#ffd6d6; }

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

    .empty{ color:var(--muted); background:var(--card); border:1px solid rgba(255,255,255,0.07); border-radius:12px; padding:24px; text-align:center; }

    .highlight{ background:linear-gradient(180deg, rgba(255,0,0,0.06), transparent), var(--card);
                border:1px solid rgba(255,255,255,0.09); border-radius:14px; padding:16px; margin:10px 0 16px; }
    .highlight h2{ font-size:18px; margin:0 0 6px; }
    .highlight .desc{ color:var(--muted); font-size:14px; }

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

    <!-- 상단 툴바: 유형/정렬 + 검색 (AJAX로 재검색) -->
    <form class="toolbar" action="${contextPath}/news/list.do" method="get" id="newsToolbar">
      <select name="type" aria-label="유형">
        <option value="">전체 유형</option>
        <option value="notice" ${param.type == 'notice' ? 'selected' : ''}>공지사항</option>
        <option value="update" ${param.type == 'update' ? 'selected' : ''}>업데이트</option>
        <option value="devnote" ${param.type == 'devnote' ? 'selected' : ''}>데발자노트</option>
      </select>

      <select name="sort" aria-label="정렬">
        <option value="recent" ${param.sort == 'recent' ? 'selected' : ''}>최신순</option>
        <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>인기순</option>
        <option value="comment" ${param.sort == 'comment' ? 'selected' : ''}>댓글많은순</option>
      </select>

      <input type="text" name="q" placeholder="키워드로 검색 (예: 점검, 이벤트, 패치)" value="${fn:escapeXml(param.q)}" />
      <button type="submit">검색</button>
    </form>

    <!-- 최신 하이라이트(선택) : 초기 SSR 데이터 있으면 표시 -->
    <c:if test="${not empty latest}">
      <section class="highlight" id="latestBox">
        <h2>[<c:out value="${latest.typeLabel}" />]
          <a href="${contextPath}/news/view.do?id=${latest.id}"><c:out value="${latest.title}" /></a>
        </h2>
        <div class="desc">
          <span class="meta">게시일: <c:out value="${latest.createdAt}" /></span>
          <c:if test="${not empty latest.summary}"> · <c:out value="${latest.summary}" /></c:if>
        </div>
      </section>
    </c:if>

    <!-- 카테고리 탭: a의 기본 이동은 막고 AJAX로 로딩 -->
    <nav class="tabs" aria-label="카테고리" role="tablist">
      <!-- 접근성/비JS 사용자 고려: href 유지. JS가 preventDefault 처리 -->
      <a class="tab ${empty param.type ? 'active' : ''}" role="tab" aria-selected="${empty param.type ? 'true' : 'false'}"
         href="${contextPath}/news/list.do" data-type="">전체</a>
      <a class="tab ${param.type == 'notice' ? 'active' : ''}" role="tab" aria-selected="${param.type == 'notice' ? 'true' : 'false'}"
         href="${contextPath}/news/list.do?type=notice" data-type="notice">공지사항</a>
      <a class="tab ${param.type == 'update' ? 'active' : ''}" role="tab" aria-selected="${param.type == 'update' ? 'true' : 'false'}"
         href="${contextPath}/news/list.do?type=update" data-type="update">업데이트</a>
      <a class="tab ${param.type == 'devnote' ? 'active' : 'false'}" role="tab" aria-selected="${param.type == 'devnote' ? 'true' : 'false'}"
         href="${contextPath}/news/list.do?type=devnote" data-type="devnote">개발자노트</a>
    </nav>

    <!-- 리스트 영역: JS가 채움. (SSR fallback도 아래에 유지) -->
    <section class="list" id="newsList">
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

    <!-- 빈 상태/로딩 메시지 -->
    <div class="empty" id="newsEmpty" <c:if test="${not empty newsList}">hidden</c:if>>
      <c:choose>
        <c:when test="${empty newsList}">등록된 새소식이 없습니다.</c:when>
        <c:otherwise>&nbsp;</c:otherwise>
      </c:choose>
    </div>

    <!-- 페이징 영역 -->
    <div class="pager" id="newsPager" <c:if test="${empty page}">hidden</c:if>>
      <c:if test="${not empty page}">
        <c:if test="${page.hasPrev}">
          <a href="${contextPath}/news/list.do?page=${page.prev}&#38;type=${param.type}&#38;q=${fn:escapeXml(param.q)}&#38;sort=${param.sort}">이전</a>
        </c:if>
        <c:forEach var="p" begin="${page.start}" end="${page.end}">
          <a class="${p == page.current ? 'active' : ''}" href="${contextPath}/news/list.do?page=${p}&#38;type=${param.type}&#38;q=${fn:escapeXml(param.q)}&#38;sort=${param.sort}">${p}</a>
        </c:forEach>
        <c:if test="${page.hasNext}">
          <a href="${contextPath}/news/list.do?page=${page.next}&#38;type=${param.type}&#38;q=${fn:escapeXml(param.q)}&#38;sort=${param.sort}">다음</a>
        </c:if>
      </c:if>
    </div>
  </main>

  <noscript>
    <div class="empty" style="margin:16px">자바스크립트가 비활성화되어 있어 서버 렌더링으로만 동작합니다.</div>
  </noscript>

  <script>
  (function () {
    // ===== 상태 =====
    var activeType = getQS('type') || '';     // '', 'notice', 'update', 'devnote'
    var sort = getQS('sort') || 'recent';
    var q = getQS('q') || '';
    var page = parseInt(getQS('page') || '1', 10) || 1;
    var opened = true; // 처음엔 열림 상태

    // ===== DOM =====
    var tabs = document.querySelectorAll('.tabs .tab');
    var listEl = document.getElementById('newsList');
    var pagerEl = document.getElementById('newsPager');
    var emptyEl = document.getElementById('newsEmpty');
    var form = document.getElementById('newsToolbar');
    var latestBox = document.getElementById('latestBox');

    // ===== 탭 클릭 =====
    for (var i=0;i<tabs.length;i++){
      (function(tab){
        tab.addEventListener('click', function(e){
          e.preventDefault();
          var type = tab.getAttribute('data-type') || '';
          if (activeType === type) {
            // 토글
            opened = !opened;
            toggleUI();
            return;
          }
          activeType = type;
          opened = true;
          page = 1;
          markActiveTab();
          loadAndRender();
        });
      })(tabs[i]);
    }

    // ===== 검색/정렬 =====
    if (form) {
      form.addEventListener('submit', function(e){
        e.preventDefault();
        var fd = new FormData(form);
        var typeSel = fd.get('type') || '';
        sort = fd.get('sort') || 'recent';
        q = (fd.get('q') || '').trim();
        if (activeType !== typeSel) {
          activeType = typeSel;
        }
        opened = true;
        page = 1;
        markActiveTab();
        loadAndRender();
      });
    }

    function markActiveTab(){
      for (var i=0;i<tabs.length;i++){
        var t = tabs[i];
        var sel = (t.getAttribute('data-type') || '') === activeType;
        if (opened && sel) t.classList.add('active'); else t.classList.remove('active');
        t.setAttribute('aria-selected', (opened && sel) ? 'true' : 'false');
      }
    }

    function toggleUI(){
      if (!opened) {
        listEl.innerHTML = '';
        pagerEl.hidden = true;
        emptyEl.hidden = true;
        for (var i=0;i<tabs.length;i++){ tabs[i].classList.remove('active'); tabs[i].setAttribute('aria-selected','false'); }
        return;
      }
      markActiveTab();
      loadAndRender();
    }

    function showLoading(){
      emptyEl.hidden = false;
      emptyEl.textContent = '불러오는 중...';
      listEl.innerHTML = '';
      pagerEl.hidden = true;
    }

    function renderError(err){
      emptyEl.hidden = false;
      emptyEl.textContent = '목록을 불러오지 못했어요.';
      if (window.console) console.error(err);
    }

    function renderList(items){
      listEl.innerHTML = '';
      if (!items || !items.length) {
        emptyEl.hidden = false;
        emptyEl.textContent = '등록된 새소식이 없습니다.';
        pagerEl.hidden = true;
        return;
      }
      emptyEl.hidden = true;

      var frag = document.createDocumentFragment();
      for (var i=0;i<items.length;i++){
        var n = items[i];
        var el = document.createElement('article');
        el.className = 'item';
        el.innerHTML =
          '<span class="badge">'+esc(n.typeLabel || '')+'</span>' +
          '<div>' +
            '<div class="title">' +
              '<a href="${contextPath}/news/view.do?id='+n.id+'">'+esc(n.title || '')+'</a>' +
            '</div>' +
            '<div class="meta">' +
              '<span>게시일 '+esc(n.createdAt || '')+'</span>' +
              (n.author ? ' · <span>작성 '+esc(n.author)+'</span>' : '') +
              (n.views != null ? ' · <span>조회 '+n.views+'</span>' : '') +
            '</div>' +
          '</div>' +
          '<a class="btn" href="${contextPath}/news/view.do?id='+n.id+'">자세히</a>';
        frag.appendChild(el);
      }
      listEl.appendChild(frag);
    }

    function renderPager(p){
      if (!p) { pagerEl.hidden = true; return; }
      var hasPrev=p.hasPrev, hasNext=p.hasNext, start=p.start, end=p.end, current=p.current, prev=p.prev, next=p.next;
      pagerEl.innerHTML = '';
      var frag = document.createDocumentFragment();
      if (hasPrev) frag.appendChild(pageBtn('이전', prev));
      for (var i=start;i<=end;i++){
        var a = pageBtn(String(i), i);
        if (i === current) a.classList.add('active');
        frag.appendChild(a);
      }
      if (hasNext) frag.appendChild(pageBtn('다음', next));
      pagerEl.appendChild(frag);
      pagerEl.hidden = false;
    }

    function pageBtn(label, tgt){
      var a = document.createElement('a');
      a.textContent = label;
      a.href = '#';
      a.addEventListener('click', function(e){
        e.preventDefault();
        page = tgt;
        loadAndRender();
      });
      return a;
    }

    function renderHighlight(latest){
      if (!latest || !latest.id || !latestBox) return;
      latestBox.innerHTML =
        '<h2>['+esc(latest.typeLabel || '')+'] ' +
        '<a href="${contextPath}/news/view.do?id='+latest.id+'">'+esc(latest.title || '')+'</a></h2>' +
        '<div class="desc"><span class="meta">게시일: '+esc(latest.createdAt || '')+'</span>' +
        (latest.summary ? ' · '+esc(latest.summary) : '') + '</div>';
    }

    // ===== 데이터 로딩 =====
    function loadAndRender(){
      showLoading();
      var url = '${contextPath}/news/list.json'
              + '?type=' + enc(activeType)
              + '&sort=' + enc(sort)
              + '&q='    + enc(q)
              + '&page=' + enc(page);
      if (window.fetch) {
        fetch(url, { headers: { 'Accept':'application/json' } })
          .then(function(res){ if(!res.ok) throw new Error('HTTP '+res.status); return res.json(); })
          .then(function(data){
            renderList(data.list || []);
            renderPager(data.page || null);
            renderHighlight(data.latest || null);
          })
          .catch(renderError);
      } else {
        // XHR 폴백(구형 브라우저)
        var xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.onreadystatechange = function(){
          if (xhr.readyState === 4) {
            if (xhr.status >= 200 && xhr.status < 300) {
              try {
                var data = JSON.parse(xhr.responseText);
                renderList(data.list || []);
                renderPager(data.page || null);
                renderHighlight(data.latest || null);
              } catch(e){ renderError(e); }
            } else { renderError(new Error('HTTP '+xhr.status)); }
          }
        };
        xhr.send();
      }
    }

    // ===== 유틸 =====
    function esc(s){ return (s||'').replace(/[&<>"']/g, function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]; }); }
    function enc(s){ return encodeURIComponent(s==null?'':String(s)); }
    function getQS(name){ var m = new RegExp('[?&]'+name+'=([^&]*)').exec(location.search); return m ? decodeURIComponent(m[1].replace(/\+/g,' ')) : ''; }

    // 초기 동작: 탭 표시 동기화 + (원하면) 첫 로딩
    markActiveTab();
    // 페이지 최초 진입 시 자동 로딩을 원하면 아래 라인 활성화
    // loadAndRender();
  })();
  </script>
</body>
</html>
