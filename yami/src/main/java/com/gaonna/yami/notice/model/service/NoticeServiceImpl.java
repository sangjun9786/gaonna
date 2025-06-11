package com.gaonna.yami.notice.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.notice.model.dao.NoticeDao;
import com.gaonna.yami.notice.model.vo.Notice;

@Service
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private SqlSession sqlSession;

    @Autowired
    private NoticeDao noticeDao;

    @Override
    public List<Notice> selectNoticeList() {
        return noticeDao.selectNoticeList(sqlSession);
    }
    
    @Override
    public Notice selectNotice(int noticeNo) {
        return noticeDao.selectNotice(sqlSession, noticeNo);
    }

    @Override
    public int updateCount(int noticeNo) {
        return noticeDao.updateCount(sqlSession, noticeNo);
    }

    @Override
    public int insertNotice(Notice 	notice) {
        return noticeDao.insertNotice(sqlSession, notice);
    }

    @Override
    public int updateNotice(Notice notice) {
        return noticeDao.updateNotice(sqlSession, notice);
    }

    @Override
    public int deleteNotice(int noticeNo) {
        return noticeDao.deleteNotice(sqlSession, noticeNo);
    }
    
    @Override
    public int selectListCount(String keyword) {
        return noticeDao.selectListCount(sqlSession, keyword);
    }
    
    @Override
    public List<Notice> selectList(PageInfo pi, String keyword) {
        int startRow = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
        int endRow = startRow + pi.getBoardLimit() - 1;

        Map<String, Object> map = new HashMap<>();
        map.put("startRow", startRow);
        map.put("endRow", endRow);
        map.put("pi", pi); 
        map.put("keyword", keyword);

        return noticeDao.selectList(sqlSession, map);
    }
}
