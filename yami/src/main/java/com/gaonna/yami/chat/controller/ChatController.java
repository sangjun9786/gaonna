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
    public String enterOrCreateRoom(@RequestParam("productNo") int productNo,
                                    @RequestParam("sellerNo") int sellerNo,
                                    HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인 후 이용하세요.");
            return "common/errorPage";
        }

        int buyerNo = loginUser.getUserNo();
        // 본인 상품엔 접근 불가
        if (sellerNo == buyerNo) {
            model.addAttribute("errorMsg", "본인 상품에는 채팅을 시작할 수 없습니다.");
            return "common/errorPage";
        }

        // 방이 있으면 반환, 없으면 생성 후 반환
        ChatRoom room = chatService.getOrCreateRoom(sellerNo, buyerNo, productNo);
        if (room == null) {
            model.addAttribute("errorMsg", "채팅방 생성 실패");
            return "common/errorPage";
        }

        model.addAttribute("chatRoom", room);
        List<ChatMessage> messages = chatService.getMessages(room.getRoomNo());
        model.addAttribute("chatMessages", messages);

        int otherUserNo = (buyerNo == room.getUser2No()) ? room.getUser1No() : room.getUser2No();
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
