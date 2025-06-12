<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<script type="text/javascript" 
		src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=85oq183idp">
	</script>
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
        <form method="post" action="${contextPath}/productEnrollForm.pr" enctype="multipart/form-data" onsubmit="return validateForm();" id="productForm">
            <input type="hidden" name="userNo" value="${loginUser.userNo}">

            <!-- 대표 이미지 -->
            <div class="form-group">
                <label class="form-label">대표 이미지 (1개만 등록 가능합니다)</label>
                <label class="file-label" id="thumbnail-label">파일 선택</label>
                <input type="file" name="thumbnail" class="form-control-file" id="thumbnail" accept="image/*" style="display: none;">
                <div class="preview" id="preview-thumbnail"></div>
                <div class="file-names" id="thumbnail-file-name"></div>
            </div>

            <!-- 상세 이미지 -->
            <div class="form-group">
                <label class="form-label">상세 이미지</label>
                <label for="detail-add" class="file-label">파일 선택</label>
                <input type="file" id="detail-add" accept="image/*" style="display: none;">
                <div class="preview" id="preview-detail"></div>
                <div class="file-names" id="detail-file-names"></div>
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
            <!-- 거래희망장소 -->
			<div class="form-group">
			    <label class="form-label">거래희망장소</label>
			    <div class="d-flex mb-2">
			        <button type="button" class="btn btn-outline-primary mr-2" id="openMapModal">지도에서 선택</button>
			        <input type="hidden" name="dealLat" id="dealLat">
			        <input type="hidden" name="dealLng" id="dealLng">
			        <input type="hidden" name="dealAddress" id="dealAddress">
			        <input type="hidden" name="dealStaticMapUrl" id="dealStaticMapUrl">
			    </div>
			    <!-- 지도 이미지 미리보기 -->
			    <div id="deal-map-preview" style="width: 300px; height: 200px; border-radius: 8px; border:1px solid #ccc; overflow: hidden; margin-bottom:8px; display: none;">
			        <img id="deal-map-img" src="" style="width:100%;height:100%;object-fit:cover;">
			    </div>
			    <!-- 선택한 주소(텍스트) -->
			    <div id="deal-address-text" class="text-muted small"></div>
			</div>
			<!-- 지도 모달 (네이버 지도 API 사용 예시) -->
			<div class="modal fade" id="dealMapModal" tabindex="-1" aria-hidden="true">
			    <div class="modal-dialog modal-dialog-centered">
			        <div class="modal-content">
			        <div class="modal-header">
			            <h5 class="modal-title">거래 희망 장소 선택</h5>
			            <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
			                <span aria-hidden="true">&times;</span>
			            </button>
			        </div>
			        <div class="modal-body" style="height:400px; position:relative;">
			            <div id="dealMap" style="width:100%;height:100%;"></div>
			            <img src="https://cdn-icons-png.flaticon.com/512/684/684908.png" class="center-marker" style="position:absolute;top:50%;left:50%;transform:translate(-50%,-100%);z-index:10;width:32px;">
			        </div>
			        <div class="modal-footer">
			            <button type="button" class="btn btn-primary" id="selectDealLocation">선택 완료</button>
			        </div>
			        </div>
			    </div>
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

    $('#detail-add').on('change', function () {
        const files = Array.from(this.files);
        const preview = $('#preview-detail');
        const fileNameContainer = $('#detail-file-names');
        const form = $('#productForm');

        let currentCount = form.find('input[name="uploadFiles"]').length;

        if (currentCount + files.length > maxDetailImages) {
            alert("상세 이미지는 최대 " + maxDetailImages + "개까지 등록 가능합니다.");
            return this.value = "";
        }

        files.forEach(file => {
            const reader = new FileReader();
            reader.onload = function (e) {
                const id = Date.now() + Math.random();
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
            }
            reader.readAsDataURL(file);
        });

        this.value = "";
    });

    function validateForm() {
        if (!$('#thumbnail').val()) {
            alert("대표 이미지를 선택해주세요.");
            return false;
        }
        return true;
    }
    
    //지도창 띄우기
    function setDealLocation(lat, lng, address) {
    // Static Map URL 생성(예시)
	    var staticMapUrl = "https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?center=" 
	        + lng + "," + lat + "&level=16&w=300&h=200&markers=type:d|size:mid|pos:" + lng + " " + lat;
	    
	    $('#dealLat').val(lat);
	    $('#dealLng').val(lng);
	    $('#dealAddress').val(address);
	    $('#dealStaticMapUrl').val(staticMapUrl);
	
	    $('#deal-map-img').attr('src', staticMapUrl);
	    $('#deal-map-preview').show();
	    $('#deal-address-text').text(address);
	}
    
</script>

<script>
let dealMap, dealMapCenter = {lat: 37.5665, lng: 126.9780}; // 서울 기본

// 지도 모달 열기
$('#openMapModal').on('click', function() {
    $('#dealMapModal').modal('show');
    setTimeout(initDealMap, 200); // 모달 fully open 후 지도 초기화
});

function initDealMap() {
    if (!dealMap) {
        dealMap = new naver.maps.Map('dealMap', {
            center: new naver.maps.LatLng(dealMapCenter.lat, dealMapCenter.lng),
            zoom: 16
        });
        // 지도 이동 시 중앙좌표 주소 갱신
        naver.maps.Event.addListener(dealMap, 'idle', function() {
            updateDealAddress();
        });
    }
    dealMap.setCenter(new naver.maps.LatLng(dealMapCenter.lat, dealMapCenter.lng));
}

// 중앙좌표로 주소 변환
function updateDealAddress() {
    const center = dealMap.getCenter();
    $.ajax({
        url: "${pageContext.request.contextPath}/getReverseGeocode.lo", // reverse geocode API
        method: "POST",
        data: { latitude: center.lat(), longitude: center.lng() },
        dataType: "json",
        success: function(data) {
            $('#deal-address-text').text(data.roadAddress || data.jibunAddress || "");
        }
    });
}

// 선택 완료 클릭 시
$('#selectDealLocation').on('click', function() {
    const center = dealMap.getCenter();
    const lat = center.lat(), lng = center.lng();
    // 주소값 받아오기 (이미 updateDealAddress()에서 넣어둠)
    const address = $('#deal-address-text').text() || "";

    // StaticMap URL 생성 (네이버 Static Map, 실제 서비스시 API키/ID 백엔드에서 보호 추천)
    const staticMapUrl =
        "https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?"
        + "center=" + lng + "," + lat
        + "&level=16&w=300&h=200"
        + "&markers=type:d|size:mid|pos:" + lng + " " + lat;

    $('#dealLat').val(lat);
    $('#dealLng').val(lng);
    $('#dealAddress').val(address);
    $('#dealStaticMapUrl').val(staticMapUrl);

    $('#deal-map-img').attr('src', staticMapUrl);
    $('#deal-map-preview').show();

    $('#deal-address-text').text(address);

    $('#dealMapModal').modal('hide');
});
</script>

</body>
</html>
