package com.gaonna.yami.chat.controller;

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
import com.gaonna.yami.chat.model.service.ChatService;
import com.gaonna.yami.chat.model.vo.ChatListView;
import com.gaonna.yami.chat.model.vo.ChatMessage;
import com.gaonna.yami.chat.model.vo.ChatRoom;
import com.gaonna.yami.member.model.vo.Member;

@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    private ChatService chatService;
    
    @Autowired
    private AlarmService alarmService;

    @GetMapping("/list")
    public String chatRoomList(HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인 후 이용 가능합니다.");
            return "common/errorPage";
        }

        int userNo = loginUser.getUserNo();
        List<ChatListView> list = chatService.getChatListByUser(userNo);
        model.addAttribute("chatList", list);
        return "chat/chatList";
    }

    @GetMapping("/room")
    public String enterOrCreateRoom(@RequestParam(value = "roomNo", required = false) Integer roomNo,
                                    @RequestParam(value = "productNo", required = false) Integer productNo,
                                    @RequestParam(value = "sellerNo", required = false) Integer sellerNo,
                                    HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인 후 이용하세요.");
            return "common/errorPage";
        }
        int loginUserNo = loginUser.getUserNo();

        ChatRoom room = null;
        if (roomNo != null) {
            // [입장] roomNo로 직접 조회 (판매자, 구매자 모두 가능)
            room = chatService.findRoomByRoomNo(roomNo);
            if (room == null || (room.getUser1No() != loginUserNo && room.getUser2No() != loginUserNo)) {
                model.addAttribute("errorMsg", "채팅방에 접근할 수 없습니다.");
                return "common/errorPage";
            }
        } else if (productNo != null && sellerNo != null) {
            // [생성 or 입장] 기존 로직
            if (sellerNo == loginUserNo) {
                model.addAttribute("errorMsg", "본인 상품에는 채팅을 시작할 수 없습니다.");
                return "common/errorPage";
            }
            room = chatService.getOrCreateRoom(sellerNo, loginUserNo, productNo);
            if (room == null) {
                model.addAttribute("errorMsg", "채팅방 생성 실패");
                return "common/errorPage";
            }
        } else {
            model.addAttribute("errorMsg", "잘못된 접근입니다.");
            return "common/errorPage";
        }
        
        alarmService.deleteChatAlarmsByRoom(loginUserNo, room.getRoomNo());

        model.addAttribute("chatRoom", room);
        List<ChatMessage> messages = chatService.getMessages(room.getRoomNo());
        model.addAttribute("chatMessages", messages);

        int otherUserNo = (loginUserNo == room.getUser1No()) ? room.getUser2No() : room.getUser1No();
        String otherUserName = chatService.getUserNameByNo(otherUserNo);
        model.addAttribute("otherName", otherUserName != null ? otherUserName : "알수없음");

        return "chat/chatRoom";
    }

    @PostMapping("/send")
    @ResponseBody
    public ChatMessage sendMessage(@RequestParam("roomNo") int roomNo,
                                   @RequestParam("content") String content,
                                   HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return null;

        ChatMessage msg = new ChatMessage();
        msg.setRoomNo(roomNo);
        msg.setSenderNo(loginUser.getUserNo());
        msg.setContent(content);

        int result = chatService.sendMessage(msg);
        if (result > 0) {
        	ChatRoom room = chatService.findRoomByRoomNo(roomNo);
            int receiverNo = (room.getUser1No() == loginUser.getUserNo()) ? room.getUser2No() : room.getUser1No();
            	
            Alarm alarm = new Alarm();
            alarm.setUserNo(receiverNo);     // 알림 받을 사람
            alarm.setType("chat");           // 알림 타입: chat
            alarm.setRefNo(roomNo);          // 채팅방 번호
            alarm.setContent(loginUser.getUserName() + "님이 메시지를 보냈습니다.");
        	
            alarmService.insertAlarm(alarm);
        	
        	
        	
        	ChatMessage latestMsg = chatService.getLatestMessage(roomNo, loginUser.getUserNo(), content);
            return latestMsg; 
        }
        return null;
    }


    @PostMapping("/readAll")
    @ResponseBody
    public String readAllMessages(@RequestParam("roomNo") int roomNo, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "fail";
        int userNo = loginUser.getUserNo();
        int result = chatService.readAllMessages(roomNo, userNo);
        return result > 0 ? "success" : "fail";
    }
    
    @PostMapping("/delete")
    @ResponseBody
    public String deleteMessage(@RequestParam("messageNo") int messageNo, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "fail";

        int result = chatService.deleteMessage(messageNo);
        return result > 0 ? "success" : "fail";
    }
    
    
    
    
}