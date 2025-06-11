package com.gaonna.yami.notice.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.notice.model.vo.Notice;

@Repository
public class NoticeDao {

    public List<Notice> selectNoticeList(SqlSession sqlSession) {
        return sqlSession.selectList("noticeMapper.selectNoticeList");
    }

    public Notice selectNotice(SqlSession sqlSession, int noticeNo) {
        return sqlSession.selectOne("noticeMapper.selectNotice", noticeNo);
    }

    public int updateCount(SqlSession sqlSession, int noticeNo) {
        return sqlSession.update("noticeMapper.updateCount", noticeNo);
    }

    public int insertNotice(SqlSession sqlSession, Notice notice) {
        return sqlSession.insert("noticeMapper.insertNotice", notice);
    }

    public int updateNotice(SqlSession sqlSession, Notice notice) {
        return sqlSession.update("noticeMapper.updateNotice", notice);
    }

    public int deleteNotice(SqlSession sqlSession, int noticeNo) {
        return sqlSession.update("noticeMapper.deleteNotice", noticeNo);
    }
    
    public int selectListCount(SqlSessionTemplate sqlSession) {
        return sqlSession.selectOne("noticeMapper.selectListCount");
    }
    
    public List<Notice> selectList(SqlSessionTemplate sqlSession, PageInfo pi) {
        return sqlSession.selectList("noticeMapper.selectList", pi);
    }
    
    public int selectListCount(SqlSession sqlSession) {
        return sqlSession.selectOne("noticeMapper.selectListCount");
    }
    
    public List<Notice> selectList(SqlSession sqlSession, Map<String, Object> paramMap) {
        return sqlSession.selectList("noticeMapper.selectList", paramMap);
    }
    
    
}
