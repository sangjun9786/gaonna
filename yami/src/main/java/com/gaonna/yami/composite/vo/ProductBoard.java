package com.gaonna.yami.composite.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ProductBoard {
	private int productNo;
	private int categoryNo;
	private double score;
	private int price;
	private String uploadDate; //업로드 날짜. Date 형변환
	private int productCount; //조회수
	private String productTitle;
	private String productContent;
	private String status;
}
