<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>추천 게시판</title>
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
		    /* 기존: text-align: center; 제거 */
		    text-align: left; /* 왼쪽 정렬 적용 */
		    cursor: pointer;
		    display: flex;
		    flex-direction: column;
		    justify-content: space-between;
		    height: 100%;
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
            font-size: 16px;
            min-height: 40px;
        }

        .photo-price {
            color: red;
            font-weight: bold;
            margin-top: 5px;
        }

        .photo-info {
            display: flex;
		    justify-content: space-between;
		    font-size: 14px;
		    color: #555;
		    min-height: 65px;
        }
        
        .info-left, .info-right {
		    display: flex;
		    flex-direction: column;
		    gap: 2px;
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
<%@ include file="/WEB-INF/views/common/searchbar.jsp" %>

<div class="container-main">

    

    <div class="content">
        <h2>📸 가온나 인기 회원의 상품</h2>
        <div class="photo-grid">
            <c:forEach var="product" items="${list2}">
                <div class="photo-item"
                     onclick="location.href='${pageContext.request.contextPath}/productDetail.pro?productNo=${product.productNo}'">

                    <c:if test="${not empty product.atList}">
							<img src="${pageContext.request.contextPath}/resources/uploadFiles/${product.atList[0].changeName}" alt="${product.productTitle}" />
                    </c:if>
                    <c:if test="${empty product.atList}">
                        <img src="${pageContext.request.contextPath}/resources/img/default.png" alt="기본 이미지">
                    </c:if>

                    <div class="photo-title">${product.productTitle}</div>
                    <div class="photo-price">${product.price}원</div>

                    <div class="photo-info d-flex justify-content-between">
				    <!-- 왼쪽 정보 -->
				    <div class="info-left">
				        <div>${product.coordAddress}</div>
				        <div>${product.userName}</div>
				        <div>${product.categoryName}</div>
				    </div>
				
				    <!-- 오른쪽 정보 -->
				    <div class="info-right text-end">
				        <div>👁️ ${product.productCount}</div>
				        <div>❤️ ${product.wishCount}</div>
				        <div>
				            <fmt:formatDate value="${product.uploadDate}" pattern="yy.MM.dd" />
				        </div>
				    </div>
				</div>
                </div>
            </c:forEach>
        </div>
        <br>
        <br>
		<div class="content">
        <h2>📸 가온나 최고 인기 상품</h2>
        <div class="photo-grid">
            <c:forEach var="product" items="${list}">
                <div class="photo-item"
                     onclick="location.href='${pageContext.request.contextPath}/productDetail.pro?productNo=${product.productNo}'">

                    <c:if test="${not empty product.atList}">
							<img src="${pageContext.request.contextPath}/resources/uploadFiles/${product.atList[0].changeName}" alt="${product.productTitle}" />
                    </c:if>
                    <c:if test="${empty product.atList}">
                        <img src="${pageContext.request.contextPath}/resources/img/default.png" alt="기본 이미지">
                    </c:if>

                    <div class="photo-title">${product.productTitle}</div>
                    <div class="photo-price">${product.price}원</div>

                    <div class="photo-info d-flex justify-content-between">
				    <!-- 왼쪽 정보 -->
				    <div class="info-left">
				        <div>${product.coordAddress}</div>
				        <div>${product.userName}</div>
				        <div>${product.categoryName}</div>
				    </div>
				
				    <!-- 오른쪽 정보 -->
				    <div class="info-right text-end">
				        <div>👁️ ${product.productCount}</div>
				        <div>❤️ ${product.wishCount}</div>
				        <div>
				            <fmt:formatDate value="${product.uploadDate}" pattern="yy.MM.dd" />
				        </div>
				    </div>
				</div>
              </div>
            </c:forEach>
        </div>
        
    </div>
</div>

</body>
</html>