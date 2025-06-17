package com.gaonna.yami.product.service;

import java.util.List;
import com.gaonna.yami.product.vo.Reply;

public interface ReplyService {
    // 댓글 저장
    int insertReply(Reply r);

    // 특정 상품에 달린 댓글 목록 조회
    List<Reply> selectReplyList(int productNo);

    //댓글 수정
	int updateReply(Reply reply);

	//댓글 삭제
	int deleteReply(Reply reply);
}