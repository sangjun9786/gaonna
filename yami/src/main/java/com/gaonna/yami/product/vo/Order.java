package com.gaonna.yami.product.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Order {
	private int orderNo;          // 주문 번호
    private int buyerId;          // 구매자(회원번호)
    private int sellerId;         // 판매자(회원번호)
    private int productNo;        // 상품 번호
    private int price;            // 결제금액
    private int usedPoint;        // 사용포인트
    private String payMethod;     // 결제수단
    private String status;        // 주문상태 (REQ, DONE, etc.)
    private Date regDate;         // 주문 등록일
    private Date confirmDate;     // 거래 확정일
    
    private String buyerName;      // 구매자 이름
    private String buyerPhone;     // 구매자 연락처
    private String meetLocation;   // 거래 희망 장소
    private String message;        // 판매자에게 남기는 메시지
    private String sellerName;   // 판매자 이름(주문 시점 기준)
    private String sellerPhone;  // 판매자 연락처(주문 시점 기준)
}
