<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8"/>
    <title>YAMI</title>
  </head>
  <body>
    <%@include file="/WEB-INF/views/common/header.jsp"%>
	
	<hr>
	<h3>이메일 실험하기</h3>
	<br>
    <form action="${root}/sendEmail" method="post">
      이메일 : <input type="email" name="toAddress" required/> <br />
      제목 : <input type="text" name="subject" required/> <br />
      내용 : <input type="text" name="content" required/> <br />
      <button type="submit">이메일 보내기</button>
    </form>
    
    <br>
    <hr>
    <br>

    <h3>바로가기</h3>
    <br>
    <a href="http://localhost:8888/yami/confirmEmailInsert.me?tokenNo=0&token=0">회원가입 이메일 만료 체험</a>
    <br>
    
  </body>
</html>
