<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setTimeZone value="Asia/Seoul"/>

<link rel="stylesheet" href="${ctx}/resources/css/freeboard.css"/>

<div class="wrap">
  <div class="toolbar">
    <span class="muted">자유 게시판</span>
    <span class="spacer"></span>

    <a class="btn" href="<c:url value='/free/list.do'/>">새로고침</a>

    <c:if test="${login}">
      <a class="btn primary" href="<c:url value='/free/write.do'/>">글쓰기</a>
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
        <c:when test="${not empty posts}">
          <c:forEach var="p" items="${posts}">
            <tr>
              <td><c:out value="${p.postId}"/></td>
              <td class="title">
                <a href="<c:url value='/free/view.do'><c:param name='postId' value='${p.postId}'/></c:url>">
                  <c:out value="${p.title}"/>
                </a>
              </td>
              <td class="writer"><c:out value="${p.writerName}"/></td>
              <td class="date"><fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
              <td class="hits"><c:out value="${p.viewCnt}"/></td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr><td colspan="5" class="empty">표시할 게시글이 없습니다.</td></tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>

  <div class="pager">
    <c:if test="${page > 1}">
      <a href="<c:url value='/free/list.do'><c:param name='page' value='${page-1}'/><c:param name='size' value='${size}'/></c:url>">‹</a>
    </c:if>
    <a class="on">${page}</a>
    <c:if test="${page < totalPages}">
      <a href="<c:url value='/free/list.do'><c:param name='page' value='${page+1}'/><c:param name='size' value='${size}'/></c:url>">›</a>
    </c:if>
  </div>
</div>
