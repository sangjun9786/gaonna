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
	private int userNo;
	private int price;
	private Date uploadDate;
	private int productCount;
	private String productTitle;
	private String productContent;
	private String status;
	private String coordAddress; //유저 위치정보값
	private String userId;
	private String userName;
	private String categoryName;
	
    private ArrayList<Attachment> atList;
//    private ArrayList<Comment> commentList;

}
