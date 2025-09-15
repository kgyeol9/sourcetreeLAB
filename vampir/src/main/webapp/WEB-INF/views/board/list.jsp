<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- 보드 전용(이 JSP 내부 스코프) 스타일: home.jsp 톤과 일치 -->
<style>
/* 홈과 동일한 다크 톤/레이아웃 리듬 */
.board-wrap {
	position: relative;
}

.board-wrap .container {
	max-width: 1200px;
	margin: 120px auto 2em auto; /* 헤더(고정 70px) + 사이드 로그인 박스 시작선과 라인 맞춤 */
	padding: 0 1em;
	color: #eee; /* 다크 배경에서 본문 가독색 */
}

/* 상단 라인: 좌측 제목, 우측 액션 버튼 */
.board-wrap .topbar {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 10px;
}

.board-wrap .title {
	margin: 0;
	font-size: 1.25rem;
	font-weight: 800;
	color: #ff6666; /* home 섹션 헤딩 계열 */
	letter-spacing: .2px;
}

/* 액션 버튼 (home의 레드 버튼 톤) */
.board-wrap .actions {
	display: flex;
	gap: 8px;
}

.board-wrap .btn {
	display: inline-block;
	padding: 8px 14px;
	border-radius: 8px;
	border: 1px solid #333;
	background: #2a2a2a;
	color: #eee;
	font-weight: 700;
	text-decoration: none;
	cursor: pointer;
}

.board-wrap .btn:hover {
	background: #323232;
}

.board-wrap .btn.primary {
	background: #bb0000;
	border-color: #bb0000;
	color: #fff;
}

.board-wrap .btn.primary:hover {
	background: #ff4444;
	border-color: #ff4444;
}

/* 검색 바 (home 입력 톤) */
.board-wrap .search {
	display: flex;
	gap: 8px;
	margin: 12px 0 14px;
}

.board-wrap .search input[type="text"] {
	flex: 1;
	padding: 10px 12px;
	border-radius: 8px;
	border: 1px solid #333;
	background: #222;
	color: #eee;
}

.board-wrap .search input::placeholder {
	color: #9aa2af;
}

.board-wrap .search .btn {
	padding: 8px 16px;
}

/* 리스트 테이블 (home 섹션 카드 톤) */
.board-wrap .table {
	width: 100%;
	border-collapse: separate;
	border-spacing: 0;
	background: #1f1f1f;
	border: 1px solid #333;
	border-radius: 8px;
	box-shadow: 0 0 8px #bb000033;
	overflow: hidden;
}

.board-wrap .table th, .board-wrap .table td {
	padding: 14px 16px;
	border-bottom: 1px solid #333;
}

.board-wrap .table th {
	background: #181a1f;
	color: #dbe1ea;
	font-weight: 700;
	text-align: left;
	position: sticky;
	top: 0;
	z-index: 1;
}

.board-wrap .table tr:last-child td {
	border-bottom: none;
}

.board-wrap .table tbody tr:hover {
	background: #191d24;
}

/* 컬럼 폭/정렬 */
.board-wrap .col-no {
	width: 80px;
	color: #c9d0db;
}

.board-wrap .col-user {
	width: 160px;
	color: #d5d9e3;
}

.board-wrap .col-date {
	width: 180px;
	color: #c9d0db;
}

.board-wrap .col-views {
	width: 90px;
	color: #c9d0db;
	text-align: right;
}

/* 링크: 파란/보라/밑줄 방지, hover 동일 컬러(요청) */
.board-wrap a, .board-wrap a:link, .board-wrap a:visited {
	color: inherit;
	text-decoration: none;
}

.board-wrap a:hover {
	color: inherit;
	text-decoration: none;
}

/* 페이징 중앙 */
.board-wrap .pagination {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 8px;
	margin: 16px 0 0;
}

.board-wrap .pagination a, .board-wrap .pagination span {
	min-width: 34px;
	display: inline-block;
	text-align: center;
	padding: 6px 10px;
	border-radius: 8px;
	background: #1a1d23;
	border: 1px solid #333;
	color: #eee;
}

.board-wrap .pagination .current {
	background: #bb0000;
	border-color: #bb0000;
	color: #fff;
}

/* 좁은 화면 대응 */
@media ( max-width : 768px) {
	.board-wrap .container {
		margin: 100px auto 1.5em;
		padding: 0 .75em;
	}
	.board-wrap .col-user {
		width: 120px;
	}
	.board-wrap .col-date {
		width: 150px;
	}
	.board-wrap .col-views {
		width: 70px;
	}
}
</style>
<script>
	function fn_articleForm(isLogOn,articleForm,loginForm){
	  if(isLogOn != '' && isLogOn != 'false'){
	    location.href=articleForm;
	  }else{
	    alert("로그인 후 글쓰기가 가능합니다.")
	    location.href='${contextPath}/member/loginForm.do'; // alert 확인 후 로그인폼으로 이동
	  }
	}
</script>
<div class="board-wrap">
	<div class="container">
		<div class="topbar">
			<h2 class="title">
				<a class="logo" href="${contextPath}/board/listArticles.do">자유게시판</a>
			</h2>
			<div class="actions">
				<a href="javascript:fn_articleForm('${isLogOn}','${contextPath}/board/write.do', 
                                                    '${contextPath}/member/loginForm.do')" class="btn primary">글쓰기</a>
				<a href="${contextPath}/board/listArticles.do" class="btn">목록</a>
			</div>
		</div>

		<!-- 검색 -->
		<div class="search">
			<!-- 컨트롤러가 검색 파라미터를 아직 안 받더라도 UI는 유지됩니다 -->
			<form action="${contextPath}/board/listArticles.do" method="get"
				style="display: flex; gap: 8px; width: 100%">
				<input type="text" name="keyword" value="${param.keyword}"
					placeholder="제목/작성자 검색">
				<button type="submit" class="btn primary">검색</button>
			</form>
		</div>

		<!-- 리스트 -->
		<table class="table">
			<thead>
				<tr>
					<th class="col-no">번호</th>
					<th>제목</th>
					<th class="col-user">작성자</th>
					<th class="col-date">작성일</th>
					<th class="col-views">조회</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${not empty articlesList}">
						<c:forEach var="a" items="${articlesList}">
							<tr>
								<td class="col-no">#<c:out value="${a.articleNO}" /></td>
								<td class="title"><a
									href="${contextPath}/board/view.do?articleNO=${a.articleNO}">
										<c:out value="${a.title}" />
								</a></td>
								<td class="col-user"><c:out value="${a.id}" /></td>
								<td class="col-date"><c:choose>
										<c:when test="${not empty a.writeDate}">
											<fmt:formatDate value="${a.writeDate}"
												pattern="yyyy.MM.dd HH:mm" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
								<%-- <td class="col-views"><c:out value="${a.viewCnt}" /></td> --%>
								<td class="col-views"><c:out value="미구현" /></td>
								<!-- 조회수를 측정하는 값이 없는 관계로 viewCnt를 불러오는 과정 중 오류 발생 < 임시 주석처리 -->
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="5"
								style="text-align: center; color: #b8c0cc; padding: 28px;">
								게시글이 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>

		<!-- 서버 페이징이 없으면 임시 표시용 -->
		<div class="pagination">
			<c:if test="${not empty page}">
				<c:forEach var="p" begin="1" end="${page.totalPages}">
					<c:choose>
						<c:when test="${p == page.number}">
							<span class="current">${p}</span>
						</c:when>
						<c:otherwise>
							<a href="${contextPath}/board/listArticles.do?page=${p}">${p}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:if>
		</div>
	</div>
</div>
