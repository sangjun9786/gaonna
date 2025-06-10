<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>가고구 드래그 등록</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
            font-size: 14px;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .preview {
            display: flex;
            flex-wrap: wrap;
        }
        .preview-item {
            position: relative;
            margin: 5px;
        }
        .preview-item img {
            width: 150px;
            height: 120px;
            object-fit: cover;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .remove-btn {
            position: absolute;
            top: 0;
            right: 0;
            background: red;
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            font-size: 14px;
            line-height: 20px;
            text-align: center;
            cursor: pointer;
        }
        .file-names {
            margin-top: 10px;
            font-size: 14px;
            font-weight: bold; /* 폰트 굵기 추가 */
    		display: block;
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
        .file-label {
            padding: 6px 12px;
            font-size: 14px;
            background-color: #ff6600;
            color: white;
            border-radius: 4px;
            cursor: pointer;
            display: inline-block;
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
        <form method="post" action="${contextPath}/productEnrollForm.pr" enctype="multipart/form-data" onsubmit="return validateForm();">
            <input type="hidden" name="userNo" value="${loginUser.userNo}">

            <!-- 대표 이미지 -->
            <div class="form-group">
                <label class="form-label">대표 이미지 (1개만 등록 가능합니다)</label>
                <label class="file-label" id="thumbnail-label">파일 선택</label>
                <input type="file" name="thumbnail" class="form-control-file" id="thumbnail" accept="image/*" style="display: none;">
                <div class="preview" id="preview-thumbnail"></div>
                <div class="file-names" id="thumbnail-file-name" style="font-size:14px;"></div>
            </div>

            <!-- 상세 이미지 -->
            <div class="form-group">
                <label class="form-label">상세 이미지</label>
                <label for="detail-images" class="file-label">파일 선택</label>
                <input type="file" name="uploadFiles" class="form-control-file" id="detail-images" accept="image/*" multiple style="display: none;">
                <div class="preview" id="preview-detail"></div>
                <div class="file-names" id="detail-file-names" style="font-size:14px;"></div>
            </div>

            <!-- 제목, 설명 등 -->
            <div class="form-group">
                <label class="form-label">제목</label>
                <input type="text" name="productTitle" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="form-label">상세 설명</label>
                <textarea name="productContent" class="form-control" rows="5" required></textarea>
            </div>
            <div class="form-group">
                <label class="form-label">가격 (원)</label>
                <input type="number" name="price" class="form-control" required>
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
    const maxDetailImages = 3;
    let detailFileList = [];

    $('#thumbnail-label').on('click', function () {
        $('#thumbnail').click();
    });

    $('#thumbnail').on('change', function () {
        const preview = $('#preview-thumbnail');
        const fileNameDisplay = $('#thumbnail-file-name');
        preview.empty();
        fileNameDisplay.empty();

        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                const item = $('<div class="preview-item"></div>');
                const img = $('<img>').attr('src', e.target.result);
                const btn = $('<button class="remove-btn">x</button>').on('click', function () {
                    $('#thumbnail').val("");
                    preview.empty();
                    fileNameDisplay.empty();
                });
                item.append(img).append(btn);
                preview.append(item);
            }
            reader.readAsDataURL(file);
            fileNameDisplay.text("파일명1: " + file.name);
        }
    });

    $('#detail-images').on('change', function () {
        console.log(this.files); // 파일 선택 확인용

        const files = Array.from(this.files);
        const preview = $('#preview-detail');
        const fileNameContainer = $('#detail-file-names');

        if (files.length + detailFileList.length > maxDetailImages) {
            alert("상세 이미지는 최대 " + maxDetailImages + "개까지 등록 가능합니다.");
            return this.value = "";
        }

        files.forEach((file) => {
            const reader = new FileReader();
            reader.onload = function (e) {
                const item = $('<div class="preview-item"></div>');
                const img = $('<img>').attr('src', e.target.result);
                const btn = $('<button class="remove-btn">x</button>').on('click', function () {
                    const i = detailFileList.indexOf(file);
                    if (i > -1) detailFileList.splice(i, 1);
                    item.remove();
                    nameItem.remove();
                });
                item.append(img).append(btn);
                preview.append(item);
            }
            reader.readAsDataURL(file);

            detailFileList.push(file);
            const nameItem = $('<div>').text("파일명" + detailFileList.length + ": " + file.name);
            fileNameContainer.append(nameItem);
        });

        this.value = "";
    });
	//이미지 없을시 유효성검사
    function validateForm() {
        if (!$('#thumbnail').val()) {
            alert("대표 이미지를 선택해주세요.");
            return false;
        }
        return true;
    }
</script>

</body>
</html>

