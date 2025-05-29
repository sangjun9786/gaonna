package com.gaonna.yami.location.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Location {
	private String latitude; //위도
	private String longitude; //경도
	private String timestamp; //시간 - 1970.1.1부터 ms단위
	
	private String roadAddress; //도로명주소
	private String jibunAddress; //지번주소
	private String detailAddress; //상세주소
	
	private String zipCode; //우편번호
}
