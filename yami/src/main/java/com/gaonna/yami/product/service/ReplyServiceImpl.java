package com.gaonna.yami.product.service;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.gaonna.yami.product.dao.ReplyDao;
import com.gaonna.yami.product.vo.Reply;

@Service
public class ReplyServiceImpl implements ReplyService {

    @Autowired
    private SqlSession sqlSession;

    @Autowired
    private ReplyDao replyDao;

    @Override
    public int insertReply(Reply r) {
        return replyDao.insertReply(sqlSession, r);
    }

    @Override
    public List<Reply> selectReplyList(int productNo) {
        return replyDao.selectReplyList(sqlSession, productNo);
    }
}