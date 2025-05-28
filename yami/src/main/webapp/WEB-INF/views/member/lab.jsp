<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
  <head>
	<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=85oq183idp"></script>
    <meta charset="UTF-8"/>
    <title>YAMI</title>
  </head>
  <body>
    <%@include file="/WEB-INF/views/common/header.jsp"%>
	<hr>
	<h3>이메일</h3>
	<br>
    <form action="${root}/sendEmail" method="post">
      이메일 : <input type="email" name="toAddress" required/> <br />
      제목 : <input type="text" name="subject" required/> <br />
      내용 : <input type="text" name="content" required/> <br />
      <button type="submit">이메일 보내기</button>
    </form>
    
    <hr>
    <br>
  	<h3>위치확인</h3>
    <button type="button" id='location'>DORO!</button>
    <div id = 'locationDiv'>
    	<c:choose>
    		<c:when test="${not empty currLo}">
		    	흠...당신은
		    	<br>
		    	좌표가 '${currLo.longitude}, ${currLo.latitude}'이니
		    	<br>
		    	'${currLo.area1} ${currLo.area2} ${currLo.area3}'에 있군요.
		    	<br>
    		</c:when>
    		<c:otherwise>
    			뭘봐요
    		</c:otherwise>
    	</c:choose>
    </div>
    <c:set var="currLo" value="${sessionScope.currLo}"/>
    
    <form action="${root}/get.lo" method="post" id="locationForm">
    	<input type="hidden" name="latitude" id="latitude">
    	<input type="hidden" name="longitude" id="longitude">
    	<input type="hidden" name="timestamp" id="timestamp">
    </form>
    
    <br>
    <hr>
    <br>

    <div id="map" style="width: 600px; height: 400px"></div>

    <script>
    

    </script>
    
    
    <br>
    <hr>
    <br>

    <h3>바로가기</h3>
    <br>
    <a href="http://localhost:8888/yami/confirmEmailInsert.me?tokenNo=0&token=0">회원가입 이메일 만료 체험</a>
    <br>
    
    
    <script type="text/javascript">
    	let div = document.getElementById('locationDiv');
    	let latitude = position.coords.latitude;
    	let longitude = position.coords.longitude;
    	let timestamp = position.timestamp;
    	
    	document.getElementById('location').addEventListener('click',function(){
		    navigator.geolocation.getCurrentPosition(function(position) {
		    	
		    	document.getElementById('latitude').value = latitude;
		    	document.getElementById('longitude').value = longitude;
		    	document.getElementById('timestamp').value = timestamp;
		    	
		    	document.getElementById('locationForm').submit();
		    });
    	});
    	
    	//지도
		var mapOptions = {
				  center: new naver.maps.LatLng(longitude, latitude),
				  zoom: 10,
				};

		var map = new naver.maps.Map("map", mapOptions);
    </script>
    
  </body>
</html>
