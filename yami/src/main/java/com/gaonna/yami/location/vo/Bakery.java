package com.gaonna.yami.location.vo;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Bakery {
	private String bakeryNo;
	private String openDate;
	private String openDateStr;
	private String phone;
	private String roadAddress;
	private String jibunAddress;
	private String bakeryName;
	private String latitude;
	private String longitude;
	
	private int like;
	private int dislike;
	
	//sdf로 변경
	public void bakerySDF(List<Bakery> result) {
	    SimpleDateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd");
	    SimpleDateFormat toFormat = new SimpleDateFormat("yyyy년 MM월 dd일");
	    for (Bakery bakery : result) {
	        String openDateStr = bakery.getOpenDateStr(); // 기존에 String형식으로 저장된 값
	        if (openDateStr != null && !openDateStr.isEmpty()) {
	            try {
	                Date date = fromFormat.parse(openDateStr);
	                bakery.setOpenDateStr(toFormat.format(date));
	            } catch (Exception e) {
	                bakery.setOpenDateStr(""); // 파싱 실패시 빈값 처리
	            }
	        } else {
	            bakery.setOpenDateStr("");
	        }
	    }
	}

}
