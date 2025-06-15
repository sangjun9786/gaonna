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
public class ReplyCo {
	private int replyNo;
	private int productNo;
	
	private String userId;
	private String replyText;
	private Date replyDate;
	
	private String userName; //member에서 추출
	private String productTitle;//product_board에서 추출
	private String replyDateStr;//sdf
	
	
	//sdf로 변경
	public void replySDF(List<ReplyCo> result) {
		SimpleDateFormat sdf = new SimpleDateFormat("yy년 MM월 dd일 HH시 mm분");
		for (ReplyCo reply : result) {
			Date replyDate = reply.getReplyDate();
			if (replyDate != null) {
				reply.setReplyDateStr(sdf.format(replyDate));
			} else {
				reply.setReplyDateStr("");
			}
		}
	}
}
