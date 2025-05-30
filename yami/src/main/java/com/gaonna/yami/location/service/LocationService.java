package com.gaonna.yami.location.service;

import java.util.List;

import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;

public interface LocationService {

	//좌표 -> 행정동
	String reverseGeocode(Coord coord) throws Exception;

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

}
