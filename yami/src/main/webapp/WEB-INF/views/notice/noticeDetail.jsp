<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!DOCTYPE html>
<html>
<head>
  <title>공지사항 상세</title>
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #f6f6f6;
      margin: 0;
      padding: 0;
    }

    .container {
      width: 100%;
      max-width: 780px;
      background: #fff;
      border-radius: 16px;
      padding: 40px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.05);
      margin: 60px auto; 
    }

    .notice-header {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 30px;
    }

    .notice-header img {
      width: 32px;
      height: auto;
    }

    .notice-header h2 {
      font-size: 22px;
      font-weight: bold;
      margin: 0;
      color: #222;
    }

    .notice-title {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 12px;
      color: #333;
    }

    .notice-meta {
      font-size: 14px;
      color: #777;
      margin-bottom: 20px;
      border-bottom: 1px solid #eee;
      padding-bottom: 10px;
    }

    .notice-content {
      font-size: 15px;
      color: #333;
      line-height: 1.6;
      white-space: pre-line;
      margin-bottom: 30px;
    }

    .btn-group {
      text-align: right;
    }

    .btn-group a {
      display: inline-block;
      margin-left: 10px;
      background-color: #ff6f00;
      color: #fff;
      padding: 10px 18px;
      border-radius: 6px;
      font-size: 14px;
      text-decoration: none;
      font-weight: bold;
    }

    .btn-group a:hover {
      background-color: #e85f00;
    }
  </style>
</head>
<body>

  <div class="container">
    
    <div class="notice-header">
      <img src="${pageContext.request.contextPath}/resources/img/photoaa.png" alt="공지 아이콘">
      <h2>공지사항</h2>
    </div>

    <div class="notice-title">${n.noticeTitle}</div>

    <div class="notice-meta">
      작성자: ${n.userId} &nbsp;&nbsp;/&nbsp;&nbsp;
      등록일: ${n.createDate} &nbsp;&nbsp;/&nbsp;&nbsp;
      조회수: ${n.count}
    </div>

    <div class="notice-content">${n.noticeContent}</div>

    <div class="btn-group">
      <a href="${pageContext.request.contextPath}/notice/updateForm?nno=${n.noticeNo}">수정</a>
      <a href="${pageContext.request.contextPath}/notice/delete?nno=${n.noticeNo}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
      <a href="${pageContext.request.contextPath}/notice/list">목록</a>
    </div>

  </div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
