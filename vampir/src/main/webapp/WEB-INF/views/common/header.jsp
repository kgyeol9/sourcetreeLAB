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
<link rel="stylesheet" href="${contextPath}/resources/css/header.css">

<style>
/* 프로필 토글 박스 */
.logOn-box {
  position: absolute;
  top: 60px;
  right: 20px;
  width: 260px;
  background: #1c1c1c;
  border: 1px solid #444;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.6);
  padding: 15px;
  opacity: 0;               /* 기본은 보이지 않음 */
  visibility: hidden;       /* 시각적으로만 숨김 */
  transform: translateY(-10px); /* 살짝 위에서 내려오는 효과 */
  transition: opacity 0.3s ease, transform 0.3s ease, visibility 0.3s;
  z-index: 999;
}

.logOn-box.show {
  opacity: 1;
  visibility: visible;
  transform: translateY(0); /* 원래 위치로 */
}

.logOn-box .user-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.logOn-box .user-name {
  font-size: 16px;
  color: #f5f5f5;
  margin: 0;
}

.logOn-box .logout-btn {
  font-size: 14px;
  color: #e03b3b;
  text-decoration: none;
}

.logOn-box .user-main {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
}

.logOn-box .profile-pic {
  width: 50px;
  height: 50px;
  background: #333;
  border-radius: 50%;
  margin-right: 10px;
}

.logOn-box .user-textbox span {
  font-size: 14px;
  color: #ccc;
}

.logOn-box .user-bottom {
  display: flex;
  justify-content: space-between;
}

.logOn-box .btn {
  flex: 1;
  margin: 0 4px;
  text-align: center;
  background: #333;
  padding: 8px 0;
  border-radius: 6px;
  color: #f5f5f5;
  text-decoration: none;
  font-size: 14px;
  transition: background 0.2s;
}

.logOn-box .btn:hover {
  background: #e03b3b;
}
</style>
</head>
<body>
  <table border=0 width="100%">
    <tr>
      <td>
        <header>
          <a href="${contextPath}/home.do" class="logo">VAMPI.GG</a>

          <div class="settings">
            <c:choose>
              <c:when test="${isLogOn == true && member != null}">
                <div class="dropdown">
                  <button id="toggleBtn">프로필(임시)</button>
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
                <button type="button" onclick="location.href='${contextPath}/member/loginForm.do'">로그인</button>
              </c:otherwise>
            </c:choose>
            <button id="menuBtn">메뉴</button>
          </div>
        </header>
      </td>
    </tr>
  </table>

<script>
const toggleBtn = document.getElementById("toggleBtn");
const logOnBox = document.getElementById("logOnBox");

toggleBtn.addEventListener("click", (e) => {
  e.stopPropagation();
  logOnBox.classList.toggle("show");
});

document.addEventListener("click", (e) => {
  if (!logOnBox.contains(e.target) && e.target !== toggleBtn) {
    logOnBox.classList.remove("show");
  }
});
</script>

</body>
</html>
