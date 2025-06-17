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
	private String phone;
	private String roadAddress;
	private String jibunAddress;
	private String bakeryName;
	private Double latitude;
	private Double longitude;
	
	private int likeCount;
	private int dislikeCount;
	
	//sdf로 변경
	public void bakerySDF(List<Bakery> result) {
	    SimpleDateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd");
	    SimpleDateFormat toFormat = new SimpleDateFormat("yyyy년 MM월 dd일");
	    for (Bakery bakery : result) {
            try {
                Date date = fromFormat.parse(bakery.getOpenDate());
                bakery.setOpenDate(toFormat.format(date));
            } catch (Exception e) {
            	e.printStackTrace();
            }
	    }
	}

}
