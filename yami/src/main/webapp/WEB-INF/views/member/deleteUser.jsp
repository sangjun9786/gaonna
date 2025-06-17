<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
<!-- Bootstrap 5.3.5 CDN 추가 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body class="bg-light">
    <%@include file="/WEB-INF/views/common/header.jsp" %>

    <div class="container mt-5">
        <div class="card shadow-lg mx-auto" style="max-width: 600px;">
            <div class="card-body text-center p-5">
                <h2 class="card-title mb-4">회원 탈퇴</h2>
                <div class="alert alert-warning mb-4">
                    탈퇴를 위해 아이디와 비밀번호를 입력해 주세요.
                </div>
                <!-- action/method 추가 -->
                <form id="withdrawForm" action="${root}/deleteUser.me" method="POST" autocomplete="off">
                    <div class="mb-3">
                        <input type="text" class="form-control form-control-lg" id="userId"
                               name="userId" placeholder="아이디" required>
                    </div>
                    <div class="mb-3">
                        <input type="password" class="form-control form-control-lg" id="userPwd"
                               name="userPwd" placeholder="비밀번호" required>
                        <div id="result" class="form-text text-muted mt-1"></div>
                    </div>
                    <div class="row g-2">
                        <div class="col">
                            <button type="button" id="backBtn" class="btn btn-outline-secondary w-100">
                                되돌아가기
                            </button>
                        </div>
                        <div class="col">
                            <!-- type을 submit으로 변경 -->
                            <button type="submit" id="deleteBtn" class="btn btn-danger w-100" disabled>
                                회원 탈퇴
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

<script>
let idPass = false;
let pwdPass = false;

const debounceIdCheck = _.debounce(function() {
    const userId = $('#userId').val().trim();
    if (!userId) {
        $('#result').removeClass('text-success text-danger').addClass('text-muted')
            .text('아이디를 입력해 주세요.');
        idPass = false;
        toggleDeleteBtn();
        return;
    }
    $.ajax({
        url: '${root}/confirmIdPwd.me',
        method: 'POST',
        data: { userId: userId, userPwd: $('#userPwd').val().trim() },
        success: function(result) {
            if (result === 'pass') {
                $('#result').removeClass('text-danger').addClass('text-success')
                    .text('아이디/비밀번호가 확인되었습니다.');
                idPass = true;
            } else {
                $('#result').removeClass('text-success').addClass('text-danger')
                    .text('아이디/비밀번호를 확인해 주세요.');
                idPass = false;
            }
            toggleDeleteBtn();
        },
        error: function() {
            $('#result').removeClass('text-success').addClass('text-danger')
                .text('서버 오류가 발생했습니다.');
            idPass = false;
            toggleDeleteBtn();
        }
    });
}, 300);

$('#userId').on('input', function() {
    debounceIdCheck();
});

$('#userPwd').on('input', function() {
    const pwd = $(this).val();
    const regex = /^[A-Za-z0-9]{4,30}$/;
    if (regex.test(pwd)) {
        pwdPass = true;
    } else {
        $('#result').removeClass('text-success').addClass('text-danger')
            .text('비밀번호는 특수문자 제외 4~30글자입니다.');
        pwdPass = false;
    }
    debounceIdCheck();
    toggleDeleteBtn();
});

function toggleDeleteBtn() {
    $('#deleteBtn').prop('disabled', !(idPass && pwdPass));
}

$('#backBtn').on('click', function() {
    history.back();
});

// AJAX 제거: 폼 제출 시 바로 서버로 POST 요청
$('#withdrawForm').on('submit', function(e) {
    if (!(idPass && pwdPass)) {
        e.preventDefault(); // 유효하지 않으면 제출 막음
        $('#result').addClass('text-danger').text('입력 정보를 확인해 주세요.');
    }
});
</script>
</body>
</html>
