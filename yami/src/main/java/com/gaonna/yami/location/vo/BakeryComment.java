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
public class BakeryComment {
	private int commentNo;
	private int parentCommentNo;
	private String commentContent;
	private String commentType; //'COMMENT', 'RECOMMENT'
	private String bakeryNo;
	private int userNo;
	private String userName; //member에서 조인
	private Date commentDate;
	private String commentDateStr;
	private String like; //L:좋 D:싫 P:대댓글(좋/싫 없음)
	private String status; //Y:정상 N:삭제됨 M:수정됨 P:신고됨
	
	public void bakeryCommentSDF(List<BakeryComment> result) {
		SimpleDateFormat sdf = new SimpleDateFormat("yy년 MM월 dd일");
		for (BakeryComment bakeryComment : result) {
			Date bakeryCommentDate = bakeryComment.getCommentDate();
			if (bakeryCommentDate != null) {
				bakeryComment.setCommentDateStr(sdf.format(bakeryCommentDate));
			} else {
				bakeryComment.setCommentDateStr("");
			}
		}
	}
}
