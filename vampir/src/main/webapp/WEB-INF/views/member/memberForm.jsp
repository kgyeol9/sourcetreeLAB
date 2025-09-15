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
body { background-color:#121212; color:#eee; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin:0; }
a { text-decoration:none; }
main { display:flex; justify-content:center; align-items:center; min-height:100vh; }
.signup-container { background:#1f1f1f; padding:2em 3em; border-radius:8px; box-shadow:0 0 15px #bb000033; width:380px; text-align:center; }
h2 { color:#bb0000; margin-bottom:1.5em; }
label { display:block; margin:1em 0 0.3em 0; text-align:left; font-weight:600; }
input[type="text"], input[type="email"], input[type="password"] {
  width:100%; padding:0.6em; border:none; border-radius:4px; background:#333; color:#eee; font-size:1em;
}
input::placeholder { color:#888; }
.signup-container button { margin-top:1.8em; width:100%; padding:0.7em; background-color:#bb0000; border:none; border-radius:4px; color:white; font-weight:700; font-size:1em; cursor:pointer; transition:background-color 0.3s; }
.signup-container button:hover { background-color:#e63946; }
.login-link { margin-top:1em; font-size:0.9em; }
.login-link a { color:#bbb; transition:color 0.3s; }
.login-link a:hover { color:#ff4444; }
.error { color:#ff6b6b; font-size:0.9em; margin-top:0.5em; display:none; text-align:left; }
</style>
</head>
<body>
  <main>
    <div class="signup-container">
      <h2>회원가입</h2>

      <!-- ✅ name을 VO 프로퍼티(memId, memPwd, nickname, email)와 1:1로 맞춤 -->
      <form method="POST" action="${contextPath}/member/addMember.do" onsubmit="return checkPwd();">
        <label for="memId">아이디</label>
        <input id="memId" type="text" name="memId" placeholder="아이디를 입력하세요" required />

        <label for="memPwd">비밀번호</label>
        <input id="memPwd" type="password" name="memPwd" placeholder="비밀번호를 입력하세요" required />

        <label for="memPwdConfirm">비밀번호 확인</label>
        <input id="memPwdConfirm" type="password" placeholder="비밀번호를 다시 입력하세요" required />
        <div id="pwdErr" class="error">비밀번호가 일치하지 않습니다.</div>

        <label for="nickname">닉네임</label>
        <input id="nickname" type="text" name="nickname" placeholder="닉네임을 입력하세요(최대 12자)" required />

        <label for="email">이메일</label>
        <input id="email" type="email" name="email" placeholder="이메일 주소를 입력하세요" required />

        <button type="submit">회원가입</button>
      </form>

      <div class="login-link">
        이미 회원이신가요? <a href="${contextPath}/member/loginForm.do">로그인</a>
      </div>
    </div>
  </main> 

  <script>
    function checkPwd() {
      var p1 = document.getElementById('memPwd').value;
      var p2 = document.getElementById('memPwdConfirm').value;
      var err = document.getElementById('pwdErr');
      if (p1 !== p2) {
        err.style.display = 'block';
        return false;
      }
      err.style.display = 'none';
      return true;
    }
  </script>
</body>
</html>
