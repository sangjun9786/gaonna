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
	  margin-left: 400px;
	  margin-right: 400px;
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
			    <option value="resell" ${condition == 'resell' ? 'selected' : ''}>Resell</option>
			    <option value="location" ${condition == 'location' ? 'selected' : ''}>Location</option>
			    <option value="notice" ${condition == 'notice' ? 'selected' : ''}>Notice</option>
			</select>
		</div>
		<input type="text" class="form-control form-control-lg"
			id="keyword" placeholder="제목 또는 내용으로 검색" aria-label="Search"
			value="${keyword}">
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
			let url = '';	            
			if (condition == 'resell') {
				url = '${root}/filter.bo?location=${selectedLocation}&category=${selectedCategory}&price1=${selectedPrice1}&price2=${selectedPrice2}&keyword=' + encodedKeyword + '&condition=' + condition;
			} else if (condition == 'location') {
				url = '${root}/dongneMain.dn?keyword=' + encodedKeyword + '&condition=' + condition;
			} else if (condition == 'notice') {
				url = '${root}/notice/list?keyword=' + encodedKeyword + '&condition=' + condition;
			}
			if (url) {
				location.href = url;
			}
		});
	});
</script>	
</body>
</html>