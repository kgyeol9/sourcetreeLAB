<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사이드 메뉴</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/hee.css">
</head>
<body>
  <div class="sidebar">
    <div class="subcategory" id="c1">
      <h3>대분류 1</h3>
      <ul><li><a href="#">소분류 1</a></li><li><a href="#">소분류 2</a></li><li><a href="#">소분류 3</a></li></ul>
    </div>
    <div class="subcategory" id="c2">
      <h3>대분류 2</h3>
      <ul><li><a href="#">소분류 1</a></li><li><a href="#">소분류 2</a></li><li><a href="#">소분류 3</a></li></ul>
    </div>
    <div class="subcategory" id="c3">
      <h3>대분류 3</h3>
      <ul><li><a href="#">소분류 1</a></li><li><a href="#">소분류 2</a></li><li><a href="#">소분류 3</a></li></ul>
    </div>
    <div class="subcategory" id="c4">
      <h3>대분류 4</h3>
      <ul><li><a href="#">소분류 1</a></li><li><a href="#">소분류 2</a></li><li><a href="#">소분류 3</a></li></ul>
    </div>
    <div class="subcategory" id="c5">
      <h3>대분류 5</h3>
      <ul><li><a href="#">소분류 1</a></li><li><a href="#">소분류 2</a></li><li><a href="#">소분류 3</a></li></ul>
    </div>
    <div class="subcategory" id="c6">
      <h3>대분류 6</h3>
      <ul><li><a href="#">소분류 1</a></li><li><a href="#">소분류 2</a></li><li><a href="#">소분류 3</a></li></ul>
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
