package com.gaonna.yami.report.controller;

import java.util.*;
import javax.servlet.http.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.report.model.service.ReportService;
import com.gaonna.yami.report.model.vo.Report;

@Controller
@RequestMapping("/report")
public class ReportController {

    @Autowired
    private ReportService reportService;

    /** 신고 등록 */
    @PostMapping("/insert")
    public String insertReport(Report report, HttpSession session, Model model, RedirectAttributes ra) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인 후 이용 가능합니다.");
            return "common/errorPage";
        }

        String myKey = "reply".equals(report.getReportType())
            ? loginUser.getUserId()
            : String.valueOf(loginUser.getUserNo());

        String targetKey = reportService.findTargetWriterKey(report.getReportType(), report.getTargetNo());

        if (myKey.equals(targetKey)) {
            model.addAttribute("errorMsg", "본인 컨텐츠는 신고할 수 없습니다.");
            return "common/errorPage";
        }
        
        
        report.setReporterNo(loginUser.getUserNo());


        // 🚫 이미 신고한 항목인지 검사
        if (reportService.checkAlreadyReported(report) > 0) {
            String type = report.getReportType();
            String msg = "이미 신고한 항목입니다.";
            if ("chat".equals(type)) {
                msg = "이미 신고한 채팅입니다.";
            } else if ("reply".equals(type)) {
                msg = "이미 신고한 댓글입니다.";
            } else if ("post".equals(type) || "product".equals(type)) {
                msg = "이미 신고한 게시글입니다.";
            }

            ra.addFlashAttribute("alertMsg", msg);
            String referer = (String) session.getAttribute("referer");
            if (referer == null) referer = "/";
            return "redirect:" + referer;
        }

        report.setReporterNo(loginUser.getUserNo());
        int result = reportService.insertReport(report);

        String referer = (String) session.getAttribute("referer");
        if (referer == null) referer = "/";

        if (result > 0) {
            ra.addFlashAttribute("alertMsg", "신고가 정상적으로 등록되었습니다.");
            return "redirect:" + referer;
        } else {
            model.addAttribute("errorMsg", "신고 등록 실패");
            return "common/errorPage";
        }
    }



    /** 대기 신고 목록 */
    @GetMapping("/list")
    public String reportList(Model model) {
        Map<String, Object> param = new HashMap<>();
        param.put("status", "P");
        List<Map<String, Object>> list = reportService.getReportList(param);
        model.addAttribute("reportList", list);
        return "report/reportList";
    }

    /** 처리/반려 신고 목록 */
    @GetMapping("/archived")
    public String reportArchivedList(Model model) {
        Map<String, Object> param = new HashMap<>();
        param.put("statusList", Arrays.asList("Y", "N"));
        List<Map<String, Object>> list = reportService.getReportList(param);
        model.addAttribute("reportList", list);
        return "report/reportArchivedList";
    }

    /** 신고 상세 */
    @GetMapping("/detail")
    public String reportDetail(@RequestParam("reportNo") int reportNo,
                               Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null || "N".equals(loginUser.getRoleType())) {
            model.addAttribute("errorMsg", "접근 권한이 없습니다.");
            return "common/errorPage";
        }

        Map<String, Object> report = reportService.getReportDetail(reportNo);
        model.addAttribute("report", report);
        return "report/reportDetail";
    }

    /** 신고 상태 변경 */
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

    /** 신고 폼 */
    @GetMapping("/insertForm")
    public String insertForm(@RequestParam String reportType,
                             @RequestParam int targetNo,
                             Model model, HttpSession session,
                             HttpServletRequest request) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인 후 이용 가능합니다.");
            return "common/errorPage";
        }
        String referer = request.getHeader("referer");
        if (referer != null) session.setAttribute("referer", referer);

        model.addAttribute("reportType", reportType);
        model.addAttribute("targetNo", targetNo);
        return "report/reportInsert";
    }
}
