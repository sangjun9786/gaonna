package com.gaonna.yami.composite.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;

import com.gaonna.yami.composite.service.CompositeService;

public class CompositeController {
	@Autowired
	public CompositeService service;
	
	//나의 찜으로
	@GetMapping("wishlist.co")
	public String goMyWishlist() {
		return "member/myWishlist";
	}
	
	//나의 채팅으로
	@GetMapping("chat.co")
	public String goMyChat() {
		return "member/myChat";
	}
	
	//나의 게시글로
	@GetMapping("board.co")
	public String goMyBoard() {
		return "member/myBoard";
	}
	
	//나의 댓글로
	@GetMapping("reply.co")
	public String goMyReply() {
		return "member/myReply";
	}
}
