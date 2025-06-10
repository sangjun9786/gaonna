package com.gaonna.yami.product.vo;

import java.sql.Timestamp;  // ✅ 수정된 부분

public class Reply {
    private int replyNo;       // 댓글 고유 번호 (시퀀스)
    private int productNo;     // 어느 상품에 속한 댓글인지
    private String userId;     // 작성자 아이디 (세션에서 가져옴)
    private String replyText;  // 댓글 내용
    private Timestamp replyDate;  // ✅ 날짜 + 시간까지 저장

    // Getter / Setter
    public int getReplyNo() {
        return replyNo;
    }
    public void setReplyNo(int replyNo) {
        this.replyNo = replyNo;
    }

    public int getProductNo() {
        return productNo;
    }
    public void setProductNo(int productNo) {
        this.productNo = productNo;
    }

    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getReplyText() {
        return replyText;
    }
    public void setReplyText(String replyText) {
        this.replyText = replyText;
    }

    public Timestamp getReplyDate() {
        return replyDate;
    }
    public void setReplyDate(Timestamp replyDate) {
        this.replyDate = replyDate;
    }
}
