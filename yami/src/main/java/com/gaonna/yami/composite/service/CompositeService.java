package com.gaonna.yami.composite.service;

import java.util.List;
import java.util.Map;

import com.gaonna.yami.composite.vo.Category;
import com.gaonna.yami.composite.vo.ReplyCo;
import com.gaonna.yami.composite.vo.SearchForm;

public interface CompositeService {

	//ajax - 카테고리 조회
	List<Category> selectCategory();

	//ajax - 게시글 조회
	Map<String, Object> searchMyBoard(SearchForm searchForm);

	//ajax - 판매게시판 댓글 조회
	Map<String, Object> searchMyReply(SearchForm searchForm);

	//ajax - 우리동네빵집 댓글 조회
	Map<String, Object> searchMyReplyDongne(SearchForm searchForm);

	//ajax - 찜 조회
	Map<String, Object> searchMyWishlist(SearchForm searchForm);

	//ajax - 찜 삭제
	int deleteMyWishlist(int productNo, int userNo);
	
}