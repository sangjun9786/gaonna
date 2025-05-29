 package com.gaonna.yami.location.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Location {
	private int locationNo; //주소 식별번호
	private Date locationDate; //추가/수정된 날짜
	private String roadAddress; //도로명주소
	private String jibunAddress; //지번주소
	private String detailAddress; //상세주소
	private String zipCode; //우편번호
}
