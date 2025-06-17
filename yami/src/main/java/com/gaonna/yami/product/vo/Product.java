package com.gaonna.yami.product.vo;

import java.sql.Date;
import java.util.ArrayList;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Product {
	private int productNo;
	private int categoryNo;
	private double score;
	private int userNo; // 🔧 수정된 부분
	private int price;
	private Date uploadDate;
	private int productCount;
	private String productTitle;
	private String productContent;
	private String status;
	
	private String coordAddress; // 유저 위치 정보
	private String userId;   // 판매자 ID
	private String userName; // 판매자 이름
	private String categoryName;
	private String originName;   
	private String changeName;
	private String userPhone; // 판매자 연락처
	private int wishCount;

	
	private ArrayList<Attachment> atList = new ArrayList<>();
	// private ArrayList<Comment> commentList;
}