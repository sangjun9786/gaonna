package com.gaonna.yami.composite.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class BoardCo {
	private int productNo;
	private String categoryName; //category에서 추출
	private int price;
	private Date uploadDate;
	private String productTitle;
	private String productContent;
	private String status;
	private int replyCount; //댓글 수, reply에서 추출
}
