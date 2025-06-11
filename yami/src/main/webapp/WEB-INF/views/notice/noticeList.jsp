<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
  <title>공지사항 목록</title>
  <%@ include file="/WEB-INF/views/common/header.jsp" %>

  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #ffffff;
      margin: 0;
      padding: 20px;
    }

    .container {
      width: 100%;
      max-width: 980px;
      background-color: #fff;
      padding: 50px;
      box-shadow: 0 0 20px rgba(0,0,0,0.05);
      border-radius: 12px;
    }

    .notice-header {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 30px;
    }

    .notice-header img {
      width: 26px;
      height: 26px;
    }

    .notice-header h2 {
      font-size: 22px;
      font-weight: bold;
      color: #333;
      margin: 0;
    }

    table.notice-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 30px;
      table-layout: fixed;
    }

    table.notice-table col:nth-child(1) { width: 8%; }
    table.notice-table col:nth-child(2) { width: 44%; }
    table.notice-table col:nth-child(3) { width: 18%; }
    table.notice-table col:nth-child(4) { width: 10%; }
    table.notice-table col:nth-child(5) { width: 20%; }

    thead {
      border-top: 2px solid #ff6f00;
      border-bottom: 2px solid #ddd;
    }

    th {
      padding: 14px 12px;
      background-color: #fefefe;
      font-weight: 500;
      font-size: 14px;
      color: #444;
      text-align: center;
      word-break: keep-all;
    }

    td {
      padding: 14px 12px;
      font-size: 14px;
      color: #333;
      border-bottom: 1px solid #eee;
      text-align: center;
      word-break: break-all;
    }

    td.title-cell {
      text-align: left;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      max-width: 0;
    }

    .title-link {
      color: #222;
      text-decoration: none;
      display: block;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    .title-link:hover {
      color: #ff6f00;
      text-decoration: underline;
    }

    .write-btn {
      display: inline-block;
      background-color: #ff6f00;
      color: white;
      padding: 12px 30px;
      border: none;
      border-radius: 6px;
      font-size: 14px;
      font-weight: bold;
      text-decoration: none;
      cursor: pointer;
      margin-left: 5px;
    }

    .write-btn:hover {
      background-color: #e65c00;
    }

    .pagination {
      margin-top: 30px;
      display: flex;
      justify-content: center;
      gap: 4px;
    }

    .page-btn {
      display: inline-block;
      padding: 8px 14px;
      margin: 0 2px;
      border: 1px solid #ddd;
      border-radius: 4px;
      color: #ff6f00;
      text-decoration: none;
      font-weight: bold;
    }

    .page-btn:hover {
      background-color: #fff5ec;
    }

    .page-btn.active {
      background-color: #ff6f00;
      color: #fff;
      pointer-events: none;
      border: 1px solid #ff6f00;
    }

    .write-btn-area {
      margin-top: 10px;
      text-align: right;
    }
  </style>
</head>

<body>
  <div class="container">
    <div class="notice-header">
      <img src="${pageContext.request.contextPath}/resources/img/photoaa.png" alt="공지">
      <h2>공지사항</h2>
    </div>

    <table class="notice-table">
      <colgroup>
        <col />
        <col />
        <col />
        <col />
        <col />
      </colgroup>
      <thead>
        <tr>
          <th>번호</th>
          <th style="text-align:left;">제목</th>
          <th>작성자</th>
          <th>조회수</th>
          <th>등록일</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="notice" items="${list}" varStatus="status">
          <tr>
            <td>${pageInfo.listCount - (pageInfo.currentPage - 1) * pageInfo.boardLimit - status.index}</td>
            <td class="title-cell">
              <a href="${pageContext.request.contextPath}/notice/detail?nno=${notice.noticeNo}"
                 class="title-link">${notice.noticeTitle}</a>
            </td>
            <td>${notice.userId}</td>
            <td>${notice.count}</td>
            <td>${notice.createDate}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <div class="pagination">
      <c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
        <c:choose>
          <c:when test="${i eq pageInfo.currentPage}">
            <span class="page-btn active">${i}</span>
          </c:when>
          <c:otherwise>
            <a class="page-btn" href="${pageContext.request.contextPath}/notice/list?cpage=${i}">${i}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>
    </div>

    <c:if test="${loginUser.roleType ne 'N'}">
      <div class="write-btn-area">
        <a href="${pageContext.request.contextPath}/notice/enrollForm" class="write-btn">공지사항 등록</a>
      </div>
    </c:if>
  </div>
</body>
</html>
