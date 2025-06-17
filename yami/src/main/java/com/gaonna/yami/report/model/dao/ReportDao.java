package com.gaonna.yami.report.model.dao;

import java.util.List;
import java.util.Map;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.gaonna.yami.report.model.vo.Report;

@Repository
public class ReportDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public int insertReport(Report report) {
        return sqlSession.insert("reportMapper.insertReport", report);
    }

    public List<Map<String, Object>> selectReportList(Map<String, Object> param) {
        return sqlSession.selectList("reportMapper.selectReportList", param);
    }

    public Map<String, Object> selectReportByNo(int reportNo) {
        return sqlSession.selectOne("reportMapper.selectReportByNo", reportNo);
    }

    public int updateReportStatus(Map<String, Object> param) {
        return sqlSession.update("reportMapper.updateReportStatus", param);
    }

    public int findProductWriterNo(int productNo) {
        return sqlSession.selectOne("reportMapper.findProductWriterNo", productNo);
    }

    public String findReplyWriterId(int replyNo) {
        return sqlSession.selectOne("reportMapper.findReplyWriterNo", replyNo);
    }

    public int findChatWriterNo(int messageNo) {
        return sqlSession.selectOne("reportMapper.findChatWriterNo", messageNo);
    }

    public int countHandledReportsByUser(int userNo) {
        return sqlSession.selectOne("reportMapper.countHandledReportsByUser", userNo);
    }
    
    public int checkAlreadyReported(Report report) {
        return sqlSession.selectOne("reportMapper.checkAlreadyReported", report);
    }
}
