package com.gaonna.yami.composite.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gaonna.yami.composite.service.CompositeService;
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
	@GetMapping("selectCategory.co")
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
	
	//ajax - 게시글 조회
	@ResponseBody
	@GetMapping("searchMyBoard.co")
	public Map<String, Object> searchMyBoard(HttpSession session,Model model
			,SearchForm searchForm) {
		try {
			//loginUser의 userNo따서 searchForm에 넣기
			searchForm.setUserNo(((Member)session
					.getAttribute("loginUser")).getUserNo());
			Map<String, Object> result = service.searchMyBoard(searchForm);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	//ajax - 판매게시판 댓글 조회
	@ResponseBody
	@GetMapping("searchMyReply.co")
	public Map<String, Object> searchMyReply(HttpSession session,Model model
			,SearchForm searchForm) {
		try {
			//loginUser의 userNo따서 searchForm에 넣기
			searchForm.setUserNo(((Member)session
					.getAttribute("loginUser")).getUserNo());
			Map<String, Object> result = service.searchMyReply(searchForm);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	//ajax - 우리동네빵집 댓글 조회
	@ResponseBody
	@GetMapping("searchMyReplyDongne.co")
	public Map<String, Object> searchMyReplyDongne(HttpSession session,Model model
			,SearchForm searchForm) {
		try {
			//loginUser의 userNo따서 searchForm에 넣기
			searchForm.setUserNo(((Member)session
					.getAttribute("loginUser")).getUserNo());
			Map<String, Object> result = service.searchMyReplyDongne(searchForm);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	//우리동네빵집 댓글 바로가기
	@GetMapping("myReplyDongneDetail.co")
	public String myReplyDongneDetail(Model model, HttpSession session,
			int commentNo, int userNo, String bakeryNo) {
		try {
			//유효성 검사
			int loginUserNo = ((Member)session.getAttribute("loginUser")).getUserNo();
			if(userNo != loginUserNo) {
				model.addAttribute("errorMsg","잘못된 접근입니다.");
				return "common/errorPage";
			}
			
			model.addAttribute("targetBakeryNo", bakeryNo);
			model.addAttribute("targetCommentNo", commentNo);
			
			return "member/myReplyDongneDetail";
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg","500 err");
			return "common/errorPage";
		}
	}
	
	
	
	//ajax - 찜 조회
	@ResponseBody
	@PostMapping("wishlist.co")
	public Map<String, Object> myWishlist(Model model
			,HttpSession session, SearchForm searchForm) {
		try {
			//loginUser의 userNo따서 searchForm에 넣기
			searchForm.setUserNo(((Member)session
					.getAttribute("loginUser")).getUserNo());
			Map<String, Object> result = service.searchMyWishlist(searchForm);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg","500 err");
			return null;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	

	
	
}
