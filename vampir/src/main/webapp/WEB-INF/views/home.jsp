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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">
<style>

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

/* 메인 콘텐츠 위치 조정 */
main {
	max-width: 1200px;
	margin: -80px auto 2em auto;
	/* 로그인 박스 아래로 10px 간격 추가 */
	padding: 0 1em;
}

.grid-layout {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 2em;
	margin-top: 200px;
	margin-bottom: 1em;
}

@media ( max-width : 768px) {
	.grid-layout {
		grid-template-columns: 1fr;
	}
	.login-box {
		margin: 100px auto 2em auto;
	}
}




</style>
</head>

<body>

	<!-- 사이드 메뉴 -->
	<!--<div class="side-menu" id="sideMenu">
		<button class="close-btn" id="closeMenu">✕</button>
		<h3>메뉴</h3>
		<a href="#game-info">게임 정보</a> <a href="#community">커뮤니티</a> <a
			href="#notices">공지사항</a> <a href="#events">이벤트</a>
	</div>-->

	<!-- 메인 콘텐츠 -->
	<main>
		<!-- 쌀 계산기 -->
		<section id="rice-calculator">
			<h2>쌀 계산기</h2>
			<div class="calc-container">
				<div class="input-group">
					<label id="leftLabel" for="leftInput">다이아</label> <input
						type="number" id="leftInput" placeholder="입력">
				</div>
				<button id="swapBtn">⇄</button>
				<div class="input-group">
					<label id="rightLabel" for="rightInput">골드</label> <input
						type="number" id="rightInput" placeholder="자동 계산" readonly>
				</div>
			</div>
			<p style="font-size: 0.85em; color: #aaa;">※ 교환 비율: 1 다이아 = 100
				골드</p>
		</section>

		<!-- 기존 콘텐츠 -->
		<div class="grid-layout">
			<section id="game-info">
				<h2>인기 게시판</h2><!--자유/질문게시판 -->>
				<ul>
					<li>클래스 소개: 밤의 사냥꾼, 피의 마도사, 고대 군주</li>
					<li>맵과 지역: 도시 전역 및 전략적 위치 가이드</li>
					<li>무기 및 장비: 다양한 흡혈귀 전용 무기 소개</li>
					<li>게임 시스템: 스킬, 전투, 레벨업, 보상</li>
				</ul>
			</section>
			<section id="community">
				<h2>실시간 파티</h2> <!-- 파티원 모집 -->>
				<ul>
					<li>[질문] 신규 유저 추천 클래스는?</li>
					<li>[팁] 효율적인 은신 및 기습 공격 방법</li>
					<li>[공략] 붉은달 숲 보스 처치법</li>
					<li>[영상] 고수들의 플레이 하이라이트</li>
				</ul>
			</section>
			<section id="notices">
				<h2>best 공략</h2>
				<ul>
					<li>8/20 ~ 8/31 스크린샷 콘테스트 진행 중</li>
					<li>9월 대규모 업데이트 예고</li>
					<li>한정판 아이템 획득 이벤트</li>
				</ul>
			</section>
			<section id="notices">
				<h2>공지사항</h2>
				<ul>
					<li>길드 모집 게시판</li>
					<li>친구 및 파티 매칭</li>
					<li>팬아트 및 영상 공유</li>
					<li>자유 게시판</li>
				</ul>
			</section>
		</div>
	</main>
	<script>
    // 다크모드 토글 (기존 코드 그대로)
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

    // 사이드 메뉴 열고 닫기 (기존 코드 그대로)
    const menuBtn = document.getElementById('menuBtn');
    const sideMenu = document.getElementById('sideMenu');
    const closeMenu = document.getElementById('closeMenu');

    menuBtn.addEventListener('click', () => {
      sideMenu.classList.add('active');
    });
    closeMenu.addEventListener('click', () => {
      sideMenu.classList.remove('active');
    });

    // 쌀 계산기 (다이아 → 골드 변환)
    const leftInput = document.getElementById('leftInput');
    const rightInput = document.getElementById('rightInput');
    const leftLabel = document.getElementById('leftLabel');
    const rightLabel = document.getElementById('rightLabel');
    const swapBtn = document.getElementById('swapBtn');
    let exchangeRate = 100; // 1 다이아 = 100 골드
    let isNormal = true; // true: 왼쪽=다이아, 오른쪽=골드

    // 입력에 따라 오른쪽 계산
    leftInput.addEventListener('input', () => {
      const value = parseFloat(leftInput.value) || 0;
      rightInput.value = isNormal ? value * exchangeRate : value / exchangeRate;
    });

    // 스왑 버튼 클릭 시
    swapBtn.addEventListener('click', () => {
      // 라벨 교환
      const tempLabel = leftLabel.textContent;
      leftLabel.textContent = rightLabel.textContent;
      rightLabel.textContent = tempLabel;

      // 입력 초기화
      leftInput.value = '';
      rightInput.value = '';

      // 상태 변경
      isNormal = !isNormal;
    });
  </script>
</body>

</html>