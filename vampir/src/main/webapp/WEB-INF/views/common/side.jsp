<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사이드 메뉴</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/side.css">
</head>
<body>
  <div class="sidebar">
    <div class="subcategory" id="c1">
      <h3>DB</h3>
      <ul>
      <li><a href="#">아이템 DB</a></li>
      <li><a href="#">형상/탈것 DB</a></li>
      <li><a href="#">몬스터 DB</a></li>
      <li><a href="#">맵 DB</a></li>
      <li><a href="#">내실 DB</a></li>
      </ul>
    </div>
   
    <div class="subcategory" id="c2">
      <h3>게시판</h3>
      <ul>
      <li><a href="#">자유/질문 게시판</a></li>
      <li><a href="#">공략 게시판</a></li>
      <li><a href="${pageContext.request.contextPath}/partyboard.do">파티 게시판</a></li>
	  <li><a href="#">길드 게시판</a></li>
  	  <li><a href="#">월드 게시판</a></li>
  	  <li><a href="#">직업 게시판</a></li>
	  </ul>
    </div>
    
    <div class="subcategory" id="c3">
      <h3>새소식</h3>
      <ul>
      <li><a href="#">공지사항</a></li>
      <li><a href="#">업데이트</a></li>
      <li><a href="#">개발자노트</a></li>
      </ul>
    </div>
    
    <div class="subcategory" id="c4">
      <h3>고객센터</h3>
      <ul><li><a href="#">자주묻는질문</a></li>
      <li><a href="#">1:1 문의</a></li>
      </ul>
    </div>
  </div>

  <script>
    function scrollToCategory(id) {
      const el = document.getElementById(id);
      if (el) el.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  </script>
</body>
</html>
