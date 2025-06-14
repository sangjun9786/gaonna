package com.gaonna.yami.location.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.gaonna.yami.location.vo.Bakery;
import com.gaonna.yami.location.vo.BakeryComment;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;

public interface LocationService {

	//좌표 -> 행정동
	String reverseGeocode(Coord coord) throws Exception;
	
	//좌표 -> 도로명+위치
	Location reverseGeocodeLo(Coord coord) throws Exception;
	
	//주소 검색
	List<Location> geocode(String address) throws Exception;

	//유저 좌표(동네) 검색
	List<Coord> selectUserDongne(int userNo);

	//우리동네 메인으로 추가
	int insertDongneMain(Coord currCoord, Member loginUser);
	
	//우리동네 추가
	int insertDongne(Coord currCoord, Member loginUser);

	//좌표 삭제
	int deleteCoord(int coordNo);

	//유저 주소록 검색
	List<Location> selectLocation(Member m);

	//유저 배송지 삭제
	int deleteUserLocation(HttpSession session,Member m, int locationNo);

	//유저 대표배송지 변경
	int updateMainlocation(Member m);

	//유저 배송지 추가
	int insertLocationMe(Member m, Location lo);

	//유저 메인 배송지 추가
	int insertMainLocation(HttpSession session,Member m, Location lo);

	//대표동네에 따른 동네빵집 조회
	List<Bakery> selectBakeries(Coord mainCoord);

	//댓글 조회
	List<BakeryComment> selectBakeryComment(String bakeryNo, int page);

	//대댓글 조회
	List<BakeryComment> selectBakeryRecomment(String bakeryNo, int page, int parentCommentNo);
	
	//댓글 넣기
	int insertBakeryComment(Map<String, Object> map);

	//대댓글 넣기
	int insertBakeryRecomment(Map<String, Object> map);

	//댓글 수정하기
	int updateBakeryComment(Map<String, Object> map);

	//댓글 삭제하기
	int deleteBakeryComment(int commentNo);

	//bakeryNo로 뽱집 조회하기
	Bakery selectBakeryInfo(String bakeryNo);

}
