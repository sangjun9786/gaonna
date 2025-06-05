<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    body {
        font-family: '맑은 고딕', sans-serif;
        background-color: #f9f9f9;
        margin: 0;
        padding: 0;
    }

    .container-main {
        display: flex;
        padding: 20px;
    }

    .form-container {
        flex: 1;
        background-color: white;
        padding: 30px;
        margin: 0 20px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-label {
        font-weight: bold;
        margin-bottom: 5px;
        display: block;
    }

    .form-control {
        width: 100%;
        padding: 10px;
        font-size: 14px;
        border-radius: 5px;
        border: 1px solid #ccc;
    }

    .form-control-file {
        margin-top: 5px;
    }

    .preview img {
        width: 150px;
        height: 120px;
        object-fit: cover;
        margin: 5px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    .action-btn {
        background-color: #ff6600;
        color: white;
        border: none;
        padding: 12px;
        width: 100%;
        font-size: 16px;
        cursor: pointer;
        border-radius: 4px;
    }
</style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:if test="${empty loginUser}">
<script>
    alert("로그인 후 이용 가능한 서비스입니다.");
    location.href = "${contextPath}/login.me";
</script> 
</c:if> 

<c:if test="${not empty loginUser}">
<div class="container-main">
    <%@ include file="/WEB-INF/views/product/sidebar.jsp" %>

    <div class="form-container">
        <h2>상품 등록</h2>
        <form method="post" action="${contextPath}/productEnrollForm.pr" enctype="multipart/form-data">
            <!-- 로그인 유저 번호 hidden -->
            <input type="hidden" name="userNo" value="${loginUser.userNo}">

            <div class="form-group">
                <label class="form-label">대표 이미지</label>
                <input type="file" name="uploadFiles" class="form-control-file" accept="image/*" required multiple>
                <div class="preview" id="preview-area"></div>
            </div>

            <div class="form-group">
                <label class="form-label">제목</label>
                <input type="text" name="productTitle" class="form-control" placeholder="상품 제목 입력" required>
            </div>

            <div class="form-group">
                <label class="form-label">상세 설명</label>
                <textarea name="productContent" class="form-control" rows="5" placeholder="상품에 대한 설명을 작성하세요." required></textarea>
            </div>

            <div class="form-group">
                <label class="form-label">가격 (원)</label>
                <input type="number" name="price" class="form-control" placeholder="예: 10000" required>
            </div>

            <div class="form-group">
                <label class="form-label">카테고리</label>
                <select name="categoryNo" class="form-control" required>
                    <option value="">-- 카테고리를 선택하세요 --</option>
                    <c:forEach var="category" items="${categoryList}">
                        <option value="${category.categoryNo}">${category.categoryName}</option>
                    </c:forEach>
                </select>
            </div>

            <button type="submit" class="action-btn">작성 완료</button>
        </form>
    </div>
</div>
</c:if>

<script>
    // 이미지 미리보기
    document.querySelector('input[type="file"]').addEventListener('change', function(e) {
        const previewArea = document.getElementById('preview-area');
        previewArea.innerHTML = ''; // 초기화
        const files = e.target.files;

        Array.from(files).forEach(file => {
            const reader = new FileReader();
            reader.onload = function(ev) {
                const img = document.createElement('img');
                img.setAttribute('src', ev.target.result);
                previewArea.appendChild(img);
            };
            reader.readAsDataURL(file);
        });
    });
</script>

</body>
</html>