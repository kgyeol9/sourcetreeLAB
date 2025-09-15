<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
   request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<title>뱀피지지 - 로그인</title>
<style>
body {
	background-color: #121212;
	color: #eee;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	margin: 0;
}

a {
	text-decoration: none;
}

main {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh; 
}

.signup-container {
  margin: 0 auto; /* 중앙 정렬 강제 */
}

.login-container {
	background: #1f1f1f;
	padding: 2em 3em;
	border-radius: 8px;
	box-shadow: 0 0 15px #bb000033;
	width: 350px;
	text-align: center;
}

h2 {
	color: #bb0000;
	margin-bottom: 1.5em;
}

label {
	display: block;
	margin: 1em 0 0.3em 0;
	text-align: left;
	font-weight: 600;
}

input[type="text"], input[type="password"] {
	width: 100%;
	padding: 0.6em;
	border: none;
	border-radius: 4px;
	background: #333;
	color: #eee;
	font-size: 1em;
}

input::placeholder {
	color: #888;
}

.login {
	margin-top: 1.8em;
	width: 100%;
	padding: 0.7em;
	background-color: #bb0000;
	border: none;
	border-radius: 4px;
	color: white;
	font-weight: 700;
	font-size: 1em;
	cursor: pointer;
	transition: background-color 0.3s;
}

.login:hover {
	background-color: #e63946;
}

.links {
	margin-top: 1em;
	font-size: 0.9em;
}

.links a {
	color: #bbb;
	text-decoration: none;
	margin: 0 0.8em;
	transition: color 0.3s;
}

.links a:hover {
	color: #ff4444;
}
/* 에러 메시지 스타일 */
.login-error {
	background: #2a0000;
	color: #ff5555;
	border: 1px solid #bb0000;
	padding: 8px;
	border-radius: 4px;
	font-size: 0.9em;
	margin-bottom: 0.8em;
	text-align: center;
}

</style>
</head>

<body>>

	<main>
		<div class="login-container">
			<h2>로그인</h2>
			
				<c:if test="${param.result eq 'loginFailed'}">
					<div class="login-error">아이디 또는 비밀번호가 올바르지 않습니다.</div>
				</c:if>			
			
			<form action="${contextPath}/member/login.do" method="POST">
				<label for="username">아이디</label> <input type="text" id="username"
					name="id" placeholder="아이디를 입력하세요" required /> <label
					for="password">비밀번호</label> <input type="password" id="password"
					name="pwd" placeholder="비밀번호를 입력하세요" required />

				<button class="login" type="submit">로그인</button>
			</form>
			<div class="links">
				<a href="#">아이디 찾기</a> | <a href="#">비밀번호 찾기</a> | <a
					href="${contextPath}/member/memberForm.do">회원가입</a>
			</div>
		</div>
	</main>

	<script>
    // 다크모드 토글
    const darkToggle = document.getElementById('darkToggle');
    darkToggle.addEventListener('click', () => {
      document.body.classList.toggle('light');
      if (document.body.classList.contains('light')) {
        document.body.style.background = "#f5f5f5";
        document.body.style.color = "#111";
      } else {
        document.body.style.background = "#121212";
        document.body.style.color = "#eee";
      }
    });

    // 사이드 메뉴 열고 닫기
    const menuBtn = document.getElementById('menuBtn');
    const sideMenu = document.getElementById('sideMenu');
    const closeMenu = document.getElementById('closeMenu');

    menuBtn.addEventListener('click', () => {
      sideMenu.classList.add('active');
    });
    closeMenu.addEventListener('click', () => {
      sideMenu.classList.remove('active');
    });
  </script>
</body>

</html>