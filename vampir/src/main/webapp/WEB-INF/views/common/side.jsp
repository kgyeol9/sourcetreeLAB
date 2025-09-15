<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사이드 메뉴</title>

<style>
  :root {
    --sidebar-bg: #1b1b1b;
    --border-color: #333;
    --text-color: #e0e0e0;
    --highlight: #bb2222;
    
        /* 스크롤 색상 */
    --scrollbar-bg: #1b1b1b;           /* 스크롤 바탕 */
    --scrollbar-thumb: #333;           /* 기본 손잡이: 거의 배경색에 묻힘 */
    --scrollbar-thumb-hover: #991f1f;  /* hover 시 빨간색 포인트 */
    --scrollbar-thumb-active: #b22222; /* 클릭 중엔 더 밝은 빨강 */
  }

  body {
    margin: 0;
    background: #222;
    color: var(--text-color);
    font-family: Arial, sans-serif;
  }

  /* 대분류 박스 */
  .category-box {
    background: var(--sidebar-bg);
    border: 1px solid var(--border-color);
    padding: 10px;
    margin: 10px;
    border-radius: 6px;
  }

  .category-box span {
    cursor: pointer;
    margin: 0 6px;
    color: var(--highlight);
  }

  .category-box span:hover {
    text-decoration: underline;
  }

  /* 소분류 박스 */
#subcategory-container {
  background: #2a2a2a;
  border: 1px solid var(--border-color);
  padding: 10px;
  margin: 10px;
  border-radius: 6px;
  overflow: hidden;
  max-height: 0;
  opacity: 0;
  transition: max-height 0.4s ease, opacity 0.4s ease;
  position: relative;
}

#subcategory-container.open {
  max-height: 600px; /* 원하는 높이로 제한 */
  opacity: 1;
  overflow-y: auto; /* 세로 스크롤 */
}
/* 크롬, 엣지, 사파리 */
#subcategory-container.open::-webkit-scrollbar {
  width: 10px;
}

#subcategory-container.open::-webkit-scrollbar-track {
  background: var(--scrollbar-bg);
  border-radius: 6px;
}

#subcategory-container.open::-webkit-scrollbar-thumb {
  background: var(--scrollbar-thumb);
  border-radius: 6px;
  transition: background 0.3s ease;
}

#subcategory-container.open::-webkit-scrollbar-thumb:hover {
  background: var(--scrollbar-thumb-hover);
}

#subcategory-container.open::-webkit-scrollbar-thumb:active {
  background: var(--scrollbar-thumb-active);
}

/* 기본적으로 겹쳐놓음 */
.subcategory {
  position: absolute;
  top: 10px;
  left: 10px;
  right: 10px;
  opacity: 0;
  max-height: 0;
  overflow: hidden;
  transition: opacity 0.4s ease;
}

/* 개별 카테고리 열기 */
.subcategory.open {
  opacity: 1;
  max-height: 500px;
  position: relative;
}

/* 전체 보기는 전부 자연스럽게 쌓이도록 */
.subcategory.show-all {
  position: relative;
  opacity: 1;
  max-height: none;
}

  .subcategory h3 {
    margin: 0.5em 0;
    border-bottom: 1px solid var(--border-color);
    color: var(--highlight);
  }

  .subcategory ul {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .subcategory li {
    margin: 0.5em 0;
  }

  .subcategory a {
    text-decoration: none;
    color: var(--text-color);
  }

  .subcategory a:hover {
    color: var(--highlight);
  }
</style>
</head>
<body>

<!-- 대분류 영역 -->
<!-- <div class="category-box" id="category-list">
  <span onclick="showAll()">전체</span> |
  <span onclick="toggleCategory('c1')">대분류 1</span> |
  <span onclick="toggleCategory('c2')">대분류 2</span> |
  <span onclick="toggleCategory('c3')">대분류 3</span> |
  <span onclick="toggleCategory('c4')">대분류 4</span> |
  <span onclick="hideSubcategories()">닫기</span>
</div> -->

<!-- 소분류 영역 -->
<div id="subcategory-container">
  <div class="subcategory" id="c1">
    <h3>대분류 1</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>

  <div class="subcategory" id="c2">
    <h3>대분류 2</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>

  <div class="subcategory" id="c3">
    <h3>대분류 3</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>

  <div class="subcategory" id="c4">
    <h3>대분류 4</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>
</div>

<script>
function toggleCategory(id) {
    const container = document.getElementById("subcategory-container");
    const target = document.getElementById(id);

    // 전체 보기 상태 해제
    document.querySelectorAll('.subcategory').forEach(el => {
      el.classList.remove("show-all");
      el.style.display = "none";
    });

    // 이미 열려있던 걸 다시 누르면 닫기
    if (target.classList.contains("open")) {
      target.classList.remove("open");
      container.classList.remove("open");
      target.style.display = "none";
      return;
    }

    // 모든 소분류 닫기
    document.querySelectorAll('.subcategory').forEach(el => el.classList.remove("open"));

    // 새 소분류 열기
    container.classList.add("open");
    target.style.display = "block";
    requestAnimationFrame(() => target.classList.add("open"));
  }

function showAll() {
	  const container = document.getElementById("subcategory-container");

	  // 전체 보기가 이미 열린 상태라면 닫기
	  const isAllOpen = container.classList.contains("open") &&
	                    Array.from(document.querySelectorAll('.subcategory'))
	                         .every(el => el.classList.contains("show-all"));

	  if (isAllOpen) {
	    hideSubcategories();
	    return;
	  }

	  // 전체 보기 열기
	  container.classList.add("open");
	  document.querySelectorAll('.subcategory').forEach(el => {
	    el.classList.remove("open");
	    el.style.display = "block";
	    el.classList.add("show-all");
	  });
	}

  function hideSubcategories() {
    const container = document.getElementById("subcategory-container");
    container.classList.remove("open");

    document.querySelectorAll('.subcategory').forEach(el => {
      el.classList.remove("open", "show-all");
      el.style.display = "none";
    });
  }
</script>

</body>
</html>
