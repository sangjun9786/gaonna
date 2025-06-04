<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" 
		src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=85oq183idp">
	</script>
	<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
<meta charset="UTF-8">
<title>배송지 추가</title>
<style>
    #mapModal .modal-dialog { max-width: 700px; }
    #map { width: 100%; height: 400px; visibility: hidden;}
    .center-marker {
        position: absolute;
        top: 50%; left: 50%;
        width: 32px; height: 32px;
        transform: translate(-50%, -100%);
        z-index: 10;
        pointer-events: none;
    }
</style>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-body">
            <h3 class="card-title mb-4">배송지 추가하기</h3>
            
            <div class="mb-3 row">
                <label for="inputAddress" class="col-sm-2 col-form-label">주소 입력</label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" name="inputAddress" id="inputAddress" required>
                </div>
                <div class="col-sm-3">
                    <button type="button" class="btn btn-primary w-100" id="search">검색하기</button>
                </div>
            </div>
            
            <div class="mb-3 d-flex gap-2">
                <button type="button" class="btn btn-outline-primary" id="btnDirect">직접 입력하기</button>
                <button type="button" class="btn btn-outline-primary" id="btnMap">지도에서 선택하기</button>
            </div>
            
            <!-- 검색 결과 영역 -->
            <div id="searchResult" class="alert alert-info d-none mt-3"></div>
            
            <!-- 오류 메시지 영역 -->
            <div id="errorMsg" class="alert alert-danger d-none mt-3"></div>
            
            <!-- 검색 결과 선택 후 자동 입력 폼 -->
            <form action="insertLocation.me" method="post" id="searchForm" class="mt-4 d-none">
                <div class="mb-2">
                    <label class="form-label">우편번호</label>
                    <input type="text" class="form-control" name="zipCode" id="zipCode" readonly>
                </div>
                <div class="mb-2">
                    <label class="form-label">도로명 주소</label>
                    <input type="text" class="form-control" name="roadAddress" id="roadAddress" readonly>
                </div>
                <div class="mb-2">
                    <label class="form-label">지번 주소</label>
                    <input type="text" class="form-control" name="jibunAddress" id="jibunAddress" readonly>
                </div>
                <div class="mb-2">
                    <label class="form-label">상세 주소</label>
                    <input type="text" class="form-control" name="detailAddress" id="detailAddress">
                </div>
                
				<div class="form-check mb-3">
				  <input class="form-check-input" type="checkbox" name="isMain" value="Y" id="isMainCheckSearch">
				  <label class="form-check-label" for="isMainCheckSearch">
				    대표 주소로 설정하기
				  </label>
				</div>                
				<button type="submit" class="btn btn-primary">저장하기</button>
            </form>
            
            <!-- 직접 입력 폼 -->
            <form action="insertLocation.me" method="post" id="directForm" class="mt-4 d-none">
                <div class="mb-2">
                    <label class="form-label">우편번호</label>
                    <input type="text" class="form-control" name="zipCode">
                </div>
                <div class="mb-2">
                    <label class="form-label">도로명 주소</label>
                    <input type="text" class="form-control" name="roadAddress">
                </div>
                <div class="mb-2">
                    <label class="form-label">지번 주소</label>
                    <input type="text" class="form-control" name="jibunAddress">
                </div>
                <div class="mb-2">
                    <label class="form-label">상세 주소</label>
                    <input type="text" class="form-control" name="detailAddress">
                </div>

				<div class="form-check mb-3">
				  <input class="form-check-input" type="checkbox" name="isMain" value="Y" id="isMainCheckDirect">
				  <label class="form-check-label" for="isMainCheckDirect">
				    대표 주소로 설정하기
				  </label>
				</div>
                <button type="submit" class="btn btn-primary">저장하기</button>
            </form>
            
            <!-- 지도에서 선택 폼 -->
            <form action="insertLocation.me" method="post" id="mapForm" class="mt-4 d-none">
                <div class="mb-2">
                    <label class="form-label">우편번호</label>
                    <input type="text" class="form-control" name="zipCode">
                </div>
                <div class="mb-2">
                    <label class="form-label">도로명 주소</label>
                    <input type="text" class="form-control" name="roadAddress">
                </div>
                <div class="mb-2">
                    <label class="form-label">지번 주소</label>
                    <input type="text" class="form-control" name="jibunAddress">
                </div>
                <div class="mb-2">
                    <label class="form-label">상세 주소</label>
                    <input type="text" class="form-control" name="detailAddress">
                </div>

				<div class="form-check mb-3">
					<input class="form-check-input" type="checkbox" name="isMain" value="Y" id="isMainCheckMap">
					<label class="form-check-label" for="isMainCheckMap">
						대표 주소로 설정하기
					</label>
				</div>
				<button type="submit" class="btn btn-primary">저장하기</button>
            </form>
        </div>
    </div>
</div>
<!-- 지도 모달 -->
<div class="modal fade" id="mapModal" tabindex="-1" aria-labelledby="mapModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="mapModalLabel">지도에서 위치 선택</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body position-relative" style="height: 420px;">
        <div id="map"></div>
        <img src="https://cdn-icons-png.flaticon.com/512/684/684908.png" class="center-marker" alt="중앙마커">
      </div>
      
      <!-- 비동기 피드백 -->
		<div id="mapRoadAddressView" class="mt-2 text-primary fw-bold text-center py-2"></div>	
		
		<!-- 확인/취소 버튼 -->
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        <button type="button" class="btn btn-primary" id="selectMapLocation">선택 완료</button>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
// 버튼 DOM 객체
const btnDirect = document.getElementById('btnDirect');
const btnMap = document.getElementById('btnMap');

// 버튼 클릭 시 스타일 및 폼 토글
btnDirect.onclick = function() {
    btnDirect.classList.remove('btn-outline-primary');
    btnDirect.classList.add('btn-primary', 'active');
    btnMap.classList.remove('btn-primary', 'active');
    btnMap.classList.add('btn-outline-primary');
    document.getElementById('directForm').classList.remove('d-none');
    document.getElementById('mapForm').classList.add('d-none');
    document.getElementById('searchForm').classList.add('d-none');
};
btnMap.onclick = function() {
    btnMap.classList.remove('btn-outline-primary');
    btnMap.classList.add('btn-primary', 'active');
    btnDirect.classList.remove('btn-primary', 'active');
    btnDirect.classList.add('btn-outline-primary');
    document.getElementById('mapForm').classList.remove('d-none');
    document.getElementById('directForm').classList.add('d-none');
    document.getElementById('searchForm').classList.add('d-none');
};

// 검색 결과에서 선택 시 버튼 스타일 초기화
function resetInputButtons() {
    btnDirect.classList.remove('btn-primary', 'active');
    btnDirect.classList.add('btn-outline-primary');
    btnMap.classList.remove('btn-primary', 'active');
    btnMap.classList.add('btn-outline-primary');
}

// 주소 검색 AJAX
document.getElementById("search").addEventListener('click', function(){
    let inputAddress = document.getElementById('inputAddress').value;
    $.ajax({
        url: "getGeocode.lo",
        data: {inputAddress : inputAddress},
        method: 'GET',
        dataType: 'json',
        success: function(result) {
            let searchResult = document.getElementById('searchResult');
            let errorMsg = document.getElementById('errorMsg');
            searchResult.classList.add('d-none');
            errorMsg.classList.add('d-none');

            if(!result){
                errorMsg.textContent = "통신 오류가 발생했습니다.";
                errorMsg.classList.remove('d-none');
                return;
            }
            if(result.length === 0){
                errorMsg.textContent = "검색 결과가 없습니다.";
                errorMsg.classList.remove('d-none');
                return;
            }

            console.log(result);
            // 결과 리스트 출력 (선택 가능)
            searchResult.innerHTML = '';
            result.forEach(function(lo, idx){
            	console.log(lo.zipCode);
            	console.log(lo.jibunAddress);
            	console.log(lo.zipCode);
                searchResult.innerHTML += `
                    <div class="border rounded p-2 mb-2 search-item" style="cursor:pointer;" data-idx="${'$'}{idx}">
                        <div><span class="fw-bold">[${'$'}{lo.zipCode}]</span> ${'$'}{lo.roadAddress}</div>
                        <div class="text-muted small">${'$'}{lo.jibunAddress}</div>
                    </div>
                `;
            });
            searchResult.classList.remove('d-none');

            // 결과 클릭 시 자동 입력 폼 채우기
            document.querySelectorAll('.search-item').forEach(function(item, idx){
                item.onclick = function(){
                    let lo = result[idx];
                    document.getElementById('zipCode').value = lo.zipCode;
                    document.getElementById('roadAddress').value = lo.roadAddress;
                    document.getElementById('jibunAddress').value = lo.jibunAddress;
                    document.getElementById('detailAddress').value = '';
                    document.getElementById('searchForm').classList.remove('d-none');
                    document.getElementById('directForm').classList.add('d-none');
                    document.getElementById('mapForm').classList.add('d-none');
                    resetInputButtons();
                    searchResult.classList.add('d-none');
                };
            });
        },
        error: function(){
            let errorMsg = document.getElementById('errorMsg');
            errorMsg.textContent = "통신 오류가 발생했습니다.";
            errorMsg.classList.remove('d-none');
        }
    });
});

//공통 유효성 검사 함수
function validateLocationForm(form) {
 const roadAddress = form.querySelector('[name="roadAddress"]');
 const jibunAddress = form.querySelector('[name="jibunAddress"]');
 const detailAddress = form.querySelector('[name="detailAddress"]');
 const zipCode = form.querySelector('[name="zipCode"]');
 const errorMsg = document.getElementById('errorMsg');

 // 정규식 조건
 const addr80 = /^.{0,80}$/;
 const detail60 = /^.{0,60}$/;
 const zip8num = /^\d{1,8}$/;

 // 검증
 if (!roadAddress.value.match(addr80)) {
     errorMsg.textContent = "도로명 주소는 80자 이내여야 합니다.";
     errorMsg.classList.remove('d-none');
     roadAddress.focus();
     return false;
 }
 if (!jibunAddress.value.match(addr80)) {
     errorMsg.textContent = "지번 주소는 80자 이내여야 합니다.";
     errorMsg.classList.remove('d-none');
     jibunAddress.focus();
     return false;
 }
 if (!detailAddress.value.match(detail60)) {
     errorMsg.textContent = "상세 주소는 60자 이내여야 합니다.";
     errorMsg.classList.remove('d-none');
     detailAddress.focus();
     return false;
 }
 if (!zipCode.value.match(zip8num)) {
     errorMsg.textContent = "우편번호는 8자리 숫자여야 합니다.";
     errorMsg.classList.remove('d-none');
     zipCode.focus();
     return false;
 }
 errorMsg.classList.add('d-none');
 return true;
}

//각 폼에 이벤트 등록
document.getElementById('searchForm').onsubmit = function(e) {
 if (!validateLocationForm(this)) e.preventDefault();
};
document.getElementById('directForm').onsubmit = function(e) {
 if (!validateLocationForm(this)) e.preventDefault();
};
document.getElementById('mapForm').onsubmit = function(e) {
 if (!validateLocationForm(this)) e.preventDefault();
};


//---------------------다이나믹 웹뷰------------------------
let map;
let debounceTimer;
let debouncedSendCoords;
window.onload = function() {
    map = new naver.maps.Map('map', {
        center: new naver.maps.LatLng(37.5665, 126.9780),
        zoom: 16
    });
    
	debouncedSendCoords = _.debounce(sendCenterCoords, 500);
    
    naver.maps.Event.addListener(map, 'idle', function() {
    	debouncedSendCoords();
    });
    

};

//누르면 지도 튀어나옴
document.getElementById('mapModal').addEventListener('shown.bs.modal', function() {
    document.getElementById('map').style.visibility = 'visible';
    map.autoResize();
});
//지도 들어감
document.getElementById('mapModal').addEventListener('hidden.bs.modal', function() {
    document.getElementById('map').style.visibility = 'hidden';
});


btnMap.onclick = function() {
    btnMap.classList.remove('btn-outline-primary');
    btnMap.classList.add('btn-primary', 'active');
    btnDirect.classList.remove('btn-primary', 'active');
    btnDirect.classList.add('btn-outline-primary');
    document.getElementById('mapForm').classList.remove('d-none');
    document.getElementById('directForm').classList.add('d-none');
    document.getElementById('searchForm').classList.add('d-none');
    
    let mapModal = new bootstrap.Modal(document.getElementById('mapModal'));
    mapModal.show();
    
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            function(position) {
                var userLocation = new naver.maps.LatLng(
                    position.coords.latitude,
                    position.coords.longitude
                );
                map.setCenter(userLocation);
            },
            function(error) {
                alert('위치 정보를 가져올 수 없습니다.');
            },
            {
                enableHighAccuracy: true,
                timeout: 5000,
                maximumAge: 0
            }
        );
    }
};


function sendCenterCoords() {
    if(!map) return;
    
    const center = map.getCenter();
    $.ajax({
        url: "${root}/getReverseGeocode.lo",
        method: "POST",
        dataType: "json",
        data: {
            latitude: center.lat(),
            longitude: center.lng()
        },
        success: function(data) {
            if(data?.roadAddress) {
                $('#mapForm [name="roadAddress"]').val(data.roadAddress);
                $('#mapForm [name="jibunAddress"]').val(data.jibunAddress || '');
                $('#mapForm [name="zipCode"]').val(data.zipCode || '');
                document.getElementById('mapRoadAddressView').textContent = data.roadAddress;
            }else {
                document.getElementById('mapRoadAddressView').textContent = '';
            }
        }
    });
}

// 선택 완료 버튼 클릭 시
document.getElementById('selectMapLocation').addEventListener('click', function() {
    $('#mapForm [name="detailAddress"]').focus();
    let modalEl = document.getElementById('mapModal');
    let modalInstance = bootstrap.Modal.getInstance(modalEl);
    if(modalInstance) {
        modalInstance.hide();
    }
});
</script>
</body>
</html>