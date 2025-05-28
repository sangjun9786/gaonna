package com.gaonna.yami.event.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Event {
	private int eventNo;
	private int userNo;
	private int count;
	private Date lastDate;
	private String status;
}
