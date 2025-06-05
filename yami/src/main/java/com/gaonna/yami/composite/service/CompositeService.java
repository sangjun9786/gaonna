package com.gaonna.yami.composite.service;

import java.util.List;

import com.gaonna.yami.composite.vo.Category;
import com.gaonna.yami.composite.vo.SearchForm;

public interface CompositeService {

	//ajax - 카테고리 조회
	List<Category> selectCategory();

	//ajax - 게시글 수 조회
	int countMyBoard(SearchForm searchForm);

	//ajax - 게시글 조회
	List<?> searchMyBoard(SearchForm searchForm);
	
}
