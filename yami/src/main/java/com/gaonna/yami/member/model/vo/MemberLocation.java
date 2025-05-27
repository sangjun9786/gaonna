package com.gaonna.yami.member.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class MemberLocation {
	private int userNo;
	private double latitude; //위도
	private double longitude; //경도
	private long timestamp; //시간 - 1970.1.1부터 ms단위
	
	private String naverCode; //해당 행정구역 네이버 코드
	private String area1; //시/도
	private String area2; //시/군/구
	private String area3; //읍/면/동
	private String buildingCode; //빌딩
	private String zipCode; //우편번호
	private String roadCode; //도로코드
}
