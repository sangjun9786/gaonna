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
	$(document).ready(function() {
		$('#warp').on('click', '#searchBtn', function (e) {
			e.preventDefault();
	
			console.log('Search button clicked!');
	
			let condition = $('#condition').val();
			let keyword = $('#keyword').val();
			let encodedKeyword = encodeURIComponent(keyword);
				            
			if (condition == 'resell') {
				$.ajax({
					type: 'POST',
					url: '${root}/saveKeyword',
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
			} else if (condition == 'location') {
				location.href = '${root}/locationSearch';
			} else if (condition == 'notice') {
				$.ajax({
					type: 'POST',
					url: '${root}/saveKeyword',
					data: {
						keyword: keyword
					},
					success: function(response) {
						console.log('세션에 키워드 저장 성공:', response);
						location.href = '${root}/notice/list';
					},
					error: function(xhr, status, error) {
						console.error('세션 저장 실패:', error);
						alert('검색어 저장 중 오류가 발생했습니다.');
					}
				});
			} else if (condition == 'qna') {
				location.href = '${root}/qnaSearch';
			} else if (condition == 'report') {
				location.href = '${root}/reportSearch';
			}
		});
	});
</script>	
</body>
</html>