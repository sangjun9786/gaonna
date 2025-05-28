package com.gaonna.yami.location.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Location {
	private int locationNo; //위치 식별번호
	private String latitude; //위도
	private String longitude; //경도
	private String timestamp; //시간 - 1970.1.1부터 ms단위
	
	private String naverCode; //해당 행정구역 네이버 코드
	private String area1; //시/도
	private String area2; //시/군/구
	private String area3; //읍/면/동
	private String buildingCode; //빌딩
	private String zipCode; //우편번호
	private String roadCode; //도로코드
}
