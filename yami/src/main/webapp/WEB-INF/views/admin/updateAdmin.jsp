<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 계정 조회 및 수정</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <div class="card shadow-lg mb-4">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-person-badge me-2"></i>관리자 조회 및 수정</h4>
                </div>
                <div class="card-body">
                    <div class="row g-3 align-items-center">
                        <div class="col-auto">
                            <label class="form-check-label me-3">
                                <input type="radio" class="form-check-input" name="select" value="all" checked>
                                전체 조회
                            </label>
                            <label class="form-check-label me-3">
                                <input type="radio" class="form-check-input" name="select" value="superAdmin">
                                최고 관리자
                            </label>
                            <label class="form-check-label me-3">
                                <input type="radio" class="form-check-input" name="select" value="admin">
                                일반 관리자
                            </label>
                            <label class="form-check-label me-3">
                                <input type="radio" class="form-check-input" name="select" value="viewer">
                                뷰어
                            </label>
                        </div>
                        <div class="col-auto">
                            <button type="button" id="adminSearch" class="btn btn-primary">
                                <i class="bi bi-search"></i> 검색하기
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="searchResult">
                <div class="alert alert-info mb-0">검색 결과가 이곳에 표시됩니다.</div>
            </div>
        </div>
    </div>
</div>

<!-- 관리자 정보 수정 모달 -->
<div class="modal fade" id="adminEditModal" tabindex="-1" aria-labelledby="adminEditModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-light">
        <h5 class="modal-title" id="adminEditModalLabel">
          <i class="bi bi-pencil-square me-2"></i>관리자 정보 수정
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="editUserNo" name="userNo">
        <div class="mb-3">
          <label for="editUserId" class="form-label">아이디</label>
          <input type="text" class="form-control" id="editUserId" name="userId" required>
        </div>
        <div class="mb-3">
          <label for="editUserPwd" class="form-label">비밀번호</label>
          <input type="text" class="form-control" id="editUserPwd" name="userPwd" required>
        </div>
        <div class="mb-3">
          <label for="editUserName" class="form-label">이름</label>
          <input type="text" class="form-control" id="editUserName" name="userName" required>
        </div>
        <div class="mb-3">
          <label for="editPhone" class="form-label">전화번호</label>
          <input type="text" class="form-control" id="editPhone" name="phone">
        </div>
        <div class="mb-3">
          <label for="editPoint" class="form-label">포인트</label>
          <input type="number" class="form-control" id="editPoint" name="point">
        </div>
        <div class="mb-3">
          <label for="editStatus" class="form-label">회원 상태</label>
          <select class="form-select" id="editStatus" name="status">
            <option value="Y">정상</option>
            <option value="N">탈퇴</option>
            <option value="E">휴면</option>
            <option value="U">이메일 미인증 </option>
          </select>
        </div>
        
        <div class="mb-3">
          <label for="editRoleType" class="form-label">권한</label>
          <select class="form-select" id="editRoleType" name="roleType">
            <option value="superAdmin">최고 관리자</option>
            <option value="admin">일반 관리자</option>
            <option value="viewer">뷰어</option>
            <option value="non">관리자 권한 박탈</option>
          </select>
        </div>
	        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        <button id="adminEdit" type="button" class="btn btn-primary">
          <i class="bi bi-check-circle me-1"></i>확인
        </button>
      </div>
    </div>
  </div>
</div>

<script>
$(function() {


// 검색 버튼 누를 때
$('#adminSearch').on('click', function(){
	ajaxSearchAdmin();
});

    
function ajaxSearchAdmin(){
    let select = $('input[name="select"]:checked').val();
    let $searchResult = $('#searchResult');

    $.ajax({
        url: "${root}/searchAdmin.ad",
        method: "POST",
        dataType: "json",
        data: { select: select },
        success: function(result) {
            $searchResult.empty();

            if(result.length === 0){
                $searchResult.html('<div class="alert alert-warning mb-0">검색 결과가 없습니다.</div>');
                return;
            }

            let table = `
            <div class="table-responsive">
              <table class="table table-hover align-middle text-center">
                <thead class="table-light">
                  <tr>
                    <th>회원번호</th>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>전화번호</th>
                    <th>포인트</th>
                    <th>가입일</th>
                    <th>수정일</th>
                    <th>상태</th>
                    <th>권한</th>
                    <th>수정</th>
                  </tr>
                </thead>
                <tbody>
            `;

            result.forEach(function(item) {
                table += `
                  <tr>
                    <td>\${item.userNo}</td>
                    <td>\${item.userId}</td>
                    <td>\${item.userName}</td>
                    <td>\${item.phone ? item.phone : ''}</td>
                    <td>\${item.point ?? 0}</td>
                    <td>\${item.enrollDate ? item.enrollDate : ''}</td>
                    <td>\${item.modifyDate ? item.modifyDate : ''}</td>
                    <td>\${item.status ? item.status : ''}</td>
                    <td>\${item.roleType}</td>
                    <td>
                      <button type="button" class="btn btn-outline-primary btn-sm edit-btn" 
                        data-user='\${JSON.stringify(item)}'>
                        <i class="bi bi-pencil-square"></i> 수정
                      </button>
                    </td>
                  </tr>
                `;
            });

            table += `
                </tbody>
              </table>
            </div>
            `;

            $searchResult.html(table);
        }
    });
}

    // 동적 수정 버튼 클릭 이벤트 (이벤트 위임)
$('#searchResult').on('click', '.edit-btn', function(){
    const user = $(this).data('user');
    
    // 모달에 값 세팅
    $('#editUserNo').val(user.userNo);
    $('#editUserId').val(user.userId);
    $('#editUserName').val(user.userName);
    $('#editPhone').val(user.phone);
    $('#editPoint').val(user.point);
    $('#editStatus').val(user.status);
    $('#editRoleType').val(user.roleType);

    // 모달 오픈
    const modal = new bootstrap.Modal(document.getElementById('adminEditModal'));
    modal.show();
});

    // 수정 모달 form submit
$('#adminEdit').on('click', function(){

    $.ajax({
        url: "${root}/updateAdmin.ad",
        method: "POST",
        data: $("#adminEditModal").find("input, select").serialize(),
        success: function(result) {
        	if(result == 'pass'){
		         alert('수정이 완료되었습니다.');
		         bootstrap.Modal.getInstance(document.getElementById('adminEditModal')).hide();
		         ajaxSearchAdmin(); // 결과 재조회
		         
        	}else if(result ="noRole"){
        		alert('잘못된 접근입니다.');
        	}else if(result ="superAdmin"){
        		alert('0번 관리자의 권한은 수정할 수 없습니다.');
        	}else{
        		alert('수정 실패! 관리자에게 문의하세요.');
        	}
        	
        },
        error: function() {
            alert('수정 실패! 관리자에게 문의하세요.');
        }
    });
});
    
    
});
</script>
</body>
</html>