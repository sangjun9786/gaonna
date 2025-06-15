<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 수정</title>
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
            font-weight: bold;
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

<c:if test="${not empty loginUser}">
<div class="container-main">
    <%@ include file="/WEB-INF/views/product/sidebar.jsp" %>

    <div class="form-container">
        <h2>상품 수정</h2>
        <form method="post" action="${contextPath}/update.pro" enctype="multipart/form-data" id="productUpdateForm">
            <!-- 기본정보 -->
            <input type="hidden" name="productNo" value="${p.productNo}">
            <input type="hidden" name="userNo" value="${p.userNo}">

            

            <!-- 대표 이미지 -->
            <div class="form-group">
                <label class="form-label">대표 이미지</label>
				<c:forEach var="a" items="${p.atList}">
				    <c:if test="${a.fileLevel == 1}">
				        <div class="preview" id="preview-thumbnail">
				            <div class="preview-item">
				                <img src="${contextPath}/resources/uploadFiles/${a.changeName}" alt="대표 이미지">
				                
				            </div>
				        </div>
				        <div class="file-names">기존 파일명: ${a.originName}</div>
				        <!-- 기존 대표 이미지 정보 서버 전달 -->
			            <input type="hidden" name="originName" value="${a.originName}">
			            <input type="hidden" name="changeName" value="${a.changeName}">
			            <input type="hidden" name="hasThumbnail" value="true">
				    </c:if>
				</c:forEach>

                <label class="file-label" for="thumbnail">새 파일 선택</label>
				    <input type="file" name="thumbnail" id="thumbnail" class="form-control-file" accept="image/*" style="display: none;">
				</div>

            <!-- 상세 이미지 -->
            <div class="form-group">
                <label class="form-label">상세 이미지</label>

                <!-- 기존 상세 이미지 (fileLevel=2) -->
                <div class="preview" id="preview-detail">
                    <c:forEach var="a" items="${p.atList}">
                        <c:if test="${a.fileLevel == 2}">
                            <div class="preview-item" data-file="${a.changeName}">
                                <img src="${contextPath}/resources/uploadFiles/${a.changeName}" alt="상세 이미지">
                                <button type="button" class="remove-btn old-detail-remove">x</button>
                                    <input type="hidden" name="keepDetailFiles" value="${a.changeName}" />
                            </div>
                        </c:if>
                    </c:forEach>
                </div>

                <!-- 새로 추가할 상세 이미지 -->
                <label for="detail-add" class="file-label">새 파일 선택</label>
                <input type="file" id="detail-add" accept="image/*" style="display: none;">
                <div class="file-names" id="detail-file-names"></div>
            </div>

            <!-- 제목 -->
            <div class="form-group">
                <label class="form-label">제목</label>
                <input type="text" name="productTitle" class="form-control" value="${p.productTitle}" required>
            </div>

            <!-- 설명 -->
            <div class="form-group">
                <label class="form-label">상세 설명</label>
                <textarea name="productContent" class="form-control" rows="5" required>${p.productContent}</textarea>
            </div>

            <!-- 가격 -->
            <div class="form-group">
                <label class="form-label">가격</label>
                <input type="number" name="price" class="form-control" value="${p.price}" required min="0" step="100">
            </div>

            <!-- 거래 희망 장소 -->
            <div class="form-group">
                <label class="form-label">거래 희망 장소</label>
                <input type="text" class="form-control" value="${p.coordAddress}" readonly>
            </div>

            <!-- 카테고리 -->
            <div class="form-group">
                <label class="form-label">카테고리</label>
                <select name="categoryNo" class="form-control" required>
                    <option value="">-- 카테고리를 선택하세요 --</option>
                    <c:forEach var="category" items="${categoryList}">
                        <option value="${category.categoryNo}" <c:if test="${category.categoryNo == p.categoryNo}">selected</c:if>>
                            ${category.categoryName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <button type="submit" class="action-btn">수정 완료</button>
        </form>
    </div>
</div>
</c:if>
<script>
    const maxDetailImages = 3;

    // 대표 이미지 미리보기
    $('#thumbnail').on('change', function () {
        const file = this.files[0];
        const preview = $('#preview-thumbnail');
        preview.empty();

        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                const item = $('<div class="preview-item"></div>');
                const img = $('<img>').attr('src', e.target.result);
                item.append(img);
                preview.append(item);
            };
            reader.readAsDataURL(file);
        }
    });

    // 기존 상세 이미지 삭제
    $(document).on('click', '.old-detail-remove', function () {
        const item = $(this).closest('.preview-item');
        item.find('input[name="remainFiles"]').remove(); // 숨겨진 값 삭제
        item.remove();
    });

    // 새 상세 이미지 추가
    $('#detail-add').on('change', function () {
        const files = Array.from(this.files);
        const preview = $('#preview-detail');
        const fileNameContainer = $('#detail-file-names');
        const form = $('#productUpdateForm');

        // 현재 input[name="uploadFiles"] 개수 + 기존 이미지 개수
        let currentCount = form.find('input[name="uploadFiles"]').length + form.find('input[name="remainFiles"]').length;

        if (currentCount + files.length > maxDetailImages) {
            alert("상세 이미지는 최대 " + maxDetailImages + "개까지 등록 가능합니다.");
            return this.value = "";
        }

        files.forEach(file => {
            const reader = new FileReader();
            const id = Date.now() + Math.random();
            reader.onload = function (e) {
                const item = $('<div class="preview-item"></div>');
                const img = $('<img>').attr('src', e.target.result);
                const btn = $('<button class="remove-btn">x</button>').on('click', function () {
                    $(`#input-${id}`).remove();
                    item.remove();
                    nameItem.remove();
                });

                item.append(img).append(btn);
                preview.append(item);

                const input = $(`<input type="file" name="uploadFiles" style="display:none;" id="input-${id}">`);
                const dt = new DataTransfer();
                dt.items.add(file);
                input[0].files = dt.files;
                form.append(input);

                nameItem = $('<div>').text("파일명: " + file.name);
                fileNameContainer.append(nameItem);
            };
            reader.readAsDataURL(file);
        });

        this.value = "";
    });

    // 유효성 검사
    $('#productUpdateForm').on('submit', function () {
        const price = parseInt($('input[name="price"]').val());

        if (isNaN(price) || price < 0) {
            alert("가격은 0원 이상의 숫자만 입력 가능합니다.");
            return false;
        }

        if (price % 100 !== 0) {
            alert("가격은 100원 단위로 입력해주세요.");
            return false;
        }

        return true;
    });
</script>
</body>
</html>