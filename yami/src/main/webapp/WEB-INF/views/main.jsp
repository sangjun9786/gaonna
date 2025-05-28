<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <br>
    <button type="button" id='location'>위치확인</button>
    <div id = 'locationDiv'></div>
    <br>
    <hr>
    <br>

    <h3>바로가기</h3>
    <br>
    <a href="http://localhost:8888/yami/confirmEmailInsert.me?tokenNo=0&token=0">회원가입 이메일 만료 체험</a>
    <br><br><br>
    <a href="${root}/lab">실험실</a>

    <script type="text/javascript">
    	document.getElementById('location').addEventListener('click',function(){
		    navigator.geolocation.getCurrentPosition(function(position) {
		    	let div = document.getElementById('locationDiv');
		    	div.innerHTML ="위도 : "+position.coords.latitude;
		    	div.innerHTML +=" 경도 : "+position.coords.longitude;
		    	div.innerHTML +=" 시간 : "+position.timestamp;
		    });
    	});
    </script>
  </body>
</html>
