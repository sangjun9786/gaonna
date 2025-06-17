package com.gaonna.yami.report.model.service;

import java.util.List;
import java.util.Map;

import com.gaonna.yami.report.model.vo.Report;

public interface ReportService {
    // 일반회원: 신고 등록
    int insertReport(Report report);

    // 관리자: 신고 목록 조회
    List<Report> getReportList(Map<String, Object> param);

    // 관리자: 신고 상세 조회
    Report getReportDetail(int reportNo);

    // 관리자: 신고 상태 변경
    int changeReportStatus(Map<String, Object> param);

    // 관리자: 전체 신고 건수(페이징)
    int getReportCount(Map<String, Object> param);

    // (추가) 신고 대상의 실제 작성자 회원번호 반환 (본인 신고 차단 용)
    int findTargetWriterNo(String reportType, int targetNo);
    
    
    int countHandledReportsByUser(int userNo);

}
