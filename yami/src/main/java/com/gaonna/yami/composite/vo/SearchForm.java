package com.gaonna.yami.composite.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class SearchForm {
	private String searchType1; //검색할 게시판 유형
	private String searchType2; //전체/제목/내용
	private String searchKeyword; //검색어
	private int page; //이동할 페이지
	private int searchCount; //페이지 당 보여줄 수
	private int resultCount; //검색결과 수
	
	private int endRow; //끝 행
	private int startRow; //시작 행
	
	private int userNo; //로그인한 회원의 회원번호
	
	//SearchForm은 정상화당했다!
	public void normalize() {
		
        //searchCount 유효성 검사
		switch (this.searchCount) {
		    case 10:
		    case 30:
		    case 50:
		    case 100:
		    	break;
		    default: this.searchCount = 10;
		}

        //페이지 범위 유효성 검사
		int maxPage = (this.resultCount + this.searchCount - 1) / this.searchCount;
		maxPage = Math.max(maxPage, 1);
		this.page = Math.max(1, Math.min(this.page, maxPage));

		//searchType2 유효성 검사
		switch(this.searchType2) {
		case "all" :
		case "title" :
		case "content" :
			break;
		default : this.searchType2 = "all";
		}
		
        //시작,종료 행
        this.startRow = this.searchCount * (this.page - 1) + 1;
        this.endRow = this.searchCount * this.page;
        
        //searchKeyword 공백 자르기
        this.searchKeyword = searchKeyword.trim();
    }
	
	/*
	 * reply
	 * 
	 * searchType2
	 * searchKeyword
	 * 안씀
	 * 
	 */
}
