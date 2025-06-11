<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" 
	src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=85oq183idp">
</script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<%--부트스트랩 라이브러리는 헤더에 선언되어 있다고 가정--%>
<meta charset="UTF-8">
<title>동네 한바퀴</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp"%>

<div>
우리 동네 빵집
</div>

<%--화면은 중앙에, 적절한 크기로 키우기 --%>
<div id="map" style="width: 600px; height: 400px"></div>


<%--

아래 작성된 모든 서버와의 통신은 ajax post요청으로 구현
비동기식 연결이 (대)댓글 작성/수정/삭제/신고에서 성공하면
서버에서는 pass를, 실패하면 noPass를 보냄
el표기법을 사용할 때는 jsp임을 감안해서 작성
예)${}은 이스케이프 문자를 포함한 \${}로 표기하기
,${a===b}은 ${a eq b}로 표기하기

적당한 부트스트랩 아이콘을 활용하기


지도 : 네이버 클라우드 Web Dynamic Map
지도는 ${loginUser.mainCoord}와
session에 저장된 컬랙션 coords 중
${coord.coordNo}가 일치하는 coord의
${coord.latitude}와 ${coord.longitude}를 지도 센터 좌표로 생성됨

센터 좌표로부터 1km이내에 해당하는 곳을 영역 표시.
1km경계를 표시하고, 경계 안은 옅은 주황색(혹은 다른 적당한 색상)으로 채우기

pageScope에 저장된 컬랙션 bakeries 의
모든 bakery객체에 대해 ${bakery.latitude}, ${bakery.longitude}
에 해당 위치를 빵집임을 나타내는 아이콘으로 표시

해당 아이콘을 누르면, ${pageScope.root}/bakeryComment.dn로
${bakery.bakeryNo}와 page(현재 페이지) 가지고 10개 단위로 요청
응답받은 bakeryComment 적당한 팝업/모달 창으로 띄워주기

팝업 창을 띄울 때는 bakery정보를 먼저 띄우고,
bakeryComment를 조회중일 때 로딩 상태임을 나타내는 표시로 채우기

팝업 창 최상단 오른쪽에는 x표시(뒤로가기) 띄우기
뒤로가기는 esc키, 팝업창 외부를 눌러도 동일하게 작동되게 하기
만일 댓글/대댓글 작성 중이라면,
'작성하신 댓글은 저장되지 않습니다. 창을 닫으시겠습니까?' 경고창 띄우기

팝업 창에는 먼저 누른 ${bakery.bakeryNo}에 해당하는
bakery관련 데이터를 상단에 띄운다.
bakeryName(상호명)을 큼지막하게, 그 옆에는 phone(전화번호)과
openDateStr(개업일), roadAddress(도로명주소), jibunAddress(지번주소)
,like(좋아요 수), dislike(싫어요 수)
를 보여준다. 상호명을 제외한 나머지 정보는 정보의 길이를 고려해서
표시 위치 정하기
정보가 없을 경우는 '-' 출력되도록 하기

팝업 창 bakery부분 아래는 BakeryComment영역
commentType이 COMMENT이면 댓글
RECOMMENT이면 대댓글
대댓글이 달린 댓글인지 parentCommentNo가 있는지 식별함

댓글은 commentContent(작성 내용)을 메인으로 두고,
그 옆에는 status(좋아요/싫어요)표시
commentDateStr(작성일)과 userName(작성자)를 작은 글씨로 표시
댓글에 해당하는 대댓글이 존재하면(댓글의 commentNo와
대댓글의 parentCommentNo가 동일하면, 댓글과 대댓글)
댓글 다음 카드에 대댓글임을 표시(들여쓰기 등)하고 대댓글 표시하기

댓글, 대댓글의 status가
'M'이면 commentContent 맨 뒤에 '수정됨'라는 작은 글씨 추가하기
'N'이면, 댓글에는 '삭제된 댓글입니다.'만 표시하고(작성자,작성일 등 표시X) 대댓글 표시하기.
대댓글이 없는 댓글이거나 대댓글인 경우는 db에서 가져오지 않음
'P'이면, 댓글에는 '신고되어 블라인드된 댓글입니다.'와 신고 아이콘을 표시하고(작성자,작성일 등 표시X) 대댓글 표시하기
대댓글이 없는 댓글이거나 대댓글인 경우는 db에서 가져오지 않음

댓글 카드는 5개만 띄우고, 스크롤(팝업 창 옆에 스크롤바 만들기)을 내리면
나머지 5개가 보임. 마지막 댓글이 보여진 상태에서 스크롤을 내리면
'댓글 불러오기' 글귀가 보이고, 스크롤을 내린 상태로 유지하면
${bakery.bakeryNo}와 page(다음 조회할 페이지) 가지고
${pageScope.root}/selectBakeryComment.dn로 다음 10개 조회하기

만약 조회할 페이지가 없으면
스크롤을 내릴 때 '마지막 댓글입니다' 글귀 띄우고 요청 막기

댓글을 누르면 '대댓글 작성하기','수정하기','삭제하기','신고하기'버튼이 댓글 아래에 생성됨

대댓글 작성하기 버튼을 누르면
버튼이 있던 장소에 댓글 작성 폼과 '대댓글 입력하기' 버튼 생성
대댓글이 앞뒤 공백을 제외하고 입력되어 있을 경우
대댓글 입력하기 버튼 활성화
대댓글 입력하기 버튼을 누르면 로딩 표시를 버튼에 표시하고,
대댓글 내용(content), 대댓글의 부모 댓글번호(commentNo),
해당 팝업 창의 빵집번호(bakeryNo)를
${pageScope.root}/insertBakeryRecomment.dn로 보내기
보낸 후 해당 팝업 창 다시 로딩


댓글/대댓글 수정하기
수정하기 버튼은 해당 댓글을 작성한 유저(${BakeryComment.userNo == loginUser.userNo})
혹은 관리자(${loginUser.roleType != 'N'})일때 등장
버튼이 있던 장소에 댓글 작성 폼과 '수정하기' 버튼 생성
댓글이 앞뒤 공백을 제외하고 입력되어 있을 경우
수정하기 버튼 활성화
수정하기 버튼을 누르면 로딩 표시를 버튼에 표시하고,
댓글 내용(content), 댓글 식별번호(commentNo), 좋아요/싫어요(bakeryLike, 좋아요 : L, 싫어요 : D, 대댓글일 경우 : P),
수정하기 전 댓글을 작성한 회원의 식별번호(BakeryComment.userNo)를
${pageScope.root}/updateBakeryComment.dn로 보내기
보낸 후 해당 팝업 창 다시 로딩


삭제하기 버튼은 해당 댓글을 작성한 유저(${BakeryComment.userNo == loginUser.userNo})
혹은 관리자(${loginUser.roleType != 'N'})일때 등장
삭제하기 버튼을 누르면 확인 창이 등장하고,
확인을 누르면 로딩 표시를 버튼에 표시
BakeryComment.userNo, commentNo를
${pageScope.root}/deleteBakeryComment.dn로 보내기


신고하기 버튼을 누르면
'정말로 신고하시겠습니까?' 확인 창 등장
확인 누르면 해당 댓글 번호(commentNo), 신고한 회원 번호(${loginUser.userNo})를
${pageScope.root}/reportBakeryComment.dn로 보내기
로딩 표시를 버튼에 표시하고, 요청 보낸 후 '신고되었습니다' 팝업창 띄우기

대댓글을 누르면 '수정하기','삭제하기','신고하기'버튼이 등장
각 버튼은 댓글의 '수정하기','삭제하기','신고하기'버튼과
로직 및 요청 경로가 동일


팝업 창 하단에는 댓글 작성하기 버튼이 존재
해당 버튼을 누르면 버튼이 있던 장소에 댓글 작성 폼과 '댓글 입력하기' 버튼,
추천(L)/비추천(D)이 아이콘으로 표시된 라디오 버튼 생성
댓글이 앞뒤 공백을 제외하고 입력되어 있고 추천/비추천을 선택하면
댓글 입력하기 버튼 활성화
버튼을 누르면 로딩 표시를 버튼에 표시하고,
댓글 내용(content), 해당 팝업 창의 빵집번호(bakeryNo)를
${pageScope.root}/insertBakeryComment.dn로 보내기
보낸 후 해당 팝업 창 다시 로딩 


--bakery 객체--
public class Bakery {
	private String bakeryNo;
	private String openDateStr;
	private String phone;
	private String roadAddress;
	private String jibunAddress;
	private String bakeryName;
	private String latitude;
	private String longitude;
	private int like;
	private int dislike;
}

--bakeryComment객체--
public class BakeryComment {
	private int commentNo;
	private int parentCommentNo; //대댓글일 경우 부모 댓글 commentNo가 여기 담김
	private String commentContent;
	private String commentType; //'COMMENT', 'RECOMMENT'
	private String bakeryNo;
	private int userNo;
	private String userName;
	private String commentDateStr;
	private String like; //L:좋 D:싫 P:대댓글(좋/싫 없음)
	private String status; //Y:일반 N:삭제됨 M:수정됨 P:신고됨
}
--%>
<script type="text/javascript">

// 지도 생성 함수
function createMap(centerLat, centerLng) {
    var mapOptions = {
    		
        center: new naver.maps.LatLng(centerLat, centerLng),
        zoom: 15
    };
    var map = new naver.maps.Map("map", mapOptions);
}


</script>

</body>
</html>