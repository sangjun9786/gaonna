package com.gaonna.yami.composite.vo;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
	private String uploadDateStr;
	private String productTitle;
	private String productContent;
	private int productCount;
	private String status;
	private int replyCount; //댓글 수, reply에서 추출
	
	//sdf로 변경
	public void boardSDF(List<BoardCo> result) {
		SimpleDateFormat sdf = new SimpleDateFormat("yy년 MM월 dd일 HH시 mm분");
		for (BoardCo board : result) {
			Date boardDate = board.getUploadDate();
			if (boardDate != null) {
				board.setUploadDateStr(sdf.format(boardDate));
			} else {
				board.setUploadDateStr("");
			}
		}
	}
}
