package com.gaonna.yami.admin.service;

import java.util.List;
import java.util.Map;

import com.gaonna.yami.composite.vo.BoardCo;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;

public interface AdminService {

	//콘솔 명령 - 관리자 로그인
	Member consoleLogin(String userId);

	//관리자 권한 조회
	String selectRoleType(Member loginUser);

	//ajax 관리자 조회
	List<Member> searchAdmin(String select);

	//관리자 데이터 수정
	int updateAdmin(Member m);

	//관리자 추가
	int insertAdmin(Member m);

	//ajax 회원 조회
	List<Member> searchMember(String searchType, String searchKeyword, int searchCount, int page);

	//ajax 회원 수 조회
	String countMember(String searchType ,String searchKeyword);

	//ajax 회원 수정
	int updateUser(Member m);

	//ajax 유저 동네 조회
	List<Coord> userDongne(int userNo);

	//ajax 유저 배송지 조회
	List<Location> userLocation(int userNo);

	//ajax 게시글 조회
	Map<String, Object> searchBoard(SearchForm searchForm);

	//ajax 댓글 조회
	Map<String, Object> searchReply(SearchForm searchForm);
	
	//ajax 뽱집댓글 조회
	Map<String, Object> searchReplyDongne(SearchForm searchForm);

	//ajax - 특정 회원이 작성한 게시글 조회
	Map<String, Object> searchBoardMember(SearchForm searchForm);

	//ajax - 특정 회원이 작성한 판매게시판 댓글 조회
	Map<String, Object> searchReplyMember(SearchForm searchForm);

	//ajax - 특정 회원이 작성한 우리동네빵집 댓글 조회
	Map<String, Object> searchReplyDongneMember(SearchForm searchForm);
}
