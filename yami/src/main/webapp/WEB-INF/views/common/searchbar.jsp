<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<link
	href="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/webjars/bootstrap/5.3.5/js/bootstrap.bundle.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<meta charset="UTF-8">
<title>searchbar</title>
<style>
	#warp {
	  display: flex;
	  align-items: center;
	  gap: 10px;
	  margin-left: 300px;
	  margin-right: 300px;
	}
	.select {
		margin-top: 15px;
	}
</style>
</head>
<body>
	<c:set var="root" value="${pageContext.request.contextPath}"/>
	<c:set var="loginUser" value="${sessionScope.loginUser}"/>
	<div id="warp">
		<div class="select">
	    	<select class="form-select form-select-lg mb-3" id="condition">
				<option value="resell">Resell</option>
			    <option value="location">Location</option>
			    <option value="notice">Notice</option>
			    <option value="qna">QnA</option>
			    <option value="report">Report</option>
			</select>
		</div>
		<input type="text" class="form-control form-control-lg"
			id="keyword" placeholder="제목 또는 내용으로 검색" aria-label="Search"
			value = ${keyword }>
		<button class="btn btn-primary btn-lg" type="submit" id="searchBtn">
			<i class="bi bi-search"></i>
		</button>
	</div>
<script>
	$(document).ready(function() { // DOM 로드 후 실행을 보장하는 표준 방식
	
		// 이벤트 위임을 사용하여 #warp 내의 #searchBtn 클릭 이벤트를 처리
		$('#warp').on('click', '#searchBtn', function (e) {
			e.preventDefault(); // **가장 중요: 버튼의 기본 폼 제출 동작을 막습니다.**
	
			console.log('Search button clicked!'); // 디버깅용 로그
	
			let condition = $('#condition').val(); // ID 셀렉터 사용
			let keyword = $('#keyword').val();     // ID 셀렉터 사용
			let encodedKeyword = encodeURIComponent(keyword);
				            
			if (condition == 'resell') {
				$.ajax({
					type: 'POST',
					url: '${root}/saveKeyword', // ${root}를 사용하여 절대 경로 지정
					data: {
						keyword: keyword
					},
					success: function(response) {
						console.log('세션에 키워드 저장 성공:', response);
						location.href = '${root}/filter.bo?location=${selectedLocation}&category=${selectedCategory}&price1=${selectedPrice1}&price2=${selectedPrice2}';
					},
					error: function(xhr, status, error) {
						console.error('세션 저장 실패:', error);
						alert('검색어 저장 중 오류가 발생했습니다.');
					}
				});
			} else { // resell이 아닌 다른 조건일 경우
				if (condition == 'location') {
					url = '${root}/locationSearch?keyword=' + encodedKeyword;
				} else if (condition == 'notice') {
					$.ajax({
						type: 'POST',
						url: '${root}/saveKeyword', // ${root}를 사용하여 절대 경로 지정
						data: {
							keyword: keyword
						},
						success: function(response) {
							console.log('세션에 키워드 저장 성공:', response);
							location.href = '${root}/searchNotice';
						},
						error: function(xhr, status, error) {
							console.error('세션 저장 실패:', error);
							alert('검색어 저장 중 오류가 발생했습니다.');
						}
					});
				} else if (condition == 'qna') {
					url = '${root}/qnaSearch?keyword=' + encodedKeyword;
				} else if (condition == 'report') {
					url = '${root}/reportSearch?keyword=' + encodedKeyword;
				}
				if (url) { // url이 정의된 경우에만 이동
					location.href = url;
				}
			}
		});
	});
</script>	
</body>
</html>