package com.gaonna.yami.alarm.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gaonna.yami.alarm.model.service.AlarmService;
import com.gaonna.yami.alarm.model.vo.Alarm;
import com.gaonna.yami.member.model.vo.Member;

@Controller
@RequestMapping("/alarm")
public class AlarmController {

    @Autowired
    private AlarmService alarmService;

    // 알림 목록 조회
    @GetMapping("/list")
    @ResponseBody
    public List<Alarm> getAlarmList(HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return null;
        return alarmService.selectAlarmList(loginUser.getUserNo());
    }

    // 알림 전체 읽음 처리
    @PostMapping("/readAll")
    @ResponseBody
    public String readAllAlarm(HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "fail";
        int result = alarmService.updateAllAlarmRead(loginUser.getUserNo());
        return result > 0 ? "success" : "fail";
    }

    // 알림 단건 삭제
    @PostMapping("/delete")
    @ResponseBody
    public String deleteAlarm(@RequestParam("alarmNo") int alarmNo) {
        int result = alarmService.deleteAlarm(alarmNo);
        return result > 0 ? "success" : "fail";
    }

    // 알림 전체 삭제
    @PostMapping("/deleteAll")
    @ResponseBody
    public String deleteAllAlarm(HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "fail";
        int result = alarmService.deleteAllAlarm(loginUser.getUserNo());
        return result > 0 ? "success" : "fail";
    }
    
    @GetMapping("/alarmPage")
    public String alarmPage(HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login.me";
        List<Alarm> list = alarmService.selectAlarmList(loginUser.getUserNo());
        model.addAttribute("alarmList", list);
        return "alarm/alarm"; 
    }
    
    @GetMapping("/count")
    @ResponseBody
    public int getUnreadAlarmCount(HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return 0;
        return alarmService.selectUnreadAlarmCount(loginUser.getUserNo());
    }
    
    @GetMapping("/readOneAndRedirect")
    public String readOneAndRedirect(@RequestParam("alarmNo") int alarmNo,
                                     @RequestParam("type") String type,
                                     @RequestParam("refNo") int refNo) {
        
    	alarmService.markAsRead(alarmNo);

        if ("chat".equals(type)) {
            return "redirect:/chat/room?roomNo=" + refNo;
        } else if ("reply".equals(type)) {
            return "redirect:/productDetail.pro?productNo=" + refNo; 	
        } else {
            return "redirect:/alarm/alarmPage";
        }
    }
    
    
    
    
    
    
}
