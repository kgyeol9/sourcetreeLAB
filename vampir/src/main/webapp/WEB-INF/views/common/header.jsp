<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
  request.setCharacterEncoding("UTF-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헤더</title>
<style>
    /* 헤더 스타일 */
    #header {
        position: fixed;   /* 상단 고정 */
        top: 0;
        left: 0;
        width: 100%;
        height: 70px;      /* 고정 높이 */
        background-color: #333;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 20px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        z-index: 1000;     /* 본문/사이드보다 항상 위 */
    }

    /* 본문과 사이드바가 헤더와 겹치지 않도록 */
    body {
        margin: 0;  
        padding-top: 103px; /* header 높이만큼 아래로 밀기 */
    }

header .logo {
	position: absolute;
	left: 2em;
	top: 50%;
	transform: translateY(-50%);
	font-size: 1.8em;
	color: #bb0000;
	cursor: pointer;
	margin: 0;
	font-weight: 600;
}

nav.center-nav {
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100%;
	gap: 20px;
}

nav.center-nav a {
	color: #eee;
	font-weight: 600;
}

nav.center-nav a:hover {
	color: #ff4444;
}
/* 설정툴 (헤더 오른쪽) */
.settings {
	position: absolute;
	right: 2em;
	top: 50%;
	transform: translateY(-50%);
	display: flex;
	gap: 15px;
}

.settings button, .settings a {
	background: #333;
	color: #eee;
	padding: 6px 12px;
	border-radius: 4px;
	border: none;
	cursor: pointer;
	font-weight: 600;
}

.settings button:hover, .settings a:hover {
	background: #bb0000;
}
/* 사이드 메뉴 (완전히 숨기기 + 닫기 버튼) */
.side-menu {
	position: fixed;
	top: 0;
	right: -100%;
	/* 아예 화면 밖으로 */
	width: 250px;
	height: 100%;
	background: #1c1c1c;
	padding: 2em 1.5em;
	transition: right 0.3s ease;
	box-shadow: -2px 0 5px #00000088;
	z-index: 20;
}

.side-menu.active {
	right: 0;
}

.side-menu h3 {
	margin-top: 0;
	color: #ff5555;
}

.side-menu a {
	display: block;
	margin: 1em 0;
	color: #eee;
}

.side-menu .close-btn {
	background: none;
	border: none;
	color: #eee;
	font-size: 1.2em;
	position: absolute;
	top: 10px;
	right: 15px;
	cursor: pointer;
}
/* 버튼과 드롭다운을 묶는 래퍼 */
.profile-dropdown {
	position: relative; /* 이 안에서 absolute가 위치 잡음 */
	display: inline-block;
}

/* 드롭다운 박스 */
.logOn-box {
	position: absolute;
	top: 100%;   /* 버튼 바로 아래 */
	right: 0;    /* 버튼 오른쪽 끝과 정렬 */
	background: #1f1f1f;
	padding: 1em;
	border-radius: 8px;
	box-shadow: 0 0 8px #bb000033;
	width: 280px;
	z-index: 999;

	transform: translateY(-10px);
	opacity: 0;
	pointer-events: none;
	transition: transform 0.3s ease, opacity 0.3s ease;
}

.logOn-box.show {
	transform: translateY(0);
	opacity: 1;
	pointer-events: auto;
}

</style>

</head>
<body>
	<table border=0 width="100%">
		<tr>
			<td><header>
					<a href="${contextPath}/home.do" class="logo">VAMPI.GG</a>
					<nav class="center-nav">
						<a href="${contextPath}/itemDB.do">아이템DB</a>
						<a href="#game-info">게임 정보</a>
						<a href="${contextPath}/board/list.do">커뮤니티</a>
						<a href="#notices">공지사항</a>
						<a href="#events">이벤트</a>
					</nav>
					<div class="settings">
					
						<c:choose>
							<c:when test="${isLogOn == true  && member!= null}">
							<div class=dropdown>
								<button id="toggleBtn"> 프로필(임시) </button>
							
							<!-- 토글 카드 -->
								<aside class="logOn-box" id="logOnBox">
									<div class="user-top">
										<h3 class="user-name">${member.name}님</h3>
										<a href="${contextPath}/member/logout.do" class="logout-btn">로그아웃</a>
									</div>

									<div class="user-main">
										<div class="profile-pic"></div>
										<div class="user-textbox">
											<span>회원 전용 텍스트 영역</span>
										</div>
									</div>

									<div class="user-bottom">
										<a href="#" class="btn inbox">쪽지함</a>
										<a href="${contextPath}/member/mypage.do" class="btn mypage">마이페이지</a>
									</div>
								</aside>
							</div>
							
							</c:when>
						<c:otherwise>
							<button type="button" onclick="location.href='${pageContext.request.contextPath}/member/loginForm.do'"> 로그인 </button>
						</c:otherwise>
						</c:choose>
						<button id="menuBtn">메뉴</button>
					</div>
				</header></td>
		</tr>
	</table>

<script>
	const toggleBtn = document.getElementById("toggleBtn");
	const logOnBox = document.getElementById("logOnBox");

	toggleBtn.addEventListener("click", () => {
		logOnBox.classList.toggle("show");
	});
</script>

</body>
</html>