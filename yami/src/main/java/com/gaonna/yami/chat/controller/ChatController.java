package com.gaonna.yami.chat.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.gaonna.yami.chat.model.service.ChatService;
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
        List<ChatRoom> myRooms = chatService.getMyRooms(userNo);
        model.addAttribute("chatRooms", myRooms);
        return "chat/chatList"; 
    }

    @GetMapping("/room")
    public String enterRoom(@RequestParam("productNo") int productNo,
                            @RequestParam("sellerNo") int sellerNo,
                            HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            model.addAttribute("errorMsg", "로그인 후 이용하세요.");
            return "common/errorPage";
        }

        int loginUserNo = loginUser.getUserNo();
        

        int user1 = Math.min(sellerNo, loginUserNo);
        int user2 = Math.max(sellerNo, loginUserNo);
        ChatRoom room = chatService.findRoomByUsersAndProduct(user1, user2, productNo);
        
        if (room == null) {
            room = chatService.getOrCreateRoom(sellerNo, loginUserNo, productNo);
        }
        
        if (room == null && loginUserNo != sellerNo) {
            room = chatService.getOrCreateRoom(sellerNo, loginUserNo, productNo);
        }
        
        if (room == null) {
            model.addAttribute("errorMsg", "채팅방이 존재하지 않습니다.");
            return "common/errorPage";
        }
        model.addAttribute("chatRoom", room);
        List<ChatMessage> messages = chatService.getMessages(room.getRoomNo());
        model.addAttribute("chatMessages", messages);

        // 상대방 USER_NO 계산 (내가 구매자면 sellerNo, 내가 판매자면 buyerNo)
        int otherUserNo = (loginUser.getUserNo() == room.getUser1No()) ? room.getUser2No() : room.getUser1No();

        // 상대방 USER_ID(이메일) 가져오기
        String otherUserId = chatService.getUserIdByNo(otherUserNo);
        // 이메일 앞부분만 추출
        String otherId = otherUserId != null ? otherUserId.split("@")[0] : "알수없음";
        model.addAttribute("otherId", otherId);

        return "chat/chatRoom";
    }
    
    
    
    @PostMapping("/create")
    @ResponseBody
    public String createRoom(@RequestParam("productNo") int productNo,
                             @RequestParam("sellerNo") int sellerNo,
                             HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) return "fail";
        int buyerNo = loginUser.getUserNo();

        if (buyerNo == sellerNo) return "fail";

        ChatRoom room = chatService.getOrCreateRoom(sellerNo, buyerNo, productNo); 
        return (room != null) ? "success" : "fail";
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
