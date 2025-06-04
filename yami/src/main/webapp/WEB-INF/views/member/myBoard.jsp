<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 게시글</title>
</head>
<body>
	<%@include file="/WEB-INF/views/common/header.jsp" %>
	
	
	<div>
		작성한 게시글
	</div>
	
	<form id="searchForm">
		검색 범위
		<select id="searchType1" name="searchType" required>
			<option value="boardAll">전체 판매 게시판</option>
			
			<%--
			여기에 selectCategory.co로 ajax요청을 보내서 데이터를 받아옴
			질문게시판 앞에 추가하는 로직이라
			게시판 순서 변경에 주의
			--%>
			
			<option value="question">질문게시판</option>
			<option value="report">신고게시판</option>
		</select>
		
		<select id="searchType2" name="searchType" required>
			<option value="all">전체</option>
			<option value="title">제목</option>
			<option value="content">내용</option>
		</select>
		
		<input type="text" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력해주세요"/>
		
		표시할 게시글 수 :
		<select id="searchCount" name="searchCount" required>
			<option value="10">10개</option>
			<option value="30">30개</option>
			<option value="50">50개</option>
			<option value="100">100개</option>
		</select>
		
		<%--페이지 바에 따른 이동할 페이지--%>
		<input type="hidden" id="page" name="page" value="1">

		<%-- 검색된 게시글 수를 여기 값으로 넣기 --%>
		<input type="hidden" id="resultCount" name='resultCount'>
		
		<button type="submit" id="searchBoard">검색</button>
		
	</form>
	
	<div>
		<%-- 검색된 게시글 수를 여기에 표시 --%>
	</div>
	
	<div>
		<%--
		검색된 게시글 리스트를 여기에 표시
		searchType에 따라 다른 객체 컬랙션이 넘어온다
		searchType이 question, report일 경우를 제외한 모든 상황 : 
		public class Product {
				private int productNo;
				private int categoryNo;
				private double score;
				private int price;
				private Date uploadDate;
				private int productCount;
				private String productTitle;
				private String productContent;
				private String status;
		}위 객체를 받아옴
		카드 형식으로 페이지당 searchCount수 만큼 표시
		카드에는 제목 최대 10글자(그 이상은 ...으로 표시)
		내용 최대 30글자(그 이상 ...으로 표시)
		카드를 누르면 ${root}/board.pro?productNo='누른 카드의productNo' get요청
		
		
		searchType이 question : 
		
		searchType이 report :
		
		
		
		
		--%>
	
	
	</div>


	<div>
		<%--페이지 바 --%>
		
	</div>

	
<script type="text/javascript">
$(function(){
	//category긁어 와 검색할 게시판에 넣기
	$.ajax({
		url: '${root}/selectCategory.co',
		method: 'POST',
		data: {},
		dataType: "json",
		success: function(result) {
			//질문게시판 앞에 추가
            let $questionOption = $('#searchType option[value="question"]');
            $.each(result, function(idx, category){
                $('<option>', {
                    value: category.categoryNo,
                    text: category.categoryName
                }).insertBefore($questionOption);
            });
        },
        error: function() {
            alert('카테고리 정보를 불러오지 못했습니다.');
        }
	});
	
	//버튼 이벤트 핸들러
	document.getElementById("searchBoard").addEventListener("click", searchBoard);
	
	function searchBoard(){
		let params = $('#searchForm').serialize();
		
		//게시판 수 검색
		$.ajax({
			url: '${root}/countMyBoard.co',
			method: 'POST',
			data: params,
			success: function(result) {
				//int형으로 받아온 데이터를 검색된 게시글 수에 넣어둠
	        },
	        error: function() {
	        	//검색결과에 '서버와 통신할 수 없습니다'표시
	        }
		});
		
		//게시판 검색
		$.ajax({
			url: '${root}/searchMyBoard.co',
			method: 'POST',
			data: params,//searchType은 문자열로 넘기기
			dataType: "json",
			success: function(result) {
				/*
				받아온 데이터 동적으로 생성
				*/
	        },
	        error: function() {
	            //검색결과에 '서버와 통신할 수 없습니다'표시
	        }
		});
	}
	
	searchBoard();//현 주소로 접속할 때 게시글 조회
});

</script>
	
</body>
</html>