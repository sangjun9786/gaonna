package com.gaonna.yami.search.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class PerchasedBo {
	private int productNo;
	private String categoryName; //category에서 추출
	private int price;
	private int userNo;
	private String userId;
	private String productTitle;
	private String productContent;
	private int productCount;
	private String score2;
	private int orderNo;
	private String status;
}
