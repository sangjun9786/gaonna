package com.gaonna.yami.location.service;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;
import com.google.gson.JsonElement;

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


}
