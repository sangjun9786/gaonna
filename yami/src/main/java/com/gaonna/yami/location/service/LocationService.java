package com.gaonna.yami.location.service;

import java.util.List;

import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;

public interface LocationService {

	//좌표 -> 행정동
	String reverseGeocode(Coord coord) throws Exception;

	//주소 검색
	List<Location> geocode(String address) throws Exception;

	//유저 좌표(동네) 검색
	List<Coord> selectUserDongne(int userNo);

}
