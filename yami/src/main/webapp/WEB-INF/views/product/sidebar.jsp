<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    .sidebar {
        width: 250px;
        padding: 20px;
        border-right: 1px solid #ccc;
    }

    .sidebar h4 {
        margin-top: 20px;
        font-weight: bold;
    }

    .write-btn {
        display: block;
        width: 100%;
        background-color: #ff6600;
        color: white;
        border: none;
        padding: 12px;
        font-size: 16px;
        border-radius: 4px;
        text-align: center;
        margin-bottom: 30px;
        text-decoration: none;
    }

    .write-btn:hover {
        background-color: #e05500;
        text-decoration: none;
        color: white;
    }
</style>

<div class="sidebar">
    <!-- 글작성 버튼 -->
    <a href="${pageContext.request.contextPath}/productEnrollForm.pr" class="write-btn">글작성</a>
    <c:if test="${empty cate}">
  		<script>
	  	  $(function() {
		     location.href = "${root}/get.ca";
		  });
	  </script>
	</c:if>
	<c:if test="${not empty loginUser and empty loca}">
		<script>
  			$(function() {
 		       location.href = "${root}/get.lo";
		    });
 		</script>
	</c:if>
    <h4>위치</h4>
    <h6>${userLoca }</h6>
    <input type="radio" name="location" value="0" checked>
    <label>전체</label> <br>
    <c:forEach var="item" items="${loca }">
        <input type="radio" name="location" value=${item.locationNo }>
        <label>${item.locationName }</label> <br>
    </c:forEach>
    
    <h4>카테고리</h4>
    <input type="radio" name="category" value="0" checked>
    <label>전체</label> <br>
    <c:forEach var="item" items="${cate }">
        <input type="radio" name="category" value=${item.categoryNo }>
        <label>${item.categoryName }</label> <br>
    </c:forEach>
	<h4>가격</h4>
	<input type="number" name="price1"> <br> ~ <br> <input type="number" name="price2">
	
</div>