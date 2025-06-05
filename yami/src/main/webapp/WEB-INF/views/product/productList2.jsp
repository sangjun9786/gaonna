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
            font-family: '맑은 고딕', sans-serif;
            background-color: #f9f9f9;
        }

        .container-main {
            display: flex;
            padding: 20px;
        }

        .content {
            flex: 1;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
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

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="container-main">

    <%@ include file="/WEB-INF/views/product/sidebar.jsp" %> <!-- 사이드바 인클루드 -->

    <div class="content">
        <h2>📸 가온나 야미 리스트</h2>
        <div class="photo-grid">
            <c:forEach var="photo" items="${photos}">
                <div class="photo-item">
    <a href="${pageContext.request.contextPath}/productDetail.pro?productNo=${photo.productNo}" style="text-decoration: none; color: inherit;">
        <img src="${pageContext.request.contextPath}/resources/img/${photo.path}" alt="${photo.title}">
        <div class="photo-title">${photo.title}</div>
        <div class="photo-price">${photo.price}원</div>
        <div class="photo-location-category">${photo.location} ${photo.category}</div>
    </a>
</div>
            </c:forEach>
        </div>

        <!-- 페이지네이션 표시 -->
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <c:forEach var="i" begin="${pi.startPage}" end="${pi.endPage}">
                    <li class="page-item ${pi.currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/productList.pro?currentPage=${i}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </div>
</div>

</body>
</html>