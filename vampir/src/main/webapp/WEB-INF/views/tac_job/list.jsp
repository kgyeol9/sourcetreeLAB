<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setTimeZone value="Asia/Seoul"/>

<link rel="stylesheet" href="${ctx}/resources/css/freeboard.css"/>

<div class="wrap">
  <div class="toolbar">
    <span class="muted">${type == 'job' ? '직업 게시판' : '공략 게시판'}</span>
    <span class="spacer"></span>

    <a class="btn" href="${ctx}/tac_job/list.do?type=${type}">새로고침</a>
    <c:if test="${isLogOn == true && member != null}">
      <a class="btn primary" href="${ctx}/tac_job/write.do?type=${type}">글쓰기</a>
    </c:if>
  </div>

  <table class="board">
    <colgroup>
      <col style="width:90px"><col><col style="width:160px"><col style="width:160px"><col style="width:90px">
    </colgroup>
    <thead>
      <tr>
        <th>번호</th><th style="text-align:left">제목</th><th>작성자</th><th>작성일</th><th>조회</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${not empty boards}">
          <c:forEach var="b" items="${boards}">
            <tr>
              <td><c:out value="${b.board_id}"/></td>
              <td class="title">
                <a href="${ctx}/tac_job/view.do?board_id=${b.board_id}">
                  <c:out value="${b.title}"/>
                </a>
              </td>
              <td class="writer"><c:out value="${b.nickname}"/></td>
              <td class="date"><fmt:formatDate value="${b.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
              <td class="hits"><c:out value="${b.view_count}"/></td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr><td colspan="5" class="empty">표시할 게시글이 없습니다.</td></tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>
