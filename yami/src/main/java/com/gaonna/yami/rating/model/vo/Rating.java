package com.gaonna.yami.rating.model.vo;

import java.sql.Date;

public class Rating {
    // 시퀀스에서 꺼낸 PK
    private Integer ratingId;
    // 어떤 상품에 대한 평점인지
    private int productNo;
    // 로그인한 사용자의 userNo (RATING.USER_NO 컬럼)
    private int userNo;
    // 한줄평
    private String userComment;
    // 등록일
    private Date ratingDay;
    // 평점 점수(1~5)
    private int score;

    // ——————————— Getter & Setter ———————————

    public Integer getRatingId() {
        return ratingId;
    }
    public void setRatingId(Integer ratingId) {
        this.ratingId = ratingId;
    }

    public int getProductNo() {
        return productNo;
    }
    public void setProductNo(int productNo) {
        this.productNo = productNo;
    }

    public int getUserNo() {
        return userNo;
    }
    public void setUserNo(int userNo) {
        this.userNo = userNo;
    }

    public String getUserComment() {
        return userComment;
    }
    public void setUserComment(String userComment) {
        this.userComment = userComment;
    }

    public Date getRatingDay() {
        return ratingDay;
    }
    public void setRatingDay(Date ratingDay) {
        this.ratingDay = ratingDay;
    }

    public int getScore() {
        return score;
    }
    public void setScore(int score) {
        this.score = score;
    }
}