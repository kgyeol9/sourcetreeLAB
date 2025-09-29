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
/* 위치/레이아웃 유지 */
#dia-calculator{
  position: relative; top:190px; background:#1f1f1f;
  padding:2em; border-radius:8px; box-shadow:0 0 8px #bb000033; margin-bottom:2em;
}
/* 메인 레이아웃 유지 */
main{ max-width:1200px; margin:-80px auto 2em auto; padding:0 1em; }
.grid-layout{ display:grid; grid-template-columns:repeat(2,1fr); gap:2em; margin-top:200px; margin-bottom:1em; }
@media (max-width:768px){ .grid-layout{ grid-template-columns:1fr; } .login-box{ margin:100px auto 2em auto; } }

/* 계산기 내부 */
.dc-head{ display:flex; align-items:center; gap:12px; margin:0 0 12px 0; }
.dc-head h2{ margin:0; font-size:1.25rem; }
.dc-head .dc-rate{ margin-left:auto; display:flex; align-items:center; gap:8px; background:#141414; border:1px solid #2a2a2a; border-radius:8px; padding:8px 10px; }
.dc-head .dc-rate input{ width:120px; background:transparent; border:0; outline:0; color:#fff; text-align:right; }

.dc-row{ display:flex; gap:10px; align-items:center; margin-bottom:10px; }
.dc-row label{ min-width:64px; color:#ddd; }
.dc-input{ flex:1; display:flex; align-items:center; background:#151515; border:1px solid #2a2a2a; border-radius:8px; padding:8px 10px; }
.dc-input input{ width:100%; background:transparent; border:0; outline:0; color:#fff; font-size:1.05rem; }
.dc-unit{ color:#9aa0a6; margin-left:8px; white-space:nowrap; }
.dc-btn{ height:36px; padding:0 14px; border-radius:8px; border:1px solid #353535; background:#202020; color:#fff; font-weight:700; cursor:pointer; }
.dc-btn.primary{ background:#bb0000; border-color:#bb0000; }

/* 버튼 줄을 오른쪽으로 */
.dc-controls{ display:flex; gap:8px; align-items:center; justify-content:flex-end; }
</style>
</head>

<body>
  <main>
    <!-- 다이아 계산기 -->
    <section id="dia-calculator" aria-label="다이아 계산기">

      <!-- 제목 줄 + 환율(우측 끝) -->
      <div class="dc-head">
        <h2>다이아 계산기</h2>
        <div class="dc-rate">
          <span style="color:#ccc;">환율</span>
          <input id="dc_rate" type="text" value="100" inputmode="decimal" aria-label="환율(1 DIA = ? KRW)">
          <span style="color:#aaa;">(1 DIA = KRW)</span>
        </div>
      </div>

      <div class="dc-row">
        <label id="dc_left_label" for="dc_left">다이아</label>
        <div class="dc-input">
          <input id="dc_left" type="text" inputmode="decimal" placeholder="값 입력" autocomplete="off">
          <span id="dc_left_unit" class="dc-unit">DIA</span>
        </div>
        <button id="dc_swap" class="dc-btn" title="다이아 ↔ 원 스왑">⇄</button>
      </div>

      <div class="dc-row">
        <label id="dc_right_label" for="dc_right">원</label>
        <div class="dc-input">
          <input id="dc_right" type="text" inputmode="decimal" placeholder="값 입력" autocomplete="off">
          <span id="dc_right_unit" class="dc-unit">KRW</span>
        </div>
      </div>

      <!-- 버튼 줄(오른쪽 끝 정렬) -->
      <div class="dc-controls">
        <button id="dc_buy"  class="dc-btn primary">구매하기</button>
        <button id="dc_sell" class="dc-btn">판매하기</button>
      </div>
    </section>

    <!-- 기존 콘텐츠 (그대로) -->
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
    // ===== 다이아 계산기 =====
    (function(){
      var $ = function(s){ return document.querySelector(s); };

      var leftInp  = $('#dc_left');
      var rightInp = $('#dc_right');
      var rateInp  = $('#dc_rate');
      var swapBtn  = $('#dc_swap');
      var buyBtn   = $('#dc_buy');
      var sellBtn  = $('#dc_sell');

      var leftLabel  = $('#dc_left_label');
      var rightLabel = $('#dc_right_label');
      var leftUnit   = $('#dc_left_unit');
      var rightUnit  = $('#dc_right_unit');

      // 숫자 파싱/표시
      var nf = new Intl.NumberFormat('ko-KR');
      function parseNum(v){ return Number(String(v||'').replace(/[,\s]/g,'')) || 0; }
      function fmt(n){ return n===0 ? '0' : nf.format(n); }

      // 상태: 왼쪽이 다이아인지 여부 (true면 왼쪽=DIA, 오른쪽=KRW)
      var leftIsDia = true;

      // 환율은 항상: 1 DIA = rate KRW
      function recalcFromLeft(){
        var left = parseNum(leftInp.value);
        var rate = parseNum(rateInp.value) || 0;

        if(leftIsDia){
          var krw = left * rate;
          rightInp.value = left ? fmt(krw) : '';
        }else{
          var dia = rate ? (left / rate) : 0;
          rightInp.value = left ? fmt(dia) : '';
        }
      }
      function recalcFromRight(){
        var right = parseNum(rightInp.value);
        var rate  = parseNum(rateInp.value) || 0;

        if(leftIsDia){
          var dia = rate ? (right / rate) : 0;
          leftInp.value = right ? fmt(dia) : '';
        }else{
          var krw = right * rate;
          leftInp.value = right ? fmt(krw) : '';
        }
      }

      leftInp.addEventListener('input', recalcFromLeft);
      rightInp.addEventListener('input', recalcFromRight);

      rateInp.addEventListener('input', function(){
        if(leftInp.value) recalcFromLeft();
        else if(rightInp.value) recalcFromRight();
      });

      // 스왑: 라벨/단위 변경 + 값 재계산
      swapBtn.addEventListener('click', function(){
        leftIsDia = !leftIsDia;

        if(leftIsDia){
          leftLabel.textContent  = '다이아';
          rightLabel.textContent = '원';
          leftUnit.textContent   = 'DIA';
          rightUnit.textContent  = 'KRW';
        }else{
          leftLabel.textContent  = '원';
          rightLabel.textContent = '다이아';
          leftUnit.textContent   = 'KRW';
          rightUnit.textContent  = 'DIA';
        }

        if(leftInp.value) recalcFromLeft();
        else if(rightInp.value) recalcFromRight();
      });

      // 링크 버튼
      function openBarotem(){ window.open('https://www.barotem.com/', '_blank', 'noopener'); }
      buyBtn.addEventListener('click', openBarotem);
      sellBtn.addEventListener('click', openBarotem);
    })();
  </script>
</body>
</html>
