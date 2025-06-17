package com.gaonna.yami.product.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import com.gaonna.yami.product.vo.Reply;

@Repository
public class ReplyDao {

    /**
     * 댓글 한 건을 DB에 INSERT
     * MyBatis 매퍼 ID: "replyMapper.insertReply"
     */
    public int insertReply(SqlSession sqlSession, Reply r) {
        return sqlSession.insert("replyMapper.insertReply", r);
    }

    /**
     * 특정 상품(productNo)에 달린 댓글 목록 SELECT
     * MyBatis 매퍼 ID: "replyMapper.selectReplyList"
     */
    public List<Reply> selectReplyList(SqlSession sqlSession, int productNo) {
        return sqlSession.selectList("replyMapper.selectReplyList", productNo);
    }

	public int updateReply(SqlSession sqlSession, Reply reply) {
		return sqlSession.update("replyMapper.updateReply",reply);
	}

	public int deleteReply(SqlSession sqlSession, Reply reply) {
		return sqlSession.delete("replyMapper.deleteReply",reply);
	}


}