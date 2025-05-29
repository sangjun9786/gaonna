package com.gaonna.yami.location.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Coord {
	private int coordNo;//좌표 식별번호
	private String latitude; //위도
	private String longitude; //경도
	private String coordAddress; //해당 좌표 위치
	private Date coordDate; //추가/수정된 날짜
}
