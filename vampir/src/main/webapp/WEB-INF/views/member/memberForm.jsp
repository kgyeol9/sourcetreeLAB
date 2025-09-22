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
<title>뱀피지지 - 회원가입</title>

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
	background: #1f1f1f;
	padding: 2em 3em;
	border-radius: 8px;
	box-shadow: 0 0 15px #bb000033;
	width: 380px;
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

input[type="text"], input[type="email"], input[type="password"] {
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

.signup-container button {
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

.signup-container button:hover {
	background-color: #e63946;
}

.login-link {
	margin-top: 1em;
	font-size: 0.9em;
}

.login-link a {
	color: #bbb;
	transition: color 0.3s;
}

.login-link a:hover {
	color: #ff4444;
}

.error {
	color: #ff6b6b;
	font-size: 0.9em;
	margin-top: 0.5em;
	display: none;
	text-align: left;
}
</style>

<!-- jQuery (필수) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>
	// 검증 상태 플래그와 마지막 검증된 값
	let idVerified = false;
	let lastVerifiedId = "";

	// 입력이 바뀌면 검증 상태 해제
	document.addEventListener('DOMContentLoaded', function() {
		const input = document.getElementById('_memId');
		input.addEventListener('input', function() {
			if (idVerified) {
				idVerified = false;
				lastVerifiedId = "";
				document.getElementById('memId').value = ""; // 제출값 해제
				setIdStatus('아이디가 변경되었습니다. 다시 중복체크 해주세요.', 'warn');
				document.getElementById('btnOverlapped').disabled = false; // 버튼 재활성화
			} else {
				// 아직 미검증 상태일 때는 안내만
				setIdStatus('', 'neutral');
			}
		});
	});

	function setIdStatus(msg, type) {
		const el = document.getElementById('idStatus');
		const colors = {
			ok : '#35c759',
			bad : '#ff3b30',
			warn : '#ffd60a',
			neutral : '#bbb'
		};
		el.style.color = colors[type] || '#bbb';
		el.textContent = msg || '';
	}

	function fn_overlapped() {
		var _id = $("#_memId").val().trim();

		// ✅ 팝업 대신 상태줄 안내만
		if (_id === '') {
			setIdStatus('아이디를 입력해주세요.', 'neutral');
			return;
		}

		// (나머지 기존 코드 그대로 두세요)
		$.ajax({
			type : "post",
			url : "${contextPath}/member/overlapped.do",
			dataType : "text",
			data : {
				id : _id
			},
			success : function(data) {
				if ($.trim(data) === 'false') {
					setIdStatus('사용 가능한 아이디입니다.', 'ok');
					// 기존에 하던 동작이 있으면 그대로 유지
					// $('#memId').val(_id); 등
				} else {
					setIdStatus('이미 사용 중인 아이디입니다.', 'bad');
				}
			},
			error : function() {
				setIdStatus('중복 확인 중 오류가 발생했습니다.', 'bad');
			}
		});
	}

	// 제출 전 검증 완료 여부 확인
	function beforeSubmit() {
		const typed = $('#_memId').val().trim();
		const hidden = $('#memId').val().trim();
		if (!idVerified || !hidden || typed !== hidden) {
			alert('아이디 중복체크를 완료해주세요.');
			return false;
		}
		return checkPwd(); // 기존 비번 일치 검사 호출
	}
</script>

</head>

<body>
	<main>
		<div class="signup-container">
			<h2>회원가입</h2>

			<!-- name을 서버 VO 프로퍼티(memId, memPwd, nickname, email)에 맞춤 -->
			<!-- 서버 VO가 member_id/member_pw 형태라면 아래 name도 동일하게 바꿔주세요 -->
			<form method="POST" action="${contextPath}/member/addMember.do"
				onsubmit="return beforeSubmit();">
				<label for="_memId">아이디</label>
				<div style="display: flex; gap: 8px; align-items: center;">
					<input type="text" id="_memId" placeholder="아이디를 입력하세요" required
						minlength="4" maxlength="20" pattern="[a-zA-Z0-9_]+"
						autocomplete="username" /> <input type="hidden" name="memId"
						id="memId" /> <input type="button" id="btnOverlapped"
						value="중복체크" onClick="fn_overlapped()" />
				</div>
				<!-- 상태 배지/메시지 -->
				<div id="idStatus"
					style="margin-top: 6px; font-size: 0.9em; color: #bbb;"></div>

				<label for="memPwd">비밀번호</label> <input id="memPwd" type="password"
					name="memPwd" placeholder="비밀번호를 입력하세요" minlength="8"
					autocomplete="new-password" required /> <label for="memPwdConfirm">비밀번호
					확인</label> <input id="memPwdConfirm" type="password"
					placeholder="비밀번호를 다시 입력하세요" required />
				<div id="pwdErr" class="error">비밀번호가 일치하지 않습니다.</div>

				<label for="nickname">닉네임</label> <input id="nickname" type="text"
					name="nickname" placeholder="닉네임을 입력하세요(최대 12자)" required
					maxlength="12" /> <label for="email">이메일</label> <input id="email"
					type="email" name="email" placeholder="이메일 주소를 입력하세요" required />

				<button type="submit">회원가입</button>
			</form>

			<div class="login-link">
				이미 회원이신가요? <a href="${contextPath}/member/loginForm.do">로그인</a>
			</div>
		</div>
	</main>
</body>
</html>
