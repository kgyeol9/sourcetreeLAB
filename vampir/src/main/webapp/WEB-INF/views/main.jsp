<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%@ page session="false"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<title>뱀피지지 - 비로그인</title>
<style>
body {
	margin: 0;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background: #121212;
	color: #eee;
	transition: background 0.3s, color 0.3s;
}

a {
	text-decoration: none;
}

/* 쌀 계산기 */
#rice-calculator {
	position: relative;
	top: 190px;
	background: #1f1f1f;
	padding: 2em;
	border-radius: 8px;
	box-shadow: 0 0 8px #bb000033;
	margin-bottom: 2em;
}

.calc-container {
	display: flex;
	align-items: center;
	gap: 1em;
	flex-wrap: wrap;
}

.calc-container .input-group {
	display: flex;
	flex-direction: column;
	flex: 1 1 200px;
}

.calc-container input {
	padding: 8px;
	border-radius: 4px;
	border: 1px solid #333;
	background: #222;
	color: #eee;
}

#swapBtn {
	background: #bb0000;
	color: #fff;
	border: none;
	padding: 8px 12px;
	border-radius: 4px;
	cursor: pointer;
	font-size: 1.2em;
}

#swapBtn:hover {
	background: #ff4444;
}

/* 메인 콘텐츠 위치 조정 */
main {
	max-width: 1200px;
	margin: -80px auto 2em auto;
	padding: 0 1em;
}
table {
	position: relative;
	top: 200px;
}
</style>
</head>

<body>

	<!-- 사이드 메뉴 -->
	<div class="side-menu" id="sideMenu">
		<button class="close-btn" id="closeMenu">✕</button>
		<h3>메뉴</h3>
		<a href="#game-info">게임 정보</a> <a href="#community">커뮤니티</a> <a
			href="#notices">공지사항</a> <a href="#events">이벤트</a>
	</div>

	<!-- 메인 콘텐츠 -->
	<main>
		<table>
		<tr align="center" bgcolor="lightgreen">
			<td><b>아이템 이름</b></td>
		</tr>

		<c:forEach var="item" items="${itemsList}">
			<tr align="center">
				<td>${item.name}</td>
			</tr>
		</c:forEach>
		</table>
	</main>
	
</body>

</html>