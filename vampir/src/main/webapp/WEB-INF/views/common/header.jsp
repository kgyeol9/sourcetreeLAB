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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">

</head>
<body>
	<table border=0 width="100%">
		<tr>
			<td><header>
					<a href="${contextPath}/home.do" class="logo">VAMPI.GG</a>
					<nav class="center-nav">
						<a href="#notices">새소식</a>
						<a href="${contextPath}/itemDB.do">DB</a>
						<a href="#game-info">인기 게시판</a>
						<a href="${contextPath}/board/list.do">커뮤니티</a>
						<a href="#">고객센터</a>
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