package com.gaonna.yami.product.vo;

import java.sql.Date;

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
	private String userNo;
	private int price;
	private Date uploadDate;
	private int productCount;
	private String productTitle;
	private String productContent;
	private String status;

//    private ArrayList<Attachment> atList;
//    private ArrayList<Comment> commentList;

}
