<%@ include file="/WEB-INF/views/common/header.jsp" %>

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
  h2 {
    font-size: 22px;
    font-weight: bold;
    margin-bottom: 30px;
    color: #222;
  }
  label {
    font-weight: 500;
    margin-bottom: 6px;
    display: block;
  }
  input[type="text"], textarea {
    width: 100%;
    padding: 12px;
    margin-bottom: 20px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 15px;
  }
  textarea {
    height: 200px;
    resize: vertical;
  }
  .btn-group {
    text-align: right;
  }
  .btn-group button {
    background-color: #ff6f00;
    color: white;
    padding: 10px 20px;
    border: none;
    font-weight: bold;
    border-radius: 6px;
    font-size: 14px;
    cursor: pointer;
  }
  .btn-group button:hover {
    background-color: #e85f00;
  }
  
  .btn-group {
    text-align: right;
    margin-top: 30px; 
}
</style>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head><title>공지사항 수정</title></head>
<body>

  <div class="container">
  <h2>공지사항 수정</h2>
	  <form action="${pageContext.request.contextPath}/notice/update" method="post">
		  <input type="hidden" name="noticeNo" value="${notice.noticeNo}">
		  <label for="title">제목</label>
		  <input type="text" id="title" name="noticeTitle" value="${notice.noticeTitle}" required>
		  <label for="content">내용</label>
		  <textarea id="content" name="noticeContent" required>${notice.noticeContent}</textarea>
		  <div class="btn-group" style="text-align:right;">
		    <button type="submit">수정하기</button>
		  </div>
	  </form>
</div>

</body>
</html>
