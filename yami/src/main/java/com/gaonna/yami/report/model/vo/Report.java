package com.gaonna.yami.report.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Report {

    private int reportNo;         // 신고 번호 (PK)
    private String reportType;    // 신고 유형: 'POST', 'REPLY', 'CHAT'
    private int targetNo;         // 신고 대상 번호 (게시글/댓글/채팅)
    private int reporterNo;       // 신고자 회원 번호
    private String reason;        // 간단한 신고 사유 (ex. 욕설, 도배 등)
    private String content;       // 상세 설명 
    private String status;        // 처리 상태: 'P' 대기, 'Y' 승인, 'N' 반려
    private Date createdAt;       // 신고 등록일
    private Date handledAt;       // 관리자 처리일 (승인/반려된 날짜)

}