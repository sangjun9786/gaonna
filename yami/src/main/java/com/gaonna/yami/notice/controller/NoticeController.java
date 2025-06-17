package com.gaonna.yami.notice.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.common.Pagination;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.notice.model.service.NoticeService;
import com.gaonna.yami.notice.model.vo.Notice;

@Controller
@RequestMapping("/notice")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;
    

    // 홈 리디렉션
    @GetMapping("/")
    public String homeRedirect() {
        return "redirect:/notice/list";
    }

    // 공지사항 상세조회 + 조회수 증가
    @GetMapping("/detail")
    public String selectNotice(@RequestParam("nno") int noticeNo, Model model) {
        int result = noticeService.updateCount(noticeNo);
        if (result > 0) {
            Notice n = noticeService.selectNotice(noticeNo);
            model.addAttribute("n", n);
            return "notice/noticeDetail";
        } else {
            model.addAttribute("errorMsg", "공지사항 조회 실패");
            return "common/errorPage";
        }
    }

    // 공지사항 작성 폼
    @GetMapping({"/enroll", "/enrollForm"})
    public String noticeEnrollForm(HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null || "N".equals(loginUser.getRoleType())) {
            session.setAttribute("alertMsg", "관리자만 접근 가능한 기능입니다.");
            return "redirect:/";
        }
        return "notice/noticeEnroll";
    }

    // 공지사항 등록
    @PostMapping("/insert")
    public String noticeEnroll(Notice n, HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null || "N".equals(loginUser.getRoleType())) {
            session.setAttribute("alertMsg", "관리자만 접근 가능한 기능입니다.");
            return "redirect:/";
        }
        n.setUserNo(loginUser.getUserNo());	

        int result = noticeService.insertNotice(n);
        if (result > 0) {
            return "redirect:/notice/list";
        } else {
            model.addAttribute("errorMsg", "공지사항 등록 실패");
            return "common/errorPage";
        }
    }

    // 공지사항 수정 폼
    @GetMapping("/updateForm")
    public String noticeUpdateForm(@RequestParam("nno") int noticeNo, Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null || "N".equals(loginUser.getRoleType())) {
            session.setAttribute("alertMsg", "관리자만 접근 가능한 기능입니다.");
            return "redirect:/";
        }

        Notice n = noticeService.selectNotice(noticeNo);
        model.addAttribute("notice", n);
        return "notice/noticeUpdate";
    }

    // 공지사항 수정
    @PostMapping("/update")
    public String noticeUpdate(Notice n, HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null || "N".equals(loginUser.getRoleType())) {
            session.setAttribute("alertMsg", "관리자만 접근 가능한 기능입니다.");
            return "redirect:/";
        }

        int result = noticeService.updateNotice(n);
        if (result > 0) {
            return "redirect:/notice/detail?nno=" + n.getNoticeNo();
        } else {
            model.addAttribute("errorMsg", "공지사항 수정 실패");
            return "common/errorPage";
        }
    }

    // 공지사항 삭제
    @GetMapping("/delete")
    public String deleteNotice(@RequestParam("nno") int noticeNo, HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null || "N".equals(loginUser.getRoleType())) {
            session.setAttribute("alertMsg", "관리자만 접근 가능한 기능입니다.");
            return "redirect:/";
        }

        int result = noticeService.deleteNotice(noticeNo);
        if (result > 0) {
            return "redirect:/notice/list";
        } else {
            model.addAttribute("errorMsg", "공지사항 삭제 실패");
            return "common/errorPage";
        }
    }
    
    @GetMapping("/list")
    public String selectNoticeList(@RequestParam(value = "cpage", defaultValue = "1") int currentPage,
                                   Model model,
                                   @RequestParam(value = "keyword", defaultValue = "") String keyword,
                                   @RequestParam(value = "condition", defaultValue = "notice") String condition) {
    	
        int listCount = noticeService.selectListCount(keyword); 
        int pageLimit = 5;   
        int boardLimit = 10; 

        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);

        List<Notice> list = noticeService.selectList(pi, keyword);

        model.addAttribute("list", list);
        model.addAttribute("pageInfo", pi);
        model.addAttribute("keyword", keyword);
        model.addAttribute("condition", condition);
        return "notice/noticeList";
    }
}
