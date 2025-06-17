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

    // 1. 신고 등록
    public int insertReport(Report report) {
        return sqlSession.insert("reportMapper.insertReport", report);
    }

    // 2. 신고 목록 조회
    public List<Report> selectReportList(Map<String, Object> param) {
        return sqlSession.selectList("reportMapper.selectReportList", param);
    }

    // 3. 신고 상세 조회
    public Report selectReportByNo(int reportNo) {
        return sqlSession.selectOne("reportMapper.selectReportByNo", reportNo);
    }

    // 4. 신고 상태 변경
    public int updateReportStatus(Map<String, Object> param) {
        return sqlSession.update("reportMapper.updateReportStatus", param);
    }

    // 5. 신고 카운트(페이징)
    public int countReport(Map<String, Object> param) {
        return sqlSession.selectOne("reportMapper.countReport", param);
    }

    // 6. 게시글 작성자 조회 (신고자==작성자 차단용)
    public int findProductWriterNo(int productNo) {
        return sqlSession.selectOne("reportMapper.findProductWriterNo", productNo);
    }

    // 7. 댓글 작성자 조회
    public int findReplyWriterNo(int replyNo) {
        return sqlSession.selectOne("reportMapper.findReplyWriterNo", replyNo);
    }

    // 8. 채팅 작성자 조회
    public int findChatWriterNo(int messageNo) {
        return sqlSession.selectOne("reportMapper.findChatWriterNo", messageNo);
    }
    
    
    public int countHandledReportsByUser(int userNo) {
        return sqlSession.selectOne("reportMapper.countHandledReportsByUser", userNo);
    }

}
