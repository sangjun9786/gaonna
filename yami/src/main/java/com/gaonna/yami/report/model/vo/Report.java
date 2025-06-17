package com.gaonna.yami.report.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Report {
    private int reportNo;        // 신고 PK
    private String reportType;   // 신고 유형 (post/reply/chat 등)
    private int targetNo;        // 신고 대상 PK (게시글, 댓글 등)
    private int reporterNo;      // 신고자 PK
    private String reason;       // 신고 사유(코드값 등)
    private String content;      // 상세 신고 내용
    private String status;       // 상태 (P:대기, Y:처리, N:기각)
    private Date createdAt;      // 신고 일시
    private Date handledAt;      // 처리일시
}
