package com.gaonna.yami.report.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.report.model.dao.ReportDao;
import com.gaonna.yami.report.model.vo.Report;

@Service
public class ReportServiceImpl implements ReportService {

    @Autowired
    private ReportDao reportDao;

    @Override
    public int insertReport(Report report) {
        return reportDao.insertReport(report);
    }

    @Override
    public List<Report> getReportList(Map<String, Object> param) {
        return reportDao.selectReportList(param);
    }

    @Override
    public Report getReportDetail(int reportNo) {
        return reportDao.selectReportByNo(reportNo);
    }

    @Override
    public int changeReportStatus(Map<String, Object> param) {
        return reportDao.updateReportStatus(param);
    }

    @Override
    public int getReportCount(Map<String, Object> param) {
        return reportDao.countReport(param);
    }

    // 신고 대상에 대한 실제 작성자 회원번호 반환
    @Override
    public int findTargetWriterNo(String reportType, int targetNo) {
        // type에 따라 분기
        if ("post".equals(reportType)) {
            return reportDao.findProductWriterNo(targetNo); // 게시글 작성자
        } else if ("reply".equals(reportType)) {
            return reportDao.findReplyWriterNo(targetNo);   // 댓글 작성자
        } else if ("chat".equals(reportType)) {
            return reportDao.findChatWriterNo(targetNo);    // 채팅 작성자
        } else {
            return 0; // 없는 타입 방지
        }
    }
    
    
    @Override
    public int countHandledReportsByUser(int userNo) {
        return reportDao.countHandledReportsByUser(userNo);
    }

}
