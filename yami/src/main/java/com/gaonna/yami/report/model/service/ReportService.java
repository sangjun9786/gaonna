package com.gaonna.yami.report.model.service;

import java.util.List;
import java.util.Map;
import com.gaonna.yami.report.model.vo.Report;

public interface ReportService {
    int insertReport(Report report);
    List<Map<String, Object>> getReportList(Map<String, Object> param);
    Map<String, Object> getReportDetail(int reportNo);
    int changeReportStatus(Map<String, Object> param);
    String findTargetWriterKey(String reportType, int targetNo);
    int countHandledReportsByUser(int userNo);
    int checkAlreadyReported(Report report);	
}
