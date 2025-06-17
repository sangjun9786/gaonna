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
    public List<Map<String, Object>> getReportList(Map<String, Object> param) {
        return reportDao.selectReportList(param);
    }

    @Override
    public Map<String, Object> getReportDetail(int reportNo) {
        return reportDao.selectReportByNo(reportNo);
    }

    @Override
    public int changeReportStatus(Map<String, Object> param) {
        return reportDao.updateReportStatus(param);
    }

    @Override
    public String findTargetWriterKey(String reportType, int targetNo) {
        switch (reportType) {
            case "post":
                return String.valueOf(reportDao.findProductWriterNo(targetNo));
            case "reply":
                return reportDao.findReplyWriterId(targetNo);
            case "chat":
                return String.valueOf(reportDao.findChatWriterNo(targetNo));
            default:
                return null;
        }
    }

    @Override
    public int countHandledReportsByUser(int userNo) {
        return reportDao.countHandledReportsByUser(userNo);
    }
    
    @Override
    public int checkAlreadyReported(Report report) {
        return reportDao.checkAlreadyReported(report);
    }
}
