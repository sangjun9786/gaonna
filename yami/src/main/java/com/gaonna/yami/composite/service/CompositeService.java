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

	//ajax - 댓글 조회
	Map<String, Object> searchMyReply(SearchForm searchForm);
	
}
