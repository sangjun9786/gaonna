<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>상품 리스트</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        .container-main {
            display: flex;
            padding: 20px;
        }

        .sidebar {
            width: 250px;
            padding: 20px;
            border-right: 1px solid #ccc;
        }

        .sidebar h4 {
            margin-top: 20px;
            font-weight: bold;
        }

        .content {
            flex: 1;
            padding: 20px;
        }

        .photo-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .photo-item {
            background-color: #fff;
            padding: 10px;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            text-align: center;
        }

        .photo-item img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 5px;
        }

        .photo-title {
            margin-top: 10px;
            font-weight: bold;
        }

        .photo-price {
            color: red;
            font-weight: bold;
            margin-top: 5px;
        }

        .photo-location-category {
            font-size: 14px;
            color: #888;
            margin-top: 3px;
        }
    </style>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp" %>

<div class="container-main">
    <!-- 사이드바 -->
    <div class="sidebar">
     <!-- 메인 페이지로 가기 버튼 -->
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary btn-block mb-3">메인으로</a>
    
        <h4>위치</h4>
        <ul>
            <li><input type="checkbox"> 강남구</li>
            <li><input type="checkbox"> 역삼동</li>
            <li><input type="checkbox"> 청담동</li>
            <li><input type="checkbox"> 당산동</li>
        </ul>

        <h4>카테고리</h4>
        <ul>
            <li><input type="checkbox"> 패션잡화</li>
            <li><input type="checkbox"> 전자기기</li>
            <li><input type="checkbox"> 가전/주방</li>
        </ul>
    </div>

    <!-- 상품 리스트 -->
    <div class="content">
        <h2>📸 가온나 야미 리스트</h2>
        <div class="photo-grid">
            <c:forEach var="photo" items="${photos}">
                <div class="photo-item">
                    <img src="${pageContext.request.contextPath}/resources/img/${photo.path}" alt="${photo.title}">
                    <div class="photo-title">${photo.title}</div>
                    <div class="photo-price">${photo.price}원</div>
                    <div class="photo-location-category">${photo.location} ${photo.category}</div>
                </div>
            </c:forEach>
        </div>

        <!-- 페이지네이션 표시 -->
        <nav aria-label="Page navigation" class="mt-4">
    <ul class="pagination justify-content-center">
        <c:forEach var="i" begin="${pi.startPage}" end="${pi.endPage}">
            <li class="page-item ${pi.currentPage == i ? 'active' : ''}">
                <c:choose>
                    <c:when test="${i == 1}">
                        <a class="page-link" href="${pageContext.request.contextPath}/productList.pro">${i}</a>
                    </c:when>
                    <c:otherwise>
                        <a class="page-link" href="${pageContext.request.contextPath}/productList.pro?currentPage=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </li>
        </c:forEach>
    </ul>
</nav>
    </div>
</div>
</body>
</html>