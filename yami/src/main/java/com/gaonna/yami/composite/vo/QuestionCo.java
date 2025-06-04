package com.gaonna.yami.composite.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class QuestionCo {
	private int questionId;
	private String title;
	private String content;
	private String createAt; //업로드 날짜. Date 형변환
	private int answerCount;
	private String isAnswered;
}
