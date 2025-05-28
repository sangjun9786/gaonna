package com.gaonna.yami.location.service;

import com.gaonna.yami.location.vo.Location;

public interface LocationService {

	//좌표 -> 행정동
	Location reverseGeocode(Location lo) throws Exception, InterruptedException;

}
