package com.gaonna.yami.location.service;

import java.util.List;

import com.gaonna.yami.location.vo.Location;

public interface LocationService {

	//좌표 -> 행정동
	Location reverseGeocode(Location lo) throws Exception;

	//주소 검색
	List<String> geocode(String address) throws Exception;

}
