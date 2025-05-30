<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주소록 넣기</title>
<%--부트스트랩 라이브러리는 선언되어 있다고 가정 --%>
</head>
<body>
	<%@include file="/WEB-INF/views/common/header.jsp"%>
	
	<h3>주소록 넣기</h3>
	
	주소 입력 : <input type="text" name="inputAddress" id="inputAddress" required>
	<button type="submit" id="search">검색하기</button>
	
	<br>
    <button type="button">직접 입력하기</button>
    <button type="button">지도에서 선택하기</button>
    
    <div id='searchResult'>
    <%--
    이 영역은 숨겨진 영역으로, 검색하기를 누르고 ajax
    조회 결과가 success이면 튀어나옴
    --%>
    
    
    </div>
    
    <div>
    <%--조회된 결과를 선택하면 자동으로 form을 채워줌 --%>
	    <form action="insertLocation.me" method="post" id="searchForm">
	    	우편번호 : <input type="text" name="zipCode" disabled>
	    	도로명 주소 : <input type="text" name="roadAddress" disabled>
	    	지번 주소 : <input type="text" name="jibunAddress" disabled>
	    	상세 주소 : <input type="text" name="detailAddress" disabled>
	    	<input type='hidden' name='isMain' value='${pageScope.isMain}'>
	    	<button type="submit">저장하기</button>
	    </form>
    </div>
    
    <%--ajax결과가 success가 아니면 오류났다고 알리는 영역 띄우기 --%>
    
    <div>
    <%--이 영역은 숨겨진 영역으로, 직접 입력하기를 누르면 튀어나옴 --%>
    	<form action="insertLocation.me" method="post" id="insertFrom">
	    	우편번호 : <input type="text" name="zipCode">
	    	도로명 주소 : <input type="text" name="roadAddress">
	    	지번 주소 : <input type="text" name="jibunAddress">
	    	상세 주소 : <input type="text" name="detailAddress">
	    	<input type='hidden' name='isMain' value='${pageScope.isMain}'>
	    	<button type="submit">저장하기</button>
	    </form>
    </div>
	    
	<div>
   <%--이 영역은 숨겨진 영역으로, 지도에서 선택하기를 누르면 튀어나옴 --%>
		<form action="insertLocation.me" method="post" id="insertFrom">
    	우편번호 : <input type="text" name="zipCode">
	    	도로명 주소 : <input type="text" name="roadAddress">
	    	지번 주소 : <input type="text" name="jibunAddress">
	    	상세 주소 : <input type="text" name="detailAddress">
	    	<input type='hidden' name='isMain' value='${pageScope.isMain}'>
	    	<button type="submit">저장하기</button>
	    </form>
	</div>
   
	<script type="text/javascript">
	
	document.getElementById("search").addEventListener('click', function(){
		$.ajax({
			url: "getGeocode.lo",
			data: {inputAddress : inputAddress},
			method: 'GET',
		    dataType: 'json',
			success: function(result) {
				let searchResult = document.getElementById('div');
				
				if(result == null){
				<%-- 통신 오류가 발생! --%>
				}else if(result.size() == 0){
					<%-- 내용이 없다고 띄우기 --%>
				}
				
				
				<%--
				location객체를 컬랙션 리스트로 받아옴
				첫 번째 div영역에 우편번호, 도로명주소, 지번주소를 동적 생성해서 보여주기
				--%>
				
				for(let lo : result){
					searchResult.innerHTML += "우편번호 : "+${result.zipCode};
					searchResult.innerHTML += "도로명주소 : "+${result.roadAddress};
					searchResult.innerHTML += "지번주소 : "+${result.jibunAddress};
				}
				
				
				
				
			},
			error: function(){
				<%-- 통신 오류가 발생! --%>
				
			}
		});
   
	});
   
	</script>
</body>
</html>