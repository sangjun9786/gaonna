package com.gaonna.yami.member.email.vo;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Email {
	private String toAddress;
	private String subject;
	private String content;
}
