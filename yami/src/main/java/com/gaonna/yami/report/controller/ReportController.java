package com.gaonna.yami.report.controller;

import java.util.HashMap;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.report.model.service.ReportService;
import com.gaonna.yami.report.model.vo.Report;

@Controller
@RequestMapping("/report")
public class ReportController {

    @Autowired
    private ReportService reportService;

    // 🚨 신고 등록 (일반회원 가능, 본인 컨텐츠 신고 불가)
    @PostMapping("/insert")
    public String insertReport(Report report, HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인 후 이용 가능합니다.");
            return "common/errorPage";
        }
        int loginUserNo = loginUser.getUserNo();
        int targetWriterNo = reportService.findTargetWriterNo(report.getReportType(), report.getTargetNo());

        // 본인 컨텐츠 신고 차단
        if (loginUserNo == targetWriterNo) {
            model.addAttribute("errorMsg", "본인 컨텐츠는 신고할 수 없습니다.");
            return "common/errorPage";
        }

        report.setReporterNo(loginUserNo);
        int result = reportService.insertReport(report);
        if (result > 0) {
            return "redirect:/";
        } else {
            model.addAttribute("errorMsg", "신고 등록 실패");
            return "common/errorPage";
        }
    }

    // 🚨 신고 목록 (관리자/최고관리자만)
    @GetMapping("/list")
    public String reportList(@RequestParam(required = false) String status,
                             @RequestParam(required = false) String reportType,
                             Model model,
                             HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        // 👉 "N"이 아니면 관리자 권한으로 본다!
        if (loginUser == null || "N".equals(loginUser.getRoleType())) {
            model.addAttribute("errorMsg", "접근 권한이 없습니다.");
            return "common/errorPage";
        }

        Map<String, Object> param = new HashMap<>();
        param.put("status", status);
        param.put("reportType", reportType);
        List<Report> list = reportService.getReportList(param);
        model.addAttribute("reportList", list);
        return "report/reportList";
    }

    // 🚨 신고 상세 (관리자/최고관리자만)
    @GetMapping("/detail")
    public String reportDetail(@RequestParam("reportNo") int reportNo,
                               Model model,
                               HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null || "N".equals(loginUser.getRoleType())) {
            model.addAttribute("errorMsg", "접근 권한이 없습니다.");
            return "common/errorPage";
        }
        Report report = reportService.getReportDetail(reportNo);
        model.addAttribute("report", report);
        return "report/reportDetail";
    }

    // 🚨 신고 상태 변경 (관리자/최고관리자만, Ajax 사용 권장)
    @PostMapping("/updateStatus")
    @ResponseBody
    public String updateStatus(@RequestParam int reportNo,
                               @RequestParam String status,
                               HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null || "N".equals(loginUser.getRoleType())) {
            return "unauthorized";
        }
        Map<String, Object> param = new HashMap<>();
        param.put("reportNo", reportNo);
        param.put("status", status);
        int result = reportService.changeReportStatus(param);
        return result > 0 ? "success" : "fail";
    }
    
 // 🚩 신고 작성 폼 (신고 폼 화면을 GET으로 띄워줌)
    @GetMapping("/insertForm")
    public String insertForm(@RequestParam String reportType,
                             @RequestParam int targetNo,
                             Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인 후 이용 가능합니다.");
            return "common/errorPage";
        }
        // 신고폼에 넘길 값
        model.addAttribute("reportType", reportType);
        model.addAttribute("targetNo", targetNo);
        return "report/reportInsert"; // 신고 작성 폼 JSP 이름에 맞게!
    }
}
