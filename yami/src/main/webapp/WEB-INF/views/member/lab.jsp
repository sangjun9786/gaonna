<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
  <head>
	<script type="text/javascript" 
		src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=85oq183idp">
	</script>
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
		    	'${currLo}'에 있군요.
		    	<br>
    		</c:when>
    		<c:otherwise>
    			뭘봐요
    		</c:otherwise>
    	</c:choose>
    </div>
    <br>
    <button type="button" id='location2'>DORO!!</button>
    <div id="location2Div"></div>
    
    <c:set var="currLo" value="${sessionScope.currLo}"/>
    
    <form action="${root}/currLo.lab" method="post" id="locationForm">
    	<input type="hidden" name="latitude" id="latitude">
    	<input type="hidden" name="longitude" id="longitude">
    	<input type="hidden" name="timestamp" id="timestamp">
    </form>
    
    <br>
    <hr>
    <br>

	<h3>Web Dynamic Map</h3>
    <div id="map" style="width: 600px; height: 400px"></div>
    
    
    <br>
    <hr>
    <br>
    <form action="${root}/address.lab">
	    주소 입력 : <input type="textarea" name="address" id="address">
	    <button type="submit">DORO?</button>
    </form>
    <br>
    <div id="addresses">
    	<c:choose>
    		<c:when test="${empty sessionScope.currAdd }">
    			뭘봐요
    		</c:when>
    		<c:otherwise>
    			가까운 장소 검색 결과 : <br>
    			<c:set var="currAdd" value="${sessionScope.currAdd}" />
    			<ul>
					<c:forEach var="address" items="${currAdd}">
						<li>
							도로명 :
							${address.roadAddress}
						</li>
						<li>
							지번 :
							${address.jibunAddress}
						</li>
						<li>
							우편번호 :
							${address.zipCode}
						</li>
						<br>
					</c:forEach>
				</ul>
    		</c:otherwise>
    	</c:choose>
    </div>
    
    <br>
    <hr>
    <br>

    <h3>바로가기</h3>
    <br>
    <a href="http://localhost:8888/yami/confirmEmailInsert.me?tokenNo=0&token=0">회원가입 이메일 만료 체험</a>
    <br>
    
    
    <script type="text/javascript">
    	let div = document.getElementById('locationDiv');
    	let latitude;
    	let longitude;
    	let timestamp;
    	
    	document.getElementById('location').addEventListener('click',function(){
		    navigator.geolocation.getCurrentPosition(function(position) {
		    	latitude = position.coords.latitude;
		    	longitude = position.coords.longitude;
		    	timestamp = position.timestamp;
		    	
		    	console.log("위도 : "+latitude);
		    	console.log("경도 : "+longitude);
		    	
		    	
		    	document.getElementById('latitude').value = latitude;
		    	document.getElementById('longitude').value = longitude;
		    	document.getElementById('timestamp').value = timestamp;
		    	
		    	document.getElementById('locationForm').submit();
		    });
    	});
    	
    	document.getElementById('location2').addEventListener('click',function(){
		    navigator.geolocation.getCurrentPosition(function(position) {
		    	latitude = position.coords.latitude;
		    	longitude = position.coords.longitude;
		    	timestamp = position.timestamp;
		    	let location2Div = document.getElementById("location2Div");
		    	
		    	location2Div.innerHTML = '위도 :'+latitude+'<br>';
		    	location2Div.innerHTML += '경도 :'+longitude+'<br>';
		    });
    	});
    	
    	//지도
		var mapOptions = {
				  center: new naver.maps.LatLng(37.5392375,126.9003409),
				  zoom: 15,
				};

		var map = new naver.maps.Map("map", mapOptions);
    </script>
    
  </body>
</html>
