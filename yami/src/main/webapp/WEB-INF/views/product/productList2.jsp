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
            cursor: pointer; /* ★ 클릭 가능한 느낌 */
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
        
       
        .pagination .page-item.active .page-link {
            background-color: #fd7e14;
    		border-color: #fd7e14;
    		color: white;
        }
        .pagination .page-link {
            color: #fd7e14;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="container-main">

    <%@ include file="/WEB-INF/views/product/sidebar.jsp" %>

    <div class="content">
        <h2>📸 가온나 야미 리스트</h2>
        <div class="photo-grid">
            <c:forEach var="product" items="${list}">
                <div class="photo-item"
                     onclick="location.href='${pageContext.request.contextPath}/productDetail.pro?productNo=${product.productNo}'">
                    
                        <c:if test="${not empty product.atList}">
                            <img src="${pageContext.request.contextPath}${product.atList[0].filePath}/${product.atList[0].changeName}" alt="${product.productTitle}">
                        </c:if>
                        <c:if test="${empty product.atList}">
                            <img src="${pageContext.request.contextPath}/resources/img/default.png" alt="기본 이미지">
                        </c:if>
                    
                    <div class="photo-title">${product.productTitle}</div>
                    <div class="photo-price">${product.price}원</div>
                    <div class="photo-location-category">${product.userNo} | 카테고리: ${product.categoryNo}</div>
                </div>
            </c:forEach>
        </div>

<!--         페이지네이션 -->
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <c:forEach var="i" begin="${pi.startPage}" end="${pi.endPage}">
                    <li class="page-item ${pi.currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/productList2.pro?currentPage=${i}">
                    ${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </div>
</div>

</body>
</html>