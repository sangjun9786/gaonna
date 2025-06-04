package com.gaonna.yami.composite.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gaonna.yami.composite.service.CompositeService;
import com.gaonna.yami.composite.vo.BoardCo;
import com.gaonna.yami.composite.vo.Category;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.member.model.vo.Member;
import com.google.gson.Gson;

@Controller
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
	
	//ajax - 카테고리 목록 검색
	@ResponseBody
	@PostMapping("selectCategory.co")
	public String selectCategory() {
		try {
			List<Category> category = service.selectCategory();
			String json = new Gson().toJson(category);
			return json;
		} catch (Exception e) {
			e.printStackTrace();
			return "[]";
		}
	}
	
	//ajax - 게시글 수 조회
	@ResponseBody
	@PostMapping("countMyBoard.co")
	public int countMyBoard(HttpSession session,Model model
			,SearchForm searchForm) {
		try {
			//loginUser의 userNo따서 searchForm에 넣기
			searchForm.setUserNo(((Member)session
					.getAttribute("loginUser")).getUserNo());
			
			return service.countMyBoard(searchForm);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	//ajax - 게시글 조회
	@ResponseBody
	@PostMapping("searchMyBoard.co")
	public String searchMyBoard(HttpSession session,Model model
			,SearchForm searchForm) {
		try {
			//loginUser의 userNo따서 searchForm에 넣기
			searchForm.setUserNo(((Member)session
					.getAttribute("loginUser")).getUserNo());
			List<BoardCo> result = service.searchMyBoard(searchForm);
			return new Gson().toJson(result);
		} catch (Exception e) {
			e.printStackTrace();
			return "[]";
		}
	}
	
	
	//ajax - 댓글 수 조회
	@ResponseBody
	@PostMapping("countMyReply.co")
	public int countMyReply(HttpSession session,Model model
			,SearchForm searchForm) {
		try {
			//loginUser의 userNo따서 searchForm에 넣기
			searchForm.setUserNo(((Member)session
					.getAttribute("loginUser")).getUserNo());
			return service.countMyReply(searchForm);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
}
